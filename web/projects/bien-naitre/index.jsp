<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=BIEN-NAITRE&Dir=projects/bien-naitre/");
%>