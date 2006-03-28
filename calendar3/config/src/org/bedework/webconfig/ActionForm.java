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

package org.bedework.webconfig;

import org.bedework.calenv.CalEnv;
import org.bedework.webconfig.collections.ConfigCollection;

import edu.rpi.sss.util.jsp.UtilActionForm;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Properties;
import java.util.Vector;

import org.apache.struts.upload.FormFile;

/** Action form for bedework web config application
 *
 * @author  Mike Douglass     douglm@rpi.edu
 */
public class ActionForm extends UtilActionForm {
  /** This object will be set up appropriately for the kind of client,
   * e.g. admin, guest etc.
   */
  private CalEnv env;
  
  private FormFile uploadFile;

  private Collection propertyCollections;
	private Hashtable map;

  /* The result of all this */
  private Properties properties;

  /* ====================================================================
   *                   Property methods
   * ==================================================================== */

  /**
   * @param val
   */
  public void setUploadFile(FormFile val) {
    uploadFile = val;
  }

  /**
   * @return FormFile
   */
  public FormFile getUploadFile() {
    return uploadFile;
  }

  /** Set the property collections
   *
   * @param val
   */
  public void setPropertyCollections(Collection val) {
    propertyCollections = val;
  }

  /** Get the property collections
   *
   * @return Collection of ConfigCollection
   */
  public Collection getPropertyCollections() {
    if (propertyCollections == null) {
			propertyCollections = new Vector();
      map = new Hashtable();
    }
    return propertyCollections;
  }

  /** Set the properties
   *
   * @param val
   */
  public void setProperties(Properties val) {
      properties = val;
  }

  /** Get the properties
   *
   * @return Properties set from form values.
   */
  public Properties getProperties() {
    if (properties == null) {
      try {
        properties = (Properties)CalEnv.getProperties().clone();
      } catch (Throwable t) {
        getErr().emit(t);
      }
    }
    return properties;
  }

	/** Add a collection
	 *
	 * @param val
	 * @throws Throwable
	 */
	public void addPropertyCollection(ConfigCollection val) throws Throwable {
		String name = val.getName();

		if (findPropertyCollection(name) != null) {
			throw new Exception("Duplicate property collection " + name);
		}

		getPropertyCollections().add(val);
		map.put(name, val);
	}
	/** Find the collection with the given name
	 *
	 * @param name
	 * @return ConfigCollection
	 */
	public ConfigCollection findPropertyCollection(String name) {
    getPropertyCollections();
		return (ConfigCollection)map.get(name);
	}

  /**
   * @param val
   */
  public void assignEnv(CalEnv val) {
    env = val;
  }

  /**
   * @return env object
   */
  public CalEnv getEnv() {
    return env;
  }
}
