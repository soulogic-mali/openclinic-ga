<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<form name='linkForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td/>
			<td><%=getTran(request,"web","description",sWebLanguage) %></td>
			<td><%=getTran(request,"web","studyid",sWebLanguage) %></td>
			<td><%=getTran(request,"web", "modality", sWebLanguage) %></td>
			<td><%=getTran(request,"web","image",sWebLanguage) %></td>
		</tr>
		<%
			String serverid=SH.c(request.getParameter("serverid"));
			String transactionid=SH.c(request.getParameter("transactionid"));
			//We search for the existing studies that exist for this patient
			Vector<TransactionVO> pacstrans = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
			for(int n=0;n<pacstrans.size();n++){
				TransactionVO tran = pacstrans.elementAt(n);
				String orderuid = tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID");
				if(orderuid.length()==0 || orderuid.equalsIgnoreCase(serverid+"."+transactionid)){
					//This study is linked to the Imaging request. Show the thumbnail
					%>
					<tr>
						<td class='admin'><input type='checkbox' class='text' name='lcb_<%=tran.getServerId()+"."+tran.getTransactionId()%>' <%=orderuid.length()==0?"":"checked" %>></td>
						<td class='admin'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION")%></td>
						<td class='admin2'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>
										  <br/><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%></td>
						<td class='admin2'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY")%></td>
						<td class='admin2'><center><img id='i_<%=n%>' onerror='window.setTimeout("loadunknownimage(\"i_<%=n%>\")",100);document.getElementById("img_<%=n%>").style.display="none";' style='max-width: 60px; max-height:60px;' src='<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>'/></center></td>
					</tr>
					<%
				}
			}
		%>
	</table>
	<center><input onclick='saveLinks()' type='button' class='button' name='buttonSaveLinks' value='<%=getTran(request,"web","save",sWebLanguage)%>'/></center>
</form>
