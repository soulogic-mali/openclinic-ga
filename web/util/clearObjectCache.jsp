<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name='transactionForm' method='post'>
<%
	if(request.getParameter("clear")!=null){
		int objects = MedwanQuery.getInstance().getObjectCache().size();
		MedwanQuery.getInstance().getObjectCache().reset();
		out.println(objects+" "+getTran(request,"web","objectsremoved",sWebLanguage)+"</br/>");
	}
	else{
		Hashtable objects = MedwanQuery.getInstance().getObjectCache().getObjects();
		Hashtable objectcounts = new Hashtable();
		Enumeration e = objects.keys();
		while(e.hasMoreElements()){
			String key = ((String)e.nextElement()).split("\\.")[0];
			if(objectcounts.get(key)==null){
				objectcounts.put(key,new Double(1));
			}
			else{
				objectcounts.put(key,1+(Double)objectcounts.get(key));
			}
		}
		if(objectcounts.size()>0){
			out.println("<table width='50%'><tr class='admin'><td>"+getTran(request,"web","object",sWebLanguage)+"</><td>"+getTran(request,"web","total",sWebLanguage)+"</td></tr>");
			Enumeration e2 = objectcounts.keys();
			while(e2.hasMoreElements()){
				String key=(String)e2.nextElement();
				out.println("<tr><td class='admin'>"+key+"</td><td class='admin2'>"+objectcounts.get(key)+"</td></tr>");
			}
			out.println("<table></br/></br/><input class='button' type='submit' name='clear' value='"+getTranNoLink("web","clear",sWebLanguage)+"'/>");
		}
		else{
			out.println(getTran(request,"web","noobjectsincache",sWebLanguage)+"</br/></br/>");
		}
	}
%>
	<input type='submit' class='button' name='refresh' value='<%=getTranNoLink("web","refresh",sWebLanguage) %>'/>
</form>