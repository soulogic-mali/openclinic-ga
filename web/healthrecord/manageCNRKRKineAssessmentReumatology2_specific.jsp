<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","palmup",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PALMUP", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","patte",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PATTE", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","neer",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_NEER", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","hawkins",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_HAWKINS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","yocum",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_YOCUM", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","yergason",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_YERGASON", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","flick",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_FLICK", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","rabot",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_RABOT", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","crank",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_CRANK", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","fulcrum",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_FULCRUM", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","zohlein",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_ZOHLEIN", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","shelve.ant",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_SHELVEANT", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","shelve.post",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_SHELVEPOST", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","sillon",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_SILLON", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","jobe",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_JOBE", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","droparm",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_DROPARM", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","gilchrist",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_GILCHRIST", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","gerber",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_GERBER", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","valgusstress",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_VALGUSSTRESS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","varusstress",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_VARUSSTRESS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","wrist.ext",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_WRISTEXT", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","wrist.flex",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_WRISTFLEX", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","scaph",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_SCAPH", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","watson",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_WATSON", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","bunnel",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_BUNNEL", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","wrist.varus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_WRISTVARUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","wrist.valgus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_WRISTVALGUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","tinel",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_TINEL", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","phalen",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PHALEN", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","froment",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_FROMENT", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","right.ant",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_RIGHTANT", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","thomas",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_THOMAS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","ober",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_OBER", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","patrick",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PATRICK", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","buttock",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_BUTTOCK", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","lasegue.lomb",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_LASEGUELOMB", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","lasegue.real",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_LASEGUEREAL", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","lasegue.crossed",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_LASEGUECROSSED", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","bragard",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_BRAGARD", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","leri",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_LERI", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","vasalva",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_VASALVA", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","knee.valgus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_KNEEVALGUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","knee.varus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_KNEEVARUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","lachman",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_LACHMAN", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","patella.bomb",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PATELLABOMB", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","patella.shock",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_PATELLASHOCK", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","genety",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_GENETY", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","mcmurray",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_MCMURRAY", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","grinding",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_GRINDING", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","drawer",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_DRAWER", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","thompson",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_THOMPSON", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","hoffa",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_HOFFA", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","ankle.varus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_ANKLEVARUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","ankle.valgus",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_ANKLE.VALGUS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","homans",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_HOMANS", "cnrkr.posneg", sWebLanguage, "") %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2' colspan='9'>
			<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SPEC_COMMENT", 80, 1) %>
		</td>
	</tr>
</table>