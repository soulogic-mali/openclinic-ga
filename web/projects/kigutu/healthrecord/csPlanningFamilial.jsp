<%@page errorPage="/includes/error.jsp" %>
<%@include file="/includes/validateUser.jsp" %>
<%=checkPermission(out,"occup.vitalsigns", "select", activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
  
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
 
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <%=contextHeader(request, sWebLanguage)%>
    
    <table width="100%" cellspacing="1" class="list">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;<%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur="checkDate(this);">
                <script>writeTranDate();</script>
            </td>
        </tr>
        
        <tr>
            <td class="admin"><%=getTranNoLink("cs.planification", "type.utilisatrice", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="radio" onDblClick="uncheckRadio(this);" id="utilisatricenew" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_UTILISATRICE" property="itemId"/>]>.value" value="nouvelle"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_UTILISATRICE;value=nouvelle"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "nouvelle", sWebLanguage, "utilisatricenew")%>
                <input type="radio" onDblClick="uncheckRadio(this);" id="utilisatrice" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_UTILISATRICE" property="itemId"/>]>.value" value="fin.mois"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_UTILISATRICE;value=fin.mois"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "fin.mois", sWebLanguage, "utilisatrice")%>
            </td>
        </tr>
        
        <tr>
            <td class="admin"><%=getTran(request,"cs.planification", "methode", sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <br/>
				<input type="checkbox" id="actions_1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PILULE" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PILULE;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "pilule", sWebLanguage, "actions_1")%>
										  
				<input type="radio" onDblClick="uncheckRadio(this);" id="pilule_coc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_PILULE" property="itemId"/>]>.value" value="nouvelle"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_PILULE;value=nouvelle"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "coc", sWebLanguage, "pilule_coc")%>
                <input type="radio" onDblClick="uncheckRadio(this);" id="utilisatrice" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_PILULE" property="itemId"/>]>.value" value="fin.mois"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_TYPE_PILULE;value=fin.mois"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "cop", sWebLanguage, "pilule_cop")%>
                <br/>
                <input type="checkbox" id="actions_10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_INJECTABLE" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_INJECTABLE;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "injectable", sWebLanguage, "actions_10")%>
                <br/>
                <input type="checkbox" id="actions_3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_IMPLANT" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_IMPLANT;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "implant", sWebLanguage, "actions_3")%>
                <br/>
                <input type="checkbox" id="actions_4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_DIU" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_DIU;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "diu", sWebLanguage, "actions_4")%>
                <br/>
                <input type="checkbox" id="actions_11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PRESERVATIF_MASCULIN" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PRESERVATIF_MASCULIN;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "preservatif.m", sWebLanguage, "actions_11")%>
                <br/>
                <input type="checkbox" id="actions_12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PRESERVATIF_FEMININ" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_PRESERVATIF_FEMININ;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "preservatif.f", sWebLanguage, "actions_12")%>
                <br/>
                <input type="checkbox" id="actions_13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_SPERMICIDE" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_SPERMICIDE;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "spermicide", sWebLanguage, "actions_13")%>
                <br/>
                <input type="checkbox" id="actions_14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_AUTRE_METHODE" property="itemId"/>]>.value" value="true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_AUTRE_METHODE;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"cs.planification", "autre.methode", sWebLanguage, "actions_14")%>
				<br/>
			</td>
        </tr>
      
	  <tr>
		<td class="admin"><%=getTran(request,"web","effets_Secondaires",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_EFFECTS" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"pf.effects",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_EFFECTS"),sWebLanguage,false,true) %>
			                </select>
						</td>
        </tr>
		
		<tr>
		<td class="admin"><%=getTran(request,"web","methode_arretee",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_STOPPED_METHOD" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"pf.stopped_method",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_STOPPED_METHOD"),sWebLanguage,false,true) %>
			                </select>
						</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"cs.planification", "accompagnee", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="radio" onDblClick="uncheckRadio(this);" id="newcase1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_ACCOMPAGNEE" property="itemId"/>]>.value" value="yes"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_ACCOMPAGNEE;value=yes"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "yes", sWebLanguage, "newcase1")%>
                <input type="radio" onDblClick="uncheckRadio(this);" id="newcase2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_ACCOMPAGNEE" property="itemId"/>]>.value" value="no"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_ACCOMPAGNEE;value=no"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "no", sWebLanguage, "newcase2")%>
            </td>
        </tr>
        
        <%-- COMMENT --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
            <td colspan="3" class="admin2">
                <textarea id="comment" rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="75" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_0" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_0" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_1" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PVV_COMMENTAIRE_2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_3" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_4" property="value"/></textarea>
              
                <input type="hidden" id="comment_1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_1" property="itemId"/>]>.value">
                <input type="hidden" id="comment_2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_2" property="itemId"/>]>.value">
                <input type="hidden" id="comment_3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_3" property="itemId"/>]>.value">
                <input type="hidden" id="comment_4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CS_PLANNING_FAMILIAL_COMMENTAIRE_4" property="itemId"/>]>.value">
            </td>
        </tr>
    </table>
    
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
    <%=getButtonsHtml(request,activeUser,activePatient,"occup.vitalsigns",sWebLanguage)%>
    <%=ScreenHelper.alignButtonsStop()%>
    
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    $("comment_1").value = $F("comment").substring(250,500);
    $("comment_2").value = $F("comment").substring(500,750);
    $("comment_3").value = $F("comment").substring(750,1000);
    $("comment_4").value = $F("comment").substring(1000,1250);
    $("comment").value = $F("comment").substring(0,250);

    var temp = Form.findFirstElement(transactionForm); //for ff compatibility
    document.getElementById("buttonsDiv").style.visibility = "hidden";
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>