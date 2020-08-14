<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
<%
	if(checkString(request.getParameter("norms")).length()>0){
		String[] norms=checkString(request.getParameter("norms")).split(";");
		SortedSet normset = new TreeSet();
		for(int n=0;n<norms.length;n++){
			normset.add(norms[n]);
		}
		Iterator inorms = normset.iterator();
		while(inorms.hasNext()){
			String norm = (String)inorms.next();
			out.println("<tr><td class='admin2' width='1%' nowrap>["+norm.split("\\@")[0].toUpperCase()+"] "+norm.split("\\@")[1].toUpperCase()+"&nbsp;&nbsp;</td><td class='admin2'><b>"+getTran(request,"admin.nomenclature.asset",norm.split("\\@")[1],sWebLanguage)+"</b></td></tr>");
		}
	}
%>
</table>