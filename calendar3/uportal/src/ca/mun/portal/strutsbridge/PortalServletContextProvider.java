package ca.mun.portal.strutsbridge;

import javax.portlet.GenericPortlet;
import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.apache.pluto.core.impl.PortletContextImpl;
import org.apache.portals.bridges.common.ServletContextProvider;

/**
 * ServletContextProviderImpl supplies access to the Servlet context of uPortal Portlet.
 *
 * @author Satish Sekharan
 */
public class PortalServletContextProvider implements ServletContextProvider {

  public ServletContext getServletContext(GenericPortlet portlet) {
    return ((PortletContextImpl)portlet.getPortletContext())
        .getServletContext();
  }

  public HttpServletRequest getHttpServletRequest(GenericPortlet portlet,
                                                  PortletRequest request)  {
    return (HttpServletRequest)((HttpServletRequestWrapper)request).getRequest();
  }


  public HttpServletResponse getHttpServletResponse(GenericPortlet portlet,
                                                    PortletResponse response) {
    PortletResponseWrapper wrapper = new PortletResponseWrapper((HttpServletResponse)response);

    return (HttpServletResponse)wrapper.getResponse();
  }

}