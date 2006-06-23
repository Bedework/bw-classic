/*
 * Copyright 2000-2004 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ca.mun.portal.strutsbridge.taglib;

import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.ServletRequest; // for javadoc

import org.apache.portals.bridges.struts.PortletServlet;
import org.apache.portals.bridges.struts.config.PortletURLTypes;
import org.apache.struts.taglib.html.FormTag;

/** Supports the Struts html:form tag to be used within uPortlet context for
 * generating urls for the bedework portlet.
 *
 * @author <a href="mailto:ate@douma.nu">Ate Douma</a>
 * @author <a href="mailto:satish@mun.ca">Satish Sekharan</a>
 * @author Mike Douglass    douglm at rpi.edu
 * @version $Id: RewriteTag.java 2005-10-25 12:31:13Z satish $
 */
public class CalFormTag extends FormTag {
  /* bedework dummy request parameter - it's an encoded form of ?b=de */
  private static final String bedeworkDummyPar = "%3Fb%3Dde";

  /**
   * Modifies the default generated form action url to be a valid Portlet ActionURL
   * when in the context of a {@link PortletServlet#isPortletRequest(ServletRequest) PortletRequest}.
   * @return the formStartElement
   */
  protected String renderFormStartElement() {
    String formStartElement = super.renderFormStartElement();

    if (!PortletServlet.isPortletRequest(pageContext.getRequest())) {
      return  formStartElement;
    }

    int actionURLStart = formStartElement.indexOf("action=") + 8;
    int actionURLEnd = formStartElement.indexOf('"', actionURLStart);

    String urlStr = formStartElement.substring(actionURLStart,
                                               actionURLEnd);

    try {
      URL url = new URL(urlStr);

      /* We want a context relative url */
      urlStr = url.getFile();

      //System.out.println("FFFFFFFFFFFFFFFFFFFFUrlStr = " + urlStr);

      /* Drop the context
       */
      int pos = urlStr.indexOf('/');
      if (pos > 0) {
        urlStr = urlStr.substring(pos);
      }

      urlStr = TagsSupport.getURL(pageContext, urlStr,
                                  PortletURLTypes.URLType.ACTION);

      /* remove embedded anchor because calendar xsl stylesheet
       * adds extra parameters later during transformation
       */
      pos = urlStr.indexOf('#');
      if (pos > -1) {
        urlStr = urlStr.substring(0, pos);
      }

      /* Remove bedework dummy request parameter -
       * it's an encoded form of ?b=de */
      urlStr = urlStr.replaceAll(bedeworkDummyPar, "");

      //Generate valid xml markup for transformationthrow new
      urlStr = urlStr.replaceAll("&", "&amp;");

      //System.out.println("FFFFFFFFFFFFFFFFFFFFUrlStr = " + urlStr);
    } catch (MalformedURLException mue) {
      return null;
    }

    return formStartElement.substring(0, actionURLStart) +
           urlStr +
           formStartElement.substring(actionURLEnd);
  }
}
