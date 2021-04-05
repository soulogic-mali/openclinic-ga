<%@page import="be.openclinic.medical.*"%>
<%@include file="/includes/validateUser.jsp" %>
<%@page errorPage="/includes/error.jsp" %>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
        <%-- ###################################### WORK ######################################--%> <%-- DATE --%>
        <tr>
            <td class="admin">
                <%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
            </td>
            <td class="admin2" colspan='3'>
            	<input type='hidden' id='deliverydatefield' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYDATE" property="itemId"/>]>.value' value='<%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYDATE")%>'/>
            	<%=ScreenHelper.writeDateField("deliverydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYDATE"), true, false, sWebLanguage, sCONTEXTPATH,"document.getElementById(\"deliverydatefield\").value=this.value;updateGraphs();")%>
            </td>
        </tr>
        <%-- admission --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "admission", sWebLanguage)%></td>
            <td class="admin2" colspan='3'>
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
            <td class="admin2" colspan='3'>
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
            <td class="admin2" colspan='3'>
                <select class="text" id="beginHourSelect" onchange="updateGraphs();">
                    <option/>
                    <%for(int i = 0; i < 24; i++){%>
                    <option value="<%=i%>"><%=i%></option>
                <%}%>
                </select> :
                <select class="text" id="beginMinutSelect" onchange="updateGraphs();">
                    <option value="00" selected="selected">00</option>
                    <%
                    	for(int n=1;n<60;n++){
                    		String time = ""+n;
                    		if(n<10){
                    			time="0"+n;
                    		}
                    		out.println("<option value='"+time+"'>"+time+"</option>");
                    	}
                    %>
                </select>
                <input id="ITEM_TYPE_DELIVERY_STARTHOUR" type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
                <script>
                    var setBeginHourIntSelect = function(){

                        var hours = $("beginHourSelect").options;
                        var min = $("beginMinutSelect").options;
                        var hourToTest = parseInt($("ITEM_TYPE_DELIVERY_STARTHOUR").value.split(":")[0]);

                        var minToTest = parseInt($("ITEM_TYPE_DELIVERY_STARTHOUR").value.split(":")[1]);
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
            <td class="admin2" nowrap colspan='3'>
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
            <td colspan="4"><%=getTran(request,"gynaeco", "familyhead", sWebLanguage)%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "name", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_NAME")%> type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_NAME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_NAME" property="value"/>">
   			</td>
            <td class="admin"><%=getTran(request,"gynaeco", "relationship", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_RELATION")%> type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_RELATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_RELATION" property="value"/>">
   			</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "phone", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_PHONE")%> type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_PHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_PHONE" property="value"/>">
   			</td>
            <td class="admin"><%=getTran(request,"gynaeco", "nationality", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_NATIONALITY")%> type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_NATIONALITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_NATIONALITY" property="value"/>">
   			</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "profession", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_PROFESSION")%> type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_PROFESSION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_PROFESSION" property="value"/>">
   			</td>
            <td class="admin"><%=getTran(request,"gynaeco", "employer", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CONTACT_EMPLOYER")%> type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_EMPLOYER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CONTACT_EMPLOYER" property="value"/>">
   			</td>
        </tr>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"gynaeco", "history", sWebLanguage)%>
            </td>
        </tr>
		<tr>
			<td colspan='4'>
				<div id='problems'>
				</div>
				<script>
				  function showProblemlist(){
				    openPopup("medical/manageProblems.jsp&reloadFunction=loadProblemlist()&ts=<%=getTs()%>",700,500);
				  }
				  function loadProblemlist(){
				    var url = "<c:url value=''/>healthrecord/ajax/getProblemList.jsp";
				    new Ajax.Request(url,{
				      method: "POST",
				      parameters: "",
				      onSuccess: function(resp){
				        document.getElementById('problems').innerHTML=resp.responseText;
				      }
				    });
				  }
				  loadProblemlist();
				</script>
			</td>
		</tr>
		<tr>
			<td colspan='4'>
				<hr/>
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
        <%if(MedwanQuery.getInstance().getConfigInt("hideDeliveryMedicalHistory",0)==0){ %>
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
        <%} %>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "history.chi", sWebLanguage)%></td>
   			<td class='admin2'>
                <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HISTORY_CHIOTHER" property="value"/></textarea>
   			</td>
            <td class="admin"><%=getTran(request,"gynaeco", "abo", sWebLanguage)%></td>
   			<td class='admin2'>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ABO")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ABO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ABO" property="value"/>">
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
            		<tr>
            			<td width="16%">
            				<%=getTran(request,"web", "iptdoses", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_IPTDOSES")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IPTDOSES" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IPTDOSES" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "itnused", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_ITN")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ITN" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ITN" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "vdrl", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_VDRL")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VDRL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VDRL" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "pmtct2", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_PMTCT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PMTCT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_PMTCT" property="value"/>">
            			</td>
            			<td colspan="2">
            				<%=getTran(request,"web", "lasthemoglobine", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_LASTHB")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_LASTHB" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_LASTHB" property="value"/>"> g/dl &nbsp;&nbsp;&nbsp;
                            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_LASTHBDATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_LASTHBDATE" property="value" formatType="date"/>" id="lasthbdate" onBlur='checkDate(this);'/>
                            <script>writeMyDate("lasthbdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
            			</td>
            		</tr>
            	</table>
   			</td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "diseasehistory", sWebLanguage)%></td>
   			<td colspan="3" class='admin2'>
            	<table width='100%'>
            		<tr>
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_METRORHAGIE" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_METRORHAGIE;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "metroraghie", sWebLanguage)%>
            			</td>
            			<td width="32%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_INTRAVAGINALLOSS" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_INTRAVAGINALLOSS;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "intravaginalloss", sWebLanguage)%>
            			</td>
            			<td width="32%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_LUMBARPAIN" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DH_LUMBARPAIN;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "lumbarpain", sWebLanguage)%>
            			</td>
            			<td width="16%">
            				<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_DELIVERY_PREECLAMPSIA", "") %>
            				<%=getTran(request,"web", "preeclampsia", sWebLanguage)%>
            			</td>
            		</tr>
            	</table>
            </td>
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
            			<td width="16%">
                            <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IRON" property="itemId"/>]>.value" value="medwan.common.true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_IRON;value=medwan.common.true"
                                                      property="value"
                                                      outputString="checked"/>><%=getTran(request,"gynecology", "iron", sWebLanguage)%>
            			</td>
            			<td width="32%">
            				<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_DELIVERY_HBVPOS", "") %>
            				<%=getTran(request,"web","hbvplus",sWebLanguage) %>
            				<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_DELIVERY_HBVPOSTREATED", "") %>
            				<%=getTran(request,"web","undertreatment",sWebLanguage) %>
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
            					<option value='?' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH").equals("?")?"selected":"" %>>?</option>
            				</select>
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "vihpartner", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIHPARTNER" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "ptme", sWebLanguage)%>:
            				<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_PREGNANCY_PTME", "ptme",sWebLanguage, "") %>
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
            			<td width="16%">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "moulding", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_MOULDING")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_MOULDING" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_MOULDING" property="value"/>">
            			</td>
            			<td width="16%">
            				<%=getTran(request,"web", "caput", sWebLanguage)%>:
            				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_COLLAR_CAPUT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_CAPUT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_CAPUT" property="value"/>">
            			</td>
            			</td>
            			<td colspan="3">
            				<%=getTran(request,"web", "liquor", sWebLanguage)%>:
            				<select class='text' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_LIQUOR" property="itemId"/>]>.value">
            					<option/>
            					<%=ScreenHelper.writeSelect(request, "delivery.liquor", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_COLLAR_LIQUOR"), sWebLanguage) %>
            				</select>
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
            <td class="admin"><%=getTran(request,"gynaeco", "diagnosis", sWebLanguage)%></td>
   			<td class='admin2'>
   				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_DIAGNOSIS")%> class="text" rows="1" cols="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_DIAGNOSIS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_DIAGNOSIS" property="value"/></textarea>
   			</td>
            <td class="admin"><%=getTran(request,"gynaeco", "approach", sWebLanguage)%></td>
   			<td class='admin2'>
   				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAM_APPROACH")%> class="text" rows="1" cols="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_APPROACH" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAM_APPROACH" property="value"/></textarea>
   			</td>
        </tr>
		<tr>
			<td class="admin">
	               <%=getTran(request,"gynecology", "performedby", sWebLanguage)%>
			</td>
			<td colspan="3" class='admin2'>
               	<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAMINATIONPERFORMEDBY" property="itemId"/>]>.value">
               		<option/>
               		<%=ScreenHelper.writeSelect(request,"delivery.performers",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAMINATIONPERFORMEDBY"),sWebLanguage) %>
               	</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	<%=getTran(request,"gynaeco", "performer", sWebLanguage)%>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_EXAMINATIONPERFORMER")%> type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAMINATIONPERFORMER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EXAMINATIONPERFORMER" property="value"/>">
			</td>
		</tr>
        