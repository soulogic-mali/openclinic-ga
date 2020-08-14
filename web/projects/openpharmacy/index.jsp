<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=OpenPharmacy&Dir=projects/openpharmacy/");
%>