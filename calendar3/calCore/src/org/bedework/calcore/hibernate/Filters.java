/*
 Copyright (c) 2000-2005 University of Washington.  All rights reserved.

 Redistribution and use of this distribution in source and binary forms,
 with or without modification, are permitted provided that:

   The above copyright notice and this permission notice appear in
   all copies and supporting documentation;

   The name, identifiers, and trademarks of the University of Washington
   are not used in advertising or publicity without the express prior
   written permission of the University of Washington;

   Recipients acknowledge that this distribution is made available as a
   research courtesy, "as is", potentially with defects, without
   any obligation on the part of the University of Washington to
   provide support, services, or repair;

   THE UNIVERSITY OF WASHINGTON DISCLAIMS ALL WARRANTIES, EXPRESS OR
   IMPLIED, WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT LIMITATION
   ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
   PARTICULAR PURPOSE, AND IN NO EVENT SHALL THE UNIVERSITY OF
   WASHINGTON BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
   DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
   PROFITS, WHETHER IN AN ACTION OF CONTRACT, TORT (INCLUDING
   NEGLIGENCE) OR STRICT LIABILITY, ARISING OUT OF OR IN CONNECTION WITH
   THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
/* **********************************************************************
    Copyright 2005 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/
package org.bedework.calcore.hibernate;

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CoreEventInfo;
import org.bedework.calfacade.filter.BwAndFilter;
import org.bedework.calfacade.filter.BwCategoryFilter;
import org.bedework.calfacade.filter.BwCreatorFilter;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.filter.BwLocationFilter;
import org.bedework.calfacade.filter.BwOrFilter;
import org.bedework.calfacade.filter.BwSponsorFilter;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList;

/** Class to carry out some of the manipulations needed for filter support.
 * We attempt to modify the query so that the minimum  number of events are
 * returned. Later on we run the results through the filters to deal with
 * the remaining conditions.
 *
 * <p>We process the query in a number of passes to allow the query sections
 * to be built.
 *
 * <p>Pass 1 is the join pass and assumes we have added the select and from
 * clauses. It gives the method the opportunity to add any join clauses.
 *
 * <p>Pass 2 the where pass, allows us to add additional where clauses.
 * There are two methods associated with this: addWhereSubscriptions
 * and addWhereFilters
 *
 * <p>Pass 3 is parameter replacement and the methods can now replace any
 * parameters.
 *
 * <p>Pass 4 the post execution pass allows the filters to process the
 * result and handle any filters that could not be handled by the query.
 *
 * <p> The constructors accept two FilterVO objects, one represents the
 * subscriptions and the other the current filters. Subscriptions are in
 * addition to the default selection and filters subtract from them.
 *
 * <p>The kind of query we're looking to build is something like:
 * <br/>
 * select ev from EventVO<br/>
 * [ join ev.categories as keyw ] --- only for any category matching <br/>
 * where<br/>
 * [ date-ranges-match and ] -- usually have this<br/>
 * ( public-or-creator-test <br/>
 *   [ or  subscriptions ] )<br/>
 * and ( filters )<br/>
 *
 * <p>where the filters and subscriptions are a bunch of parenthesised tests.
 *
 * <p>We make it a requirement that subscriptions are based solely on categories
 * so that we don't need to post filter the result.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class Filters implements Serializable {
//  private boolean debug;

  private BwFilter filter;

  /** The query we are building
   */
  StringBuffer q;

  /** The query segment we are building
   */
  StringBuffer qseg;

  /** True if we can modify the query.
   */
  boolean canModQuery;

  /** True if we need a category join.
   */
  boolean needKjoin;

  /** True if we need to run the result through the filter.
   */
  boolean postFilter;

  /** This provides an index to append to parameter names in the
   * generated query.
   */
  int qi;

  /** This is set for the second pass when we set the pars
   */
  HibSession sess;

  /** Name of the event we are testing.
   */
  String evName;

  /**
   * Prefix for filterquery parameters
   */
  String parPrefix = "fq__";

  //private transient Logger log;

  /** Go with the defaults (mostly)
   *
   * @param filter
   * @param q
   * @param evName
   * @param debug
   */
  public Filters(BwFilter filter,
                 StringBuffer q,
                 String evName,
                 boolean debug) {
    this.filter = filter;
    this.q = q;
    this.evName = evName;
//    this.debug = debug;
  }

  /** Don't go with the defaults
   *
   * @param filter
   * @param q
   * @param evName
   * @param parPrefix
   * @param debug
   */
  public Filters(BwFilter filter,
                 StringBuffer q,
                 String evName,
                 String parPrefix,
                 boolean debug) {
    this(filter, q, evName, debug);
    this.parPrefix = parPrefix;
  }

  /** Pass 1 is the join pass and assumes we have added the select and from
   * clauses. It gives the method the opportunity to add any join clauses.
   */
  public void joinPass() {
    if (filter == null) {
      return;
    }

    if (needsKJoin(filter)) {
      q.append(" join ");
      q.append(evName);
      q.append(".categories as ");
      q.append(parPrefix);
      q.append("keyw ");
    }
  }

  /** Pass 2 the where pass, allows us to add additional where clauses.
   * filters are added to the existing statement.
   *
   * Generate a where clause for a query which selects the events for the
   * given filter.
   *
   * @throws CalFacadeException
   */
  public void addWhereFilters() throws CalFacadeException {
    if (filter == null) {
      return;
    }

    qseg = new StringBuffer();
    postFilter = makeWhere(filter);

    if (qseg.length() != 0) {
      q.append(" and (");
      q.append(qseg);
      q.append(")");
    }
  }

  /** Pass 3 is parameter replacement and the methods can now replace any
   * parameters
   *
   * @param sess
   * @throws CalFacadeException
   */
  public void parPass(HibSession sess) throws CalFacadeException {
    qi = 0;
    this.sess = sess;

    parReplace(filter);
  }

  /** Pass 4 the post execution pass allows the filters to process the
   * result and handle any filters that could not be handled by the query.
   *
   * @param val         Collection of CoreEventInfo to be filtered
   * @return Collection filtered
   * @throws CalFacadeException
   */
  public Collection postExec(Collection val) throws CalFacadeException {
    if (!postFilter) {
      return val;
    }

    Iterator it = val.iterator();
    ArrayList l = new ArrayList();

    while (it.hasNext()) {
      CoreEventInfo cei = (CoreEventInfo)it.next();
      BwEvent ev = cei.getEvent();

      if (matches(filter, ev)) {
        l.add(cei);
      }
    }

    return l;
  }

  /* Generate a where clause for a query which selects the events for the
   * given filter. If any filter element cannot be handled by the selection
   * will return false. In that case run the selected result through the
   * filter to select the elements.
   *
   * @param f         FilterVO element.
   */
  private boolean makeWhere(BwFilter f) {
    if (f instanceof BwAndFilter) {
      BwAndFilter fb = (BwAndFilter)f;

      qseg.append('(');

      boolean first = true;
      boolean postFilter = false;
      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        if (!first) {
          qseg.append(" and ");
        }

        if (makeWhere((BwFilter)it.next())) {
          postFilter = true;
        }

        first = false;
      }

      qseg.append(")");

      return postFilter;
    }

    if (f instanceof BwCreatorFilter) {
      qseg.append('(');
      qseg.append(evName);
      qseg.append(".creator.account=:");
      qseg.append(parPrefix);
      qseg.append(qi);
      qi++;
      qseg.append(")");

      return false;
    }

    if (f instanceof BwCategoryFilter) {
      qseg.append("(:");
      qseg.append(parPrefix);
      qseg.append(qi);
      qi++;
      qseg.append(" in elements(ev.categories))");

      return false;
    }

    if (f instanceof BwLocationFilter) {
      qseg.append("(");
      qseg.append(evName);
      qseg.append(".location=:");
      qseg.append(parPrefix);
      qseg.append(qi);
      qi++;
      qseg.append(")");

      return false;
    }

    if (f instanceof BwOrFilter) {
      BwOrFilter fb = (BwOrFilter)f;

      qseg.append("(");

      boolean first = true;
      boolean pf = false;
      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        if (!first) {
          qseg.append(" or ");
        }

        if (makeWhere((BwFilter)it.next())) {
          pf = true;
        }

        first = false;
      }

      qseg.append(")");

      return pf;
    }

    if (f instanceof BwSponsorFilter) {
      qseg.append('(');
      qseg.append(evName);
      qseg.append(".sponsor=:");
      qseg.append(parPrefix);
      qseg.append(qi);
      qi++;
      qseg.append(')');

      return false;
    }

    /* We assume we can't handle this one as a query.
     */
    return true;
  }

  /* Fill in the parameters after we generated the query.
   */
  private void parReplace(BwFilter f) throws CalFacadeException {
    if (f instanceof BwAndFilter) {
      BwAndFilter fb = (BwAndFilter)f;

      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        parReplace((BwFilter)it.next());
      }

      return;
    }

    if (f instanceof BwCreatorFilter) {
      BwCreatorFilter fb = (BwCreatorFilter)f;

      sess.setString(parPrefix + qi, fb.getCreator().getAccount());
      qi++;

      return;
    }

    if (f instanceof BwCategoryFilter) {
      BwCategoryFilter fb = (BwCategoryFilter)f;

      sess.setEntity(parPrefix + qi, fb.getCategory());
      qi++;

      return;
    }

    if (f instanceof BwLocationFilter) {
      BwLocationFilter fb = (BwLocationFilter)f;

      sess.setEntity(parPrefix + qi, fb.getLocation());
      qi++;

      return;
    }

    if (f instanceof BwOrFilter) {
      BwOrFilter fb = (BwOrFilter)f;

      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        parReplace((BwFilter)it.next());
      }

      return;
    }

    if (f instanceof BwSponsorFilter) {
      BwSponsorFilter fb = (BwSponsorFilter)f;

      sess.setEntity(parPrefix + qi, fb.getSponsor());
      qi++;

      return;
    }
  }

  /* We can stop as soon as we determine we need a category join which is
   * usually the case
   */
  private boolean needsKJoin(BwFilter f) {
    if ((f instanceof BwAndFilter) ||
        (f instanceof BwOrFilter)) {
      Iterator it = f.getChildren().iterator();

      while (it.hasNext()) {
        if (needsKJoin((BwFilter)it.next())) {
          return true;
        }
      }
    } else if (f instanceof BwCategoryFilter) {
      return true;
    }

    return false;
  }

  /* See if event makes it through. We assume OK for filters we can handle
   * with the query
   */
  private boolean matches(BwFilter f, BwEvent ev)
          throws CalFacadeException {
    if (f instanceof BwAndFilter) {
      BwAndFilter fb = (BwAndFilter)f;

      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        if (!matches((BwFilter)it.next(), ev)) {
          return false;
        }
      }

      return true;
    }

    if (f instanceof BwCreatorFilter) {
      return true;
    }

    if (f instanceof BwCategoryFilter) {
      return true;
    }

    if (f instanceof BwLocationFilter) {
      return true;
    }

    if (f instanceof BwOrFilter) {
      BwOrFilter fb = (BwOrFilter)f;

      Iterator it = fb.getChildren().iterator();

      while (it.hasNext()) {
        if (matches((BwFilter)it.next(), ev)) {
          return true;
        }
      }

      return false;
    }

    if (f instanceof BwSponsorFilter) {
      return true;
    }

    return false;
  }

  /* Get a logger for messages
   * /
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void trace(String msg) {
    getLogger().debug(msg);
  }*/
}

