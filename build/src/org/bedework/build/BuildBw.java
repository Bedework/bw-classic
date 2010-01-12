/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
package org.bedework.build;

import edu.rpi.sss.util.Args;

import java.io.File;

/** Rather than shell scripts which have to be built for Windows and Linux, try
 * to do as much as possible as a Java application.
 *
 * @author douglm
 */
public class BuildBw {
  private String quickstartHome;

  private String userHome = System.getProperty("user.home");

  // True if we are building for the quickstart
  private boolean quickstart;

  // Location of configs
  private String bwchome;

  // config name
  private String bwc = "default";

  // Offline build - no jar downloads
  private boolean offline;

  // Packages

  static class PackageInfo {
    String name;

    // Relative to quickstartHome
    String location;

    PackageInfo(final String name, final String location) {
      this.name = name;
      this.location = location;
    }
  }

  // Non-null if a package was specified
  private PackageInfo pkg;

  private PackageInfo caldav = new PackageInfo("caldav",
                                               "/bedework/projects/caldav");

  private PackageInfo carddav = new PackageInfo("carddav",
                                                "/bedework-carddav");

  private PackageInfo client = new PackageInfo("client",
                                               "/bwclient");

  private PackageInfo monitor = new PackageInfo("monitor",
                                                "/MonitorApp");

  private PackageInfo naming = new PackageInfo("naming",
                                               "/bwnaming");

  private PackageInfo tzsvr = new PackageInfo("tzsvr",
                                              "/bwtzsvr");

  private PackageInfo webcache = new PackageInfo("webcache",
                                                 "/cachedfeeder-1.0");

  private PackageInfo webdav = new PackageInfo("webdav",
                                               "/bedework/projects/webdav");

  boolean processArgs(final Args args) throws Throwable {
    if (args == null) {
      return true;
    }

    while (args.more()) {
      if (args.ifMatch("")) {
        continue;
      }

      // look for actions first

      if (args.ifMatch("-reindex")) {
        actionReindex(args);
        break;
      }

      if (args.ifMatch("-zoneinfo")) {
        actionZoneinfo(args);
        break;
      }

      if (args.ifMatch("-buildwebcache")) {
        buildWebCache(args);
        break;
      }

      if (args.ifMatch("-deploywebcache")) {
        deployWebCache(args);
        break;
      }

      if (args.ifMatch("-bwchome")) {
        bwchome = args.next();
      } else if (args.ifMatch("-quickstartHome")) {
        quickstartHome = args.next();
      } else if (args.ifMatch("-quickstart")) {
        quickstart = true;
      } else if (args.ifMatch("-usage")) {
        usage();
      } else if (args.ifMatch("-help")) {
        usage();
      } else if (args.ifMatch("-?")) {
        usage();
      } else if (args.ifMatch("?")) {
        usage();
      } else if (args.ifMatch("-bwc")) {
        bwc=args.next();
      } else if (args.ifMatch("-offline")) {
        offline=true;
      //   Projects
      } else if (args.ifMatch("-carddav")) {
        pkg = carddav;
      } else if (args.ifMatch("-caldav")) {
        pkg = caldav;
      } else if (args.ifMatch("-client")) {
        pkg = client;
      } else if (args.ifMatch("-webdav")) {
        pkg = webdav;
      } else if (args.ifMatch("-monitor")) {
        pkg = monitor;
      } else if (args.ifMatch("-naming")) {
        pkg = naming;
      } else if (args.ifMatch("-tzsvr")) {
        pkg = tzsvr;
      } else {
        error("Illegal argument: " + args.current());
        usage();
        return false;
      }
    }

    /* Validate the results */

    if (quickstartHome == null) {
      errorUsage("Must specify -quickstartHome");
    }

    if (quickstart) {
      if ("bwchome" != null) {
        errorUsage("Cannot specify both -quickstart and -bwchome");
      }

      bwchome = quickstartHome + "/bedework/config/bwbuild";
    } else if (bwchome == null) {
      bwchome = userHome + "/bwbuild";
    }

    echo("Using configuration home " + bwchome);

    String bedeworkConfig = bwchome + "/" + bwc;

    File f = new File(bedeworkConfig);

    if (!f.exists() || !f.isDirectory()) {
      errorUsage("Configuration " +
                 bedeworkConfig +
                 " does not exist or is not a bedework configuration.");
    }

    if (offline) {
      // Add param -Dorg.bedework.offline.build=yes
    }

    String pkgHome = null;

    pkgHome = quickstartHome;

    if (pkg != null) {
      pkgHome = pkgHome + "/" + pkg.location;
    }

    echo("Execute build file in " + pkgHome);

    return true;
  }

