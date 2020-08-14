<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.vitalsigns","select",activeUser)%>
<form id="transactionForm" name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <script>
        <%-- VALIDATE WEIGHT --%>
        <%
            int minWeight = 35;
            int maxWeight = 160;

            String weightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight.validationerror",sWebLanguage);
            weightMsg = weightMsg.replaceAll("#min#",minWeight+"");
            weightMsg = weightMsg.replaceAll("#max#",maxWeight+"");
        %>
        function validateWeight(weightInput){
          weightInput.value = weightInput.value.replace(",",".");
          if(weightInput.value.length > 0){
            var min = <%=minWeight%>;
            var max = <%=maxWeight%>;

            if(isNaN(weightInput.value) || weightInput.value < min || weightInput.value > max){
              alertDialogDirectText("<%=weightMsg%>");
              //weightInput.value = "";
              weightInput.focus();
            }
          }
        }

        <%-- VALIDATE HEIGHT --%>
        <%
            int minHeight = 120;
            int maxHeight = 220;

            String heightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.height.validationerror",sWebLanguage);
            heightMsg = heightMsg.replaceAll("#min#",minHeight+"");
            heightMsg = heightMsg.replaceAll("#max#",maxHeight+"");
        %>
        function validateHeight(heightInput){
          heightInput.value = heightInput.value.replace(",",".");
          if(heightInput.value.length > 0){
            var min = <%=minHeight%>;
            var max = <%=maxHeight%>;

            if(isNaN(heightInput.value) || heightInput.value < min || heightInput.value > max){
              alertDialogDirectText("<%=heightMsg%>");
              heightInput.focus();
            }
          }
        }

        <%-- CALCULATE BMI --%>
        function calculateBMI(){
          var _BMI = 0;
          var heightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value')[0];
          var weightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value')[0];

          if(heightInput.value > 0){
            _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
            if(_BMI > 100 || _BMI < 5){
              document.getElementsByName('BMI')[0].value = "";
            }
            else {
              document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
            }
          }
        }
    </script>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>

    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
				<!-- Add time section -->
                <%
                	java.util.Date date = ((TransactionVO)transaction).getUpdateTime();
                	if(date==null){
                		date=new java.util.Date();
                	}
                	String sTime=new SimpleDateFormat("HH:mm").format(date);
                %>
                <input type='text' class='text' size='5' maxLength='5' name='trantime' id='trantime' value='<%=sTime%>'/>
                <!-- End time section -->
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
            <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min
                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1a" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"sum_r1a")%>
                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1b" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"sum_r1b")%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
            <td class="admin2" nowrap>
                <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%>
                <input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> /
                <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg
                &nbsp;
                <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%>
                <input id="sbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> /
                <input id="dbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> mmHg
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
            <td colspan="3" class="admin2">
                <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(0,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%></td>
            <td colspan="3" class="admin2">
                <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%></td>
            <td class='admin2' nowrap>
                <input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"web","fhr",sWebLanguage)%></td>
            <td class='admin2' nowrap>
                <input <%=setRightClick(session,"ITEM_TYPE_FOETAL_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="value"/>"/>
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"web","abdomencircumference",sWebLanguage)%></td>
            <td class='admin2' nowrap>
                <input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="validateWeight();calculateBMI();"/></td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="validateHeight(this);calculateBMI();"/></td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>&nbsp;</td>
            <td class='admin2'><input tabindex="-1" class="text" type="text" size="10" readonly name="BMI"></td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web", "stool", sWebLanguage)%></td>
			<td class='admin2'>
				<table width='100%' cellpadding="0" cellspacing="0">
					<tr>
						<td class='admin2' width='30%'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_STOOL", 5) %></td>
						<td class='admin'  width='30%'><%=getTran(request,"web", "coma", sWebLanguage)%>&nbsp;&nbsp;&nbsp;</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_COMA", 5) %></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web", "convulsions", sWebLanguage)%></td>
			<td class='admin2'>
				<table width='100%' cellpadding="0" cellspacing="0">
					<tr>
						<td class='admin2' width='30%'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_CONVULSIONS", 5) %></td>
						<td class='admin'  width='30%'><%=getTran(request,"web", "lethargia", sWebLanguage)%>&nbsp;&nbsp;&nbsp;</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_LETHARGIA", 5) %></td>
					</tr>
				</table>
			</td>
		</tr>
	    <tr class='admin'>
	        <td colspan="2"><%=getTran(request,"web","fluidbalance",sWebLanguage)%>&nbsp;</td>
	    </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web", "output", sWebLanguage)%></td>
			<td class='admin2'>
				<table width='100%' cellpadding="0" cellspacing="0">
					<tr>
						<td class='admin' width='16%'><%=getTran(request,"web", "urine", sWebLanguage)%><%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_BILAN") %></td>
						<td class='admin2' width='16%'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_INPUT_URINE", 3,0,5000,sWebLanguage,"calculatebilan()") %>ml</td>
						<td class='admin' width='16%'><%=getTran(request,"web", "vom", sWebLanguage)%></td>
						<td class='admin2' width='16%'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_INPUT_VOMITING", 3,0,5000,sWebLanguage,"calculatebilan()") %>ml</td>
						<td class='admin' width='16%'><%=getTran(request,"web", "diarrhea", sWebLanguage)%></td>
						<td class='admin2' width='*'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_INPUT_DIARRHEA", 3,0,5000,sWebLanguage,"calculatebilan()") %>ml</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web", "input", sWebLanguage)%></td>
			<td class='admin2'>
				<table width='100%' cellpadding="0" cellspacing="0">
					<tr>
						<td class='admin' width='16%'><%=getTran(request,"web", "perf", sWebLanguage)%></td>
						<td class='admin2' width='16%'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_INPUT_PERFUSION", 3,0,5000,sWebLanguage,"calculatebilan()") %>ml</td>
						<td class='admin' width='16%'><%=getTran(request,"web", "drinks", sWebLanguage)%></td>
						<td class='admin2' width='16%'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HPRC_INPUT_DRINKS", 3,0,5000,sWebLanguage,"calculatebilan()") %>ml</td>
						<td style='text-align: right' width='16%'><font color='red'><b><%=getTran(request,"web", "bilan", sWebLanguage)%> = </b></font></td>
						<td class='admin2' width='*'><font color='red'><b><span id='bilan' <%=setRightClick(session,"ITEM_TYPE_BILAN")%>/></b></font></td>
					</tr>
				</table>
			</td>
		</tr>
  		<tr>
			<td class='admin'><%=getTran(request,"web","vitalsignsobservations",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_VITAL_SIGNS_OBSERVATIONS", 40, 1) %>
			</td>
  		<tr>
        <%-- BUTTONS --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">&nbsp;</td>
            <td class="admin2">
                <%=getButtonsHtml(request,activeUser,activePatient,"occup.vitalsigns",sWebLanguage)%>
            </td>
        </tr>
    </table>
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
	function calculatebilan(){
		var result=((document.getElementById('ITEM_TYPE_HPRC_INPUT_DRINKS').value*1)+(document.getElementById('ITEM_TYPE_HPRC_INPUT_PERFUSION').value*1)-(document.getElementById('ITEM_TYPE_HPRC_INPUT_URINE').value*1)-(document.getElementById('ITEM_TYPE_HPRC_INPUT_VOMITING').value*1)-(document.getElementById('ITEM_TYPE_HPRC_INPUT_DIARRHEA').value*1));
		if(result>0){
			result="+"+result;
		}
		document.getElementById('ITEM_TYPE_BILAN').value=result;
		document.getElementById('bilan').innerHTML=	result+" ml";
	}
	
  calculateBMI();
  calculatebilan();
  if(document.getElementById("transactionId").value<=0){
     document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value')[0].value='<%=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid),"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT")%>';
  }
  <%-- SUBMIT FORM --%>
  function submitForm(){
	  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
			alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
			searchEncounter();
		  }	
	  else {
	    document.getElementById("buttonsDiv").style.visibility = "hidden";
	    document.getElementById('trandate').value+=' '+document.getElementById('trantime').value;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
	    %>
	  }
  }    
  function searchEncounter(){
      pu = openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
	  alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	  searchEncounter();
  }	
</script>

<%=writeJSButtons("transactionForm","saveButton")%>