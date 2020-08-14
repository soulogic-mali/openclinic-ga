<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSCHARTJS%>
<%=sJSEXCANVAS%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%'>
	<tr>
		<td class="admin" colspan='2'><%=getTran(request,"openclinic.chuk", "deliverytype", sWebLanguage)%></td>
	</tr>
	<tr>
        <td bgcolor="#EBF3F7" colspan='2'>
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
                <tr id="trtype2" name="trtype2" style='display: none'>
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
                   <tr id="trtype3" name="trtype3" style='display: none'>
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
	<tr>
	<tr>
		<td class='admin2' colspan='2'>
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web", "uterinerevision", sWebLanguage)%>
					</td>
					<td class='admin2'>
						<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_UTERUSREVISION")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_UTERUSREVISION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_UTERUSREVISION" property="value"/></textarea>
					</td>
					<td class='admin'>
						<%=getTran(request,"web", "other", sWebLanguage)%>
					</td>
					<td class='admin2'>
						<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_OTHERCOMPLICATION")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERCOMPLICATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERCOMPLICATION" property="value"/></textarea>
					</td>
				</tr>
				<tr>
		 			<td class='admin'>
           				<%=getTran(request,"web", "drugsprescribed", sWebLanguage)%>
           			</td>
           			<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_DRUGSPRESCRIBED", 50, 1)%>
		 			</td>
				</tr>
			</table>
		</td>
	</tr>
	</tr>
	<tr>
		<td colspan='2'><hr/></td>
	</tr>
    <tr>
    	<td width='50%'>
			<div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagFoetalHeartRythm"></canvas></div>
		</td>
		<td width='50%' valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","foetalheartfrequency",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='fhrDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_FHR" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_FHR" property="value"/>' id='fhrData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='fhrHour' size='2'/> : <input value='' type='text' class='text' id='fhrMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='fhrValue' size='4'/>/min
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(fhrChart,"fhrDays","fhrHour","fhrMinutes","fhrValue","fhrData","fhrData","",80,200);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td width='50%'>
			<div style="border: 0px solid black; height:100px; width:400px;"><canvas style="border: 0px solid black; height:100px; width:400px;" id="diagAmnion"></canvas></div>
		</td>
		<td width='50%' valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","amniongraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='amnionDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_AMNION" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_AMNION" property="value"/>' id='amnionData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='amnionHour' size='2'/> : <input value='' type='text' class='text' id='amnionMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> 
						<select class='text' id='amnionValue'>
							<%=ScreenHelper.writeSelect(request, "partogramme.amnion", "", sWebLanguage) %>
						</select>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(amnionChart,"amnionDays","amnionHour","amnionMinutes","amnionValue","amnionData","amnionData","headData",0,100,1.5,0.5);'/>
					</td>
				</tr>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","headgraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='headDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_HEAD" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_HEAD" property="value"/>' id='headData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='headHour' size='2'/> : <input value='' type='text' class='text' id='headMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> 
						<select class='text' id='headValue'>
							<%=ScreenHelper.writeSelect(request, "partogramme.head", "", sWebLanguage) %>
						</select>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(amnionChart,"headDays","headHour","headMinutes","headValue","headData","amnionData","headData",0,100,1.5,0.5);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td width='50%'>
			<div style="border: 0px solid black; height:100px; width:400px;"><canvas style="border: 0px solid black; height:100px; width:400px;" id="diagDrugs"></canvas></div>
		</td>
		<td width='50%' valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","druggraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='drugDays1' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DRUGS1" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DRUGS1" property="value"/>' id='drugData1'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='drugHour1' size='2'/> : <input value='' type='text' class='text' id='drugMinutes1' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> 
						<select class='text' id='drugValue1'>
							<%=ScreenHelper.writeSelect(request, "partogramme.drug", "", sWebLanguage) %>
						</select>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(drugChart,"drugDays1","drugHour1","drugMinutes1","drugValue1","drugData1","drugData1","drugData2",0,100,1.5,0.5);'/>
					</td>
				</tr>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","druggraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='drugDays2' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DRUGS2" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DRUGS2" property="value"/>' id='drugData2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='drugHour2' size='2'/> : <input value='' type='text' class='text' id='drugMinutes2' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> 
						<select class='text' id='drugValue2'>
							<%=ScreenHelper.writeSelect(request, "partogramme.drug", "", sWebLanguage) %>
						</select>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(drugChart,"drugDays2","drugHour2","drugMinutes2","drugValue2","drugData2","drugData1","drugData2",0,100,1.5,0.5);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td>
			<div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagDilatation"></canvas></div>
		</td>
		<td valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","dilatation",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='dilDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DIL" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DIL" property="value"/>' id='dilData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='dilHour' size='2'/> : <input value='' type='text' class='text' id='dilMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='dilValue' size='4'/>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(dilChart,"dilDays","dilHour","dilMinutes","dilValue","dilData","dilData","engData",0,10);'/>
					</td>
				</tr>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","engagement",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='engDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_ENG" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_ENG" property="value"/>' id='engData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='engHour' size='2'/> : <input value='' type='text' class='text' id='engMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='engValue' size='4'/>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(dilChart,"engDays","engHour","engMinutes","engValue","engData","dilData","engData",0,5);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td width='50%'>
			<div style="border: 0px solid black; height:150px; width:400px;"><canvas style="border: 0px solid black; height:150px; width:400px;" id="diagContractions"></canvas></div>
		</td>
		<td width='50%' valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","contractions",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='contrDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_CONTR" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_CONTR" property="value"/>' id='contrData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='contrHour' size='2'/> : <input value='' type='text' class='text' id='contrMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='contrValue' size='4'/>/10min
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"openclinic.chuk","duration",sWebLanguage) %> 
						<select id='durationValue' style='FONT-WEIGHT:normal;FONT-SIZE:10px;height:18px;FONT-FAMILY:arial, sans-serif;' onchange='this.style.backgroundColor=this.options[this.selectedIndex].style.backgroundColor;this.style.color=this.options[this.selectedIndex].style.color;'>
							<option value='13' style='background-color: white;color: black;'/>
							<option value='10' style='background-color: yellow;color: black;'>&lt;20s</option>
							<option value='11' style='background-color: green;color: white;'>&lt;40s</option>
							<option value='12' style='background-color: blue;color: white;'>&gt;=40s</option>
						</select>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement2(contrChart,"contrDays","contrHour","contrMinutes","contrValue","durationValue","contrData","contrData","",0,5);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td width='50%'>
			<div style="border: 0px solid black; height:100px; width:400px;"><canvas style="border: 0px solid black; height:100px; width:400px;" id="diagOxytocine"></canvas></div>
		</td>
		<td width='50%' valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","oxygraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='oxyDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_OXY" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_OXY" property="value"/>' id='oxyData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='oxyHour' size='2'/> : <input value='' type='text' class='text' id='oxyMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='oxyValue' size='4'/>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(oxyChart,"oxyDays","oxyHour","oxyMinutes","oxyValue","oxyData","oxyData","dropData",0,100,1.5,0.5);'/>
					</td>
				</tr>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","dropgraph",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='dropDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DROP" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_DROP" property="value"/>' id='dropData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='dropHour' size='2'/> : <input value='' type='text' class='text' id='dropMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='dropValue' size='4'/>
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(oxyChart,"dropDays","dropHour","dropMinutes","dropValue","dropData","oxyData","dropData",0,100,1.5,0.5);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td>
			<div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagHeartrate"></canvas></div>
		</td>
		<td valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","heartfrequency",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='hrDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_HR" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_HR" property="value"/>' id='hrData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='hrHour' size='2'/> : <input value='' type='text' class='text' id='hrMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='hrValue' size='4'/>/min
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(hrChart,"hrDays","hrHour","hrMinutes","hrValue","hrData","hrData","",40,180);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td>
			<div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagBP"></canvas></div>
		</td>
		<td valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","bloodpressure",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='bpDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_BPSYS" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_BPSYS" property="value"/>' id='sysData'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_BPDIA" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_BPDIA" property="value"/>' id='diaData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='bpHour' size='2'/> : <input value='' type='text' class='text' id='bpMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='sysValue' size='4'/>/<input type='text' class='text' value='' id='diaValue' size='4'/>mmHg
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(bpChart,"bpDays","bpHour","bpMinutes","sysValue","sysData","sysData","diaData",40,200);addMeasurement(bpChart,"bpDays","bpHour","bpMinutes","diaValue","diaData","sysData","diaData",40,200);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td>
			<div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagTemp"></canvas></div>
		</td>
		<td valign='top'>
			<table width='100%'>
				<tr>
					<td width='1%' nowrap>
						<%=getTran(request,"web","temperature",sWebLanguage) %>: 
					</td>
					<td width='1%' nowrap>
						<select id='tempDays' class='text'/>
						<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_TEMP" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PARTOGRAMME_TEMP" property="value"/>' id='tempData'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web.occup","time",sWebLanguage) %> <input type='text' class='text' value='' id='tempHour' size='2'/> : <input value='' type='text' class='text' id='tempMinutes' size='2'/>
					</td>
					<td width='1%' nowrap>
						<%=getTran(request,"web","value",sWebLanguage) %> <input type='text' class='text' value='' id='tempValue' size='4'/>°C
					</td>
					<td width="*">
						<input type='button' class='button' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addMeasurement(tempChart,"tempDays","tempHour","tempMinutes","tempValue","tempData","tempData","",35,43);'/>
					</td>
				</tr>
			</table>
		</td>
    </tr>
