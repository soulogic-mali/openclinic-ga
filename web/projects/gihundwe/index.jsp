<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=Gihundwe&Dir=projects/gihundwe/");
%>