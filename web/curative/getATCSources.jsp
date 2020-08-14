<%@page import="be.openclinic.knowledge.*,be.openclinic.pharmacy.*,be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String atccode = request.getParameter("atccode");
	ATCClass atc = ATCClass.get(atccode);
	String encounteruid = request.getParameter("encounteruid");
	String type="",name="";
	Vector items = ClinicalAssistant.getEncounterItemsForATCClass(encounteruid, atccode);
	String[] fulllabel = atc.getFullLabel(sWebLanguage).split(">");
	String atclabel="<table>";
	for(int n=0;n<fulllabel.length;n++){
		atclabel+="<tr style='font-weight: bolder;color: white'><td>";
		for(int i=0;i<n;i++){
			atclabel+="&nbsp;";
		}
		atclabel+=fulllabel[n]+"</td></tr>";
	}
	atclabel+="</table>";
	out.println("<table width='100%'>");
	out.println("<tr class='admin'><td>"+atc.getCode()+"</td><td>"+atclabel+"</td></tr>");
	HashSet allitems = new HashSet();
	for(int n=0;n<items.size();n++){
		String item = (String)items.elementAt(n);
		type=item.split(";")[0];
		if(type.equalsIgnoreCase("product")){
			Product product = Product.get(item.split(";")[1]);
			type=getTranNoLink("web","product",sWebLanguage);
			name=product.getCode()+" - "+ product.getName();
		}
		else if(type.equalsIgnoreCase("prestation")){
			Prestation prestation = Prestation.get(item.split(";")[1]);
			type=getTranNoLink("web","prestation",sWebLanguage);
			name=prestation.getCode()+" - "+prestation.getDescription();
		}
		else if(type.equalsIgnoreCase("chronic")){
			Product product = Product.get(item.split(";")[1]);
			type=getTranNoLink("web","chronicmedication",sWebLanguage);
			name=product.getCode()+" - "+ product.getName();
		}
		else if(type.equalsIgnoreCase("delivered")){
			ProductStockOperation operation = ProductStockOperation.get(item.split(";")[1]);
			type=getTranNoLink("web.manage","medicationdelivery",sWebLanguage);
			name=operation.getDate()+": <b>"+ operation.getProductStock().getProduct().getName()+"</b>";
		}
		if(!allitems.contains(type+"."+name)){
			allitems.add(type+"."+name);
			out.println("<tr><td class='admin'>"+type+"</td><td class='admin2'>"+name+"</td></tr>");
		}
	}
	out.println("</table>");
%>
<input type='button' class='button' name='button' value='<%=getTranNoLink("web","close",sWebLanguage)%>' onclick='window.close();'/>