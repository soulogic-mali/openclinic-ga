<%@page import="java.util.*"%>
<%
	System.out.println(new java.util.Date().getTime()+"####################### PAYMENT CALLBACK #######################");
	Enumeration<String> params = request.getParameterNames();
	while(params.hasMoreElements()){
		String name = params.nextElement();
		System.out.println(name+" = "+request.getParameter(name));
	}
	java.io.BufferedReader br = request.getReader();
	String line ="";
    while((line = br.readLine()) != null) {
        System.out.println("****"+line);
	}

%>