</table>

<script>

// Define a plugin to provide data labels
Chart.plugins.register({
    afterDatasetsDraw: function(chart, easing) {
        // To only draw at the end of animation, check for easing === 1
        var ctx = chart.ctx;

        chart.data.datasets.forEach(function (dataset, i) {
            var meta = chart.getDatasetMeta(i);
            if (dataset.showLabels && !meta.hidden) {
                meta.data.forEach(function(element, index) {
                    // Draw the text in black, with the specified font
                    ctx.fillStyle = 'rgb(0, 0, 0)';

                    var fontSize = 10;
                    var fontStyle = 'bold';
                    var fontFamily = 'Arial';
                    ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

                    // Just naively convert to string for now
                    var dataString = dataset.data[index].y+'';
                    if(!(dataset.data[index].z==undefined)){
                    	if(dataset.translate){
                    		dataString=pointlabels[dataset.data[index].z*1];
                    	}
                    	else{
                    		dataString = dataset.data[index].z+'';
                    	}
                    }

                    // Make sure alignment settings are correct
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';

                    var padding = 5;
                    var position = element.tooltipPosition();
                    ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
                });
            }
        });
    }
});

var fhrChart;
var dilChart;
var amnionChart;
var drugChart;
var contrChart;
var oxyChart;
var hrChart;
var bpChart;
var tempChart;
var second = 1000;
var minute = 60*second;
var hour = 60*minute;
var day = 24*hour;
var timeFormat = 'h';
var pointlabels=[
<%
	SortedMap s = MedwanQuery.getInstance().getLabels("partogramme.pointlabel", sWebLanguage);
	Iterator i = s.keySet().iterator();
	while(i.hasNext()){
		String key = (String)i.next();
		out.println("'"+s.get(key)+"',");
	}
%>
           	];

