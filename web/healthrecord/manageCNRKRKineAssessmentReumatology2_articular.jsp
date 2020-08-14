<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='15'>
			<center><%=getTran(request,"cnrkr","goniometry",sWebLanguage)%></center>
		</td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","flexion",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","extension",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","abduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","adduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","internalrotation",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","externalrotation",sWebLanguage)%></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
	</tr>
	<tr>
		<%String m = "SHOULDER";%>
		<td class='admin'><%=getTran(request,"cnrkr","shoulder",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_IROTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_IROTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EROTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EROTL", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<%m = "ELBOW";%>
		<td class='admin'><%=getTran(request,"cnrkr","elbow",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2'style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","flexion",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","extension",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","ulnarinclination",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","radialinclination",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","pronation",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","supination",sWebLanguage)%></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
	</tr>
	<tr>
		<%m = "FOREARM";%>
		<td class='admin'><%=getTran(request,"cnrkr","forearm",sWebLanguage)%></td>
		<td class='admin2' colspan='8'></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_PROR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_PROL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_SUPR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_SUPL", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<%m = "WRIST";%>
		<td class='admin'><%=getTran(request,"cnrkr","wrist",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ULNR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ULNL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_RADR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_RADL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='4'></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","flexion",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","extension",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","abduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","adduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","internalrotation",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","externalrotation",sWebLanguage)%></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
	</tr>
	<tr>
		<%m = "FINGERMP";%>
		<td class='admin'><%=getTran(request,"cnrkr","fingermp",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<%m = "FINGERTP";%>
		<td class='admin'><%=getTran(request,"cnrkr","fingertp",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='4'></td>
	</tr>
	<tr>
		<%m = "FINGERIPP";%>
		<td class='admin'><%=getTran(request,"cnrkr","fingeripp",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<%m = "FINGERIPD";%>
		<td class='admin'><%=getTran(request,"cnrkr","fingeripd",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<%m = "HIP";%>
		<td class='admin'><%=getTran(request,"cnrkr","hip",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_IROTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_IROTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EROTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EROTL", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<%m = "KNEE";%>
		<td class='admin'><%=getTran(request,"cnrkr","knee",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","flexion",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","extension",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","abduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","adduction",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","inversion",sWebLanguage)%></td>
		<td class='admin' style='text-align: center' colspan='2'><%=getTran(request,"cnrkr","eversion",sWebLanguage)%></td>
	</tr>
	<tr>
		<td class='admin2'></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","R",sWebLanguage)%></td>
		<td class='admin' style='text-align: center'><%=getTran(request,"cnrkr","L",sWebLanguage)%></td>
	</tr>
	<tr>
		<%m = "ANKLE";%>
		<td class='admin'><%=getTran(request,"cnrkr","ankle",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='4'></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_INVR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_INVL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EVR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EVL", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<%m = "TOEMP";%>
		<td class='admin'><%=getTran(request,"cnrkr","toemp",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ABDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_ADDL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='4'></td>
	</tr>
	<tr>
		<%m = "TOEIPP";%>
		<td class='admin'><%=getTran(request,"cnrkr","toeipp",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<%m = "TOEIPD";%>
		<td class='admin'><%=getTran(request,"cnrkr","toeipd",sWebLanguage)%></td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_FLEXL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTR", 3, sWebLanguage) %>
		</td>
		<td class='admin2' style='text-align: center'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTIC"+m+"_EXTL", 3, sWebLanguage) %>
		</td>
		<td class='admin2' colspan='8'></td>
	</tr>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"cnrkr","endsensation",sWebLanguage)%>
		</td>
		<td class='admin2' colspan='12'>
			<table width='100%'>
				<tr>
					<td width='30%'>
 						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTICENDSENSATION", "cnrkr.endsensation", sWebLanguage, "") %>
 					</td>
 					<td>
 						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_ARTICENDSENSATIONTEXT", 30, 1) %>
 					</td>
	   			</tr>
	   		</table>
	   	</td>
	</tr>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"cnrkr","cracking",sWebLanguage)%>
		</td>
		<td class='admin2' colspan='12'>
			<table width='100%'>
				<tr>
					<td width='30%'>
 						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ARTICCRACKING", "cnrkr.yesno", sWebLanguage, "") %>
 					</td>
 					<td>
 						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_ARTICCRACKINGTEXT", 30, 1) %>
 					</td>
	   			</tr>
	   		</table>
	   	</td>
	</tr>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"web","comment",sWebLanguage)%>
		</td>
		<td class='admin2' colspan='12'>
			<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_ARTICOMMENT", 80, 1) %>
	   	</td>
	</tr>
</table>	