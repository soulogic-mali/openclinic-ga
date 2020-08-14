<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=LAMEDICALE&Dir=projects/medicale/");
%>