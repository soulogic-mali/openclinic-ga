<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"pediatric.triage", "select",activeUser)%>

<script>
  <%-- ACTIVATE TAB --%>
  function activateTab(iTab){
    document.getElementById('tr1-view').style.display = 'none';
    document.getElementById('tr3-view').style.display = 'none';
    document.getElementById('tr4-view').style.display = 'none';

    td1.className = "tabunselected";
    td3.className = "tabunselected";
    td4.className = "tabunselected";

    if (iTab==1){
      document.getElementById('tr1-view').style.display = '';
      td1.className="tabselected";
    }
    else if (iTab==3){
      document.getElementById('tr3-view').style.display = '';
      td3.className="tabselected";
    }
    else if (iTab==4){
      document.getElementById('tr4-view').style.display = '';
      td4.className="tabselected";
    }
  }

  function deleteRowFromArrayString(sArray,rowid){
    var array = sArray.split("$");
    for (var i=0;i<array.length;i++){
      if (array[i].indexOf(rowid)>-1){
        array.splice(i,1);
      }
    }
    return array.join("$");
  }

  function getRowFromArrayString(sArray,rowid){
    var array = sArray.split("$");
    var row = "";
    for (var i=0;i<array.length;i++){
      if (array[i].indexOf(rowid)>-1){
        row = array[i].substring(array[i].indexOf("=")+1);
        break;
      }
    }
    return row;
  }

  function getCelFromRowString(sRow,celid){
    var row = sRow.split("£");
    return row[celid];
  }

  function replaceRowInArrayString(sArray,newRow,rowid){
    var array = sArray.split("$");
    for (var i=0;i<array.length;i++){
      if (array[i].indexOf(rowid)>-1){
        array.splice(i,1,newRow);
        break;
      }
    }
    return array.join("$");
  }
