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
package org.bedework.dumprestore.dump;

import java.io.Writer;
import java.util.Stack;

/**
 * @author douglm
 *
 */
/**
 * @author douglm
 *
 */
public class DumpGlobals {
  /** */
  public boolean debug;

  /** */
  public Writer out;

  /* Some counters */

  /** */
  public int filters;
  /** */
  public int users;

  /** */
  public int syspars;

  /** */
  public int timezones;

  /** */
  public int subscribedUsers;

  /** */
  public int subscriptions;

  /** */
  public int locations;

  /** */
  public int sponsors;

  /** */
  public int organizers;

  /** */
  public int attendees;

  /** */
  public int valarms;

  /** */
  public int categories;

  /** */
  public int authusers;

  /** */
  public int events;
  
  /** */
  public int eventAnnotations;

  /** */
  public int adminGroups;

  private String indent = "";
  private Stack indentStack = new Stack();

  /** */
  public DumpGlobals() {
  }

  /** */
  public void stats() {
    System.out.println("          syspars: " + syspars);
    System.out.println("            users: " + users);
    System.out.println("        timezones: " + timezones);
    System.out.println("  subscribedUsers: " + subscribedUsers);
    System.out.println("    subscriptions: " + subscriptions);
    System.out.println("        locations: " + locations);
    System.out.println("         sponsors: " + sponsors);
    System.out.println("       organizers: " + organizers);
    System.out.println("        attendees: " + attendees);
    System.out.println("           alarms: " + valarms);
    System.out.println("       categories: " + categories);
    System.out.println("        authusers: " + authusers);
    System.out.println("           events: " + events);
    System.out.println(" eventAnnotations: " + eventAnnotations);
    System.out.println("          filters: " + filters);
    System.out.println("      adminGroups: " + adminGroups);
  }

  /** */
  public void indentOut() {
    if (indentStack.empty()) {
      indent = "";
      return;
    }

    indent = (String)indentStack.pop();
  }

  /** */
  public void indentIn() {
    indentStack.push(indent);
    indent += "  ";
  }

  /**
   * @return writer
   */
  public String getIndent() {
    return indent;
  }

  /**
   * @return output writer
   */
  public Writer getOut() {
    return out;
  }
}
