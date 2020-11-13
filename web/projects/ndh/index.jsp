<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=Nyarugenge&Dir=projects/ndh/");
%>