  private void actionReindex(final Args args) throws Throwable {

  }

  private void actionZoneinfo(final Args args) throws Throwable {

  }

  private void buildWebCache(final Args args) throws Throwable {
    pkg = webcache;
//  cd $QUICKSTART_HOME/cachedfeeder-1.0
  }

  private void deployWebCache(final Args args) throws Throwable {
    pkg = webcache;
//  cd $QUICKSTART_HOME/cachedfeeder-1.0
  }

  /**
   * @param args
   */
  public static void main(final String[] args) {
    BuildBw bw = null;

    try {
      bw = new BuildBw();

      if (!bw.processArgs(new Args(args))) {
        return;
      }

//      mc.process();
    } catch (Throwable t) {
      t.printStackTrace();
    }
  }

  private static void usage() {
    echo("  $PRG [CONFIG-SOURCE] [CONFIG] [PROJECT] [ -offline ] [ target ] ");
    echo("  $PRG ACTION");
    echo("");
    echo(" where:");
    echo("   CONFIG-SOURCE optionally defines the location of configurations and");
    echo("                 is one or none of  ");
    echo("     -quickstart    to use the configurations within the quickstart");
    echo("     -bwchome path  to specify the location of the bwbuild directory");
    echo("   The default is to look in the user home for the bwbuild directory.");
    echo("");
    echo("   CONFIG optionally defines the configuration to build");
    echo("      -bwc configname");
    echo("");
    echo("   -offline     Build without attempting to retrieve library jars");
    echo("   target       Ant target to execute");
    echo("");
    echo("   PROJECT optionally defines the package to build and is none or more of");
    echo("     -carddav     Target is for the CardDAV build");
    echo("     -client      Target is for the bedework client application build");
    echo("     -monitor     Target is for the bedework monitor application");
    echo("     -naming      Target is for the abstract naming api");
    echo("     -tzsvr       Target is for the timezones server build");
    echo("     The default is a calendar build");
    echo("");
    echo("   Invokes ant to build or deploy the Bedework system. Uses a configuration");
    echo("   directory which contains one directory per configuration.");
    echo("");
    echo("   Within each configuration directory we expect a file called build.properties");
    echo("   which should point to the property and options file needed for the deploy process");
    echo("");
    echo("   In general these files will be in the same directory as build.properties.");
    echo("   The environment variable BEDEWORK_CONFIG contains the path to the current");
    echo("   configuration directory and can be used to build a path to the other files.");
    echo("");
    echo("   ACTION defines an action to take usually in the context of the quickstart.");
    echo("    In a deployed system many of these actions are handled directly by a");
    echo("    deployed application. ACTION may be one of");
    echo("      -reindex    runs the indexer directly out of the quickstart bedework");
    echo("                  dist directory to rebuild the lucene indexes");
    echo("      -zoneinfo   builds zoneinfo data for the timezomnes server");
    echo("                  requires -version and -tzdata parameters ");
    echo("      -buildwebcache    builds webcache");
    echo("      -deploywebcache   builds and deploys webcache");
    echo("");
  }

  private static void errorUsage(final String msg) {
    System.err.println(msg);
    usage();
    System.exit(1);
  }

  private static void error(final String msg) {
    System.err.println(msg);
  }

  private static void echo(final String msg) {
    System.out.println(msg);
  }
}
