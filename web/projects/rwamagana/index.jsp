<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=Rwamagana&Dir=projects/rwamagana/");
%>