window.onload = function(){
	updateGraphs();
}

function updateGraphs(){
	drawFoetalHeartRythmGraph();
	drawDilatationGraph();
	drawAmnionGraph();
	drawDrugGraph();
	drawContractionsGraph();
	drawOxyGraph();
	drawHeartrateGraph();
	drawBloodpressureGraph();
	drawTempGraph();
}

function setTimes(){
	newDate=new Date();
	var h = ("00"+newDate.getHours()).substr(("00"+newDate.getHours()).length-2);
	var m = ("00"+newDate.getMinutes()).substr(("00"+newDate.getMinutes()).length-2);
	if(newDate.getTime()<getStartDate().getTime() || newDate.getTime()>getStartDate().getTime()+12*hour){
		h='';
		m='';
	}
	document.getElementById('fhrHour').value=h;
	document.getElementById('fhrMinutes').value=m;
	document.getElementById('dilHour').value=h;
	document.getElementById('dilMinutes').value=m;
	document.getElementById('engHour').value=h;
	document.getElementById('engMinutes').value=m;
	document.getElementById('amnionHour').value=h;
	document.getElementById('amnionMinutes').value=m;
	document.getElementById('drugHour1').value=h;
	document.getElementById('drugMinutes1').value=m;
	document.getElementById('drugHour2').value=h;
	document.getElementById('drugMinutes2').value=m;
	document.getElementById('headHour').value=h;
	document.getElementById('headMinutes').value=m;
	document.getElementById('contrHour').value=h;
	document.getElementById('contrMinutes').value=m;
	document.getElementById('oxyHour').value=h;
	document.getElementById('oxyMinutes').value=m;
	document.getElementById('dropHour').value=h;
	document.getElementById('dropMinutes').value=m;
	document.getElementById('hrHour').value=h;
	document.getElementById('hrMinutes').value=m;
	document.getElementById('bpHour').value=h;
	document.getElementById('bpMinutes').value=m;
	document.getElementById('tempHour').value=h;
	document.getElementById('tempMinutes').value=m;
}

