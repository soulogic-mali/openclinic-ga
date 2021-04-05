<%@page import="org.hamcrest.core.IsSame"%>
<%@page import="ocdhis2.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String datasetname = SH.c(request.getParameter("datasetname"));
%>

<form name='transactionForm' method='post'>
	<input type='hidden' name='objectType' id='objectType' value=''/>
	<input type='hidden' name='objectValue' id='objectValue' value=''/>
	<table width='100%'>
		<tr class='admin'><td colspan='3'><%=getTran(request,"web","analyzedhis2server",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","getdatasets",sWebLanguage) %></td>
			<td class='admin2'><input name='datasetname' class='text' type='text' value='<%=datasetname %>'%></td>
			<td class='admin2'><input type='submit' class='button' name='getDatasetsButton' value='<%=getTranNoLink("web","execute",sWebLanguage)%>'/></td>
		</tr>
	</table>
	<!-- Show the results -->
	<table width='100%'>
		<%
			DHIS2Server server = new DHIS2Server();
			if(request.getParameter("getDatasetsButton")!=null){
				out.println("<tr class='admin'>");
				out.println("<td colspan='3'>dataSets</td>");
				out.println("</tr>");
				try{
					Document document = server.getXml("/dataSets?fields=id,name");
					Element root = document.getRootElement();
					Element datasets = root.element("dataSets");
					if(datasets!=null){
						SortedMap<String,Element> sM = new TreeMap();
						Iterator<Element> iDatasets = datasets.elementIterator("dataSet");
						while(iDatasets.hasNext()){
							Element dataset = iDatasets.next();
							sM.put(new String(dataset.attributeValue("name").getBytes(),"UTF-8"),dataset);
						}
						Iterator<String> iSorts = sM.keySet().iterator();
						while(iSorts.hasNext()){
							Element dataset = sM.get(iSorts.next());
							if(datasetname.length()>0 && !new String(dataset.attributeValue("name").getBytes(),"UTF-8").toLowerCase().contains(datasetname.toLowerCase())){
								continue;
							}
							out.println("<tr>");
							out.println("<td class='admin'><b>"+new String(dataset.attributeValue("name").getBytes(),"UTF-8")+"</b></td>");
							out.println("<td class='admin2'><a href='javascript:getDataSet(\""+dataset.attributeValue("id")+"\");'>"+dataset.attributeValue("id")+"</a></td>");
							out.println("</tr>");
						}
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(request.getParameter("objectType")!=null){
				if(request.getParameter("objectType").equalsIgnoreCase("dataset")){
					Document document = server.getXml("/dataSets/"+request.getParameter("objectValue")+"?fields=id,name,categoryCombo[id,name],dataSetElements[dataElement[categoryCombo[id,name],id,name]]");
					Element root = document.getRootElement();
					out.println("<tr class='admin'>");
					out.println("<td>dataSet</td>");
					out.println("<td>"+new String(root.attributeValue("name").getBytes(),"UTF-8")+"</td>");
					out.println("<td><a href='javascript:getDataSet(\""+root.attributeValue("id")+"\");'>"+root.attributeValue("id")+"</a></td>");
					out.println("</tr>");
					Element categoryCombo = root.element("categoryCombo");
					if(categoryCombo!=null){
						out.println("<tr>");
						out.println("<td class='admin'>categoryCombo</td>");
						out.println("<td class='admin2'><b>"+new String(categoryCombo.attributeValue("name").getBytes(),"UTF-8")+"</b></td>");
						out.println("<td class='admin2'><a href='javascript:getCategoryCombo(\""+categoryCombo.attributeValue("id")+"\");'>"+categoryCombo.attributeValue("id")+"</a></td>");
						out.println("</tr>");
					}
					Element dataSetElements = root.element("dataSetElements");
					if(dataSetElements!=null){
						SortedMap<String,Element> sM = new TreeMap();
						Iterator<Element> idataSetElements = dataSetElements.elementIterator("dataSetElement");
						while(idataSetElements.hasNext()){
							Element dataElement = idataSetElements.next().element("dataElement");
							sM.put(new String(dataElement.attributeValue("name").getBytes(),"UTF-8"),dataElement);
						}
						Iterator<String> sI = sM.keySet().iterator();
						while(sI.hasNext()){
							Element dataElement = sM.get(sI.next());
							out.println("<tr>");
							out.println("<td class='admin'>dataElement</td>");
							out.println("<td class='admin2'><b>"+new String(dataElement.attributeValue("name").getBytes(),"UTF-8")+"</b></td>");
							out.println("<td class='admin2'>"+dataElement.attributeValue("id")+"</td>");
							out.println("</tr>");
							categoryCombo = dataElement.element("categoryCombo");
							if(categoryCombo!=null){
								out.println("<tr>");
								out.println("<td class='admin'></td>");
								out.println("<td class='admin2'><i>categoryCombo: "+new String(categoryCombo.attributeValue("name").getBytes(),"UTF-8")+"</i></td>");
								out.println("<td class='admin2'><i><a href='javascript:getCategoryCombo(\""+categoryCombo.attributeValue("id")+"\");'>"+categoryCombo.attributeValue("id")+"</a></i></td>");
								out.println("</tr>");
							}
						}
					}
				}
				else if(request.getParameter("objectType").equalsIgnoreCase("categoryCombo")){
					Document document = server.getXml("/categoryCombos/"+request.getParameter("objectValue")+"?fields=id,name,categoryOptionCombos[id,name]");
					Element root = document.getRootElement();
					out.println("<tr class='admin'>");
					out.println("<td>categoryCombo</td>");
					out.println("<td>"+new String(root.attributeValue("name").getBytes(),"UTF-8")+"</td>");
					out.println("<td><a href='javascript:getCategoryCombo(\""+root.attributeValue("id")+"\");'>"+root.attributeValue("id")+"</a></td>");
					out.println("</tr>");
					Element categoryOptionCombos = root.element("categoryOptionCombos");
					if(categoryOptionCombos!=null){
						SortedMap<String,Element> sM = new TreeMap();
						Iterator <Element>iCategoryOptionCombo = categoryOptionCombos.elementIterator("categoryOptionCombo");
						while(iCategoryOptionCombo.hasNext()){
							Element categoryOptionCombo = iCategoryOptionCombo.next();
							sM.put(new String(categoryOptionCombo.attributeValue("name").getBytes(),"UTF-8"),categoryOptionCombo);
						}
						Iterator<String> iS = sM.keySet().iterator();
						while(iS.hasNext()){
							Element categoryOptionCombo = sM.get(iS.next());
							out.println("<tr>");
							out.println("<td class='admin'>categoryOptionCombo</td>");
							out.println("<td class='admin2'><b>"+new String(categoryOptionCombo.attributeValue("name").getBytes(),"UTF-8")+"</b></td>");
							out.println("<td class='admin2'>"+categoryOptionCombo.attributeValue("id")+"</td>");
							out.println("</tr>");
						}
					}
				}
			}
		%>
	</table>
</form>

<script>
	function getDataSet(id){
		document.getElementById('objectType').value='dataSet';
		document.getElementById('objectValue').value=id;
		transactionForm.submit();
	}
	function getCategoryCombo(id){
		document.getElementById('objectType').value='categoryCombo';
		document.getElementById('objectValue').value=id;
		transactionForm.submit();
	}
</script>