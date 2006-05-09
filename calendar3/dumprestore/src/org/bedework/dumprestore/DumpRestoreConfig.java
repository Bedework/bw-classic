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
package org.bedework.dumprestore;

/** Configuration propeties for the restore phase
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpRestoreConfig {
  private boolean debug;

  private boolean debugEntity;

  private boolean initSyspars;

  /* Initdb: We can restore timezone info from this file
   */
  private String timezonesFilename;

  /* When converting put all admin groups into the new group with this name
   * When initialising set default access to be read/write-content for this group
   */
  private String superGroupName;

  /* If non-null we will set any events with no calendar to this one.
   * This is mainly to fix errors in the data. All events should have a calendar.
   */
  private String defaultPublicCalPath;

  /* From uwcal 2.3 */

  /* True if we doing the conversion from 2.3.2 to V3 */
  private boolean from2p3px;

  /**
   * @param val
   */
  public void setDebug(boolean val)  {
    debug = val;
  }

  /** .
   *
   * @return booelan val
   */
  public boolean getDebug()  {
    return debug;
  }

  /**
   * @param val
   */
  public void setDebugEntity(boolean val)  {
    debugEntity = val;
  }

  /**
   *
   * @return boolean val
   */
  public boolean getDebugEntity()  {
    return debugEntity;
  }

  /** True if we initialise the system parameters
   *
   * @param val
   */
  public void setInitSyspars(boolean val)  {
    initSyspars = val;
  }

  /** True if we initialise the system parameters
   *
   * @return booelan val
   */
  public boolean getInitSyspars()  {
    return initSyspars;
  }

  /** Are we doing the conversion from 2.3.2 to V3
   *
   * @param val
   */
  public void setFrom2p3px(boolean val)  {
    from2p3px = val;
  }

  /** Are we doing the conversion from 2.3.2 to V3
   *
   * @return String val
   */
  public boolean getFrom2p3px()  {
    return from2p3px;
  }

  /** We can restore timezone info from this file
   *
   * @param val
   */
  public void setTimezonesFilename(String val)  {
    timezonesFilename = val;
  }

  /** We can restore timezone info from this file
   *
   * @return String val
   */
  public String getTimezonesFilename()  {
    return timezonesFilename;
  }

  /** When converting put all admin groups into the new group with this name
   *
   * @param val
   */
  public void setSuperGroupName(String val)  {
    superGroupName = val;
  }

  /** When converting put all admin groups into the new group with this name
   *
   * @return String val
   */
  public String getSuperGroupName()  {
    return superGroupName;
  }

  /** If non-null we will set any events with no calendar to this one.
   * This is mainly to fix errors in the data. All events should have a calendar.
   *
   * @param val
   */
  public void setDefaultPublicCalPath(String val)  {
    defaultPublicCalPath = val;
  }

  /** If non-null we will set any events with no calendar to this one.
   * This is mainly to fix errors in the data. All events should have a calendar.
   *
   * @return String val
   */
  public String getDefaultPublicCalPath()  {
    return defaultPublicCalPath;
  }
}
