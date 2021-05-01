<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=CARAES-HUYE&Dir=projects/nderahuye/");
%>