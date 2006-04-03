package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CoreEventInfo;
import org.bedework.calfacade.filter.BwFilter;

import java.io.Serializable;
import java.util.Collection;

/** This is the events section of the low level interface to the calendar
 * database.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface EventsI extends Serializable {

  /* ====================================================================
   *                   Events
   * ==================================================================== */

  /** Return one or more events using the calendar, guid and optionally a 
   * recurrence-id as a key.
   *
   * <p>For non-recurring events, one and only one event should be returned
   * for any given guid.
   *
   * <p>For recurring events, the guid defines the 'master' event defining
   * the rules together with any exceptions.
   *
   * <p>The sequence number and the recurrence id define a particular instance
   * of a recurrence.
   *
   * <p>To specify the master entry provide a null recurrenceId or use the
   * recurRetrieval parameter.
   *
   * @param calendar     BwCalendar object restricting search or null.
   * @param   guid      String guid for the event
   * @param   rid       String recurrence id, null for non-recurring, null valued for
   *                    master or non-null-valued for particular occurrence.
   * @param recurRetrieval Takes value defined in CalFacadeDefs.
   * @return  Collection of CoreEventInfo objects representing event(s).
   * @throws CalFacadeException
   */
  public Collection getEvent(BwCalendar calendar, String guid, String rid,
                             int recurRetrieval) throws CalFacadeException;

  /** Return a single event for the current user
   *
   * @param   eventId       int id of the event
   * @return  CoreEventInfo object representing event.
   * @throws CalFacadeException
   * 
   * @deprecated - other calendar systems won't support this. Doesn't make sense
   *               for recurring events.
   */
  public CoreEventInfo getEvent(int eventId) throws CalFacadeException;

  /** Add an event to the database. The id and uid will be set in the parameter
   * object.
   *
   * @param val   EventVO object to be added
   * @param overrides    Collection of BwEventProxy objects which override instances
   *                     of the new event
   * @throws CalFacadeException
   */
  public void addEvent(BwEvent val,
                       Collection overrides) throws CalFacadeException;

  /** Update an event in the database.
   *
   * <p>This method will set any synchronization state entries to modified
   * unless we are synchronizing in which case that belonging to the current
   * user is set to mark the event as synchronized
   *
   * @param val   EventVO object to be replaced
   * @exception CalFacadeException If there's a db problem or problem with
   *     the event
   * @throws CalFacadeException
   */
  public void updateEvent(BwEvent val) throws CalFacadeException;

  /** This class allows the implementations to pass back some information
   * about what happened. If possible it should fill in the supplied fields.
   *
   * A result of zero for counts does not necessarily indicate nothing
   * happened, for example, the implementation may store elarms as part of
   * the event object and they just go as part of event deletion.
   */
  public static class DelEventResult {
    /**  false if it didn't exist
     */
    public boolean eventDeleted;

    /** Number of alarms deleted
     */
    public int alarmsDeleted;

    /** Constructor
     *
     * @param eventDeleted
     * @param alarmsDeleted
     */
    public DelEventResult(boolean eventDeleted,
                          int alarmsDeleted) {
      this.eventDeleted = eventDeleted;
      this.alarmsDeleted = alarmsDeleted;
    }
  }

  /** Delete an event and any associated alarms
   * Set any referring synch states to deleted.
   *
   * @param val                EventVO object to be deleted
   * @return DelEventResult    result.
   * @exception CalFacadeException If there's a database access problem
   */
  public DelEventResult deleteEvent(BwEvent val) throws CalFacadeException;

  /** Return the events for the current user within the given date/time
   * range.
   *
   * @param calendar     BwCalendar object restricting search or null.
   * @param filter       BwFilter object restricting search or null.
   * @param startDate    DateTimeVO start - may be null
   * @param endDate      DateTimeVO end - may be null.
   * @param recurRetrieval Takes value defined in CalFacadeDefs
   * @return Collection  of CoreEventInfo objects
   * @throws CalFacadeException
   */
  public Collection getEvents(BwCalendar calendar, BwFilter filter,
                              BwDateTime startDate, BwDateTime endDate,
                              int recurRetrieval)
          throws CalFacadeException;

  /* * Return true if this event is editable by the current user
   *
   * @param val                EventVO object to be tested
   * @return boolean
   * @throws CalFacadeException
   * /
  public boolean editable(BwEvent val) throws CalFacadeException;*/

  /* ====================================================================
   *                       Caldav support
   * Caldav as it stands at the moment requires that we save the arbitary
   * names clients might assign to events.
   * ==================================================================== */

  /** Get events given the calendar and String name. Return null for not
   * found. For non-recurring there should be only one event. Otherwise we
   * return the currently expanded set of recurring events.
   *
   * @param cal        CalendarVO object
   * @param val        String possible name
   * @return Collection of EventVO or null
   * @throws CalFacadeException
   */
  public Collection getEventsByName(BwCalendar cal, String val)
          throws CalFacadeException;
}
