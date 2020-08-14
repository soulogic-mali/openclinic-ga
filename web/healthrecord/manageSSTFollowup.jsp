<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"occup.sstfollowup","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value='/healthrecord/updateTransaction.do'/>?ts=<%=getTs()%>" focus='type'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width='100%' border='0' cellspacing="1">
        <tr valign='top'>
            <td style="vertical-align:top;">
                <table width="100%" cellpadding="1" cellspacing="1">
				    <%-- DATE --%>
				    <tr>
				        <td class="admin">
				            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
				            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
				        </td>
				        <td class="admin2">
				            <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur='checkDate(this)'> <script>writeTranDate();</script>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	<%=getTran(request,"sst","masnumber",sWebLanguage)%>: <%=ScreenHelper.writeDefaultTextInputSticky(session, (TransactionVO)transaction, "ITEM_TYPE_SST_MASNUMBER", 10,"if(this.value==''){this.value='-';}") %>
				        </td>
				    </tr>
				    
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"Web.Occup","anthropometrie",sWebLanguage)%></td>
	                </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<table width="100%">
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b> <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b> <input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="calculateBMI();"/> cm</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b> <input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b> <input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"sst","brachialcircumference",sWebLanguage)%>:</b> <input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_SST_BC")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BC" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BC" property="value"/>">mm</td>
			            			<td nowrap><b><%=getTran(request,"sst","oedema",sWebLanguage)%>:</b>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_OEDEMAGRADE" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.oedema", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_OEDEMAGRADE"), sWebLanguage) %>
						            	</select>
			            			</td>
			            			<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b> <input tabindex="-1" class="text" type="text" size="4" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_WFL" property="itemId"/>]>.value" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/> <%=getTran(request,"sst","zvalue",sWebLanguage) %> = <input readonly class="text" type="text" size="5" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ZVALUE" property="itemId"/>]>.value" id="zvalue"></td>
			            		</tr>
			            	</table>
			            </td>
			        </tr>
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"Web.Occup","nutrition.treatment",sWebLanguage)%></td>
	                </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","phase",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<table width='100%'>
				        		<tr>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_PHASE" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.phase", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_PHASE"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","formula",sWebLanguage)%>:
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_FORMULA" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.formula", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_FORMULA"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","appetitetest",sWebLanguage)%>:
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_APPETITETESTFOLLOWUP" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.apetitetest", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_APPETITETESTFOLLOWUP"), sWebLanguage) %>
						            	</select>
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" rowspan="3" class='admin'><%=getTran(request,"web","meals",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<table width='100%'>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","mealsperday",sWebLanguage)%>:
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_MEALSPERDAY" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.numberofmeals", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_MEALSPERDAY"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","mlpermeal",sWebLanguage)%>:
										<input <%=setRightClickMini("ITEM_TYPE_SST_MEALVOLUME")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_MEALVOLUME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_MEALVOLUME" property="value"/>"/> ml
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","irondose",sWebLanguage)%>:
										<input <%=setRightClickMini("ITEM_TYPE_SST_IRONDOSE")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_IRONDOSE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_MEALVOLUME" property="value"/>"/>
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin2'>
				        	<hr/>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin2'>
				        	<table width='100%'>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","ATPE",sWebLanguage)%>:
										<input <%=setRightClickMini("ITEM_TYPE_SST_ATPEFOLLOWUP")%> class="text" type="text" size="15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ATPEFOLLOWUP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ATPEFOLLOWUP" property="value"/>"/>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","mealsperday",sWebLanguage)%>:
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ATPEMEALSPERDAY" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.numberofmeals.atpe", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ATPEMEALSPERDAY"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","bagsperday",sWebLanguage)%>:
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BAGSPERDAY" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.numberofbags", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BAGSPERDAY"), sWebLanguage) %>
						            	</select>
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","takenvolume",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<table width='100%'>
				        		<tr>
			        				<%
			        					for(int n=1;n<6;n++){
			        				%>
					        			<td>
							            	<%=n %> <select name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TAKENVOLUME"+n).getItemId()%>]>.value" class="text">
							            		<option/>
							            		<%=ScreenHelper.writeSelect(request, "sst.takenvolume", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TAKENVOLUME"+n), sWebLanguage) %>
							            	</select>
					        			</td>
					            	<%
			        					}
					            	%>
				        		</tr>
				        		<tr>
			        				<%
			        					for(int n=6;n<11;n++){
			        				%>
					        			<td>
							            	<%=n %> <select name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TAKENVOLUME"+n).getItemId()%>]>.value" class="text">
							            		<option/>
							            		<%=ScreenHelper.writeSelect(request, "sst.takenvolume", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TAKENVOLUME"+n), sWebLanguage) %>
							            	</select>
					        			</td>
					            	<%
			        					}
					            	%>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"Web.Occup","surveillance",sWebLanguage)%></td>
	                </tr>
				    <tr>
				        <td class='admin2' colspan="2">
				        	<table width='100%'>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","awake",sWebLanguage)%>
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_AWAKE" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.awake", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_AWAKE"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","stool",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_STOOL" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to4", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_STOOL"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","vomiting",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_VOMITING" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to4", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_VOMITING"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","dehydration",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_DEHYDRATION" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to3plus", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_DEHYDRATION"), sWebLanguage) %>
						            	</select>
				        			</td>
				        		</tr>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","cough",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_COUGH" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to3plus", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_COUGH"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","chock",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CHOCK" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to3plus", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CHOCK"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","capilarcoloring",sWebLanguage)%>:
				        			</td>
				        			<td>
										<input <%=setRightClickMini("ITEM_TYPE_SST_CAPCOLOR")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CAPCOLOR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CAPCOLOR" property="value"/>"/> s
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","respfrequency",sWebLanguage)%>:
				        			</td>
				        			<td>
										<input <%=setRightClickMini("ITEM_TYPE_SST_RESPFREQUENCY")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_RESPFREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_RESPFREQUENCY" property="value"/>"/> /min
				        			</td>
				        		</tr>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","pale.conjuctiva",sWebLanguage)%>:
				        			</td>
				        			<td>
						            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CONJUNCTIVA" property="itemId"/>]>.value" class="text">
						            		<option/>
						            		<%=ScreenHelper.writeSelect(request, "sst.0to3plus", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_CONJUNCTIVA"), sWebLanguage) %>
						            	</select>
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","temp.morning",sWebLanguage)%>:
				        			</td>
				        			<td>
										<input <%=setRightClickMini("ITEM_TYPE_SST_TEMPMORNING")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TEMPMORNING" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TEMPMORNING" property="value"/>"/> °C
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","temp.evening",sWebLanguage)%>:
				        			</td>
				        			<td>
										<input <%=setRightClickMini("ITEM_TYPE_SST_TEMPEVENING")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TEMPEVENING" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TEMPEVENING" property="value"/>"/> °C
				        			</td>
				        			<td>
				        				<%=getTran(request,"web","liverborder",sWebLanguage)%>:
				        			</td>
				        			<td>
										<input <%=setRightClickMini("ITEM_TYPE_SST_LIVERBORDER")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_LIVERBORDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_LIVERBORDER" property="value"/>"/> cm
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","other",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_OTHER")%> class="text" cols="60" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_OTHER" property="value"/></textarea>
				        </td>
				    </tr>
				</table>
		    </td>
   
	        <%-- DIAGNOSIS --%>
	    	<td class="admin">
	    		<table width='100%'>
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"Web.Occup","systematic.treatment",sWebLanguage)%></td>
	                </tr>
				    <tr>
				        <td class='admin'><%=getTran(request,"web","antibiotics",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_ANTIBIOTICS")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ANTIBIOTICS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ANTIBIOTICS" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin'><%=getTran(request,"web","malaria.treatment",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_TREATMENT_MALARIA")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENT_MALARIA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENT_MALARIA" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin'><%=getTran(request,"web","mycosis.treatment",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_TREATMENT_MYCOSIS")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENT_MYCOSIS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENT_MYCOSIS" property="value"/></textarea>
				        </td>
				    </tr>
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"Web.Occup","specific.treatment",sWebLanguage)%></td>
	                </tr>
				    <tr>
				        <td class='admin'><%=getTran(request,"web","antibiotics",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_ANTIBIOTICSSPEC")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ANTIBIOTICSSPEC" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_ANTIBIOTICSSPEC" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin'><%=getTran(request,"web","other",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<table width='100%'>
				        		<tr>
				        			<td>
				        				<%=getTran(request,"web","resomal",sWebLanguage)%>:
				        			</td>
				        			<td nowrap>
										<input <%=setRightClickMini("ITEM_TYPE_SST_RESOMAL")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_RESOMAL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_RESOMAL" property="value"/>"/> ml
				        			</td>
				        			<td nowrap>
				        				<%=getTran(request,"web","perfusioniv",sWebLanguage)%>:
										<input <%=setRightClickMini("ITEM_TYPE_SST_PERFUSION")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_PERFUSION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_PERFUSION" property="value"/>"/> ml
				        			</td>
				        			<td nowrap>
				        				<%=getTran(request,"web","sng",sWebLanguage)%>:
										<input <%=setRightClickMini("ITEM_TYPE_SST_SNG")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_SNG" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_SNG" property="value"/>"/>
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
	            </table>
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
	    </tr>
    </table>
        
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.sstfollowup",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
<%-- SUBMIT FORM --%> 
	function submitForm(){
		  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
				alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
				searchEncounter();
			  }	
		  else {
		    transactionForm.saveButton.disabled = true;
		    <%
		        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
		        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
		    %>
		  }
	}    
	  <%-- CALCULATE BMI --%>
	  function calculateBMI(){
	    var _BMI = 0;
	    var heightInput = document.getElementById('height');
	    var weightInput = document.getElementById('weight');
		  document.getElementById("zvalue").value="";
		  document.getElementById("wflinfo").title="";
		  document.getElementById("wflinfo").style.display='none';
    	  document.getElementById('WFL').value ='';
		  document.getElementById("WFL").className="text";
	      document.getElementsByName('BMI')[0].value = "";

	    if(heightInput.value > 0){
	      _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
	      if (_BMI > 100 || _BMI < 5){
	        document.getElementsByName('BMI')[0].value = "";
	      }
	      else {
	        document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      }
	      var wfl=(weightInput.value*1/heightInput.value*1);
	      if(wfl>0){
	    	  document.getElementById('WFL').value = wfl.toFixed(2);
	    	  checkWeightForHeight(heightInput.value,weightInput.value);
	      }
	    }
	  }

		function checkWeightForHeight(height,weight){
		      var today = new Date();
		      var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
		      new Ajax.Request(url,{
		          method: "POST",
		          postBody: "",
		          onSuccess: function(resp){
		              var label = eval('('+resp.responseText+')');
		    		  if(label.zindex>-999){
		    			  if(label.zindex<-4){
		    				  document.getElementById("WFL").className="darkredtext";
		    				  document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-3){
		    				  document.getElementById("WFL").className="darkredtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-2){
		    				  document.getElementById("WFL").className="orangetext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-1){
		    				  document.getElementById("WFL").className="yellowtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex>2){
		    				  document.getElementById("WFL").className="orangetext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex>1){
		    				  document.getElementById("WFL").className="yellowtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else{
		    				  document.getElementById("WFL").className="text";
		    				  document.getElementById("wflinfo").style.display='none';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    		  }
	    			  else{
	    				  document.getElementById("WFL").className="text";
	    				  document.getElementById("wflinfo").style.display='none';
	    				  document.getElementById("zvalue").value="";
	    			  }
		          },
		          onFailure: function(){
    				  document.getElementById("zvalue").value="";
		          }
		      }
			  );
		  	}

	  function searchEncounter(){
	      openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
	  }
	  calculateBMI();
  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
		alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
		searchEncounter();
}	

</script>

<%=writeJSButtons("transactionForm","saveButton")%>