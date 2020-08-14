<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=OpenInsurance&Dir=projects/openinsurance/");
%>