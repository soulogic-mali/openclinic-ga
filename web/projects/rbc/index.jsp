<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=Peru&Dir=projects/pe/");
%>