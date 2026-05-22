/**
 * EncodingFilter.java - Character Encoding Filter
 * Servlet filter that ensures all HTTP requests and responses use UTF-8 character encoding
 * This is critical for proper support of Nepali language characters and multilingual content
 * Applied globally to all requests via web.xml configuration
 */
package com.edumatch.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override public void init(FilterConfig cfg) throws ServletException {}
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        chain.doFilter(req, res);
    }
    @Override public void destroy() {}
}
