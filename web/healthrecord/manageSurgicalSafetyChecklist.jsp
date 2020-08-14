<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.surgicalsafetychecklist","select",activeUser)%>
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
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
		<tr>
			<td valign='top'>
				<table width=100%>
					<tr class='admin'>
						<td><%=getTran(request,"web","before.induction.anesthesia",sWebLanguage)%></td>
					</tr>
					<tr>
						<td><%=getTran(request,"web","at.least.nurse.and.anaesthesist",sWebLanguage)%></td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","patient.confirmed.identity.and.consent",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CONSENT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CONSENT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","yes",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","site.marked",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MARKED" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MARKED;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MARKED" property="itemId"/>]>.value" value="notapplicable" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MARKED;value=notapplicable" property="value" outputString="checked"/>> <%=getTran(request,"web","not.applicable",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","machine.medication.check",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MACHINECHECK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_MACHINECHECK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","yes",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","pulsoxy.check",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PULSEOXYCHECK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PULSEOXYCHECK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","yes",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","patient.has",sWebLanguage)%><br/>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","know.allergy",sWebLanguage)%></b><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ALLERGY" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ALLERGY;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ALLERGY" property="itemId"/>]>.value" value="no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ALLERGY;value=no" property="value" outputString="checked"/>> <%=getTran(request,"web","no",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","difficult.airway",sWebLanguage)%></b><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DIFFICULTAIRWAY" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DIFFICULTAIRWAY;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DIFFICULTAIRWAY" property="itemId"/>]>.value" value="no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DIFFICULTAIRWAY;value=no" property="value" outputString="checked"/>> <%=getTran(request,"web","no",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","risk.of.bloodloss",sWebLanguage)%></b><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_BLOODLOSS" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_BLOODLOSS;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes.and.central.access.planned",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_BLOODLOSS" property="itemId"/>]>.value" value="no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_BLOODLOSS;value=no" property="value" outputString="checked"/>> <%=getTran(request,"web","no",sWebLanguage)%>
						</td>
					</tr>
				</table>
			</td>
			<td valign='top' width='1%'><img src='<c:url value="_img/themes/default/right_arrow.png"/>'/></td>
			<td valign='top'>
				<table width=100%>
					<tr class='admin'>
						<td><%=getTran(request,"web","before.skin.incision",sWebLanguage)%></td>
					</tr>
					<tr>
						<td><%=getTran(request,"web","nurse.and.anaesthesist.and.surgeon",sWebLanguage)%></td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","confirm.members.introduction",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_INTRODUCTION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_INTRODUCTION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","yes",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","confirm.procedure",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PROCEDURE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PROCEDURE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","yes",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","antibiotic.given",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTIBIOTIC" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTIBIOTIC;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTIBIOTIC" property="itemId"/>]>.value" value="notapplicable" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTIBIOTIC;value=notapplicable" property="value" outputString="checked"/>> <%=getTran(request,"web","not.applicable",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","anticipated.critical.events",sWebLanguage)%><br/>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","to.surgeon",sWebLanguage)%></b><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CRITICALSTEPS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CRITICALSTEPS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","critical.steps",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DURATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_DURATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","case.duration",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTICIPATEDBLOODLOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_ANTICIPATEDBLOODLOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","anticipated.blood.loss",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","to.anaesthesist",sWebLanguage)%></b><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CONCERNS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_CONCERNS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","patient.specific.concerns",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<b><%=getTran(request,"web","to.nursing.team",sWebLanguage)%></b>	<br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_STERILITY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_STERILITY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","sterility.confirmed",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_EQUIPMENT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_EQUIPMENT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","equipment.issues",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","imaging.displayed",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_IMAGING" property="itemId"/>]>.value" value="yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_IMAGING;value=yes" property="value" outputString="checked"/>> <%=getTran(request,"web","yes",sWebLanguage)%><br/>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_IMAGING" property="itemId"/>]>.value" value="notapplicable" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_IMAGING;value=notapplicable" property="value" outputString="checked"/>> <%=getTran(request,"web","not.applicable",sWebLanguage)%>
						</td>
					</tr>
				</table>
			</td>
			<td valign='top' width='1%'><img src='<c:url value="_img/themes/default/right_arrow.png"/>'/></td>
			<td valign='top'>
				<table width=100%>
					<tr class='admin'>
						<td><%=getTran(request,"web","before.patient.leaves.ot",sWebLanguage)%></td>
					</tr>
					<tr>
						<td><%=getTran(request,"web","nurse.and.anaesthesist.and.surgeon",sWebLanguage)%></td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","nurse.verbally.confirms",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PROCEDURENAME" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_PROCEDURENAME;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","procedure.name",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_COUNTSCOMPLETION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_COUNTSCOMPLETION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","counts.completion",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_SPECIMENLABELING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_SPECIMENLABELING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","specimen.labeling",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_EQUIPMENTPROBLEMS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_EQUIPMENTPROBLEMS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","equipment.problems",sWebLanguage)%><br/>
						</td>
					</tr>
					<tr>
						<td class='admin'>
							<%=getTran(request,"web","to.surgeon.anaesthesist.nurse",sWebLanguage)%><br/>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_RECOVERYCONCERNS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SSC_RECOVERYCONCERNS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","recovery.concerns",sWebLanguage)%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
    </table>
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
        <%=getButtonsHtml(request,activeUser,activePatient,"occup.surgicalsafetychecklist",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
      function submitForm(){
        transactionForm.saveButton.disabled = true;
        <%
            SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
            out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
        %>
      }
    </script>
<%=ScreenHelper.contextFooter(request)%>
</form>
<%=writeJSButtons("transactionForm","saveButton")%>