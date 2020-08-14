<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","observation",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='25%'>
									<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STRETCHMARKS"><%=getTran(request,"cnrkr","stretchmarks",sWebLanguage)%></div>
								</td>
								<td class='admin2'>
									<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STRETCHMARKS", "cnrkr.stretchmarks", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
						      	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='25%'><%=getTran(request,"cnrkr","operation.scar",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_OPERATIONSCAR", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='25%'><%=getTran(request,"cnrkr","abdominalptosis",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ABDOMINALPTOSIS", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='25%'><%=getTran(request,"web","comment",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ABDOMINALCOMMENT", 60, 1) %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","palpation",sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' width='25%'><%=getTran(request,"cnrkr","tonus",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_TONUS", "cnrkr.abdominaltonus",sWebLanguage, "") %></td>
								<td class='admin' width='25%'><%=getTran(request,"cnrkr","contractures",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_CONTRACTURES","cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' width='25%'><%=getTran(request,"web","abdomenpain",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_PAIN","cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
								<td class='admin2' nowrap colspan='5'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_PALPATIONCOMMENT", 30, 1) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","functionaltests",sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","coughreflex.volume",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_COUGHREFLEX1","cnrkr.yesno",  sWebLanguage, "") %></td>
								<td class='admin'><%=getTran(request,"cnrkr","coughreflex.contraction",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_COUGHREFLEX2","cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin'><%=getTran(request,"web","diastasis",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_DIASTASIS","cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
								<td class='admin2' nowrap colspan='5'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_TESTCOMMENT", 30, 1) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","muscletests",sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","abdominalright",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_ABDOMINALRIGHT", sWebLanguage, "",0,5) %></td>
								<td class='admin'><%=getTran(request,"cnrkr","transverse",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_TRANSVERSE", sWebLanguage, "",0,5) %></td>
								<td class='admin'><%=getTran(request,"web","intobright",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_INTOBRIGHT", sWebLanguage, "",0,5) %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"web","intobleft",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_INTOBLEFT", sWebLanguage, "",0,5) %></td>
								<td class='admin'><%=getTran(request,"web","extobright",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_EXTOBRIGHT", sWebLanguage, "",0,5) %></td>
								<td class='admin'><%=getTran(request,"web","extobleft",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_EXTOBLEFT", sWebLanguage, "",0,5) %></td>
							</tr>
       					</table>
					</td>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","shiradoito",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_SHIRADOITO", 4, sWebLanguage) %> s</td>
				</tr>
				<tr>
					<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","abdoiminalperimeter",sWebLanguage) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","abdoiminalperimeter.dorsal",sWebLanguage) %></td>
							</tr>
							<tr>
								<% String m = "DORSAL"; %>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","contracted",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","relaxed",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","abdoiminalperimeter.4feet",sWebLanguage) %></td>
							</tr>
							<tr>
								<%  m = "4FEET"; %>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","contracted",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","relaxed",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","abdoiminalperimeter.sitting",sWebLanguage) %></td>
							</tr>
							<tr>
								<%  m = "SITTING"; %>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","contracted",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","relaxed",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr class='admin'>
								<td colspan='12'><%=getTran(request,"cnrkr","abdoiminalperimeter.standing",sWebLanguage) %></td>
							</tr>
							<tr>
								<% m = "STANDING"; %>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","contracted",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_CONTRACTED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","relaxed",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","5cmabove",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMABOVE", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","umbilicus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_UMBILICUS", 4, sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkc","5cmbelow",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_ABDOMINAL_"+m+"_RELAXED_5CMBELOW", 4, sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin' colspan='2'><%=getTran(request,"cnrkr","skinfold.contracted",sWebLanguage) %></td>
								<td class='admin2' colspan='5'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_SKINFOLDCONTRACTED", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' colspan='2'><%=getTran(request,"cnrkr","skinfold.relaxed",sWebLanguage) %></td>
								<td class='admin2' colspan='5'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_SKINFOLDRELAXED", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
       					</table>
					</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd2' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords2"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>