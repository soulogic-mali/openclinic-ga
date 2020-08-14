<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.kigutuobprotocol","select",activeUser)%>

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
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
				<%-- DESCRIPTION --%>
        <tr>
			<td width="60%">
				<table width='100%'>
					<tr>
						<td class="admin"><%=getTran(request,"gynaeco", "age.gestationnel",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="3" nowrap>
						<table>
							<tr>
								<td><%=getTran(request,"gynaeco", "date.dr", sWebLanguage)%></td>
								<td nowrap>
									<input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_DR" property="value" formatType="date"/>" id="drdate" onBlur='checkDate(this);calculateGestAge();clearDr()' onChange='calculateGestAge();' onKeyUp='calculateGestAge();'/>
									<script>writeMyDate("drdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
									<input id="agedatedr" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_DATE_DR")%> readonly type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_DATE_DR" property="value"/>" onblur="isNumber(this)"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%> <%=getTran(request,"web", "delivery.date", sWebLanguage)%>:
									<input id="drdeldate" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DATE_DR")%> type="text" class="text" size="12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_DR" property="value"/>" onblur="checkDate(this);">
								</td>
							</tr>
							<tr>
								<td><%=getTran(request,"gynaeco", "date.echography", sWebLanguage)%></td>
								<td nowrap>
								<input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_ECHO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_ECHO" property="value" formatType="date"/>" id="echodate" onBlur='checkDate(this);calculateGestAge();' onchange='calculateGestAge();' onkeyup='calculateGestAge();'/>
								<script>writeMyDate("echodate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
								<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY" property="value"/>" id="agedateecho" onblur='isNumber(this);calculateGestAge();' onchange='calculateGestAge();' onkeyup="calculateGestAge();"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%> <%=getTran(request,"web", "delivery.date", sWebLanguage)%>:
								<input id="echodeldate" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DATE_ECHOGRAPHY")%> type="text" class="text" size="12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_ECHOGRAPHY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_ECHOGRAPHY" property="value"/>" onblur="checkDate(this);">
								</td>
							</tr>
							<tr>
								<td/>
								<td>
								<%=getTran(request,"gynaeco", "actual.age", sWebLanguage)%>
								<input id="ageactualecho" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_ACTUEL")%> readonly type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ACTUEL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ACTUEL" property="value"/>" onblur="isNumber(this)"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%>
								</td>
							</tr>
							<tr>
								<td><%=getTran(request,"gynaeco", "age.trimstre", sWebLanguage)%>
								</td>
								<td nowrap>
								<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_TRIMESTRE")%> type="radio" onDblClick="uncheckRadio(this);" id="trimestre_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE" property="itemId"/>]>.value" value="1"
								<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE;value=1"
                                                      property="value" outputString="checked"/>>1
								<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_TRIMESTRE")%> type="radio" onDblClick="uncheckRadio(this);" id="trimestre_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE" property="itemId"/>]>.value" value="2"
								<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE;value=2"
                                                      property="value" outputString="checked"/>>2
								<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_TRIMESTRE")%> type="radio" onDblClick="uncheckRadio(this);" id="trimestre_r3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE" property="itemId"/>]>.value" value="3"
								<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_TRIMESTRE;value=3"
                                                      property="value" outputString="checked"/>>3
								</td>
							</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td class="admin" ><%=getTran(request,"web","foetus",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="3">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","alive",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS" property="itemId"/>]>.value" value="Mfin"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS;value=Mfin"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","Actif",sWebLanguage) %></label>
							<input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_STATUS;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","mfin",sWebLanguage) %></label>
			            </td>
					</tr>
					
				<tr>
					<td class="admin"><%=getTran(request,"web","sex",sWebLanguage)%>&nbsp;</td>
			        <td class='admin2' >
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_SEX" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"sex.type",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_SEX"),sWebLanguage,false,true) %>
			                </select>
						</td>
						<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2' ><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETUS_WEIGHT" property="value"/>"/>kg</td>
				</tr>
				
				<tr>
						<td class="admin" ><%=getTran(request,"web","head.presentation",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="3">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","cephalique",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","transverse",sWebLanguage) %></label>
							<input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION" property="itemId"/>]>.value" value="siege"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEAD_POSITION;value=siege"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","siege",sWebLanguage) %></label>
			            </td>
					</tr>
				
				
				<tr>
					<td class="admin"><%=getTran(request,"web","amnion.liquid",sWebLanguage)%>&nbsp;</td>
			        <td class='admin2' colspan="3">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AMNION_LIQUID" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"amnion.liquid",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AMNION_LIQUID"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>
				<tr>
					<td class="admin" rowspan="3"><%=getTran(request,"web","Placenta",sWebLanguage)%>&nbsp;</td>
					<td class="admin2" colspan ="3">
					<input type="radio" onDblClick="uncheckRadio(this);" id="anterior" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT" property="itemId"/>]>.value" value="Anterieur"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT;value=Anterieur"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","Anterieur",sWebLanguage) %></label>
				</td>
			</tr>
			<tr>
				<td class="admin2" >
					<input type="radio" onDblClick="uncheckRadio(this);" id="posterior" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT" property="itemId"/>]>.value" value="Posterieur"
			        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT;value=Posterieur"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","Posterieur",sWebLanguage) %></label>
													  
				</td >
				<td class="admin2" colspan="2">
				<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT_COMMENT" property="itemId"/>]>.value">
			             <option/>
				            	<%=ScreenHelper.writeSelect(request,"placenta.comment",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT_COMMENT"),sWebLanguage,false,true) %>
			        </select>	
				</td>
				</tr>
				<tr>
					<td class="admin2" >
					<input type="radio" onDblClick="uncheckRadio(this);" id="recouvrant" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT" property="itemId"/>]>.value" value="Recouvrant"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT;value=Recouvrant"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","Recouvrant",sWebLanguage) %></label>
													  
				</td >
				
				
					<td class="admin2" colspan="2">					
					<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT_COMMENT_2" property="itemId"/>]>.value">
			             <option/>
				            	<%=ScreenHelper.writeSelect(request,"placenta.comment2",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PLACENTA_ASPECT_COMMENT_2"),sWebLanguage,false,true) %>
			        </select>						  						  
			     </td>
				</tr>				
					
		
				</table>
			</td>
		
	
			<%-- DIAGNOSES --%>
	    	<td class="admin2"colspan="2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
		</tr>
	</table>
    
	        
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.kigutuobprotocol",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>
<script>
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	
  
<%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    document.transactionForm.submit();
  }
  
  function clearDr(){
        if(document.getElementById("drdate").value.length == 0){
            document.getElementById("agedatedr").value = "";
            document.getElementById("drdeldate").value = "";
        }
    }
    function calculateGestAge(){
        var trandate = new Date();
        var d1 = document.getElementById('trandate').value.split("/");
        if(d1.length == 3){
            trandate.setDate(d1[0]);
            trandate.setMonth(d1[1] - 1);
            trandate.setFullYear(d1[2]);
            var lmdate = new Date();
            d1 = document.getElementById('drdate').value.split("/");
            if(d1.length == 3){
                lmdate.setDate(d1[0]);
                lmdate.setMonth(d1[1] - 1);
                lmdate.setFullYear(d1[2]);
                var timeElapsed = trandate.getTime() - lmdate.getTime();
                timeElapsed = timeElapsed / (1000 * 3600 * 24 * 7);
                if(!isNaN(timeElapsed) && timeElapsed > 0 && timeElapsed < 60){
                    var age = Math.round(timeElapsed * 10) / 10;
                    age = age + "";
                    if(age.indexOf(".") > -1){
                        var aAge = age.split(".");
                        aAge[1] = Math.round(aAge[1] * 1 * 0.7);
                        age = aAge[0] + " " + aAge[1];
                    }
                    document.getElementById("agedatedr").value = age;
                    var drdeldate = lmdate;
                    drdeldate.setTime(drdeldate.getTime() + 1000 * 3600 * 24 * 280);
                    document.getElementById("drdeldate").value = drdeldate.getDate() + "/" + (drdeldate.getMonth() + 1) + "/" + drdeldate.getFullYear();
                    if(timeElapsed < 12){
                        document.getElementById('trimestre_r1').checked = true;
                    }
                    else if(timeElapsed < 24){
                        document.getElementById('trimestre_r2').checked = true;
                    }
                    else {
                        document.getElementById('trimestre_r3').checked = true;
                    }
                }
                else {
                    document.getElementById("drdeldate").value = '';
                }
            }
            //recalculate actual age based on echography estimation
            var ledate = new Date();
            d1 = document.getElementById('echodate').value.split("/");
            if(d1.length == 3){
                ledate.setDate(d1[0]);
                ledate.setMonth(d1[1] - 1);
                ledate.setFullYear(d1[2]);
                var timeElapsed = trandate.getTime() - ledate.getTime();
                timeElapsed = timeElapsed / (1000 * 3600 * 24 * 7);
                if(!isNaN(timeElapsed) && document.getElementById("agedateecho").value.length > 0 && !isNaN(document.getElementById("agedateecho").value)){
                    age = (document.getElementById("agedateecho").value * 1 + Math.round(timeElapsed * 10) / 10)+"";
                    if(age.indexOf(".")>-1){
                        aAge = age.split(".");
                        age = aAge[0]+ " " +aAge[1];
                    }
                    document.getElementById("ageactualecho").value = age;
                }
            }
        }
    }
	
	   if(document.getElementById("transactionId").value.startsWith("-")){
        <%
            String sAgeDateDr = "";
            ItemVO itemDelAgeDateDr = MedwanQuery.getInstance().getLastItemVO(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_DR");

            if(itemDelAgeDateDr!=null){
                sAgeDateDr = itemDelAgeDateDr.getValue();
                %>document.getElementById("drdate").value = "<%=sAgeDateDr%>";
        <%
}

ItemVO itemAgeDateEcho = MedwanQuery.getInstance().getLastItemVO(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY");
if(itemAgeDateEcho!=null){
    java.sql.Date dNow = ScreenHelper.getSQLDate(ScreenHelper.getDate());
    long lNow = dNow.getTime()/1000/3600/24/7;
    long lEcho = itemAgeDateEcho.getDate().getTime()/1000/3600/24/7;

    if(lNow-lEcho < 43){
        %>document.getElementById("agedateecho").value = "<%=lNow-lEcho%>";
        <%

    ItemVO itemEcho = MedwanQuery.getInstance().getLastItemVO(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_ECHO");
    if(itemEcho!=null){
        %>document.getElementById("echodate").value = "<%=itemEcho.getValue()%>";
        <%
    }

    ItemVO itemDateEcho = MedwanQuery.getInstance().getLastItemVO(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_ECHOGRAPHY");
    if(itemEcho!=null){
        %>document.getElementById("echodeldate").value = "<%=itemDateEcho.getValue()%>";
    <%
            }
        }
    }
    %>
        calculateGestAge();

        if(document.getElementById("agedatedr").value.length>0){
            var aDate = document.getElementById("agedatedr").value.split(" ");
            if(aDate[0].length>0){
                if(aDate[0]*1>43){
                    document.getElementById("drdate").value = "";
                    clearDr();
                }
            }
        }

        if(document.getElementById("ageactualecho").value.length>0){
            var aDate = document.getElementById("ageactualecho").value.split(" ");
            if(aDate[0].length>0){
                if(aDate[0]*1>43){
                    document.getElementById("echodate").value = "";
                    document.getElementById("agedateecho").value = "";
                    document.getElementById("echodeldate").value = "";
                    document.getElementById("ageactualecho").value = "";
                }
            }
        }
    }
    else {
        calculateGestAge();
    }
</script>

    
<%=writeJSButtons("transactionForm","saveButton")%>