package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.CalFacadeException;

import java.io.Serializable;
import java.util.Collection;

/** This is the calendars section of the low level interface to the calendar
 * database.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface CalendarsI extends Serializable {

  /* ====================================================================
   *                   Calendars
   * ==================================================================== */

  /** Returns the tree of public calendars. The returned objects are those to
   * which the current user has access and are copies of the actual db objects,
   * that is, the actual db objecst will need to be fetched for updates.
   *
   * @return BwCalendar   root with all children attached
   * @throws CalFacadeException
   */
  public BwCalendar getPublicCalendars() throws CalFacadeException;

  /** Return a list of public calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   * @throws CalFacadeException
   */
  public Collection getPublicCalendarCollections() throws CalFacadeException;

  /** Returns calendars owned by the current user.
   *
   * <p>For anonymous (public events) access, this method returns the same
   * as getPublicCalendars().
   *
   * <p>For authenticated, personal access this always returns the user
   * entry in the /user calendar tree, e.g. for user smithj it would return
   * an entry smithj
   *
   * @return BwCalendar   root with all children attached
   * @throws CalFacadeException
   */
  public BwCalendar getCalendars() throws CalFacadeException;

  /** Return a list of user calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   * @throws CalFacadeException
   */
  public Collection getCalendarCollections() throws CalFacadeException;

  /** Return a list of calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of BwCalendar
   * @throws CalFacadeException
   */
  public Collection getAddContentPublicCalendarCollections()
          throws CalFacadeException;

  /** Return a list of calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of BwCalendar
   * @throws CalFacadeException
   */
  public Collection getAddContentCalendarCollections()
          throws CalFacadeException;

  /** Get a calendar we are interested in. This is represented by the id
   * of a calendar.
   *
   * @param  val     int id of calendar
   * @return CalendarVO null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getCalendar(int val) throws CalFacadeException;

  /** Get a calendar given the path
   *
   * @param  path     String path of calendar
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getCalendar(String path) throws CalFacadeException;

  /** Get the default calendar for the current user.
   *
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getDefaultCalendar() throws CalFacadeException;

  /** Get the trash calendar for the current user.
   *
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getTrashCalendar() throws CalFacadeException;

  /** Add a calendar object
   *
   * <p>The new calendar object will be added to the db. If the indicated parent
   * is null it will be added as a root level calendar.
   *
   * <p>Certain restrictions apply, mostly because of interoperability issues.
   * A calendar cannot be added to another calendar which already contains
   * entities, e.g. events etc.
   *
   * <p>Names cannot contain certain characters - (complete this)
   *
   * <p>Name must be unique at this level, i.e. all paths must be unique
   *
   * @param  val     CalendarVO new object
   * @param  parent  CalendarVO object or null for root level
   * @throws CalFacadeException
   */
  public void addCalendar(BwCalendar val, BwCalendar parent) throws CalFacadeException;

  /** Update a calendar object
   *
   * @param  val     CalendarVO object
   * @throws CalFacadeException
   */
  public void updateCalendar(BwCalendar val) throws CalFacadeException;

  /** Delete the given calendar
   *
   * <p>XXX Do we want a recursive flag or do we implement that higher up?
   *
   * @param val      CalendarVO object to be deleted
   * @return boolean false if it didn't exist, true if it was deleted.
   * @throws CalFacadeException
   */
  public boolean deleteCalendar(BwCalendar val) throws CalFacadeException;

  /** Check to see if a calendar is referenced.
   *
   * @param val      CalendarVO object to check
   * @return boolean true if the calendar is referenced somewhere
   * @throws CalFacadeException
   */
  public boolean checkCalendarRefs(BwCalendar val) throws CalFacadeException;
}
