<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.spectacleprescription","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
    
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
	
    <table class="list" width="100%" cellspacing="1">
		<tr>
			<td style="vertical-align:top;padding:0;" class="admin2">    
			    <table class="list" width="100%" cellspacing="1">
			        <%-- DATE --%>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("web.occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <%-- SPECTACLE PRESCRIPTION --%>
			        <tr class='admin'>
			        	<td colspan='2'><%=getTran(request,"web","spectacleprescription",sWebLanguage)%></td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","prescription",sWebLanguage)%>&nbsp;</td>
			        	<td>
			        		<table width='100%' cellspacing='0' cellpadding='0'>
			        			<tr>
			        				<td/>
			            			<td class="admin" width='16%'><%=getTran(request,"web.optical","sphere",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='16%'><%=getTran(request,"web.optical","cylinder",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='16%'><%=getTran(request,"web.optical","axis",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='16%'><%=getTran(request,"web.optical","add",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='16%'><%=getTran(request,"web.optical","prism",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			        				<%
										String sphere_right = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_SPHERE");
										String sphere_left = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_SPHERE");
										String cylinder_right = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_CYLINDER");
										String cylinder_left = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_CYLINDER");
										String axis_right = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_AXIS");
										String axis_left = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_AXIS");
										String add_right = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_SPHERE");
										String add_left = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_SPHERE");
										String pddistance = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PDDISTANCE");
										String remark = ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTICAL_COMMENT");
			        					if(((TransactionVO)transaction).getTransactionId()<0){
			        						sphere_right=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_1");
			        						sphere_left=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_1");
			        						cylinder_right=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_2");
			        						cylinder_left=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_2");
			        						axis_right=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_3");
			        						axis_left=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_3");
			        						add_right=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_L");
			        						add_left=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_R");
			        						pddistance=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_RECOMMANDATION");
			        						remark=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REMARKS");
			        					}
									%>
			            			<td class="admin"><%=getTran(request,"web.optical","od",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin2"><input style='text-align: center' size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_SPHERE" property="itemId"/>]>.value" value="<%=sphere_right %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_CYLINDER" property="itemId"/>]>.value" value="<%=cylinder_right%>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_AXIS" property="itemId"/>]>.value" value="<%=axis_right %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_SPHERE" property="itemId"/>]>.value" value="<%=add_right %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_PRISM" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_PRISM" property="value"/>"></td>
			        			</tr>
			        			<tr>
			            			<td class="admin"><%=getTran(request,"web.optical","os",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_SPHERE" property="itemId"/>]>.value" value="<%=sphere_left %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_CYLINDER" property="itemId"/>]>.value" value="<%=cylinder_left%>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_AXIS" property="itemId"/>]>.value" value="<%=axis_left %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_SPHERE" property="itemId"/>]>.value" value="<%=add_left %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_PRISM" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_PRISM" property="value"/>"></td>
			        			</tr>
			        			<tr>
			        				<td/>
			            			<td class="admin"><%=getTran(request,"web.optical","pdnear",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin"><%=getTran(request,"web.optical","pddistance",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin"><%=getTran(request,"web.optical","fhsegheight",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" colspan='2'><%=getTran(request,"web.optical","comment",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			        				<td/>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PDNEAR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PDNEAR" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PDDISTANCE" property="itemId"/>]>.value" value="<%=pddistance %>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FHSEGHEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FHSEGHEIGHT" property="value"/>"></td>
			            			<td class="admin2" colspan='2'><textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPTICAL_COMMENT")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTICAL_COMMENT" property="itemId"/>]>.value"><%=remark %></textarea></td>
			        			</tr>
			        		</table>
			        	</td>
			        </tr>
			        <tr>
			        	<td class="admin"><%=getTran(request,"web","doctorrecommendation",sWebLanguage)%>&nbsp;</td>
			        	<td class='admin2'>
			        		<table width='100%'>
			        			<tr>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_BIFOCAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_BIFOCAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","bifocal",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_CR39" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_CR39;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","cr39",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_ANTIREFLECTIVE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_ANTIREFLECTIVE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","antireflective",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_SUNGLASSES" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_SUNGLASSES;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","sunglasses",sWebLanguage)%>
			        				</td>
			        			</tr>
			        			<tr>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_TRIFOCAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_TRIFOCAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","trifocal",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_POLYCARBONATE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_POLYCARBONATE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","polycarbonate",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_PHOTOCHROMATIC" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_PHOTOCHROMATIC;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","photochromatic",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_SAFETY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_SAFETY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","safety",sWebLanguage)%>
			        				</td>
			        			</tr>
			        			<tr>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_PROGRESSIVE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_PROGRESSIVE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","progressive",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_HIGHINDEX" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_HIGHINDEX;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","highindex",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_UVCOATING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_UVCOATING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","uvcoating",sWebLanguage)%>
			        				</td>
			        				<td>
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_OTHER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_OTHER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			        					<%=getTran(request,"web.optical","other",sWebLanguage)%>
			        					<input size="30" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_OTHERCOMMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REC_OTHERCOMMENT" property="value"/>">
			        				</td>
			        			</tr>
			        		</table>
			        	</td>
			        </tr>
			        <%-- CONTACT LENSE PRESCRIPTION --%>
			        <tr class='admin'>
			        	<td colspan='2'><%=getTran(request,"web","contactlenseprescription",sWebLanguage)%></td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","prescription",sWebLanguage)%>&nbsp;</td>
			        	<td>
			        		<table width='100%' cellspacing='0' cellpadding='0'>
			        			<tr>
			        				<td/>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","sphere",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","cylinder",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","axis",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","add",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","bc",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","diameter",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","quantity",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","refills",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			        				<td class="admin" rowspan='2'><%=getTran(request,"web.optical","od",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_SPHERE" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_CYLINDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_CYLINDER" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_AXIS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_AXIS" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_LENS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_LENS" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_BC" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_BC" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_DIAMETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_DIAMETER" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_QUANTITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_QUANTITY" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_REFILL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_REFILL" property="value"/>"></td>
			        			</tr>
			        			<tr>
			            			<td class="admin2" colspan='2'>
			            				<%=getTran(request,"web.optical","manufacturer",sWebLanguage)%><br/>
			            				<input size="25" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_MANUFACTURER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_MANUFACTURER" property="value"/>">
			            			</td>
			            			<td class="admin2" colspan='2'>
			            				<%=getTran(request,"web.optical","brand",sWebLanguage)%><br/>
			            				<input size="25" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_BRAND" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OD_BRAND" property="value"/>">
									</td>
			            			<td class="admin2">
			            				<%=getTran(request,"web.optical","wearschedule",sWebLanguage)%>:
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_DAILY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_DAILY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","daily",sWebLanguage)%>
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_FLEXIBLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_FLEXIBLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","flexible",sWebLanguage)%>
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_EXTENDED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OD_WEAR_EXTENDED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","extended",sWebLanguage)%>
			            			</td>
			        			</tr>
			        			<tr>
			        				<td/>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","sphere",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","cylinder",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","axis",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","add",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","bc",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","diameter",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","quantity",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='10%'><%=getTran(request,"web.optical","refills",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			        				<td class="admin" rowspan='2'><%=getTran(request,"web.optical","os",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_SPHERE" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_CYLINDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_CYLINDER" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_AXIS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_AXIS" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_LENS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_LENS" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_BC" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_BC" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_DIAMETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_DIAMETER" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_QUANTITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_QUANTITY" property="value"/>"></td>
			            			<td class="admin2"><input style='text-align: center'  size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_REFILL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_REFILL" property="value"/>"></td>
			        			</tr>
			        			<tr>
			            			<td class="admin2" colspan='2'>
			            				<%=getTran(request,"web.optical","manufacturer",sWebLanguage)%><br/>
			            				<input size="25" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_MANUFACTURER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_MANUFACTURER" property="value"/>">
			            			</td>
			            			<td class="admin2" colspan='2'>
			            				<%=getTran(request,"web.optical","brand",sWebLanguage)%><br/>
			            				<input size="25" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_BRAND" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LENS_OS_BRAND" property="value"/>">
									</td>
			            			<td class="admin2">
			            				<%=getTran(request,"web.optical","wearschedule",sWebLanguage)%>:
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_DAILY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_DAILY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","daily",sWebLanguage)%>
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_FLEXIBLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_FLEXIBLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","flexible",sWebLanguage)%>
			            			</td>
			            			<td class="admin2">
			        					<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_EXTENDED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OS_WEAR_EXTENDED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            				<%=getTran(request,"web.optical","extended",sWebLanguage)%>
			            			</td>
			        			</tr>
			        		</table>
			        	</td>
			        </tr>
			        
                </table>
			</td>
		</tr>
    </table>
    
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.spectacleprescription",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
  
  <%-- SEARCH MANAGER --%>
  function searchManager(managerUidField,managerNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("socialServiceID","CNAR.SOC")%>");
    EditEncounterForm.EditEncounterManagerName.focus();
  }      
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>