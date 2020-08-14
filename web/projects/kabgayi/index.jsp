<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=Kabgayi&Dir=projects/kabgayi/");
%>