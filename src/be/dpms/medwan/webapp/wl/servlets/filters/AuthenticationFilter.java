package be.dpms.medwan.webapp.wl.servlets.filters;

import be.dpms.medwan.common.model.IConstants;
import be.dpms.medwan.webapp.wo.authentication.AuthenticationTokenWO;
import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import be.dpms.medwan.services.authentication.exceptions.AuthenticationRequiredException;
import be.mxs.webapp.wl.session.SessionKeyFactory;
import be.openclinic.system.SH;
import net.admin.User;
import be.mxs.webapp.wl.session.SessionContainerFactory;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.webapp.wl.exceptions.InvalidSessionKeyException;
import be.mxs.webapp.wl.exceptions.SessionContainerFactoryException;

import javax.servlet.Filter;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

public class AuthenticationFilter implements Filter {

    public void init(javax.servlet.FilterConfig config) throws ServletException {

    }

    public void destroy(){

    }

    public void doFilter(javax.servlet.ServletRequest request, javax.servlet.ServletResponse response,
                         javax.servlet.FilterChain filterChain)
            throws java.io.IOException, javax.servlet.ServletException {

        try {

            verifyAuthentication(request);

            filterChain.doFilter(request, response);

        } catch (AuthenticationRequiredException e) {

            String contextPath = ((HttpServletRequest)request).getContextPath();
            String initialHTTPRequest = ( (HttpServletRequest)request ).getRequestURI().substring(contextPath.length()) + "?" + ( (HttpServletRequest)request ).getQueryString();

            AuthenticationTokenWO authenticationToken = new AuthenticationTokenWO();
            authenticationToken.setInitialHTTPRequest( initialHTTPRequest );

            SessionContainerWO sessionContainerWO;
            try {
                sessionContainerWO = (be.dpms.medwan.webapp.wo.common.system.SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO((HttpServletRequest)request, SessionContainerWO.class.getName());
            } catch (SessionContainerFactoryException e1) {
                throw new ServletException(e1.getMessage());
            }

            sessionContainerWO.setAuthenticationToken(authenticationToken);

            request.getRequestDispatcher(IConstants.MEDWAN_LOGIN_PAGE).forward(request, response);

        } catch (SessionContainerFactoryException e) {
            throw new ServletException(e.getMessage());
        }
    }

    private void verifyAuthentication(ServletRequest request) throws AuthenticationRequiredException, SessionContainerFactoryException {
        SessionContainerWO sessionContainerWO  = (be.dpms.medwan.webapp.wo.common.system.SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO((HttpServletRequest)request, SessionContainerWO.class.getName());
        HttpServletRequest httpRequest = ((HttpServletRequest)request);
        String URI=httpRequest.getRequestURI();
        
        String[] excludes = (SH.cs("authenticationExcludes","")+",/index.,/login.,checkLogin.,heartBeat.jsp,setSApwd.jsp,checkDB.jsp,blocked.jsp,loggedOut.jsp,sessionExpired.jsp,mpilogin.jsp,loginRemote.jsp,checkForMessage.jsp,setSnoozeInSession.jsp,wadoQuery.jsp").split(",");
        if ( sessionContainerWO == null ) { // This will never happen

            throw new AuthenticationRequiredException();

        } else {
        	//Exclude authentication pages
        	for(int n=0;n<excludes.length;n++) {
            	if(URI.indexOf(excludes[n])>-1) {
            		return;
            	}
        	}
            if(httpRequest.getParameter("AutoUserName")!=null){
                // active user
                User activeUser = new User();
                if(activeUser.initialize(request.getParameter("AutoUserName"),request.getParameter("AutoUserPassword"))){
                	sessionContainerWO.getSession().setAttribute("activeUser",activeUser);
                }
            }

        	//Validate if this is an authenticated session
        	if((new java.util.Date().getTime() - sessionContainerWO.getSession().getLastAccessedTime() >= sessionContainerWO.getSession().getMaxInactiveInterval()*1000) || sessionContainerWO.getSession().getAttribute("activeUser")==null) {
        		throw new AuthenticationRequiredException("Unauthenticated");
        	}
        }
    }
}