function removeMeasurement(datafield,index){
	var array = document.getElementById(datafield).value.split("|");
	array.splice(index+1,1);
	document.getElementById(datafield).value=array.join("|");
}

function addMeasurement(chart,dateid,hourid,minuteid,valueid,datafield,datafield1,datafield2,min,max,yvalue1,yvalue2){
	if(document.getElementById(dateid).value.length>0 && document.getElementById(hourid).value.length>0 && document.getElementById(minuteid).value.length>0 && document.getElementById(valueid).value.length>0){
		var nDate=document.getElementById(dateid).value;
		var nHour=document.getElementById(hourid).value*1;
		var nMinutes=document.getElementById(minuteid).value*1;
		var nValue=document.getElementById(valueid).value*1;
		var newDate=new Date(nDate.split(".")[0],nDate.split(".")[1],nDate.split(".")[2],nHour,nMinutes);
		var newValue=nValue*1;
		if(nValue<min || nValue>max){
			alert('<%=getTranNoLink("web","valueoutofbounds",sWebLanguage)%>');
		}
		else if(newDate.getTime()<getStartDate().getTime() || newDate.getTime()>getStartDate().getTime()+12*hour){
			alert('<%=getTranNoLink("web","valueoutofbounds",sWebLanguage)%>');
		}
		else{
			document.getElementById(datafield).value+="|"+newDate.getTime()+";"+newValue;
			sort(datafield);
			updateChart(chart,datafield1,datafield2,yvalue1,yvalue2);
			window.setTimeout("setTimes();",500);
		}
	}
}

function addMeasurement2(chart,dateid,hourid,minuteid,valueid,labelid,datafield,datafield1,datafield2,min,max,yvalue1,yvalue2){
	if(document.getElementById(dateid).value.length>0 && document.getElementById(hourid).value.length>0 && document.getElementById(minuteid).value.length>0 && document.getElementById(valueid).value.length>0){
		var nDate=document.getElementById(dateid).value;
		var nHour=document.getElementById(hourid).value*1;
		var nMinutes=document.getElementById(minuteid).value*1;
		var nValue=document.getElementById(valueid).value*1;
		var newDate=new Date(nDate.split(".")[0],nDate.split(".")[1],nDate.split(".")[2],nHour,nMinutes);
		var newValue=nValue*1;
		if(nValue<min || nValue>max){
			alert('<%=getTranNoLink("web","valueoutofbounds",sWebLanguage)%>');
		}
		else if(newDate.getTime()<getStartDate().getTime() || newDate.getTime()>getStartDate().getTime()+12*hour){
			alert('<%=getTranNoLink("web","valueoutofbounds",sWebLanguage)%>');
		}
		else{
			document.getElementById(datafield).value+="|"+newDate.getTime()+";"+newValue+";"+document.getElementById(labelid).value;
			sort(datafield);
			updateChart(chart,datafield1,datafield2,yvalue1,yvalue2);
			setTimes();
		}
	}
}

