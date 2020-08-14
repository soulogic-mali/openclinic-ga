<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","embracement",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_EMBRACEMENT", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","grasping",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_GRASPING", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","succion",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_SUCCION", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","crossedextension",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_CROSSEDEXTENSION", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","cardinalpoints",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_CARDINALPOINTS", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","autowalk",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_AUTOWALK", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","obstacle",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_OBSTACLE", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","babinski",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_BABINSKI", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","neckassym",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_NECKASSYM", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       							<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","necklaby",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_NACKLABY", "cnrkr.absentpresent", sWebLanguage, "") %></td>
       						</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","other",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='9'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_POSTURALOTHER", 60, 1) %>
						       	</td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='9'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_POSTURALCOMMENT", 60, 1) %>
						       	</td>
							</tr>
       					</table>
			       	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>