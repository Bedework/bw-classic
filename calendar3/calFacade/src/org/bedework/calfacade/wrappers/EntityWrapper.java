package org.bedework.calfacade.wrappers;

import org.bedework.calfacade.base.BwDbentity;

/** Intreface defining methods that must be implemented for an entity wrapper
 *
 * @author douglm
 */
public interface EntityWrapper {
  /** Avoid get and set so we don't expose the underlying object to request streams.
   *
   * @param val
   */
  public void putEntity(BwDbentity val);

  /** Avoid get and set so we don't expose the underlying object to request streams.
   *
   * @return BwDbentity
   */
  public BwDbentity fetchEntity();
}
