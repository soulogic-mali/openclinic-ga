<%@ page import="be.openclinic.pharmacy.*,java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.pdf.general.*,org.dom4j.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<td class='admin' width=1% nowrap>
					<%=getTran(request,"web","period",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<%=getTran(request,"web","from",sWebLanguage)%> <%=ScreenHelper.writeDateField("begin", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), true, true, sWebLanguage, sCONTEXTPATH) %>
					<%=getTran(request,"web","to",sWebLanguage)%> <%=ScreenHelper.writeDateField("end", "transactionForm", ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()+ScreenHelper.getTimeYear())), true, true, sWebLanguage, sCONTEXTPATH) %>
				</td>
				<td class='admin2' rowspan='3'>
					<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
				</td>
			</tr>
            <%-- Service stocks --%>
            <tr>
                <td class="admin" nowrap><%=getTran(request,"Web","servicestock",sWebLanguage)%></td>
                <td class="admin2" colspan='2'>
                	<table width='100%'>
               		<%
						Vector servicestocks = ServiceStock.findAll();   
	               		for(int n=0;n<servicestocks.size();n++){
							ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
							if(stock.isAuthorizedUser(activeUser.userid)){
								out.println("<tr><td><input "+(stock.getUid().equals(sServiceStockId)?"checked":"")+" type='checkbox' class='text' name='cbServiceStock."+stock.getUid()+"'/>"+stock.getName()+"</td></tr>");
							}
	               		}
               		%>
                	</table>
                </td>
            </tr>
		</table>
	</form>

	<script>
		function printReport(){
			var servicestocks='';
			for(n=0;n<document.all.length;n++){
				if(document.all[n] && document.all[n].name && document.all[n].name.indexOf("cbServiceStock")>-1 && document.all[n].checked){
					servicestocks+=document.all[n].name.replace("cbServiceStock.","")+";";
				}
			}
			window.open('<c:url value="pharmacy/printPoiExpiration.jsp"/>?begin='+document.getElementById('begin').value+'&end='+document.getElementById('end').value+'&ServiceStockUid='+servicestocks);
			window.close();
		}
		
		  <%-- SEARCH CATEGORY --%>
		  function searchCategory(CategoryUidField,CategoryNameField){
		    openPopup("/_common/search/searchDrugCategory.jsp&ts=<%=getTs()%>&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
		  }

		  <%-- UPDATE DRUG CATEGORY PARENTS --%>
		  function updateDrugCategoryParents(code){
		    document.getElementById('drugcategorydiv').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
		    
		    var params = 'code='+code+'&language=<%=sWebLanguage%>';
		    var url = '<c:url value="/pharmacy/updateDrugCategoryParents.jsp"/>?ts='+new Date();
			new Ajax.Request(url,{
		      method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		        $('drugcategorydiv').innerHTML = resp.responseText;
		      },
			  onFailure: function(resp){
			    $('drugcategorydiv').innerHTML = "";
		      }
			});
		  }

	</script>