function updateChart(chart,datafield1,datafield2,yvalue1,yvalue2){
	if(datafield1 && datafield1.length>0){
		chart.config.data.datasets[0].pointBackgroundColor=[];
		chart.config.data.datasets[0].data = [];
		var array = document.getElementById(datafield1).value.split("|");
		for(n=0;n<array.length;n++){
			if(array[n].length>0){
				var oDate = new Date(array[n].split(";")[0]*1);
				var oValue = array[n].split(";")[1]*1;
				if(yvalue1){
					var newData={
				            x: oDate,
				            y: yvalue1,
				            z: oValue,
				        };
				}
				else{
					var newData={
				            x: oDate,
				            y: oValue,
				        };
				}
				chart.config.data.datasets[0].data.push(newData);
		        if (chart.config.data.datasets[0].showColorLabels) {
		        	if(array[n].split(";").length>2){
		        		chart.config.data.datasets[0].pointBackgroundColor.push(pointlabels[array[n].split(";")[2]*1]);
		        	}
		        	else{
		        		chart.config.data.datasets[0].pointBackgroundColor.push('lightgrey');
		        	}
		        }
			}
		}
	}
	if(datafield2 && datafield2.length>0){
		chart.config.data.datasets[1].data = [];
		var array = document.getElementById(datafield2).value.split("|");
		for(n=0;n<array.length;n++){
			if(array[n].length>0){
				var oDate = new Date(array[n].split(";")[0]*1);
				var oValue = array[n].split(";")[1]*1;
				if(yvalue2){
					var newData={
				            x: oDate,
				            y: yvalue2,
				            z: oValue,
				        };
				}
				else{
					var newData={
				            x: oDate,
				            y: oValue,
				        };
				}
				chart.config.data.datasets[1].data.push(newData);
			}
		}
	}
	chart.update();
}

function sort(id){
	var array = document.getElementById(id).value.split("|");
	array.sort();
	document.getElementById(id).value=array.join("|");
}

function getStartDate(){
	var s = document.getElementById('deliverydate').value;
	var startyear = s.substring(6,11);
	var startmonth = s.substring(3,5)*1-1;
	var startday = s.substring(0,2);
	var starthour = document.getElementById('beginHourSelect').value;
	var startminute = document.getElementById('beginMinutSelect').value;
	var startdate = new Date(startyear,startmonth,startday,starthour,startminute);
	return startdate;
}

function drawAmnionGraph(){
	var cannotations = [];
	var ds= [
	        	{
	               	label: '<%=getTranNoLink("web","amniongraph",sWebLanguage)%>',
	         		showLabels: true,
	         		translate: true,
	         		backgroundColor: 'blue',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'triangle',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","headgraph",sWebLanguage)%>',
	         		showLabels: true,
	         		translate: true,
	         		backgroundColor: 'red',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'rect',
	                radius: 5,
	               	data: []
	           	},
   	];
	amnionChart=drawGraph(amnionChart,'diagAmnion','amnionDays,headDays','amnionData,headData',0,2,1,cannotations,ds,1.5,0.5);
}

function drawDrugGraph(){
	var cannotations = [];
	var ds= [
	        	{
	               	label: '<%=getTranNoLink("web","druggraph",sWebLanguage)%>',
	         		showLabels: true,
	         		translate: true,
	         		backgroundColor: 'blue',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'triangle',
	                radius: 5,
	                displayticks: false,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","druggraph",sWebLanguage)%>',
	         		showLabels: true,
	         		translate: true,
	         		backgroundColor: 'red',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'rect',
	                radius: 5,
	                displayticks: false,
	               	data: []
	           	},
   	];
	drugChart=drawGraph(drugChart,'diagDrugs','drugDays1,drugDays2','drugData1,drugData2',0,2,1,cannotations,ds,1.5,0.5);
}

function drawOxyGraph(){
	var cannotations = [];
	var ds= [
	        	{
	               	label: '<%=getTranNoLink("web","oxygraph",sWebLanguage)%>',
	         		showLabels: true,
	         		backgroundColor: 'blue',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'triangle',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","dropgraph",sWebLanguage)%>',
	         		showLabels: true,
	         		backgroundColor: 'red',
	         		fill: false,
	                showLine: false,
	                pointStyle: 'rect',
	                radius: 5,
	               	data: []
	           	},
   	];
	oxyChart=drawGraph(oxyChart,'diagOxytocine','oxyDays,dropDays','oxyData,dropData',0,2,1,cannotations,ds,1.5,0.5);
}

function drawFoetalHeartRythmGraph(){
	var cannotations = [
       {
         type: 'line',
         mode: 'horizontal',
         scaleID: 'y-axis-0',
         value: '100',
         borderColor: 'black',
         borderWidth: 1
     },
     {
         type: 'line',
         mode: 'horizontal',
         scaleID: 'y-axis-0',
         value: '180',
         borderColor: 'black',
         borderWidth: 1
     },
	];
	var ds= [
   	{
       	label: '<%=getTranNoLink("web","foetalheartrythm",sWebLanguage)%>',
       	data: []
   	},
   	];
	fhrChart=drawGraph(fhrChart,'diagFoetalHeartRythm','fhrDays','fhrData',80,200,10,cannotations,ds);
}