</script>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' >
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>

    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <input type="hidden" id='priorityscore' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="subClass" value="GENERAL"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>

    <%-- TITLE --%>
    <table class="list" width='100%' cellspacing="0" cellpadding="0">
        <tr class="admin">
            <td width="1%" nowrap>
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td nowrap>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
            <td width="90%"><%=contextHeader(request,sWebLanguage)%></td>
        </tr>
    </table>

    <br/>

    <%-- TABS --%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(1)" id="td1" nowrap>&nbsp;<b><%=getTran(request,"Web.Occup","phase1",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(3)" id="td3" nowrap>&nbsp;<b><%=getTran(request,"Web.Occup","phase2",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(4)" id="td4" nowrap>&nbsp;<b><%=getTran(request,"Web.Occup","phase3",sWebLanguage)%></b>&nbsp;</td>
            <td style='font-size: 16px; text-align: right;' width='*'>
            	<span style='font-size: 16px; font-weight: bolder; text-align: right; vertical-align: middle' id='priority'></span>
            </td>
        </tr>
    </table>

    <%-- HIDEABLE --%>
    <table style="vertical-align:top;" width="100%" border="0" cellspacing="0">
        <tr id="tr1-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/managePediatricTriagePhase1.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr3-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/managePediatricTriagePhase2.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr4-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/managePediatricTriagePhase3.jsp"),pageContext);%></td>
        </tr>
    </table>
    <table width='100%'>
        <tr>
            <td class="admin" colspan='4'>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup","comment",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_TRIAGE_COMMENT")%> class="text" cols="60" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_COMMENT" property="value"/></textarea>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input <%=setRightClick(session,"ITEM_TYPE_TRIAGE_CLOSED")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_CLOSED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_CLOSED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
            	<%=getTran(request,"Web.Occup","stopfollowup",sWebLanguage)%>
            </td>
            <td class="admin" width='1%' nowrap><%=getTran(request,"triage","forcepriority",sWebLanguage)%>&nbsp;</td>
            <td class='admin2'>
            	<select class='text' id='forcedpriority' onchange='doTriage();' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_FORCEDPRIORITY" property="itemId"/>]>.value">
	            	<option/>
	            	<%=ScreenHelper.writeSelect(request, "triage.priority", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_FORCEDPRIORITY"), sWebLanguage) %>
            	</select>
            </td>
        </tr>
    </table>

    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
        <%=getButtonsHtml(request,activeUser,activePatient,"pediatric.triage",sWebLanguage)%>     
    <%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  activateTab(1);

  function doTriage(){
	  document.getElementById('priority').innerHTML='';
	  document.getElementById('infection').style.border='';
	  document.getElementById('PAIN').style.border='';
	  document.getElementById('RESPIRATORY').style.border='';
	  document.getElementById('NEUROLOGY').style.border='';
	  document.getElementById('CARDIOVASCULAR').style.border='';
	  document.getElementById('MUSCULAR').style.border='';
	  document.getElementById('SKIN').style.border='';
	  document.getElementById('GASTROINTESTINAL').style.border='';
	  document.getElementById('GYNECOLOGY').style.border='';
	  document.getElementById('ENT').style.border='';
	  document.getElementById('EYE').style.border='';
	  document.getElementById('HEMATOLOGY').style.border='';
	  document.getElementById('PSY').style.border='';
	  document.getElementById('BEHAVIOR').style.border='';
	  document.getElementById('VIOLENCE').style.border='';
	  var elements = document.all;
	  for(n=0;n<elements.length;n++){
		  if(elements[n].checked){
			  if(elements[n].id.indexOf('INFECTION')>0 ){
				  document.getElementById('infection').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('PAIN')>0 ){
				  document.getElementById('PAIN').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('RESPIRATORY')>0 ){
				  document.getElementById('RESPIRATORY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('NEUROLOGY')>0 ){
				  document.getElementById('NEUROLOGY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('CARDIOVASCULAR')>0 ){
				  document.getElementById('CARDIOVASCULAR').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('MUSCULAR')>0 ){
				  document.getElementById('MUSCULAR').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('SKIN')>0 ){
				  document.getElementById('SKIN').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('GASTROINTESTINAL')>0 ){
				  document.getElementById('GASTROINTESTINAL').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('GYNECOLOGY')>0 ){
				  document.getElementById('GYNECOLOGY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('ENT')>0 ){
				  document.getElementById('ENT').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('EYE')>0 ){
				  document.getElementById('EYE').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('HEMATOLOGY')>0 ){
				  document.getElementById('HEMATOLOGY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('ENDOCRINOLOGY')>0 ){
				  document.getElementById('ENDOCRINOLOGY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('PSY')>0 ){
				  document.getElementById('PSY').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('BEHAVIOR')>0 ){
				  document.getElementById('BEHAVIOR').style.border='black 5px solid';
			  }
			  else if(elements[n].id.indexOf('VIOLENCE')>0 ){
				  document.getElementById('VIOLENCE').style.border='black 5px solid';
			  }
		  }
	  }
	  if(document.getElementById('forcedpriority').value.length>0){
		  document.getElementById('priorityscore').value=document.getElementById('forcedpriority').value;
		  if(document.getElementById('forcedpriority').value=='1'){
			  document.getElementById('priority').className='blink_text';
			  document.getElementById('priority').style.color='red';
			  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority1.png"/> ';
			  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority1",sWebLanguage)%>';
			  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription1",sWebLanguage)%>';
			  document.getElementById('triage.phase3.waitingtime').innerHTML='0 min';
			  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency1",sWebLanguage)%>';
		  }
		  else if(document.getElementById('forcedpriority').value=='2'){
			  document.getElementById('priority').className='';
			  document.getElementById('priority').style.color='red';
			  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority2.png"/> ';
			  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority2",sWebLanguage)%>';
			  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription2",sWebLanguage)%>';
			  document.getElementById('triage.phase3.waitingtime').innerHTML='15 min';
			  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency2",sWebLanguage)%>';
		  }
		  else{
			  document.getElementById('priority').className='';
			  document.getElementById('priority').style.color='black';
			  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority3.png"/> ';
			  if(document.getElementById('forcedpriority').value=='3'){
				  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority3",sWebLanguage)%>';
				  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription3",sWebLanguage)%>';
				  document.getElementById('triage.phase3.waitingtime').innerHTML='30 min';
				  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency3",sWebLanguage)%>';
			  }
			  else if(document.getElementById('forcedpriority').value=='4'){
				  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority4",sWebLanguage)%>';
				  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription4",sWebLanguage)%>';
				  document.getElementById('triage.phase3.waitingtime').innerHTML='60 min';
				  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency4",sWebLanguage)%>';
			  }
			  else {
				  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority5",sWebLanguage)%>';
				  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription5",sWebLanguage)%>';
				  document.getElementById('triage.phase3.waitingtime').innerHTML='120 min';
				  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency5",sWebLanguage)%>';
			  }
		  }
		  document.getElementById('priority').innerHTML+='<%=getTranNoLink("web","priority",sWebLanguage)%>: '+document.getElementById('forcedpriority').value;
	  }
	  else if(document.getElementById("tr1_lbyes").checked && document.getElementById("tr1_csyes").checked && document.getElementById("tr1_tpyes").checked){
		  document.getElementById('priority').style.color='red';
		  document.getElementById('priority').className='blink_text';
		  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority1.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 1';
		  document.getElementById('priorityscore').value='1';
		  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority1",sWebLanguage)%>';
		  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription1",sWebLanguage)%>';
		  document.getElementById('triage.phase3.waitingtime').innerHTML='0 min';
		  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency1",sWebLanguage)%>';
	  }
	  else if(document.getElementById("tr1_lbno").checked || document.getElementById("tr1_csno").checked || document.getElementById("tr1_tpno").checked){
		  activateTab(3);
		  bDone=false;
		  for(n=0;n<elements.length && !bDone;n++){
			  if(elements[n].id.startsWith('p1') && elements[n].checked){
				  document.getElementById('priority').style.color='red';
				  document.getElementById('priority').className='blink_text';
				  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority1.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 1';
				  document.getElementById('priorityscore').value='1';
				  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority1",sWebLanguage)%>';
				  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription1",sWebLanguage)%>';
				  document.getElementById('triage.phase3.waitingtime').innerHTML='0 min';
				  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency1",sWebLanguage)%>';
				  bDone=true;
			  }
		  }
		  if(!bDone){
			  for(n=0;n<elements.length && !bDone;n++){
				  if(elements[n].id.startsWith('p2') && elements[n].checked){
					  document.getElementById('priority').className='';
					  document.getElementById('priority').style.color='red';
					  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority2.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 2';
					  bDone=true;
					  document.getElementById('priorityscore').value='2';
					  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority2",sWebLanguage)%>';
					  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription2",sWebLanguage)%>';
					  document.getElementById('triage.phase3.waitingtime').innerHTML='15 min';
					  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency2",sWebLanguage)%>';
				  }
			  }
		  }
		  if(!bDone){
			  for(n=0;n<elements.length && !bDone;n++){
				  if(elements[n].id.startsWith('p3') && elements[n].checked){
					  document.getElementById('priority').className='';
					  document.getElementById('priority').style.color='black';
					  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority3.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 3';
					  bDone=true;
					  document.getElementById('priorityscore').value='3';
					  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority3",sWebLanguage)%>';
					  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription3",sWebLanguage)%>';
					  document.getElementById('triage.phase3.waitingtime').innerHTML='30 min';
					  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency3",sWebLanguage)%>';
				  }
			  }
		  }
		  if(!bDone){
			  for(n=0;n<elements.length && !bDone;n++){
				  if(elements[n].id.startsWith('p4') && elements[n].checked){
					  document.getElementById('priority').className='';
					  document.getElementById('priority').style.color='black';
					  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority3.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 4';
					  bDone=true;
					  document.getElementById('priorityscore').value='4';
					  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority4",sWebLanguage)%>';
					  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription4",sWebLanguage)%>';
					  document.getElementById('triage.phase3.waitingtime').innerHTML='60 min';
					  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency4",sWebLanguage)%>';
				  }
			  }
		  }
		  if(!bDone){
			  for(n=0;n<elements.length && !bDone;n++){
				  if(elements[n].id.startsWith('p5') && elements[n].checked){
					  document.getElementById('priority').className='';
					  document.getElementById('priority').style.color='black';
					  document.getElementById('priority').innerHTML='<img height="24px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_priority3.png"/> <%=getTranNoLink("web","priority",sWebLanguage)%>: 5';
					  document.getElementById('priorityscore').value='5';
					  document.getElementById('triage.phase3.priority').innerHTML='<%=getTranNoLink("triage","phase3.priority5",sWebLanguage)%>';
					  document.getElementById('triage.phase3.prioritydescription').innerHTML='<%=getTranNoLink("triage","phase3.prioritydescription5",sWebLanguage)%>';
					  document.getElementById('triage.phase3.waitingtime').innerHTML='120 min';
					  document.getElementById('triage.phase3.evaluationfrequency').innerHTML='<%=getTranNoLink("triage","phase3.evaluationfrequency5",sWebLanguage)%>';
				  }
			  }
		  }
	  }
  }
  
  function convertTable(sText){
    var aRows = sText.split("</TR>");
    sText = "";
    for (var i=0;i<aRows.length;i++){
      var sReturn = "";
      var sRow = aRows[i];
      var aTds = sRow.split("</TD>");
      for (var y=0;y<aTds.length;y++){
        var sTD = aTds[y];
        if ((sTD.indexOf("delete")<0)&&(sTD.indexOf("<TD>")>-1)){
          sReturn += sTD+"</TD>";
        }
      }

      if (sReturn.length>0){
        sText+=("<TR>"+sReturn+"</TR>");
      }
    }
    return sText;
  }

  <%-- SUBMIT FORM --%>
  function submitForm(){
	var maySubmit = true;
    if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
		alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
		searchEncounter();
	}	
    else {
		addIkireziBiometrics();	    
	    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
    }
  }

  function addIkireziBiometrics(){
    var url = '<c:url value="/ikirezi/addBiometrics.jsp"/>'+
		    '?encounteruid='+document.getElementById('encounteruid').value+
		    '&temperature='+document.getElementById('temperature').value+
		    '&wfl='+document.getElementById('wflinfo').title+
		    '&wflval='+document.getElementById('WFL').value+
		    '&bmi='+document.getElementById('bmi').value+
              '&ts='+new Date().getTime();
    new Ajax.Request(url,{
      parameters: "",
      onSuccess: function(resp){
    	  //Fine
      }
    });
  }

  function subScreen(screenName){
    document.getElementsByName('be.mxs.healthrecord.updateTransaction.actionForwardKey')[0].value = screenName;
    submitForm();
  }
  function searchEncounter(){
      pu = openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
	  alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	  searchEncounter();
  }	
  doTriage();
</script>


<%=writeJSButtons("transactionForm","saveButton")%>