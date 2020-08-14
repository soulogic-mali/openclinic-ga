<%@page import="be.openclinic.system.*"%>
<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table>
<%
	String[] materials=checkString(request.getParameter("materials")).split(",");
	StringBuffer sResult=new StringBuffer();
	for(int n=0;n<materials.length;n++){
		String[] mats = materials[n].split(":");
		ProductStock stock = ProductStock.get(mats[0]);
		if(stock!=null){
			int quantity=1;
			if(mats.length>1){
				quantity=Integer.parseInt(mats[1]);
			}
			sResult.append("<tr>");
			sResult.append("<td class='admin'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteRawMaterial(\""+materials[n]+"\")'/></td>");
			sResult.append("<td class='admin'>"+(stock.getProduct()!=null?stock.getProduct().getCode():"?")+"</td>");
			sResult.append("<td class='admin'>"+(stock.getProduct()!=null?stock.getProduct().getName():"?")+"</td>");
			sResult.append("<td class='admin'>"+quantity+"</td>");
			sResult.append("<td class='admin'>"+(stock.getServiceStock()!=null?stock.getServiceStock().getName():"")+"</td>");
			sResult.append("</tr>");
		}
	}
	if(sResult.toString().length()>0){
		out.println("<tr class='admin'><td/>");
		out.println("<td>"+getTran(request,"web","code",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","description",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","quantity",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","servicestock",sWebLanguage)+"</td>");
		out.println("</tr>");
		out.println(sResult);
	}

%>
</table>