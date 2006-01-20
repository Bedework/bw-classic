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
package org.bedework.tools.dumprestore.dump;

import org.bedework.tools.dumprestore.Defs;
import org.bedework.tools.dumprestore.dump.dumpling.DumpAll;


import java.io.FileWriter;
import java.io.OutputStreamWriter;

/** Application to dump calendar data.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class Dump implements Defs {
  DumpIntf di;

  /* Runtime arg -f Where we dump to.
   */
  private String fileName;

  /* runtime arg -i (id) */
  //private String id = "sa";

  String indent = "";

  private DumpGlobals globals = new DumpGlobals();

  Dump() throws Throwable {
  }

  void open() throws Throwable {
    di = new HibDump(globals.debug);

    if (fileName == null) {
      globals.out = new OutputStreamWriter(System.out);
    } else {
      globals.out = new FileWriter(fileName);
    }
  }

  void close() throws Throwable {
    globals.out.close();
  }

  void doDump() throws Throwable {

    new DumpAll(globals, di).dumpSection(null);
  }

  void stats() {
    globals.stats();
  }


  void processArgs(String[] args) throws Throwable {
    if (args == null) {
      return;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        globals.debug = true;
      } else if (args[i].equals("-ndebug")) {
        globals.debug = false;
      } else if (args[i].equals("-noarg")) {
      } else if (argpar("-f", args, i)) {
        i++;
        fileName = args[i];
      } else if (argpar("-i", args, i)) {
        i++;
        //id = args[i];
      } else {
        dmsg("Illegal argument: " + args[i]);
        throw new Exception("Invalid args");
      }
    }
  }

  boolean argpar(String n, String[] args, int i) throws Exception {
    if (!args[i].equals(n)) {
      return false;
    }

    if ((i + 1) == args.length) {
      throw new Exception("Invalid args");
    }
    return true;
  }

  static void dmsg(String s) {
    System.out.println(s);
  }

  /**
   * @param args
   */
  public static void main(String[] args) {
    Dump d = null;

    try {
      d = new Dump();

      d.processArgs(args);

      d.open();

      d.doDump();

      d.stats();
    } catch (Throwable t) {
      t.printStackTrace();
    } finally {
      try {
        d.close();
      } catch (Throwable t1) {
        t1.printStackTrace();
      }
    }
  }
}

