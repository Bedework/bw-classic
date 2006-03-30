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
package org.bedework.davdefs;

import edu.rpi.sss.util.xml.QName;

/** Define Webdav tags for XMlEmit
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class WebdavTags {
  /** Namespace for these tags
   */
  public static final String namespace = "DAV:";

  /** */
  public static final QName _abstract = new QName(namespace,
                                                  "abstract");

  /** */
  public static final QName ace = new QName(namespace,
                                              "ace");

  /** */
  public static final QName acl = new QName(namespace,
                                            "acl");

  /** */
  public static final QName aclPrincipalPropSet = new QName(namespace,
                                            "acl-principal-prop-set");

  /** */
  public static final QName aclRestrictions = new QName(namespace,
                                                        "acl-restrictions");

  /** */
  public static final QName all = new QName(namespace,
                                            "all");

  /** */
  public static final QName allowedPrincipal = new QName(namespace,
                                                         "allowed-principal");

  /** */
  public static final QName allprop = new QName(namespace,
                                                "allprop");

  /** */
  public static final QName alternateURISet = new QName(namespace,
                                                        "alternate-URI-set");

  /** */
  public static final QName authenticated = new QName(namespace,
                                                      "authenticated");

  /** */
  public static final QName bind = new QName(namespace,
                                             "bind");

  /** */
  public static final QName collection = new QName(namespace,
                                                   "collection");

  /** */
  public static final QName creationdate = new QName(namespace,
                                                     "creationdate");

  /** */
  public static final QName currentUserPrivilegeSet = new QName(namespace,
                                                 "current-user-privilege-set");

  /** */
  public static final QName denyBeforeGrant = new QName(namespace,
                                                        "deny-before-grant");

  /** */
  public static final QName deny = new QName(namespace,
                                             "deny");

  /** */
  public static final QName description = new QName(namespace,
                                                    "description");

  /** */
  public static final QName displayname = new QName(namespace,
                                                    "displayname");

  /** */
  public static final QName expandProperty = new QName(namespace,
                                                       "expand-property");

  /** */
  public static final QName getcontentlanguage = new QName(namespace,
                                                           "getcontentlanguage");

  /** */
  public static final QName getcontentlength = new QName(namespace,
                                                       "getcontentlength");

  /** */
  public static final QName getcontenttype = new QName(namespace,
                                                       "getcontenttype");

  /** */
  public static final QName getetag = new QName(namespace,
                                                     "getetag");

  /** */
  public static final QName getlastmodified = new QName(namespace,
                                                       "getlastmodified");

  /** */
  public static final QName grant = new QName(namespace,
                                             "grant");

  /** */
  public static final QName grantOnly = new QName(namespace,
                                             "grant-only");

  /** */
  public static final QName group = new QName(namespace,
                                             "group");

  /** */
  public static final QName groupMemberSet = new QName(namespace,
                                                       "group-member-set");

  /** */
  public static final QName groupMembership = new QName(namespace,
                                                        "group-membership");

  /** */
  public static final QName href = new QName(namespace,
                                             "href");

  /** */
  public static final QName inherited = new QName(namespace,
                                                  "inherited");

  /** */
  public static final QName inheritedAclSet = new QName(namespace,
                                                        "inherited-acl-set");

  /** */
  public static final QName invert = new QName(namespace,
                                               "invert");

  /** */
  public static final QName limitedNumberOfAces = new QName(namespace,
                                                      "limited-number-of-aces");

  /** */
  public static final QName lockdiscovery = new QName(namespace,
                                                      "lockdiscovery");

  /** */
  public static final QName lockentry = new QName(namespace,
                                                  "lockentry");

  /** */
  public static final QName lockscope = new QName(namespace,
                                                  "lockscope");

  /** */
  public static final QName locktype = new QName(namespace,
                                                 "locktype");

  /** */
  public static final QName match = new QName(namespace,
                                              "match");

  /** */
  public static final QName missingRequiredPrincipal = new QName(namespace,
                                                 "missing-required-principal");

  /** */
  public static final QName multistatus = new QName(namespace,
                                                    "multistatus");

  /** */
  public static final QName needPrivileges = new QName(namespace,
                                                   "need-privileges");

  /** */
  public static final QName noAbstract = new QName(namespace,
                                                   "no-abstract");

  /** */
  public static final QName noAceConflict = new QName(namespace,
                                                      "no-ace-conflict");

  /** */
  public static final QName noInheritedAceConflict = new QName(namespace,
                                                      "no-inherited-ace-conflict");

  /** */
  public static final QName noInvert = new QName(namespace,
                                                 "no-invert");

  /** */
  public static final QName noProtectedAceConflict = new QName(namespace,
                                                      "no-protected-ace-conflict");

  /** */
  public static final QName notSupportedPrivilege = new QName(namespace,
                                              "not-supported-privilege");

  /** */
  public static final QName owner = new QName(namespace,
                                              "owner");

  /** */
  public static final QName principal = new QName(namespace,
                                                 "principal");

  /** */
  public static final QName principalCollectionSet = new QName(namespace,
                                                 "principal-collection-set");

  /** */
  public static final QName principalMatch = new QName(namespace,
                                                 "principal-match");

  /** */
  public static final QName principalProperty = new QName(namespace,
                                                 "principal-property");

  /** */
  public static final QName principalPropertySearch = new QName(namespace,
                                                 "principal-property-search");

  /** */
  public static final QName principalSearchProperty = new QName(namespace,
                                                 "principal-search-property");

  /** */
  public static final QName principalSearchPropertySet = new QName(namespace,
                                                 "principal-search-property-set");

  /** */
  public static final QName principalURL = new QName(namespace,
                                                 "principal-URL");

  /** */
  public static final QName privilege = new QName(namespace,
                                                  "privilege");

  /** */
  public static final QName prop = new QName(namespace,
                                             "prop");

  /** */
  public static final QName property = new QName(namespace,
                                             "property");

  /** */
  public static final QName propertySearch = new QName(namespace,
                                             "property-search");

  /** */
  public static final QName propname = new QName(namespace,
                                                 "propname");

  /** */
  public static final QName propstat = new QName(namespace,
                                                 "propstat");

  /** */
  public static final QName _protected = new QName(namespace,
                                                   "protected");

  /** */
  public static final QName read = new QName(namespace,
                                             "read");

  /** */
  public static final QName readAcl = new QName(namespace,
                                                "read-acl");

  /** */
  public static final QName readCurrentUserPrivilegeSet = new QName(namespace,
                                                "read-current-user-privilege-set");

  /** */
  public static final QName recognizedPrincipal = new QName(namespace,
                                                     "recognized-principal");

  /** */
  public static final QName requiredPrincipal = new QName(namespace,
                                                     "required-principal");

  /** */
  public static final QName resource = new QName(namespace,
                                                 "resource");

  /** */
  public static final QName resourcetype = new QName(namespace,
                                                     "resourcetype");

  /** */
  public static final QName response = new QName(namespace,
                                                 "response");

  /** */
  public static final QName responseDescription = new QName(namespace,
                                                      "responsedescription");

  /** */
  public static final QName self = new QName(namespace,
                                             "self");

  /** */
  public static final QName source = new QName(namespace,
                                               "source");

  /** */
  public static final QName status = new QName(namespace,
                                                    "status");

  /** */
  public static final QName supportedPrivilege = new QName(namespace,
                                                        "supported-privilege");

  /** */
  public static final QName supportedPrivilegeSet = new QName(namespace,
                                                        "supported-privilege-set");

  /** */
  public static final QName supportedlock = new QName(namespace,
                                                  "supportedlock");

  /** */
  public static final QName unauthenticated = new QName(namespace,
                                                        "unauthenticated");

  /** */
  public static final QName unbind = new QName(namespace,
                                               "unbind");

  /** */
  public static final QName unlock = new QName(namespace,
                                               "unlock");

  /** */
  public static final QName write = new QName(namespace,
                                              "write");

  /** */
  public static final QName writeAcl = new QName(namespace,
                                                 "write-acl");

  /** */
  public static final QName writeContent = new QName(namespace,
                                                 "write-content");

  /** */
  public static final QName writeProperties = new QName(namespace,
                                                 "write-properties");
}

