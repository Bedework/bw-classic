package ca.mun.portal.strutsbridge;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

/** Implementation of <b>HttpServletResponseWrapper</b> that works with
 * uPortal 2.5.
 *
 * @author Satish Sekharan
 * @version 1.0
 */
public class PortletResponseWrapper extends HttpServletResponseWrapper {

  /** Constructor
   *
   * @param response HttpServletResponse
   */
  public PortletResponseWrapper(HttpServletResponse response) {
    super(response);
  }

  public ServletOutputStream getOutputStream() throws IOException {
    return getResponse().getOutputStream();
  }

  public PrintWriter getWriter() throws IOException {
    return (new PrintWriter(new OutputStreamWriter(getOutputStream(),
        getCharacterEncoding()), true));
  }

  public String encodeUrl(String path) {
    return super.encodeUrl(path);
  }
}