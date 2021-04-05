<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=KCP&Dir=projects/kcp/");
%>