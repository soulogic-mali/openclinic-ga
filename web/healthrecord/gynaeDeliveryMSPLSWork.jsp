<%@include file="/includes/validateUser.jsp" %>
<%@page errorPage="/includes/error.jsp" %>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
        <%-- ###################################### WORK ######################################--%> <%-- DATE --%>
        <tr>
            <td class="admin">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;<%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this);calculateGestAge();' onchange='calculateGestAge();' onKeyUp='calculateGestAge()'>
                <script>writeTranDate();</script>
            </td>
            <td class="admin" rowspan="5"><%=getTran(request,"openclinic.chuk", "deliverytype", sWebLanguage)%></td>
            <td rowspan="5" bgcolor="#EBF3F7">
                <table width="100%" cellspacing="1" bgcolor="white">
                    <%-- EUTOCIC -----------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input type="checkbox" id="type_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_EUSTOCIC" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_EUSTOCIC;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/> onclick="if(this.checked){document.getElementById('type_r2').checked=false;document.getElementById('type_r3').checked=false;document.getElementById('trtype2').style.display='none';document.getElementById('trtype3').style.display='none';}"><%=getLabel(request,"openclinic.chuk", "openclinic.common.eutocic", sWebLanguage, "type_r1")%>
                        </td>
                    </tr>
                    <%-- DYSTOCIC -----------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input type="checkbox" id="type_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_DYSTOCIC" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_DYSTOCIC;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/> onclick="if(this.checked){document.getElementById('type_r1').checked=false;}else{document.getElementById('type_r3').checked=false;document.getElementById('trtype3').style.display='none';}clearType2(this);"><%=getLabel(request,"openclinic.chuk", "openclinic.common.dystocic", sWebLanguage, "type_r2")%>
                        </td>
                    </tr>
                    <tr id="trtype2" name="trtype2">
                        <td width="25" class="admin2"/>
                        <td class="admin2">
                            <table width="100%">
                                <tr>
                                    <td><%=getTran(request,"gynaeco", "cause", sWebLanguage)%></td>
                                    <td>
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE")%> type="radio" onDblClick="uncheckRadio(this);" id="causedystocic_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE" property="itemId"/>]>.value" value="gynaeco.cause.maternel"
                                        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                                  compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE;value=gynaeco.cause.maternel"
                                                                  property="value"
                                                                  outputString="checked"/>><%=getLabel(request,"gynaeco.cause", "maternel", sWebLanguage, "causedystocic_r1")%>
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE")%> type="radio" onDblClick="uncheckRadio(this);" id="causedystocic_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE" property="itemId"/>]>.value" value="gynaeco.cause.fetal"
                                        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                                  compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE;value=gynaeco.cause.fetal"
                                                                  property="value"
                                                                  outputString="checked"/>><%=getLabel(request,"gynaeco.cause", "fetal", sWebLanguage, "causedystocic_r2")%>
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE")%> type="radio" onDblClick="uncheckRadio(this);" id="causedystocic_r3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE" property="itemId"/>]>.value" value="gynaeco.cause.mixte"
                                        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                                  compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DYSTOCIC_CAUSE;value=gynaeco.cause.mixte"
                                                                  property="value"
                                                                  outputString="checked"/>><%=getLabel(request,"gynaeco.cause", "mixte", sWebLanguage, "causedystocic_r3")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_VENTOUSSE")%> type="checkbox" id="cbventousse" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_VENTOUSSE" property="itemId"/>]>.value"
                                                <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_VENTOUSSE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.chuk", "gynaeco.ventouse", sWebLanguage, "cbventousse")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td/>
                                    <td>
                                        <table>
                                            <tr>
                                                <td><%=getTran(request,"gynaeco", "number_tractions", sWebLanguage)%></td>
                                                <td>
                                                    <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_NUMBER_TRACTIONS")%> id="ttractions" type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_NUMBER_TRACTIONS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_NUMBER_TRACTIONS" property="value"/>" onblur="isNumber(this)">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%=getTran(request,"gynaeco", "number_lachage", sWebLanguage)%></td>
                                                <td>
                                                    <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_NUMBER_LACHAGE")%> id="tlachage" type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_NUMBER_LACHAGE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_NUMBER_LACHAGE" property="value"/>" onblur="isNumber(this)">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_FORCEPS")%> type="checkbox" id="cbforceps" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FORCEPS" property="itemId"/>]>.value"
                                                <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FORCEPS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"gynaeco", "forceps", sWebLanguage, "cbforceps")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_MANOEUVRE")%> type="checkbox" id="cbmanoeuvre" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MANOEUVRE" property="itemId"/>]>.value"
                                                <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MANOEUVRE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"gynaeco", "manoeuvre", sWebLanguage, "cbmanoeuvre")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100"><%=getTran(request,"Web.Occup", "medwan.common.remark", sWebLanguage)%></td>
                                    <td>
                                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_TYPE_DYSTOCIC_REMARK")%> id="tdystoticremark" class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_DYSTOCIC_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_DYSTOCIC_REMARK" property="value"/></textarea>
                                    </td>
                                </tr>
			                    <%-- CAESERIAN ------------------------------------------%>
			                    <tr>
			                        <td colspan="2">
			                            <input type="checkbox" id="type_r3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_CAESERIAN" property="itemId"/>]>.value" value="medwan.common.true"
			                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_CAESERIAN;value=medwan.common.true"
			                                                      property="value"
			                                                      outputString="checked"/> onclick="if(this.checked){document.getElementById('type_r1').checked=false;}clearType3(this);"><%=getLabel(request,"openclinic.chuk", "openclinic.common.caeserian", sWebLanguage, "type_r3")%>
			                        </td>
			                    </tr>
			                    <tr id="trtype3" name="trtype3">
			                        <td colspan="2" style="border: 1px solid darkgrey;">
			                            <table width="100%" cellspacing="0">
			                                <tr>
			                                    <td colspan="2">
			                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CAESERIAN")%> type="radio" onDblClick="uncheckRadio(this);" id="caeserian_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN" property="itemId"/>]>.value" value="gynaeco.caeserian.before"
			                                        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                                                  compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN;value=gynaeco.caeserian.before"
			                                                                  property="value"
			                                                                  outputString="checked"/>><%=getLabel(request,"gynaeco.caeserian", "before", sWebLanguage, "caeserian_r1")%>
			                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CAESERIAN")%> type="radio" onDblClick="uncheckRadio(this);" id="caeserian_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN" property="itemId"/>]>.value" value="gynaeco.caeserian.during"
			                                        <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                                                  compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN;value=gynaeco.caeserian.during"
			                                                                  property="value"
			                                                                  outputString="checked"/>><%=getLabel(request,"gynaeco.caeserian", "during", sWebLanguage, "caeserian_r2")%>
			                                    </td>
			                                </tr>
			                                <tr>
			                                    <td><%=getTran(request,"gynaeco", "indication", sWebLanguage)%></td>
			                                    <td>
			                                    	<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN_INDICATION" property="itemId"/>]>.value">
			                                    		<option/>
			                                    		<%=ScreenHelper.writeSelect(request,"csindications",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CAESERIAN_INDICATION"),sWebLanguage) %>
			                                    	</select>
			                                    </td>
			                                </tr>
			                                <tr>
			                                    <td width="100"><%=getTran(request,"Web.Occup", "medwan.common.remark", sWebLanguage)%></td>
			                                    <td>
			                                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_REMARK")%> id="tcaeserianremark" class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_REMARK" property="value"/></textarea>
			                                    </td>
			                                </tr>
			                                <tr>
			                                    <td><%=getTran(request,"gynaeco", "caeserian_indication", sWebLanguage)%></td>
			                                    <td>
			                                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_INDICATION")%> id="tcaeserianindication" class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_INDICATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_TYPE_CAESERIAN_INDICATION" property="value"/></textarea>
			                                    </td>
			                                </tr>
			                            </table>
			                        </td>
			                    </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%-- admission --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "admission", sWebLanguage)%></td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ADMISSION")%> type="radio" onDblClick="uncheckRadio(this);" id="admission_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION" property="itemId"/>]>.value" value="gynaeco.admission.urgence"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION;value=gynaeco.admission.urgence"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"gynaeco.admission", "urgence", sWebLanguage, "admission_r1")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ADMISSION")%> type="radio" onDblClick="uncheckRadio(this);" id="admission_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION" property="itemId"/>]>.value" value="gynaeco.admission.transfer"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION;value=gynaeco.admission.transfer"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"gynaeco.admission", "transfer", sWebLanguage, "admission_r2")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ADMISSION")%> type="radio" onDblClick="uncheckRadio(this);" id="admission_r3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION" property="itemId"/>]>.value" value="gynaeco.admission.spontane"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION;value=gynaeco.admission.spontane"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"gynaeco.admission", "spontane", sWebLanguage, "admission_r3")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ADMISSION")%> type="radio" onDblClick="uncheckRadio(this);" id="admission_r4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION" property="itemId"/>]>.value" value="gynaeco.admission.other"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ADMISSION;value=gynaeco.admission.other"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"gynaeco.admission", "other", sWebLanguage, "admission_r4")%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "mcbooklet", sWebLanguage)%></td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_MCBOOKLET")%> type="radio" onDblClick="uncheckRadio(this);" id="mcbooklet_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MCBOOKLET" property="itemId"/>]>.value" value="medwan.common.true"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MCBOOKLET;value=medwan.common.true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "yes", sWebLanguage, "mcbooklet_r1")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_MCBOOKLET")%> type="radio" onDblClick="uncheckRadio(this);" id="mcbooklet_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MCBOOKLET" property="itemId"/>]>.value" value="medwan.common.false"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MCBOOKLET;value=medwan.common.false"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "no", sWebLanguage, "mcbooklet_r2")%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "start.hour", sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" id="beginHourSelect" onchange="setNewTime()">
                    <option/>
                    <%for(int i = 0; i < 24; i++){%>
                    <option value="<%=i%>"><%=i%></option>
                <%}%>
                </select> :
                <select class="text" id="beginMinutSelect" onchange="setNewTime()">
                    <option value="00" selected="selected">00</option>
                    <option value="15">15</option>
                    <option value="30">30</option>
                    <option value="45">45</option>
                </select>
                <input id="ITEM_TYPE_DELIVERY_STARTHOUR" type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
                <script>
                    var setBeginHourIntSelect = function(){

                        var hours = $("beginHourSelect").options;
                        var min = $("beginMinutSelect").options;
                        var hourToTest = parseInt($("ITEM_TYPE_DELIVERY_STARTHOUR").value.split(":")[0]);

                        var minToTest = parseInt($("ITEM_TYPE_DELIVERY_STARTHOUR").value.split(":")[1]);
                          if(minToTest<8){
                            minToTest = 0;
                          }else if(minToTest<22){
                            minToTest = 15;
                          }else if(minToTest<38){
                            minToTest = 30;
                          }else if(minToTest<52){
                            minToTest = 45;
                          }else{
                            minToTest = 0;
                              hourToTest ++;
                          }
                        for(var i=0;i<hours.length;i++){
                           if(hours[i].value==hourToTest){
                                $("beginHourSelect").selectedIndex = i;
                               break;
                            }
                        }
                        for(var i=0;i<min.length;i++){
                           if(min[i].value==minToTest){
                               $("beginMinutSelect").selectedIndex = i;
                               break;
                            }
                        }
                    }
                    setBeginHourIntSelect();
                </script>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "age.gestationnel", sWebLanguage)%></td>
            <td class="admin2" nowrap>
                <table width='100%'>
                    <tr>
                        <td><%=getTran(request,"gynaeco", "date.dr", sWebLanguage)%></td>
                        <td nowrap>
                            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_DR" property="value" formatType="date"/>" id="drdate" onBlur='checkDate(this);calculateGestAge();clearDr()' onChange='calculateGestAge();' onKeyUp='calculateGestAge();'/>
                            <script>writeMyDate("drdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                            <input id="agedatedr" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_DATE_DR")%> readonly type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_DATE_DR" property="value"/>"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%> <%=getTran(request,"web", "delivery.date", sWebLanguage)%>:
                            <input id="drdeldate" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DATE_DR")%> type="text" class="text" size="12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_DR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_DR" property="value"/>" onblur="checkDate(this);">
                        </td>
                    </tr>
                    <tr><td colspan='2'><hr/></td></tr>
                    <tr>
                        <td><%=getTran(request,"gynaeco", "date.echography", sWebLanguage)%></td>
                        <td nowrap>
                            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_ECHO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DATE_ECHO" property="value" formatType="date"/>" id="echodate" onBlur='checkDate(this);calculateGestAge();' onchange='calculateGestAge();' onkeyup='calculateGestAge();'/>
                            <script>writeMyDate("echodate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY" property="value"/>" id="agedateecho" onblur='calculateGestAge();' onchange='calculateGestAge();' onkeyup="calculateGestAge();"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%> <%=getTran(request,"web", "delivery.date", sWebLanguage)%>:
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
                    <tr><td colspan='2'><hr/></td></tr>
                    <tr>
                        <td>
                            <%=getTran(request,"gynaeco", "uterine.height.age", sWebLanguage)%>
                        </td>
                        <td>
                            <input id="ageuterineheight" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE_UTERINE_HEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ACTUEL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ACTUEL" property="value"/>" onblur="isNumber(this);calculateGestAge();"> <%=getTran(request,"web", "weeks.abr", sWebLanguage)%>
                        </td>
                    </tr>
                    <tr><td colspan='2'><hr/></td></tr>
                    <tr>
                        <td><%=getTran(request,"gynaeco", "age.trimstre", sWebLanguage)%>
                        </td>
                        <td nowrap>
                        	<table width="100%">
                        		<tr>
                        			<td>
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
									<td>
										<%=getTran(request,"web","atterm",sWebLanguage) %>:
			                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ATTERM")%> type="radio" onDblClick="uncheckRadio(this);" id="attermyes" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ATTERM" property="itemId"/>]>.value" value="medwan.common.true"
			                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ATTERM;value=medwan.common.true"
			                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
			                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ATTERM")%> type="radio" onDblClick="uncheckRadio(this);" id="attermno" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ATTERM" property="itemId"/>]>.value" value="medwan.common.false"
			                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ATTERM;value=medwan.common.false"
			                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
									</td>
								</tr>
							</table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"gynaeco", "history", sWebLanguage)%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "history.gyn", sWebLanguage)%></td>
            <td class="admin2" colspan="3">
            	<table width='100%'>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "gestity", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_GESTITY")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_GESTITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_GESTITY" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "parity", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_PARITY")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_PARITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_PARITY" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "childrenalive", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_CHILDRENALIVE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENALIVE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENALIVE" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "abortions", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_ABORTIONS")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_ABORTIONS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_ABORTIONS" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "deadborn", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_DEADBORN")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_DEADBORN" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_DEADBORN" property="value"/>">
            			</td>
            			<td>
            				<%=getTran(request,"web", "childrendied", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED" property="value"/>">
            			</td>
            		</tr>
            		<tr>
            			<td>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CS" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CS;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"openclinic.chuk", "openclinic.common.caeserian", sWebLanguage)%>
            			</td>
            			<td colspan="3">
            				<%=getTran(request,"web", "indications.cesarian", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_CS_INDICATIONS")%> type="text" class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED" property="value"/>">
            			</td>
            			<td colspan="2">
            				<%=getTran(request,"web", "date.cesarian", sWebLanguage)%>:
                            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CS_DATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CS_DATE" property="value" formatType="date"/>" id="lastcsdate" onBlur='checkDate(this);'/>
                            <script>writeMyDate("lastcsdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
            			</td>
            		</tr>
            		<tr>
            			<td>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_MYOMECTOMY" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_MYOMECTOMY;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "myemectomy", sWebLanguage)%>
            			</td>
            			<td>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_EXTRAUTERINE" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_EXTRAUTERINE;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "extrauterine.pregancy", sWebLanguage)%>
            			</td>
            			<td colspan="4">
            				<%=getTran(request,"web", "other", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_OTHER")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_OTHER" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "history.med", sWebLanguage)%></td>
            <td class="admin2" colspan="3">
            	<table width='100%'>
            		<tr>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_HTA" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_HTA;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "hta", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_DIABETES" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_DIABETES;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "diabetes", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_NEPHROPATHY" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_NEPHROPATHY;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "nephropathy", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CARDIOPATHY" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CARDIOPATHY;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "cardiopathy", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_ANEMIA" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_ANEMIA;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "anemia", sWebLanguage)%>
            			</td>
            			<td>
            				<%=getTran(request,"web", "other", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_MEDOTHER")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_MEDOTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_MEDOTHER" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "history.chi", sWebLanguage)%></td>
   			<td colspan="3" class='admin2'>
                <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER" property="value"/></textarea>
   			</td>
        </tr>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"gynaeco", "actual.pregnancy", sWebLanguage)%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "antenatal.surveillance", sWebLanguage)%></td>
   			<td colspan="3" class='admin2'>
            	<table width='100%'>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "numberofcpn", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_NUMBEROFCPN")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_NUMBEROFCPN" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_NUMBEROFCPN" property="value"/>">
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HIGHRISK" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HIGHRISK;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><b><font color="red"><%=getTran(request,"gynecology", "highriskpregnancy", sWebLanguage)%></font></b>
            			</td>
            			<td colspan="4">
            				<%=getTran(request,"web", "cpnexamresults", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_CPNRESULTS")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CPNRESULTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CPNRESULTS" property="value"/></textarea>
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "locationofcpn", sWebLanguage)%>:
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HOSPITAL" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HOSPITAL;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "hospital", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CDS" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CDS;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "healthcenter", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PRIVATECLINIC" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PRIVATECLINIC;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "privateclinic", sWebLanguage)%>
            			</td>
            			<td colspan="2">
            				<%=getTran(request,"web", "other", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_CPNOTHERLOCATION")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CPNOTHERLOCATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_CPNOTHERLOCATION" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
   			</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "particularities", sWebLanguage)%></td>
   			<td colspan="3" class='admin2'>
            	<table width='100%'>
            		<tr>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ANEMIA" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ANEMIA;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "anemia", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_OMI" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_OMI;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "omi", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HTA" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_HTA;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "hta", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DIABETES" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DIABETES;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "diabetes", sWebLanguage)%>
            			</td>
            			<td>
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_URINARYINFECTION" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_URINARYINFECTION;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "urinary.infection", sWebLanguage)%>
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_MALARIAPREVENTION" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_MALARIAPREVENTION;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "malariaprevention", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ANEMIAPREVENTION" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ANEMIAPREVENTION;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "anemiaprevention", sWebLanguage)%>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ALBENDAZOLE" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ALBENDAZOLE;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "albendazole", sWebLanguage)%>
            			</td>
            			<td colspan="2">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IRON" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IRON;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "iron", sWebLanguage)%>
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "vatdose", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_VATDOSE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VATDOSE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VATDOSE" property="value"/>">
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DEPISTSYPHILLIS" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DEPISTSYPHILLIS;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"web", "syphillis", sWebLanguage)%>:
            				<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_SYPHILLIS" property="itemId"/>]>.value">
            					<option/>
            					<option value='+' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_SYPHILLIS").equals("+")?"selected":"" %>>+</option>
            					<option value='-' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_SYPHILLIS").equals("-")?"selected":"" %>>-</option>
            				</select>
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DEPISTVIH" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DEPISTVIH;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"web", "vih", sWebLanguage)%>:
            				<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH" property="itemId"/>]>.value">
            					<option/>
            					<option value='+' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH").equals("+")?"selected":"" %>>+</option>
            					<option value='-' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH").equals("-")?"selected":"" %>>-</option>
            				</select>
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "vihpartner", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "ptme", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_PTME")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PTME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PTME" property="value"/>">
            			</td>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ARV" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ARV;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"web", "underarv", sWebLanguage)%>
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSPRECSRIBED" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSPRECSRIBED;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "drugsprescribed", sWebLanguage)%>
            			</td>
            			<td colspan="2">
            				<%=getTran(request,"web", "drugstype", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSTYPE")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSTYPE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSTYPE" property="value"/></textarea>
            			</td>
            			<td colspan="3">
            				<%=getTran(request,"web", "drugsperiod", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSPERIOD")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSPERIOD" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_DRUGSPERIOD" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
   			</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "clinicalexamination", sWebLanguage)%></td>
   			<td colspan="3" class='admin2'>
            	<table width='100%'>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "height", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_HEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_HEIGHT" property="value"/>">m
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "weight", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_WEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WEIGHT" property="value"/>">kg
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "brachialcirc", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_BRACHIAL")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BRACHIAL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BRACHIAL" property="value"/>">cm
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "bloodpressure", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_BLOODPRESSURE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BLOODPRESSURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BLOODPRESSURE" property="value"/>">mmHg
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "heartfrequency", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_HF")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_HF" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_HF" property="value"/>">bpm
            			</td>
            			<td>
            				<%=getTran(request,"web", "temperature", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_TEMPERATURE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TEMPERATURE" property="value"/>">°C
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "conjunctiva", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_CONJUNCTIVA")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONJUNCTIVA" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONJUNCTIVA" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "conscience", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_CONSCIENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONSCIENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONSCIENCE" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "uterineheight", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_UTERINEHEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_UTERINEHEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_UTERINEHEIGHT" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "bcf", sWebLanguage)%>:
            				<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BCF" property="itemId"/>]>.value">
            					<option/>
            					<option value='+' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BCF").equals("+")?"selected":"" %>>+</option>
            					<option value='-' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BCF").equals("-")?"selected":"" %>>-</option>
            				</select>
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_BCF_DATA")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BCF_DATA" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_BCF_DATA" property="value"/>">/min
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "twins", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_TWINS")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TWINS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TWINS" property="value"/>">
            			</td>
            			<td>
            				<%=getTran(request,"web", "contractions", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_CONTRACTIONS")%> type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONTRACTIONS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_CONTRACTIONS" property="value"/>">
            			</td>
            		</tr>
            		<tr>
            			<td colspan="6"><hr/></td>
            		</tr>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "vaginaltouche", sWebLanguage)%>:
            			</td>
            			<td colspan="5">
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_TV")%> type="radio" onDblClick="uncheckRadio(this);" id="tv_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV" property="itemId"/>]>.value" value="1"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV;value=1"
                                                      property="value" outputString="checked"/>><%=getTran(request,"web", "normal", sWebLanguage)%>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_TV")%> type="radio" onDblClick="uncheckRadio(this);" id="tv_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV" property="itemId"/>]>.value" value="2"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV;value=2"
                                                      property="value" outputString="checked"/>><%=getTran(request,"web", "limit", sWebLanguage)%>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_TV")%> type="radio" onDblClick="uncheckRadio(this);" id="tv_r3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV" property="itemId"/>]>.value" value="3"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_TV;value=3"
                                                      property="value" outputString="checked"/>><%=getTran(request,"web", "narrow", sWebLanguage)%>
            			</td>
            		</tr>
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "collar", sWebLanguage)%>
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "length", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_LENTH")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_LENTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_LENTH" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "position", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_POSITION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_POSITION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_POSITION" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "consistency", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_CONSISTENCY")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_CONSISTENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_CONSISTENCY" property="value"/>">
            			</td>
            			<td colspan="2">
            				<%=getTran(request,"web", "dilatation", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_DILATATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_DILATATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_DILATATION" property="value"/>">
            			</td>
            		</tr>
            		<tr>
            			<td colspan="2">
            				<%=getTran(request,"web", "presentation", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_PRESENTATION")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_PRESENTATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_PRESENTATION" property="value"/></textarea>
            			</td>
            			<td colspan="4">
            				<%=getTran(request,"web", "waterpouch", sWebLanguage)%>:
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH")%> type="radio" onDblClick="uncheckRadio(this);" id="wp_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH" property="itemId"/>]>.value" value="1"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH;value=1"
                                                      property="value" outputString="checked"/>><%=getTran(request,"web", "intact", sWebLanguage)%>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH")%> type="radio" onDblClick="uncheckRadio(this);" id="wp_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH" property="itemId"/>]>.value" value="2"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERPOUCH;value=2"
                                                      property="value" outputString="checked"/>><%=getTran(request,"web", "broken", sWebLanguage)%>
            				&nbsp;<%=getTran(request,"web", "since", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_WATERBROKENSINCE")%> type="text" class="text" size="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERBROKENSINCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_WATERBROKENSINCE" property="value"/>">
            			</td>
            		</tr>
            		<tr>
            			<td colspan="6">
            				<%=getTran(request,"web", "other", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_OTHER")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_OTHER" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
        <tr>