function drawHeartrateGraph(){
	var cannotations = [];
	var ds= [
   	{
       	label: '<%=getTranNoLink("web","heartrate",sWebLanguage)%>',
       	data: []
   	},
   	];
	hrChart=drawGraph(hrChart,'diagHeartrate','hrDays','hrData',40,180,10,cannotations,ds);
}

function drawTempGraph(){
	var cannotations = [];
	var ds= [
   	{
       	label: '<%=getTranNoLink("web","temperature",sWebLanguage)%>',
       	data: []
   	},
   	];
	tempChart=drawGraph(tempChart,'diagTemp','tempDays','tempData',35,43,0.5,cannotations,ds);
}

function drawContractionsGraph(){
	var cannotations = [];
	var ds= [
   	{
 		showColorLabels: true,
 		pointBackgroundColor: [],
       	label: '<%=getTranNoLink("web.occup","contractions",sWebLanguage)%>',
       	data: []
   	},
   	];
	contrChart=drawGraph(contrChart,'diagContractions','contrDays','contrData',0,5,1,cannotations,ds);
}

function drawDilatationGraph(){
	var ds= [
	     	{
		     	label: '<%=getTranNoLink("web","Dilatation",sWebLanguage)%>',
		 		borderColor: 'red',
		 		backgroundColor: 'rgba(0,0,0,0)',
		 		fill: false,
		     	data: []
		 	},
	    	{
		     	label: '<%=getTranNoLink("web","Engagement",sWebLanguage)%>',
		 		borderColor: 'blue',
		 		backgroundColor: 'rgba(0,0,0,0)',
		 		fill: false,
		     	data: []
		 	},
		 	{
		 		label: '',
		 		backgroundColor: 'rgba(0,0,0,0)',
		 		borderColor: 'black',
		 		borderWidth: 1,
		 		pointRadius: 0,
		     	data: [{x: getStartDate().getTime(), y: 4},{x: getStartDate().getTime()+6*hour, y: 10}],
		 	},
		 	{
		 		label: '',
		     	backgroundColor: 'rgba(0,0,0,0)',
		 		borderColor: 'black',
		 		borderWidth: 1,
		 		pointRadius: 0,
		     	data: [{x: getStartDate().getTime()+4*hour, y: 4},{x: getStartDate().getTime()+10*hour, y: 10}],
		 	},
	];
	dilChart=drawGraph(dilChart,'diagDilatation','dilDays,engDays','dilData,engData',0,10,1,[],ds);
}

function drawBloodpressureGraph(){
	var ds= [
	     	{
		     	label: '<%=getTranNoLink("web","systolic",sWebLanguage)%>',
		 		borderColor: 'red',
		 		backgroundColor: 'rgba(0,0,0,0)',
		 		fill: false,
		     	data: []
		 	},
	    	{
		     	label: '<%=getTranNoLink("web","diastolic",sWebLanguage)%>',
		 		borderColor: 'blue',
		 		backgroundColor: 'rgba(0,0,0,0)',
		 		fill: false,
		     	data: []
		 	},
	];
	bpChart=drawGraph(bpChart,'diagBP','bpDays,bpDays','sysData,diaData',40,200,10,[],ds);
}



