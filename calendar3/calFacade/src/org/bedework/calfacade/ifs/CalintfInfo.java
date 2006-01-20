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
package org.bedework.calfacade.ifs;

import java.io.Serializable;

/** This class provides information about the underlying calendar interface
 * allowing the service level to tailor queries appropriately.
 *
 * @author Mike Douglass
 */
public class CalintfInfo implements Serializable {
  /** True if this interface supports the locations methods.
   */
  private boolean handlesLocations;

  /** True if this interface supports the sponsors methods.
   */
  private boolean handlesSponsors;

  /** True if this interface supports the categories methods.
   */
  private boolean handlesCategories;

  /** Constructor
   *
   * @param handlesLocations
   * @param handlesSponsors
   * @param handlesCategories
   */
  public CalintfInfo(boolean handlesLocations,
                     boolean handlesSponsors,
                     boolean handlesCategories) {
    this.handlesLocations = handlesLocations;
    this.handlesSponsors = handlesSponsors;
    this.handlesCategories = handlesCategories;
  }

  /**
   * @return boolean true if this interface supports the locations methods
   */
  public boolean getHandlesLocations() {
    return handlesLocations;
  }

  /**
   * @return boolean true if this interface supports the sponsors methods
   */
  public boolean getHandlesSponsors() {
    return handlesSponsors;
  }

  /**
   * @return boolean true if this interface supports the categories methods
   */
  public boolean getHandlesCategories() {
    return handlesCategories;
  }

  public Object clone() {
    return new CalintfInfo(
       getHandlesLocations(),
       getHandlesSponsors(),
       getHandlesCategories()
     );
  }
}

