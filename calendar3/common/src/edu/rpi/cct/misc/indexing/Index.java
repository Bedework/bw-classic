package edu.rpi.cct.misc.indexing;

import java.io.Serializable;

/** This interface describes how we build and search indexes for
 * applications such as Luwak, forum systems etc.
 */
public interface Index extends Serializable {
  public void setDebug(boolean val);

  /** This might need to be called to open the index in the appropriate manner
   *  probably determined by information passed to the constructor.
   */
  public void open() throws IndexException;

  /** This can be called to (re)create the index. It will destroy any
   * previously existing index.
   */
  public void create() throws IndexException;

  /** See if we need to call open
   */
  public boolean getIsOpen();

  /** This gives a single keyword to identify the implementation.
   *
   * @return  String    An identifying key.
   */
  public String id();

  /** This can be called to obtain some information about the index
   * implementation. id gives a single keyword whereas this gives a more
   * detailed description.
   *
   * @return  String    A descrptive string.
   */
  public String info();

  /** Called to (re)index a record
   *
   * @param   rec      The record to index
   */
  public void indexRec(Object rec) throws IndexException;

  /** Called to unindex a record
   *
   * @param   rec      The record to unindex
   */
  public void unindexRec(Object rec) throws IndexException;

  /** Called to (re)index a batch of records
   *
   * @param   recs     The records to index
   */
  public void indexRecs(Object[] recs) throws IndexException;

  /** Called to index a batch of new records. More efficient way of
   * rebuilding the index.
   *
   * @param   recs     The records to index
   */
  public void indexNewRecs(Object[] recs) throws IndexException;

  /** Called to unindex a batch of records
   *
   * @param   recs      The records to unindex
   */
  public void unindexRecs(Object[] recs) throws IndexException;

  /** Called to find entries that match the search string. This string may
   * be a simple sequence of keywords or some sort of query the syntax of
   * which is determined by the underlying implementation.
   *
   * @param   query    Query string
   * @return  int      Number found. 0 means none found,
   *                                -1 means indeterminate
   */
  public int search(String query) throws IndexException;

  /** The implementation will determine what information the Key object
   * actually contains. The getRecord method can be called to retrieve the
   * referenced entry.
   */
  public abstract class Key {
    public float score;       // Score this record

    public abstract Object getRecord() throws IndexException;
  }

  /** Called to retrieve record keys from the result.
   *
   * @param   n        Starting index
   * @param   keys     Array for the record keys
   * @return  int      Actual number of records
   */
  public int retrieve(int n, Key[] keys) throws IndexException;

  /** Called if we intend to run a batch of updates. endBatch MUST be
   * called or manual intervention may be required to remove locks.
   */
  public void startBatch() throws IndexException;

  /** Called at the end of a batch of updates.
   */
  public void endBatch() throws IndexException;

  /** Called to close at the end of a session.
   */
  public void close() throws IndexException;

  /** Called to provide some debugging dump info. Must be open.
   */
  public void dump();

  /** Called to provide some statistics. Must be open.
   */
  public void stats();

}
