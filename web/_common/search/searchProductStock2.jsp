<%@page import="java.text.DecimalFormat,
                be.openclinic.pharmacy.ServiceStock,
                be.openclinic.pharmacy.ProductStock,
                be.openclinic.pharmacy.Product,
                java.util.Vector,
                java.util.Collections"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sReturnProductUidField = checkString(request.getParameter("ReturnProductStockUidField"));
	String sReturnProductNameField = checkString(request.getParameter("ReturnProductStockNameField"));
	String sReturnServiceStockFunction = checkString(request.getParameter("ReturnServiceStockFunction"));
	String sServiceStock = checkString(request.getParameter("servicestock"));
	String sProductName = checkString(request.getParameter("productname"));
    String main="";
	if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){
		main=MedwanQuery.getInstance().getConfigString("mainProductionWarehouseUID","");;
	}
	
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","searchinproductstock",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='servicestock' id='servicestock' onchange='setDefaultPharmacy();'>
					<option/>
					<%
						//Add all servicestocks where the user has access to
                        String defaultPharmacy = (String)session.getAttribute("defaultPharmacy");
                        Vector servicestocks = ServiceStock.getStocksByUser(activeUser.userid);
                        
                        ServiceStock stock;
                        for(int n=0; n<servicestocks.size(); n++){
                            stock = (ServiceStock)servicestocks.elementAt(n);
                        	if(main.length()>0 && main.equalsIgnoreCase(stock.getUid())){
                        		continue;
                        	}
                            out.print("<option value='"+stock.getUid()+"' "+(stock.getUid().equals(defaultPharmacy)?"selected":"")+">"+stock.getName().toUpperCase()+"</option>");
                        }
                    %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","code",sWebLanguage) %>/<%=getTran(request,"web","product",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='40' name='productname' id='productname' value='<%=sProductName%>'/></td>
		</tr>
	</table>
	<input type='submit' class='button' name='searchButton' value='<%=getTranNoLink("web","search",sWebLanguage) %>'/>
</form>

<%
	if(request.getParameter("searchButton")!=null){
		Vector productstocks = ProductStock.findNameAndCode(sServiceStock, "", sProductName,"", "", "", "", "", "", "", "", "", "OC_PRODUCT_NAME", "ASC");
		if(productstocks.size()>0){
			out.println("<table width='100%'>");
			//Add header
			out.println("<tr>");
			out.println("<td class='admin'>"+getTran(request,"web","code",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+getTran(request,"web","product",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+getTran(request,"web","level",sWebLanguage)+"</td>");
			out.println("</tr>");
			for(int n=0;n<productstocks.size();n++){
				ProductStock productStock = (ProductStock)productstocks.elementAt(n);
            	if(main.length()>0 && main.equalsIgnoreCase(productStock.getServiceStock().getUid())){
            		continue;
            	}
				out.println("<tr>");
				out.println("<td class='admin2'>"+productStock.getProduct().getCode()+"</td>");
				out.println("<td class='admin2'><b><a href='javascript:selectProductStock(\""+productStock.getUid()+"\",\""+productStock.getProduct().getName()+"\");'>"+productStock.getProduct().getName()+"</a></b>"+(sServiceStock.length()>0?"":" ("+productStock.getServiceStock().getName()+")")+"</td>");
				out.println("<td class='admin2'>"+productStock.getLevel()+"</td>");
				out.println("</tr>");
			}
			out.println("</table>");
		}
	}
%>

<script>
	function setDefaultPharmacy(){
	  var url = '<c:url value="/pharmacy/setDefaultPharmacy.jsp"/>?serviceStockUid='+document.getElementById("servicestock").value+'&ts='+new Date();
	  new Ajax.Request(url,{
	    method: "GET",
	    parameters: "",
	    onSuccess: function(resp){
	    }
	  });
	}
	
	function selectProductStock(uid,name){
		<%
			if(sReturnProductUidField.length()>0){
		%>
				if(window.opener.<%=sReturnProductUidField%>){
					window.opener.<%=sReturnProductUidField%>.value=uid;
				}
		<%
			}
			if(sReturnProductNameField.length()>0){
		%>
				if(window.opener.<%=sReturnProductNameField%>){
					window.opener.<%=sReturnProductNameField%>.value=name;
				}
		<%
			}
			if(sReturnServiceStockFunction.length()>0){
		%>
				window.opener.<%=sReturnServiceStockFunction%>;
		<%
			}
		%>
		window.close();
	}
	
	window.setTimeout("document.getElementById('productname').focus();",250);
	
</script>