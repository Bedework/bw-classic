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

/** Define value for the config app
 *
 * @author Mike Douglass
 */
public interface Defs {
  /** This prefix never changes */
  public static final String envPrefix = "org.bedework.app.bwconfig.";
  
  public static final String webconfigType = "webconfig";
  public static final String webadminType = "webadmin";
  public static final String webpublicType = "webpublic";
  public static final String webuserType = "webuser";
  public static final String publiccaldavType = "publiccaldav";
  public static final String usercaldavType = "usercaldav";
  
  /** Valid types of application */
  public static final String[] appTypes = {
    webconfigType,
    webadminType,
    webpublicType,
    webuserType,
    publiccaldavType,
    usercaldavType
  };
  
  /** */
  public static final String modulesCollectionName = "modules";
  
  /** Default properties file (built in to application) */
  //public final static String defaultProperties = "/properties/calendar/default-bedework.properties"; 
  
  /* Types for properties */
    
  /** String property */
  public final static int typeString = 0;
  
  /** Int property */
  public final static int typeInt = 1;
  
  /** boolean property */
  public final static int typeBoolean = 2;
  
  /** Choice property, i.e. One of n  (radio) */
  public final static int typeChoice = 3;  
  
  /** Multi-value property - radio or select */
  public final static int typeMultiple = 4; 
  
  /** Comment */
  public final static int typeComment = 5; 
}
