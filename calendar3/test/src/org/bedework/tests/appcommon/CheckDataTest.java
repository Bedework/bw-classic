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
package org.bedework.tests.appcommon;

import java.sql.Date;
import java.sql.Time;
import java.util.Calendar;

import junit.framework.TestCase;

/**
   Test the CheckData class
   @author Leman Chung
   @version 1.1
  */
public class CheckDataTest extends TestCase {
   /**
   * @param name
   */
  public CheckDataTest(String name) {
     super(name);
   }

   /**
     Get a Date for today
     @return today, as a <code>Date</code>
    */
   public Date today() {
     return new Date(Calendar.getInstance().getTime().getTime());
   }

   /**
     Get a Date for tomorrow
     @return tomorrow, as a <code>Date</code>
    */
   public Date tomorrow() {
     Calendar c = Calendar.getInstance();
     c.add(Calendar.DATE, 1);
     return new Date(c.getTime().getTime());
   }

   /**
     Get noon, as a time
     @return noon, as a <code>Time</code>
    */
   public Time noon() {
     Calendar c = Calendar.getInstance();
     c.clear();
     c.set(Calendar.HOUR_OF_DAY, 12);
     return new Time(c.getTime().getTime());
   }

   /**
     Get 6:30pm, as a time
     @return 6:30pm, as a <code>Time</code>
    */
   public Time sixThirtyPm() {
     Calendar c = Calendar.getInstance();
     c.clear();
     c.set(Calendar.HOUR_OF_DAY, 18);
     c.set(Calendar.MINUTE, 30);
     return new Time(c.getTime().getTime());
   }

   /**
     Test the checkDateTimes method
    */
   public void testCheckDateTimes() {
     /* XXX needs redoing with DateTimeVO
     // Test calls with no time
     assertTrue(CheckData.checkDateTimes(today(), today(), new StringBuffer()));
     assertTrue(CheckData.checkDateTimes(today(), tomorrow(),
                                         new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(tomorrow(), today(),
                                          new StringBuffer()));

     // Test call with endtime, but no starttime
     assertFalse(CheckData.checkDateTimes(today(), null, today(), noon(),
                                         new StringBuffer()));

     // Test calls with starttime, but no endtime
     assertTrue(CheckData.checkDateTimes(today(), noon(), today(), null,
                                         new StringBuffer()));
     assertTrue(CheckData.checkDateTimes(today(), noon(), tomorrow(), null,
                                         new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(tomorrow(), noon(), today(), null,
                                          new StringBuffer()));

     // Test calls with both times
     assertTrue(CheckData.checkDateTimes(today(), noon(), today(), noon(),
                                         new StringBuffer()));
     assertTrue(CheckData.checkDateTimes(today(), noon(),
                                         today(), sixThirtyPm(),
                                         new StringBuffer()));
     assertTrue(CheckData.checkDateTimes(today(), noon(), tomorrow(), noon(),
                                         new StringBuffer()));
     assertTrue(CheckData.checkDateTimes(today(), noon(),
                                          tomorrow(), sixThirtyPm(),
                                          new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(today(), sixThirtyPm(),
                                          today(), noon(),
                                          new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(tomorrow(), noon(), today(), noon(),
                                          new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(tomorrow(), sixThirtyPm(),
                                          today(), noon(),
                                          new StringBuffer()));
     assertFalse(CheckData.checkDateTimes(tomorrow(), noon(),
                                          today(), sixThirtyPm(),
                                          new StringBuffer()));
                                          */
   }
}
