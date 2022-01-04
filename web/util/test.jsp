<%@page import="java.util.*"%>
<%@page import="org.dom4j.*"%>
<%@page import="be.mayele.*"%>
<%@page import="be.mayele.bi.*"%>
<%
	HashMap parameters = new HashMap();
	parameters.put("key", "ABCD1234");
	parameters.put("format","xml");
	parameters.put("module","bi.hf");
	Vector<hf> v = hf.find("http://10.0.0.1/mayele/mayele/find.jsp", parameters);
	for(int n=0;n<v.size();n++){
		hf hf = v.elementAt(n);
		System.out.println("name ="+hf.getName());
	}
%>