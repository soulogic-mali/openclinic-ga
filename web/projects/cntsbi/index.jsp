<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=CNTS&Dir=projects/cntsbi/");
%>