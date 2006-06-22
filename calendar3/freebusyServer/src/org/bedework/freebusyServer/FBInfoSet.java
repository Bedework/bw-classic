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
package org.bedework.freebusyServer;

import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

/** Maintain information about the users (or groups) whose free/busy we are querying.
 *
 * @author Mike Douglass
 */
public class FBInfoSet {
  // Temp - maintain local set
  private TreeSet infoSet = new TreeSet();

  /** Constructor
   *
   * @throws Throwable
   */
  public FBInfoSet() throws Throwable {
    /*
    addInfo(new UserInfo("douglm", "testuser01", "bedework",
                         "localhost", 8080, false,
                         "/ucaldav/user/douglm"));
    addInfo(new UserInfo("testuser01", "bedework", "johnsa",
                         "localhost", 8080, false,
                         "/ucaldav/user/johnsa"));
                         */
    /*
    addInfo(new UserInfo("testuser02", "testuser02", "bedework",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser02"));
                         */
    addInfo(new FBUserInfo("douglm", "douglm", "bedework",
                         "localhost", 8080, false,
                         "/ucaldav/user/douglm"));
/*
    addInfo(new UserInfo("testuser02", "testuser02", "bedework",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser02"));
    addInfo(new UserInfo("testuser08", "testuser08", "bedework",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser08"));
*/
  }

  /** Get a set of all users.
   *
   * @return Set
   * @throws Throwable
   */
  public Set getAll() throws Throwable {
    return infoSet;
  }

  /**
   * @param account    - String account to locate
   * @return FBUserInfo or null
   * @throws Throwable
   */
  public FBUserInfo getInfo(String account) throws Throwable {
    Iterator it = infoSet.iterator();

    while (it.hasNext()) {
      FBUserInfo info = (FBUserInfo)it.next();
      if (account.equals(info.getAccount())) {
        return info;
      }
    }

    return null;
  }

  /**
   * @param val  FBUserInfo
   * @return true if added - false if already there
   * @throws Throwable
   */
  public boolean addInfo(FBUserInfo val) throws Throwable {
    return infoSet.add(val);
  }

  /**
   * @param account    - String account to remove
   * @throws Throwable
   */
  public void removeInfo(String account) throws Throwable {
    infoSet.remove(new FBUserInfo(account));
  }
}
