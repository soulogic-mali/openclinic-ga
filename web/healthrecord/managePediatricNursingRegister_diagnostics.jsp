<%@include file="/includes/validateUser.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>

  		<tr class='admin'>
			<td colspan='8'><center><%=getTran(request,"pediatric","diagnostics",sWebLanguage) %></center></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><center><%=getTran(request,"pediatric","domain",sWebLanguage) %></center></td>
			<td colspan='2' class='admin'><center><%=getTran(request,"pediatric","diagnosis",sWebLanguage) %></center></td>
			<td colspan='4' class='admin'><center><%=getTran(request,"pediatric","relatedfactor",sWebLanguage) %></center></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><%=getTran(request,"pediatric","domain9class2",sWebLanguage) %></td>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosis9class2", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSIS9CLASS2", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factor9class2", "ITEM_TYPE_PEDIATRICANURSING_FACTOR9CLASS2", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><%=getTran(request,"pediatric","domain11class6",sWebLanguage) %></td>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosis11class6", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSIS11CLASS6", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factor11class6", "ITEM_TYPE_PEDIATRICANURSING_FACTOR11CLASS6", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin' rowspan='2'><%=getTran(request,"pediatric","class2",sWebLanguage) %></td>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosisclass2", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSISCLASS2", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factorclass2", "ITEM_TYPE_PEDIATRICANURSING_FACTORCLASS2", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosisclass2b", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSISCLASS2B", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factorclass2b", "ITEM_TYPE_PEDIATRICANURSING_FACTORCLASS2B", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><%=getTran(request,"pediatric","domain2class5",sWebLanguage) %></td>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosis2class5", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSIS2CLASS5", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factor2class5", "ITEM_TYPE_PEDIATRICANURSING_FACTOR2CLASS5", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><%=getTran(request,"pediatric","domain11class1",sWebLanguage) %></td>
			<td colspan='2' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "diagnosis11class1", "ITEM_TYPE_PEDIATRICANURSING_DIAGNOSIS11CLASS1", sWebLanguage, false,"")%></td>
			<td colspan='4' class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "factor11class1", "ITEM_TYPE_PEDIATRICANURSING_FACTOR11CLASS1", sWebLanguage, false,"")%></td>
		</tr>
  		<tr>
			<td colspan='2' class='admin'><%=getTran(request,"web","other",sWebLanguage) %></td>
			<td colspan='6' class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_OTHERDIAGNOSIS", 60, 1) %></td>
		</tr>

</logic:present>