function drawGraph(cChart,canvasid,daysids,dataids,cMin,cMax,cStep,cAnnotations,dataset,yvalue1,yvalue2){
	var startdate = getStartDate();
	var daysid = daysids.split(",");
	for(n=0;n<daysid.length;n++){
		document.getElementById(daysid[n]).innerHTML="<option value='"+startdate.getFullYear()+"."+startdate.getMonth()+"."+startdate.getDate()+"'>"+startdate.toLocaleDateString()+"</option>";
		if(startdate.getHours()>=12){
			var nextdate = new Date(startdate.getTime()+day);
			document.getElementById(daysid[n]).innerHTML+="<option value='"+nextdate.getFullYear()+"."+nextdate.getMonth()+"."+nextdate.getDate()+"'>"+nextdate.toLocaleDateString()+"</option>";
		}
	}
	var ctx=document.getElementById(canvasid).getContext("2d");
	Chart.defaults.global.defaultFontSize=10;
	maxdate=new Date(new Date(startdate.getFullYear(),startdate.getMonth(),startdate.getDate(),startdate.getHours()).getTime()+12*hour);
	mindate=new Date(startdate.getFullYear(),startdate.getMonth(),startdate.getDate(),startdate.getHours());
	maxdate2=new Date(new Date(startdate.getFullYear(),startdate.getMonth(),startdate.getDate()).getTime()+12*hour);
	mindate2=new Date(startdate.getFullYear(),startdate.getMonth(),startdate.getDate());
	Chart.defaults.global.legend.onClick=function(){};
	cChart = new Chart(ctx, {
	    type: 'line',
	    labels: ['0','1','2','3','4','5','6','7','8','9','10','11','12'],
	    data: {
	    	datasets: dataset
	    },
	    options: {	
	        legend: {
	            display: false
	        },
	        scales: {
	        	yAxes: [{
	        		ticks: {
		        		min: cMin,
		        		max: cMax,	
		        		stepSize: cStep,
	        		}
	        	}],
	        	xAxes: [
	    	        	{
	    					type: "time",
	    					display: true,
	    					ticks: {
	    				        autoSkip: true,
	    				        maxTicksLimit: 10
	    				    },
	    					time: {
	    						format: timeFormat,
	    						// round: 'day'
	    						//min: startdate,
	    						//max: new Date(startdate.getTime()+12*hour),
	    						min: mindate,
	    						max: maxdate,
	    						unit: 'hour',
	    						stepSize: 1,
	    				        displayFormats: {
	    				            'millisecond': 'HH',
	    				            'second': 'HH',
	    				            'minute': 'HH',
	    				            'hour': 'HH',
	    				            'day': 'HH',
	    				            'week': 'HH',
	    				            'month': 'HH',
	    				            'quarter': 'HH',
	    				            'year': 'HH',
	    				         }					
	    					},
	    				},
	    	        	{
	    					type: "time",
	    					display: true,
	    					ticks: {
	    				        autoSkip: true,
	    				        maxTicksLimit: 10,
	    				        fontColor: 'lightgray',
	    				    },
	    					time: {
	    						format: timeFormat,
	    						// round: 'day'
	    						min: mindate2,
	    						max: maxdate2,
	    						unit: 'hour',
	    						stepSize: 1,
	    				        displayFormats: {
	    				            'millisecond': 'H',
	    				            'second': 'H',
	    				            'minute': 'H',
	    				            'hour': 'H',
	    				            'day': 'H',
	    				            'week': 'H',
	    				            'month': 'H',
	    				            'quarter': 'H',
	    				            'year': 'H',
	    				         }					
	    					},
	    				},
				],
	        },
		      annotation: {
		          annotations: cAnnotations,
		          drawTime: "afterDraw" // (default)
		      },
	    },
	});
	
    document.getElementById(canvasid).onclick = function(evt) {
		var activePoint = cChart.getElementAtEvent(evt)[0];
		if(activePoint && window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
	 	   var data = activePoint._chart.data;
	 	   var datasetIndex = activePoint._datasetIndex;
	 	   var value = data.datasets[datasetIndex].data[activePoint._index];
	 	   data.datasets[datasetIndex].data.splice(activePoint._index,1);
	 	   cChart.update();
	 	   var dataid = dataids.split(",");
	 	   removeMeasurement(dataid[datasetIndex],activePoint._index);
		}
	};
	if(dataids.split(',').length==1){
		updateChart(cChart,dataids.split(',')[0],'',yvalue1,yvalue2);
	}
	else{
		updateChart(cChart,dataids.split(',')[0],dataids.split(',')[1],yvalue1,yvalue2);
	}
	return cChart;
}

if(document.getElementById('type_r2').checked){
	document.getElementById('trtype2').style.display='';
}
else{
	document.getElementById('trtype2').style.display='none';
}
if(document.getElementById('type_r3').checked){
	document.getElementById('trtype3').style.display='';
}
else{
	document.getElementById('trtype3').style.display='none';
}


setTimes();
//window.setInterval("setTimes();",60000);

</script>