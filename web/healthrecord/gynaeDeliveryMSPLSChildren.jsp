<%@include file="/includes/validateUser.jsp" %>
<%@page errorPage="/includes/error.jsp" %>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
        <%-- ####################################### ENFANT 1 ###################################--%>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"openclinic.chuk", "child", sWebLanguage)%> 1
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE" property="value"/>" id="reanimationdate" OnBlur='checkDate(this);'>
                <script>writeMyDate("reanimationdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                <%=getTran(request,"openclinic.chuk", "delivery.hour", sWebLanguage)%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_HOUR")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_HOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_HOUR" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "intubation_usi", sWebLanguage)%>
            </td>
            <td class="admin2">
                <%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_DATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_DATE" property="value"/>" id="reanimationintubationdate" OnBlur='checkDate(this);'>
                <script>writeMyDate("reanimationintubationdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                <%=getTran(request,"openclinic.chuk", "delivery.hour", sWebLanguage)%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "adrenaline", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE" property="value"/>" onblur="isNumber(this)">
                <%=getTran(request,"web", "prescriptionrule", sWebLanguage)%>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "destination.new.baby", sWebLanguage)%>
            </td>
            <td class="admin2">
                <select <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION")%> id="EditReanimationDestination" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION" property="itemId"/>]>.value" class="text">
                    <option/>
                    <%=ScreenHelper.writeSelect(request,"delivery.reanimation.destination", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION"), sWebLanguage)%>
                </select>
            </td>
        </tr>
        <%-- gender / weight --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "gender", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_GENDER")%> type="radio" onDblClick="uncheckRadio(this);" id="gender_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER" property="itemId"/>]>.value" value="male"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER;value=male"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web.occup", "male", sWebLanguage, "gender_r1")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_GENDER")%> type="radio" onDblClick="uncheckRadio(this);" id="gender_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER" property="itemId"/>]>.value" value="female"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER;value=female"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web.occup", "female", sWebLanguage, "gender_r2")%>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "weight", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDWEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDWEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDWEIGHT" property="value"/>" onblur="isNumber(this)"> g
            </td>
        </tr>
        <%-- height / cranien --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "height", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDHEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDHEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDHEIGHT" property="value"/>" onblur="isNumber(this)"> cm
            </td>
            <td class="admin"><%=getTran(request,"gynaeco", "cranien", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDCRANIEN")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDCRANIEN" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDCRANIEN" property="value"/>" onblur="isNumber(this)"> cm
            </td>
        </tr>
        <tr>
            <td class="admin"/>
            <td class="admin2"/>
            <td class="admin"><%=getTran(request,"gynaeco", "HBVvaccinated24h", sWebLanguage)%>
            </td>
            <td class="admin2">
            	<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_DELIVERY_HBVVACCINATED", "") %>
            </td>
        </tr>
        <tr>
            <td class="admin"/>
            <td colspan="3" bgcolor="#EBF3F7">
                <table width="100%" cellspacing="1" bgcolor="white">
                    <%-- BORN DEAD -------------------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input onclick="doAlive()" type="radio" onDblClick="uncheckRadio(this);document.getElementById('tralive1').style.display='none'" id="alive_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE" property="itemId"/>]>.value" value="openclinic.common.borndead"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE;value=openclinic.common.borndead"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"openclinic.chuk", "openclinic.common.borndead", sWebLanguage, "alive_r1")%>
                        </td>
                    </tr>
                    <%-- death type --%>
                    <tr id="tralive1">
                        <td width="90" class="admin2"/>
                        <td class="admin2">
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DEAD_TYPE")%> type="radio" onDblClick="uncheckRadio(this);" id="deadtype_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE" property="itemId"/>]>.value" value="gynaeco.dead_type_frais"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE;value=gynaeco.dead_type_frais"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"gynaeco.deadtype", "frais", sWebLanguage, "deadtype_r1")%>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DEAD_TYPE")%> type="radio" onDblClick="uncheckRadio(this);" id="deadtype_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE" property="itemId"/>]>.value" value="gynaeco.dead_type_macere"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE;value=gynaeco.dead_type_macere"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"gynaeco.deadtype", "macere", sWebLanguage, "deadtype_r2")%>
                        </td>
                    </tr>
                    <%-- BORN ALIVE -------------------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input onclick="doAlive()" type="radio" onDblClick="uncheckRadio(this);document.getElementById('tralive2').style.display='none';" id="alive_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE" property="itemId"/>]>.value" value="openclinic.common.bornalive"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE;value=openclinic.common.bornalive"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"openclinic.chuk", "openclinic.common.bornalive", sWebLanguage, "alive_r2")%>
                        </td>
                    </tr>
                    <tr id="tralive2">
                        <td class="admin2" width="90"/>
                        <td bgcolor="#EBF3F7">
                            <table bgcolor="white" cellspacing="1">
                                <tr>
                                    <td class="admin2" colspan="3">
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_DEADIN24H")%> type="checkbox" id="cbdead24h" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_DEADIN24H" property="itemId"/>]>.value"
                                                <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_DEADIN24H;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
                                        <%=getLabel(request,"openclinic.chuk", "dead.in.24h", sWebLanguage, "cbdead24h")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="9" class="admin2">
                                    	<table width='100%'>
                                    		<tr>
                                    			<td>
			                                        <table class="list" cellspacing="1" width='100%'>
			                                            <%-- apgar header --%>
			                                            <tr class="gray">
			                                                <td width="50"><%=getTran(request,"gynaeco", "apgar", sWebLanguage)%>
			                                                </td>
			                                                <td width="50" align="center">1'</td>
			                                                <td width="50" align="center">5'</td>
			                                                <td width="50" align="center">10'</td>
			                                            </tr>
			                                            <%-- apgar.coeur --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.coeur", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_1" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_1;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_1;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_1;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_5" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_5;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_5;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_5;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_10" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_10;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_10;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_10;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.resp --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.resp", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_1" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_1;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_1;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_1;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_5" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_5;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_5;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_5;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_10" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_10;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_10;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_10;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.tonus --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.tonus", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_1" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_1;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_1;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_1;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_5" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_5;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_5;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_5;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_10" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_10;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_10;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_10;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.refl --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.refl", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_1" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_1;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_1;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_1;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_5" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_5;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_5;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_5;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_10" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_10;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_10;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_10;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.color --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.color", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_1" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_1;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_1;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_1;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_5" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_5;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_5;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_5;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_10" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_10;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_10;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_10;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.total --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.total", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <input id="total1" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_1")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_1" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                                <td>
			                                                    <input id="total5" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_5")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_5" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_5" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                                <td>
			                                                    <input id="total10" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_10")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_10" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_10" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                            </tr>
			                                        </table>
			                                    </td>
			                                </tr>
			                                <tr>
			                                	<td>
			                                		<table class='list' width='100%'>
			                                			<tr class='gray'>
			                                				<td colspan='7'><%=getTran(request,"web","surveillance",sWebLanguage) %> 24h</td>
			                                			</tr>
			                                			<tr class='gray'>
			                                				<td/>
			                                				<td>30min</td>
			                                				<td>1h</td>
			                                				<td>2h</td>
			                                				<td>6h</td>
			                                				<td>12h</td>
			                                				<td>24h</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","respiration",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_RESPIRATORY24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","pulse",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_PULSE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","temperature",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_TEMPERATURE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","umbilicus",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_UMBILICUS24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","congenitalmalformation",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_MALFORMATION24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","urine",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_URINE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","stool",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_STOOL24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","breastfeed",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_BREASTFEED24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","jaundice",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD1_SURVEILLANCE_JAUNDICE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                		</table>
			                                	</td>
			                                </tr>
			                            </table>
                                    </td>
                                    <%-- reanimation --%>
                                    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"openclinic.chuk", "reanimation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="reanimation" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_REANIMATION")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_REANIMATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_REANIMATION" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- malformation --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "malformation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="malformation" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_MALFORMATION")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_MALFORMATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_MALFORMATION" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- observation --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "observation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="observation" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_OBSERVATION")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_OBSERVATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_OBSERVATION" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- treatment --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "treatment", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="treatment" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_TREATMENT")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_TREATMENT" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- prophylaxis ARV --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "prophylaxis.ARV", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
						                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_PROPHYLAXISARV" property="itemId"/>]>.value" value="medwan.common.true"
						                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
						                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_PROPHYLAXISARV;value=medwan.common.true"
						                                           property="value"
						                                           outputString="checked"/>>
                                    </td>
                                </tr>
                                <%-- polio.date --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "polio.date", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input id="polio_date" type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N  name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDPOLIO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDPOLIO" property="value" formatType="date"/>">
                                        <script>writeMyDate("polio_date", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                                    </td>
                                </tr>
                                <%-- bcg.date --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "bcg.date", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input id="bcg_date" type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N  name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDBCG" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDBCG" property="value" formatType="date"/>">
                                        <script>writeMyDate("bcg_date", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                                    </td>
                                </tr>
                                <%-- lastname --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"web", "lastname", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input type="text" class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME" property="value"/>">
                                    </td>
                                </tr>
                                <%-- firstname --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"web", "firstname", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input type="text" class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_FIRSTNAME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_FIRSTNAME" property="value"/>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%-- ####################################### ENFANT 2 ###################################--%>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"openclinic.chuk", "child", sWebLanguage)%> 2
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE2" property="value"/>" id="reanimationdate2" OnBlur='checkDate(this);'>
                <script>writeMyDate("reanimationdate2", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                <%=getTran(request,"openclinic.chuk", "delivery.hour", sWebLanguage)%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_HOUR2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_HOUR2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_HOUR2" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "intubation_usi", sWebLanguage)%>
            </td>
            <td class="admin2">
                <%=getTran(request,"Web.Occup", "medwan.common.date", sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_DATE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_DATE2" property="value"/>" id="reanimationintubationdate2" OnBlur='checkDate(this);'>
                <script>writeMyDate("reanimationintubationdate2", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                <%=getTran(request,"openclinic.chuk", "delivery.hour", sWebLanguage)%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_INTUBATION_HOUR2" property="value"/>" onblur="checkTime(this)" onkeypress="keypressTime(this)">
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "adrenaline", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_ADRENALINE2" property="value"/>" onblur="isNumber(this)">
                <%=getTran(request,"web", "prescriptionrule", sWebLanguage)%>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "destination.new.baby", sWebLanguage)%>
            </td>
            <td class="admin2">
                <select <%=setRightClick(session,"ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION2")%> id="EditReanimationDestination" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION2" property="itemId"/>]>.value" class="text">
                    <option/>
                    <%=ScreenHelper.writeSelect(request,"delivery.reanimation.destination", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION2"), sWebLanguage)%>
                </select>
            </td>
        </tr>
        <%-- gender / weight --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "gender", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_GENDER2")%> type="radio" onDblClick="uncheckRadio(this);" id="gender2_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER2" property="itemId"/>]>.value" value="male"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER2;value=male"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web.occup", "male", sWebLanguage, "gender2_r1")%>
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_GENDER2")%> type="radio" onDblClick="uncheckRadio(this);" id="gender2_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER2" property="itemId"/>]>.value" value="female"
                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER2;value=female"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web.occup", "female", sWebLanguage, "gender2_r2")%>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "weight", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDWEIGHT2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDWEIGHT2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDWEIGHT2" property="value"/>" onblur="isNumber(this)"> g
            </td>
        </tr>
        <%-- height / cranien --%>
        <tr>
            <td class="admin"><%=getTran(request,"gynaeco", "height", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDHEIGHT2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDHEIGHT2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDHEIGHT2" property="value"/>" onblur="isNumber(this)"> cm
            </td>
            <td class="admin"><%=getTran(request,"gynaeco", "cranien", sWebLanguage)%>
            </td>
            <td class="admin2">
                <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILDCRANIEN2")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDCRANIEN2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDCRANIEN2" property="value"/>" onblur="isNumber(this)"> cm
            </td>
        </tr>
        <tr>
            <td class="admin"/>
            <td class="admin2"/>
            <td class="admin"><%=getTran(request,"gynaeco", "HBVvaccinated24h", sWebLanguage)%>
            </td>
            <td class="admin2">
            	<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_DELIVERY_HBVVACCINATED2", "") %>
            </td>
        </tr>
        <tr>
            <td class="admin"/>
            <td colspan="3" bgcolor="#EBF3F7">
                <table width="100%" cellspacing="1" bgcolor="white">
                    <%-- BORN DEAD -------------------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input onclick="doAlive()" type="radio" onDblClick="uncheckRadio(this);document.getElementById('tralive1-2').style.display='none'" id="alive_r1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE2" property="itemId"/>]>.value" value="openclinic.common.borndead"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE2;value=openclinic.common.borndead"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"openclinic.chuk", "openclinic.common.borndead", sWebLanguage, "alive_r1-2")%>
                        </td>
                    </tr>
                    <%-- death type --%>
                    <tr id="tralive1-2">
                        <td width="90" class="admin2"/>
                        <td class="admin2">
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DEAD_TYPE2")%> type="radio" onDblClick="uncheckRadio(this);" id="deadtype_r1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE2" property="itemId"/>]>.value" value="gynaeco.dead_type_frais"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE2;value=gynaeco.dead_type_frais"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"gynaeco.deadtype", "frais", sWebLanguage, "deadtype_r1-2")%>
                            <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DEAD_TYPE2")%> type="radio" onDblClick="uncheckRadio(this);" id="deadtype_r2-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE2" property="itemId"/>]>.value" value="gynaeco.dead_type_macere"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEAD_TYPE2;value=gynaeco.dead_type_macere"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"gynaeco.deadtype", "macere", sWebLanguage, "deadtype_r2-2")%>
                        </td>
                    </tr>
                    <%-- BORN ALIVE -------------------------------------------------------------%>
                    <tr>
                        <td colspan="2" class="admin2">
                            <input onclick="doAlive()" type="radio" onDblClick="uncheckRadio(this);document.getElementById('tralive2-2').style.display='none';" id="alive_r2-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE2" property="itemId"/>]>.value" value="openclinic.common.bornalive"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE2;value=openclinic.common.bornalive"
                                                      property="value"
                                                      outputString="checked"/>><%=getLabel(request,"openclinic.chuk", "openclinic.common.bornalive", sWebLanguage, "alive_r2-2")%>
                        </td>
                    </tr>
                    <tr id="tralive2-2">
                        <td class="admin2" width="90"/>
                        <td bgcolor="#EBF3F7">
                            <table bgcolor="white" cellspacing="1">
                                <tr>
                                    <td class="admin2" colspan="3">
                                        <input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_DEADIN24H2")%> type="checkbox" id="cbdead24h2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_DEADIN24H2" property="itemId"/>]>.value"
                                                <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_DEADIN24H2;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
                                        <%=getLabel(request,"openclinic.chuk", "dead.in.24h", sWebLanguage, "cbdead24h")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="9" class="admin2">
                                    	<table width='100%'>
                                    		<tr>
                                    			<td>
			                                        <table class="list" cellspacing="1" width='100%'>
			                                            <%-- apgar header --%>
			                                            <tr class="gray">
			                                                <td width="50"><%=getTran(request,"gynaeco", "apgar", sWebLanguage)%>
			                                                </td>
			                                                <td width="50" align="center">1'</td>
			                                                <td width="50" align="center">5'</td>
			                                                <td width="50" align="center">10'</td>
			                                            </tr>
			                                            <%-- apgar.coeur --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.coeur", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_12" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_12;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_12;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_12;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur5-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_52" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_52;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_52;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_52;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="coeur10-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_102" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_102;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_102;value=1" property="value" outputString="selected"/>>&lt;100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COEUR_102;value=2" property="value" outputString="selected"/>>&gt;=100 <%=getTran(request,"web","bpm",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.resp --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.resp", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_12" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_12;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_12;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_12;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp5-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_52" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_52;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_52;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_52;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="resp10-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_102" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_102;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_102;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","slow_irregular",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_RESP_102;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","good_crying",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.tonus --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.tonus", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_12" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_12;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_12;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_12;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus5-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_52" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_52;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_52;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_52;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="tonus10-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_102" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_102;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_102;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","arms_legs_bown",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TONUS_102;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","active",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.refl --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.refl", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_12" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_12;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_12;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_12;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl5-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_52" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_52;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_52;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_52;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="refl10-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_102" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_102;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","absent",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_102;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","grimace",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_REFL_102;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","sneezing_coughing",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.color --%>
			                                            <tr class="list">
			                                                <td><%=getTran(request,"gynaeco", "apgar.color", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color1-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_12" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_12;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_12;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_12;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color5-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_52" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_52;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_52;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_52;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                                <td>
			                                                    <select class="text" id="color10-2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_102" property="itemId"/>]>.value" onclick="calculateapgar();">
			                                                        <option value="-1"></option>
			                                                        <option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_102;value=0" property="value" outputString="selected"/>><%=getTran(request,"web","blue_gray_white",sWebLanguage)%></option>
			                                                        <option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_102;value=1" property="value" outputString="selected"/>><%=getTran(request,"web","normal_except_extremities",sWebLanguage)%></option>
			                                                        <option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_COLOR_102;value=2" property="value" outputString="selected"/>><%=getTran(request,"web","normal_whole_body",sWebLanguage)%></option>
			                                                    </select>
			                                                </td>
			                                            </tr>
			                                            <%-- apgar.total --%>
			                                            <tr class="list1">
			                                                <td><%=getTran(request,"gynaeco", "apgar.total", sWebLanguage)%>
			                                                </td>
			                                                <td>
			                                                    <input id="total1-2" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_12")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_12" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                                <td>
			                                                    <input id="total5-2" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_52")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_52" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_52" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                                <td>
			                                                    <input id="total10-2" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_APGAR_TOTAL_102")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_102" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_102" property="value"/>" onblur="isNumber(this)">
			                                                </td>
			                                            </tr>
			                                        </table>
			                                    </td>
			                                </tr>
			                                <tr>
			                                	<td>
			                                		<table class='list' width='100%'>
			                                			<tr class='gray'>
			                                				<td colspan='7'><%=getTran(request,"web","surveillance",sWebLanguage) %> 24h</td>
			                                			</tr>
			                                			<tr class='gray'>
			                                				<td/>
			                                				<td>30min</td>
			                                				<td>1h</td>
			                                				<td>2h</td>
			                                				<td>6h</td>
			                                				<td>12h</td>
			                                				<td>24h</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","respiration",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_RESPIRATORY24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","pulse",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_PULSE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","temperature",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_TEMPERATURE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","umbilicus",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_UMBILICUS24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","congenitalmalformation",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_MALFORMATION24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","urine",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_URINE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","stool",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_STOOL24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list1'>
			                                				<td><%=getTran(request,"web","breastfeed",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_BREASTFEED24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                			<tr class='list'>
			                                				<td><%=getTran(request,"web","jaundice",sWebLanguage) %></td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE30" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE1" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE2" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE6" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE12" property="value"/>">
			                                				</td>
			                                				<td>
												                <input type="text" class="text" size="5" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD2_SURVEILLANCE_JAUNDICE24" property="value"/>">
			                                				</td>
			                                			</tr>
			                                		</table>
			                                	</td>
			                                </tr>
			                            </table>
                                    </td>
                                    <%-- reanimation --%>
                                    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"openclinic.chuk", "reanimation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="reanimation2" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_REANIMATION2")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_REANIMATION2" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_REANIMATION2" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- malformation --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "malformation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="malformation2" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_MALFORMATION2")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_MALFORMATION2" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_MALFORMATION2" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- observation --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "observation", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="observation2" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_OBSERVATION2")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_OBSERVATION2" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_OBSERVATION2" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- treatment --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "treatment", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <textarea id="treatment2" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_CHILD_TREATMENT2")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_TREATMENT2" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_TREATMENT2" property="value"/></textarea>
                                    </td>
                                </tr>
                                <%-- prophylaxis ARV --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "prophylaxis.ARV", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
						                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_PROPHYLAXISARV2" property="itemId"/>]>.value" value="medwan.common.true"
						                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
						                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_PROPHYLAXISARV2;value=medwan.common.true"
						                                           property="value"
						                                           outputString="checked"/>>
                                    </td>
                                </tr>
                                <%-- polio.date --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "polio.date", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input id="polio_date2" type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N  name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDPOLIO2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDPOLIO2" property="value" formatType="date"/>">
                                        <script>writeMyDate("polio_date", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                                    </td>
                                </tr>
                                <%-- bcg.date --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"openclinic.chuk", "bcg.date", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input id="bcg_date2" type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N  name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDBCG2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDBCG2" property="value" formatType="date"/>">
                                        <script>writeMyDate("bcg_date", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
                                    </td>
                                </tr>
                                <%-- lastname --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"web", "lastname", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input type="text" class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME2" property="value"/>">
                                    </td>
                                </tr>
                                <%-- firstname --%>
                                <tr>
                                    <td class="admin"><%=getTran(request,"web", "firstname", sWebLanguage)%>
                                    </td>
                                    <td class="admin2">
                                        <input type="text" class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_FIRSTNAME2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_FIRSTNAME2" property="value"/>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
