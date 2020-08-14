<%@include file="/includes/validateUser.jsp" %>
<%@page errorPage="/includes/error.jsp" %>
<%=checkPermission(out,"occup.delivery", "select", activeUser)%><%=sJSDIAGRAM%>
<%!
    private String convertTimeToNbForGraph(String s){
        if(s.equals("15")){
            s = "25";
        } else if(s.equals("30")){
            s = "50";
        } else if(s.equals("45")){
            s = "75";
        }

        return s;
    }
    private StringBuffer addDilatation(int iTotal, String sHour, String sMinutes, String sOpening, String sWebLanguage){
        StringBuffer sTmp = new StringBuffer();
        sTmp.append(
                "<tr id='rowDilatation" + iTotal + "'>" +
                        "<td class='admin2'>" +
                        " <a href='javascript:deleteDilatation(rowDilatation" + iTotal + "," + sHour + convertTimeToNbForGraph(sMinutes) + ")'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' alt='" + getTran(null,"Web.Occup", "medwan.common.delete", sWebLanguage) + "' border='0'></a> " +
                        "</td>" +
                        "<td class='admin2'>&nbsp;" + sHour + ":" + sMinutes + "</td>" +
                        "<td class='admin2'>&nbsp;" + sOpening + "</td>" +
                        "<td class='admin2'><script>setNewDilatation(" + sHour + convertTimeToNbForGraph(sMinutes) + "," + sOpening + ");</script></td>" +
                        "</tr>"
        );
        return sTmp;
    }
    private StringBuffer addEngagement(int iTotal, String sHour, String sMinutes, String sGrade, String sWebLanguage){
        StringBuffer sTmp = new StringBuffer();
        sTmp.append(
                "<tr id='rowEngagement" + iTotal + "'>" +
                        "<td class='admin2'>" +
                        " <a href='javascript:deleteEngagement(rowEngagement" + iTotal + "," + sHour + convertTimeToNbForGraph(sMinutes) + ")'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' alt='" + getTran(null,"Web.Occup", "medwan.common.delete", sWebLanguage) + "' border='0'></a> " +
                        "</td>" +
                        "<td class='admin2'>&nbsp;" + sHour + ":" + sMinutes + "</td>" +
                        "<td class='admin2'>&nbsp;" + sGrade + "</td>" +
                        "<td class='admin2'><script>setNewEngagement(" + sHour + convertTimeToNbForGraph(sMinutes) + "," + sGrade + ");</script></td>" +
                        "</tr>"
        );
        return sTmp;
    }
    private StringBuffer addAction(int iTotal, String sHour, String sMinutes, String sLetter, String sWebLanguage){
        StringBuffer sTmp = new StringBuffer();
        sTmp.append(
                "<tr id='rowAction" + iTotal + "'>" +
                        "<td class='admin2'>" +
                        " <a href='javascript:deleteAction(rowAction" + iTotal + ",\"" + sHour + sMinutes + sLetter + "\")'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' alt='" + getTran(null,"Web.Occup", "medwan.common.delete", sWebLanguage) + "' border='0'></a> " +
                        "</td>" +
                        "<td class='admin2'>&nbsp;" + sHour + ":" + sMinutes + "</td>" +
                        "<td class='admin2'>&nbsp;" + sLetter + "</td>" +
                        "<td class='admin2'><script>graphAction.set('" + sHour + sMinutes + sLetter + "'" + ",'" + sLetter + "');</script></td>" +
                        "</tr>"
        );
        return sTmp;
    }
%>
<%
	try{
%>
	
<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <%=writeHistoryFunctions(((TransactionVO) transaction).getTransactionType(), sWebLanguage)%><%=contextHeader(request, sWebLanguage)%>
    <%

    StringBuffer sDilatation = new StringBuffer(),
    sDivDilatation = new StringBuffer();
    int iDilatationTotal = 1;
    TransactionVO tran = (TransactionVO) transaction;
    sDilatation.append(getItemType(tran.getItems(), sPREFIX + "ITEM_TYPE_DELIVERY_WORK_DILATATION"));
    if(sDilatation.indexOf("£") > -1){
        StringBuffer sTmpDilatation = sDilatation;
        String sTmpHour, sTmpOpening, sTmpMinutes;
        sDilatation = new StringBuffer();

        while (sTmpDilatation.toString().toLowerCase().indexOf("$") > -1){
            sTmpHour = "";
            sTmpOpening = "";
            sTmpMinutes = "";
            if(sTmpDilatation.toString().toLowerCase().indexOf("£") > -1){
                sTmpHour = sTmpDilatation.substring(0, sTmpDilatation.toString().toLowerCase().indexOf("£"));
                sTmpDilatation = new StringBuffer(sTmpDilatation.substring(sTmpDilatation.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpDilatation.toString().toLowerCase().indexOf("£") > -1){
                sTmpMinutes = sTmpDilatation.substring(0, sTmpDilatation.toString().toLowerCase().indexOf("£"));
                sTmpDilatation = new StringBuffer(sTmpDilatation.substring(sTmpDilatation.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpDilatation.toString().toLowerCase().indexOf("$") > -1){
                sTmpOpening = sTmpDilatation.substring(0, sTmpDilatation.toString().toLowerCase().indexOf("$"));
                sTmpDilatation = new StringBuffer(sTmpDilatation.substring(sTmpDilatation.toString().toLowerCase().indexOf("$") + 1));
            }
            sDilatation.append("rowDilatation" + iDilatationTotal + "=" + sTmpHour + "£" + sTmpMinutes + "£" + sTmpOpening + "$");
            sDivDilatation.append(addDilatation(iDilatationTotal, sTmpHour, sTmpMinutes, sTmpOpening, sWebLanguage));
            iDilatationTotal++;
        }
    }
    StringBuffer sEngagement = new StringBuffer(),
            sDivEngagement = new StringBuffer();
    int iEngagementTotal = 1;
    sEngagement.append(getItemType(tran.getItems(), sPREFIX + "ITEM_TYPE_DELIVERY_WORK_ENGAGEMENT"));
    if(sEngagement.indexOf("£") > -1){
        StringBuffer sTmpEngagement = sEngagement;
        String sTmpHour, sTmpGrade, sTmpMinutes;
        sEngagement = new StringBuffer();
        while (sTmpEngagement.toString().toLowerCase().indexOf("$") > -1){
            sTmpHour = "";
            sTmpGrade = "";
            sTmpMinutes = "";
            if(sTmpEngagement.toString().toLowerCase().indexOf("£") > -1){
                sTmpHour = sTmpEngagement.substring(0, sTmpEngagement.toString().toLowerCase().indexOf("£"));
                sTmpEngagement = new StringBuffer(sTmpEngagement.substring(sTmpEngagement.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpEngagement.toString().toLowerCase().indexOf("£") > -1){
                sTmpMinutes = sTmpEngagement.substring(0, sTmpEngagement.toString().toLowerCase().indexOf("£"));
                sTmpEngagement = new StringBuffer(sTmpEngagement.substring(sTmpEngagement.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpEngagement.toString().toLowerCase().indexOf("$") > -1){
                sTmpGrade = sTmpEngagement.substring(0, sTmpEngagement.toString().toLowerCase().indexOf("$"));
                sTmpEngagement = new StringBuffer(sTmpEngagement.substring(sTmpEngagement.toString().toLowerCase().indexOf("$") + 1));
            }
            sEngagement.append("rowEngagement" + iEngagementTotal + "=" + sTmpHour + "£" + sTmpMinutes + "£" + sTmpGrade + "$");
            sDivEngagement.append(addEngagement(iEngagementTotal, sTmpHour, sTmpMinutes, sTmpGrade, sWebLanguage));
            iEngagementTotal++;
        }
    }
    StringBuffer sAction = new StringBuffer(),
            sDivAction = new StringBuffer();
    int iActionTotal = 1;
    sAction.append(getItemType(tran.getItems(), sPREFIX + "ITEM_TYPE_DELIVERY_WORK_ACTION"));
    if(sAction.indexOf("£") > -1){
        StringBuffer sTmpAction = sAction;
        String sTmpHour, sTmpLetter, sTmpMinutes;
        sAction = new StringBuffer();
        while (sTmpAction.toString().toLowerCase().indexOf("$") > -1){
            sTmpHour = "";
            sTmpLetter = "";
            sTmpMinutes = "";
            if(sTmpAction.toString().toLowerCase().indexOf("£") > -1){
                sTmpHour = sTmpAction.substring(0, sTmpAction.toString().toLowerCase().indexOf("£"));
                sTmpAction = new StringBuffer(sTmpAction.substring(sTmpAction.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpAction.toString().toLowerCase().indexOf("£") > -1){
                sTmpMinutes = sTmpAction.substring(0, sTmpAction.toString().toLowerCase().indexOf("£"));
                sTmpAction = new StringBuffer(sTmpAction.substring(sTmpAction.toString().toLowerCase().indexOf("£") + 1));
            }
            if(sTmpAction.toString().toLowerCase().indexOf("$") > -1){
                sTmpLetter = sTmpAction.substring(0, sTmpAction.toString().toLowerCase().indexOf("$"));
                sTmpAction = new StringBuffer(sTmpAction.substring(sTmpAction.toString().toLowerCase().indexOf("$") + 1));
            }
            sAction.append("rowAction" + iActionTotal + "=" + sTmpHour + "£" + sTmpMinutes + "£" + sTmpLetter + "$");
            sDivAction.append(addAction(iActionTotal, sTmpHour, sTmpMinutes, sTmpLetter, sWebLanguage));
            iActionTotal++;
        }
    }%>
    <table class="list" width="100%" cellspacing="1">
	    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/gynaeDeliveryMSPLSWork.jsp"),pageContext);%>
        <%-- #################################### work travail #################################--%>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"gynaeco", "work", sWebLanguage)%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "graphs", sWebLanguage)%>
            </td>
            <td class="admin2" colspan="3">
                <div id="glycemyGraph" style="position:relative; left:0px; top:20px; height:420px" style="display:block;"></div>
            </td>
        </tr>

        <tr>
            <td class="admin"><%=getTran(request,"gynae", "dilatation.opening", sWebLanguage)%>
            </td>
            <td class="admin2" style="vertical-align:top;">
                <table cellspacing="1" cellpadding="0" width="100%" id="tblDilatation">
                    <%-- header --%>
                    <tr>
                        <td class="admin" width="40px"/>
                        <td class="admin" width="100px"><%=getTran(request,"web.occup", "medwan.common.hour", sWebLanguage)%>
                        </td>
                        <td class="admin" width="50px"><%=getTran(request,"gynae", "dilatation.opening", sWebLanguage)%>
                        </td>
                        <td class="admin" width="*"/>
                    </tr>
                    <%-- ADD-ROW --%>
                    <tr>
                        <td class="admin2"/>
                        <td class="admin2">
                            <select class="text" id="dilatationHour" name="dilatationHour">
                                <option/>
                                <%for(int i = 0; i < 24; i++){%>
                                <option value="<%=i%>"><%=i%>
                                </option>
                                <%}%>
                            </select> : <select class="text" id="dilatationMinutes" name="dilatationMinutes">
                            <option value="00" selected="selected">00</option>
                            <option value="15">15</option>
                            <option value="30">30</option>
                            <option value="45">45</option>
                        </select>
                        </td>
                        <td class="admin2" style="vertical-align:top;">
                            <select class="text" name="dilatationOpening">
                                <option/>
                                <%for(int i = 0; i < 11; i++){%>
                                <option value="<%=i%>"><%=i%>
                                </option>
                                <%}%>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="button" class="button" name="ButtonAddDilatation" value="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addDilatation();">
                        </td>
                    </tr>
                    <%-- hidden fields --%>
                    <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_DILATATION" property="itemId"/>]>.value">
                    <script>
                        //--------------- declare arrays-----------------//

                        var graphDilatation = new Hash();
                        var graphEngagement = new Hash();
                        var graphAction = new Hash();
                        var graphDilatationObjects = new Array();
                        var graphEngagementObjects = new Array();
                        var graphActionObjects = new Array();
                        var earlierBackupTime;
                        var barTop;
                        function setNewEngagement(key, value){
                            if(!graphEngagement.get(key))graphEngagement.set(key, value);
                        }
                        function setNewDilatation(key, value){
                            if(!graphDilatation.get(key))graphDilatation.set(key, value);
                        }
                        function getEarlierTime(){
                            var time = ($("beginHourSelect").value) + convertTimeToNbForGraph($("beginMinutSelect").value);
                            if(earlierBackupTime != time){
                                earlierBackupTime = time;
                                setTopUnits();
                            }
                            return time;
                        }
                        function compare(date_1, date_2){
                            //   0 if date_1=date_2
                            //   1 if date_1>date_2
                            //  -1 if date_1<date_2
                            diff = date_1.getTime() - date_2.getTime();
                            return (diff == 0 ? diff : diff / Math.abs(diff));
                        }
                    </script>
                    <%=sDivDilatation%>
                </table>
            </td>
            <td class="admin"><%=getTran(request,"gynaeco", "work.engagement", sWebLanguage)%>
            </td>
            <td class="admin2" style="vertical-align:top;">
                <table cellspacing="1" cellpadding="0" width="100%" id="tblEngagement">
                    <%-- header --%>
                    <tr>
                        <td class="admin" width="40px"/>
                        <td class="admin" width="100px"><%=getTran(request,"web.occup", "medwan.common.hour", sWebLanguage)%>
                        </td>
                        <td class="admin" width="50px"><%=getTran(request,"gynae", "engagement.degree", sWebLanguage)%>
                        </td>
                        <td class="admin" width="*"/>
                    </tr>
                    <%-- ADD-ROW --%>
                    <tr>
                        <td class="admin2"/>
                        <td class="admin2">
                            <select class="text" id="engagementHour" name="engagementHour">
                                <option/>
                                <%for(int i = 0; i < 24; i++){%>
                                <option value="<%=i%>"><%=i%>
                                </option>
                                <%}%>
                            </select> : <select class="text" id="engagementMinutes" name="engagementMinutes">
                            <option value="00" selected="selected">00</option>
                            <option value="15">15</option>
                            <option value="30">30</option>
                            <option value="45">45</option>
                        </select>
                        </td>
                        <td class="admin2" style="vertical-align:top;">
                            <select class="text" id="engagementDegree" name="engagementDegree">
                                <option/>
                                <%for(int i = -4; i < 5; i++){%>
                                <option value="<%=i%>"><%=i%>
                                </option>
                                <%}%>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="button" class="button" name="ButtonAddEngagement" value="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addEngagement();">
                        </td>
                    </tr>
                    <%-- hidden fields --%>
                    <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_ENGAGEMENT" property="itemId"/>]>.value">
                    <%=sDivEngagement%>
                </table>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"gynae", "action", sWebLanguage)%>
            </td>
            <td class="admin2">
                <table cellspacing="1" cellpadding="0" width="100%" id="tblAction">
                    <%-- header --%>
                    <tr>
                        <td class="admin" width="40px"/>
                        <td class="admin" width="100px"><%=getTran(request,"web.occup", "medwan.common.hour", sWebLanguage)%>
                        </td>
                        <td class="admin" width="50px"><%=getTran(request,"gynae", "action", sWebLanguage)%>
                        </td>
                        <td class="admin" width="*"/>
                    </tr>
                    <%-- ADD-ROW --%>
                    <tr>
                        <td class="admin2"/>
                        <td class="admin2">
                            <select class="text" id="actionHour" name="actionHour">
                                <option/>
                                <%for(int i = 0; i < 24; i++){%>
                                <option value="<%=i%>"><%=i%>
                                </option>
                                <%}%>
                            </select> : <select class="text" id="actionMinutes" name="actionMinutes">
                            <option value="00" selected="selected">00</option>
                            <option value="15">15</option>
                            <option value="30">30</option>
                            <option value="45">45</option>
                        </select>
                        </td>
                        <td class="admin2" style="vertical-align:top;">
                            <select class="text" name="actionLetter">
                                <option/>
                                <%=ScreenHelper.writeSelect(request,"gynae_action", "", sWebLanguage, true, false)%>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="button" class="button" name="ButtonAddAction" value="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addAction();">
                        </td>
                    </tr>
                    <%-- hidden fields --%>
                    <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_ACTION" property="itemId"/>]>.value">
                    <%=sDivAction%>
                </table>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk", "anesthesie", sWebLanguage)%>
            </td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_ANESTHESIE")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ANESTHESIE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ANESTHESIE" property="value"/></textarea>
            </td>
        </tr>
        <%-- #################################### DELIVERANCE #################################--%>
        <tr class="admin">
            <td colspan="4"><%=getTran(request,"gynaeco", "delivery", sWebLanguage)%>
            </td>
        </tr>
        <%-- delivery.hour / deliverance.type--%>
		<tr>
			<td class="admin">
	               <%=getTran(request,"gynecology", "performedby", sWebLanguage)%>
			</td>
			<td colspan="3" class='admin2'>
               	<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERFORMEDBY" property="itemId"/>]>.value">
               		<option/>
               		<%=ScreenHelper.writeSelect(request,"delivery.performers",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERFORMEDBY"),sWebLanguage) %>
               	</select>
			</td>
		</tr>
 		<tr>
 			<td class='admin2' colspan='4'>
 				<table width=100%'>
 					<tr>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EPISIOTOMY" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_EPISIOTOMY;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "episiotomy", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_SUTURE" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_SUTURE;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "suture", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERINEALTEAR" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERINEALTEAR;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "perinealtear", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_VAGINALTEAR" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_VAGINALTEAR;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "vaginaltear", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_COLLARTEAR" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_COLLARTEAR;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "collartear", sWebLanguage)%>
			 			</td>
			 			<td>
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HEMORRHAGIA" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_HEMORRHAGIA;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "hemorrhagia", sWebLanguage)%>
			 			</td>
			 		</tr>
 					<tr>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_INFECTION" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_INFECTION;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "infection", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ECLAMPSIA" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ECLAMPSIA;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "eclampsia", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FISTULA" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FISTULA;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "fistula", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_UTERUSTEAR" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_UTERUSTEAR;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "uterustear", sWebLanguage)%>
			 			</td>
			 			<td width="16%">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEATH" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEATH;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "maternaldeath", sWebLanguage)%>
			 			</td>
			 			<td>
            				<%=getTran(request,"web", "other", sWebLanguage)%>:
            				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_OTHERCOMPLICATION")%> class="text" rows="1" cols="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERCOMPLICATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERCOMPLICATION" property="value"/></textarea>
			 			</td>
			 		</tr>
                    <tr>
                    	<td colspan="6">
                    		<table class='list' width='100%'>
                    			<tr class='gray'>
                    				<td colspan='7'><b><%=getTran(request,"web","surveillance",sWebLanguage) %> 24h</b></td>
                    			</tr>
                    			<tr class='gray'>
                    				<td/>
                    				<td><b>30min</td>
                    				<td><b>1h</b></td>
                    				<td><b>2h</b></td>
                    				<td><b>6h</b></td>
                    				<td><b>12h</b></td>
                    				<td><b>24h</b></td>
                    			</tr>
                    			<tr class='list'>
                    				<td><%=getTran(request,"web","bloodloss",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODLOSS24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list1'>
                    				<td><%=getTran(request,"web","contracteduterus",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_CONTRACTEDUTERUS24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list'>
                    				<td><%=getTran(request,"web","respiration",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_RESPIRATION24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list1'>
                    				<td><%=getTran(request,"web","pulse",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_PULSE24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list'>
                    				<td><%=getTran(request,"web","bloodpressure",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_BLOODPRESSURE24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list1'>
                    				<td><%=getTran(request,"web","temperature",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TEMPERATURE24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list'>
                    				<td><%=getTran(request,"web","urine",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_URINE24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list1'>
                    				<td><%=getTran(request,"web","treatment",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT2" property="value"/>">
                    				</td>
                    				<td>
            							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_TREATMENT24" property="value"/>">
                    				</td>
                    			</tr>
                    			<tr class='list'>
                    				<td><%=getTran(request,"web","observation",sWebLanguage) %></td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION30" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION30" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION1" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION2" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION6" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION12" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION12" property="value"/>">
                    				</td>
                    				<td>
             							<input type="text" class="text" size="15" maxLength="255" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION24" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_MOTHER_SURVEILLANCE_OBSERVATION24" property="value"/>">
                    				</td>
                    			</tr>
                    		</table>
                    	</td>
                    </tr>
 					<tr>
			 			<td colspan="6">
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FAMILYPLANNING" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_FAMILYPLANNING;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "familyplanningatdischarge", sWebLanguage)%>
			 			</td>
			 		</tr>
			 	</table>
			 </td>
 		</tr>
	    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/gynaeDeliveryMSPLSChildren.jsp"),pageContext);%>
    </table>
    <%-- DIAGNOSES --%>
    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncodingWide.jsp"),pageContext);%>
    <table width='100%'>
        <%-- BUTTONS --%>
        <tr>
            <td class="admin2"/>
                <%=getButtonsHtml(request, activeUser, activePatient, "true".equalsIgnoreCase(request.getParameter("readonly"))?"readonly":"occup.delivery", sWebLanguage)%>
            </td>
        </tr>
    </table>            
    <%=ScreenHelper.contextFooter(request)%>
</form>
<script>
    function calculateapgar(){
    	 if(document.getElementById("coeur1").value=="-1" || document.getElementById("resp1").value=="-1" || document.getElementById("tonus1").value=="-1" || document.getElementById("refl1").value=="-1" || document.getElementById("color1").value=="-1"){
        	 document.getElementById("total1").value="?";
	     }
	     else {
	         document.getElementById("total1").value=1*document.getElementById("coeur1").value+1*document.getElementById("resp1").value+1*document.getElementById("tonus1").value+1*document.getElementById("refl1").value+1*document.getElementById("color1").value;
	     }
	     if(document.getElementById("coeur5").value=="-1" || document.getElementById("resp5").value=="-1" || document.getElementById("tonus5").value=="-1" || document.getElementById("refl5").value=="-1" || document.getElementById("color5").value=="-1"){
	         document.getElementById("total5").value="?";
	     }
	     else {
	         document.getElementById("total5").value=1*document.getElementById("coeur5").value+1*document.getElementById("resp5").value+1*document.getElementById("tonus5").value+1*document.getElementById("refl5").value+1*document.getElementById("color5").value;
	     }
	     if(document.getElementById("coeur10").value=="-1" || document.getElementById("resp10").value=="-1" || document.getElementById("tonus10").value=="-1" || document.getElementById("refl10").value=="-1" || document.getElementById("color10").value=="-1"){
	         document.getElementById("total10").value="?";
	     }
	     else {
	         document.getElementById("total10").value=1*document.getElementById("coeur10").value+1*document.getElementById("resp10").value+1*document.getElementById("tonus10").value+1*document.getElementById("refl10").value+1*document.getElementById("color10").value;
	     }
		if(document.getElementById("coeur1").value=="-1" || document.getElementById("resp1").value=="-1" || document.getElementById("tonus1").value=="-1" || document.getElementById("refl1").value=="-1" || document.getElementById("color1").value=="-1"){
		    document.getElementById("total1-2").value="";
		}
		else {
		    document.getElementById("total1-2").value=1*document.getElementById("coeur1-2").value+1*document.getElementById("resp1-2").value+1*document.getElementById("tonus1-2").value+1*document.getElementById("refl1-2").value+1*document.getElementById("color1-2").value;
		}
		if(document.getElementById("coeur5-2").value=="-1" || document.getElementById("resp5-2").value=="-1" || document.getElementById("tonus5-2").value=="-1" || document.getElementById("refl5-2").value=="-1" || document.getElementById("color5-2").value=="-1"){
		    document.getElementById("total5-2").value="";
		}
		else {
		    document.getElementById("total5-2").value=1*document.getElementById("coeur5-2").value+1*document.getElementById("resp5-2").value+1*document.getElementById("tonus5-2").value+1*document.getElementById("refl5-2").value+1*document.getElementById("color5-2").value;
		}
		if(document.getElementById("coeur10-2").value=="-1" || document.getElementById("resp10-2").value=="-1" || document.getElementById("tonus10-2").value=="-1" || document.getElementById("refl10-2").value=="-1" || document.getElementById("color10-2").value=="-1"){
		    document.getElementById("total10-2").value="";
		}
		else {
		    document.getElementById("total10-2").value=1*document.getElementById("coeur10-2").value+1*document.getElementById("resp10-2").value+1*document.getElementById("tonus10-2").value+1*document.getElementById("refl10-2").value+1*document.getElementById("color10-2").value;
		}
    }

    function convertTimeToNbForGraph(nb){
        switch (parseInt(nb)){
            case 15:
                nb = 25;
                break;
            case 25:
                nb = 15;
                break;
            case 30:
                nb = 50;
                break;
            case 50:
                nb = 30;
                break;
            case 45:
                nb = 75;
                break;
            case 75:
                nb = 45;
                break;
        }
        return nb;
    }
    <%-- SUBMIT FORM --%>
    function submitForm(){
        if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
    		alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
    		searchEncounter();
    	}	
        else {
	        var maySubmit = true;
	        if(isAtLeastOneDilatationFieldFilled()){
	            if(maySubmit){
	                if(!addDilatation()){
	                    maySubmit = false;
	                }
	            }
	        }
	        var sTmpBegin;
	        var sTmpEnd;
	        while (sDilatation.indexOf("rowDilatation") > -1){
	            sTmpBegin = sDilatation.substring(sDilatation.indexOf("rowDilatation"));
	            sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=") + 1);
	            sDilatation = sDilatation.substring(0, sDilatation.indexOf("rowDilatation")) + sTmpEnd;
	        }
	        document.getElementsByName("currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_DILATATION" property="itemId"/>]>.value")[0].value = sDilatation;
	        if(isAtLeastOneEngagementFieldFilled()){
	            if(maySubmit){
	                if(!addEngagement()){
	                    maySubmit = false;
	                }
	            }
	        }
	        while (sEngagement.indexOf("rowEngagement") > -1){
	            sTmpBegin = sEngagement.substring(sEngagement.indexOf("rowEngagement"));
	            sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=") + 1);
	            sEngagement = sEngagement.substring(0, sEngagement.indexOf("rowEngagement")) + sTmpEnd;
	        }
	        document.getElementsByName("currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_ENGAGEMENT" property="itemId"/>]>.value")[0].value = sEngagement;
	        if(isAtLeastOneActionFieldFilled()){
	            if(maySubmit){
	                if(!addAction()){
	                    maySubmit = false;
	                }
	            }
	        }
	        while (sAction.indexOf("rowAction") > -1){
	            sTmpBegin = sAction.substring(sAction.indexOf("rowAction"));
	            sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=") + 1);
	            sAction = sAction.substring(0, sAction.indexOf("rowAction")) + sTmpEnd;
	        }
	        //setBeginHourSelect int hidden field;
	        if($("beginHourSelect").value.length==0){
	            $("ITEM_TYPE_DELIVERY_STARTHOUR").value = '';
	        }else{
	            $("ITEM_TYPE_DELIVERY_STARTHOUR").value = $("beginHourSelect").value+":"+$("beginMinutSelect").value;
	        }
	
	        document.getElementsByName("currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_WORK_ACTION" property="itemId"/>]>.value")[0].value = sAction;
	        if(maySubmit){
	            document.getElementById("buttonsDiv").style.visibility = "hidden";
	            var temp = Form.findFirstElement(transactionForm);//for ff compatibility
	        <%
	            SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	            out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
	        %>
	        }
        }
    }
    function searchEncounter(){
        openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
    }
    if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
    }	
      
    function clearType2(object){
        if(!object.checked){
            if(document.getElementById("trtype2")){
            	document.getElementById("trtype2").style.display='none';
            }
            document.getElementById("cbventousse").checked = false;
            document.getElementById("ttractions").value = "";
            document.getElementById("tlachage").value = "";
            document.getElementById("cbforceps").checked = false;
            document.getElementById("cbmanoeuvre").checked = false;
            document.getElementById("causedystocic_r1").checked = false;
            document.getElementById("causedystocic_r2").checked = false;
            document.getElementById("causedystocic_r3").checked = false;
            document.getElementById("tdystoticremark").value = "";
        }
        else {
            show("trtype2");
        }
    }
    function clearType3(object){
        if(!object.checked){
            if(document.getElementsByName("trtype3")[0]){
                hide("trtype3");
            }
            document.getElementById("caeserian_r1").checked = false;
            document.getElementById("caeserian_r2").checked = false;
            document.getElementById("causecaeserian_r1").checked = false;
            document.getElementById("causecaeserian_r2").checked = false;
            document.getElementById("causecaeserian_r3").checked = false;
            document.getElementById("tcaeserianremark").value = "";
            document.getElementById("tcaeserianindication").value = "";
        }
        else {
            show("trtype3");
        }
    }
    function doAlive(){
        document.getElementById("tralive1").style.display = "none";
        document.getElementById("tralive2").style.display = "none";
        if(document.getElementById("alive_r1").checked){
            document.getElementById("cbdead24h").checked = false;
            document.getElementById("coeur1").value = "";
            document.getElementById("coeur5").value = "";
            document.getElementById("coeur10").value = "";
            document.getElementById("resp1").value = "";
            document.getElementById("resp5").value = "";
            document.getElementById("resp10").value = "";
            document.getElementById("tonus1").value = "";
            document.getElementById("tonus5").value = "";
            document.getElementById("tonus10").value = "";
            document.getElementById("refl1").value = "";
            document.getElementById("refl5").value = "";
            document.getElementById("refl10").value = "";
            document.getElementById("color1").value = "";
            document.getElementById("color5").value = "";
            document.getElementById("color10").value = "";
            document.getElementById("total1").value = "";
            document.getElementById("total5").value = "";
            document.getElementById("total10").value = "";
            document.getElementById("reanimation").value = "";
            document.getElementById("malformation").value = "";
            document.getElementById("observation").value = "";
            document.getElementById("treatment").value = "";
            document.getElementById("polio_date").value = "";
            document.getElementById("bcg_date").value = "";
            document.getElementById("tralive1").style.display = "";
        }
        else if(document.getElementById("alive_r2").checked){
            document.getElementById("deadtype_r1").checked = false;
            document.getElementById("deadtype_r2").checked = false;
            document.getElementById("tralive2").style.display = "";
        }
	    document.getElementById("tralive1-2").style.display = "none";
	    document.getElementById("tralive2-2").style.display = "none";
	    if(document.getElementById("alive_r1-2").checked){
	        document.getElementById("cbdead24h2").checked = false;
	        document.getElementById("coeur1-2").value = "";
	        document.getElementById("coeur5-2").value = "";
	        document.getElementById("coeur10-2").value = "";
	        document.getElementById("resp1-2").value = "";
	        document.getElementById("resp5-2").value = "";
	        document.getElementById("resp10-2").value = "";
	        document.getElementById("tonus1-2").value = "";
	        document.getElementById("tonus5-2").value = "";
	        document.getElementById("tonus10-2").value = "";
	        document.getElementById("refl1-2").value = "";
	        document.getElementById("refl5-2").value = "";
	        document.getElementById("refl10-2").value = "";
	        document.getElementById("color1-2").value = "";
	        document.getElementById("color5-2").value = "";
	        document.getElementById("color10-2").value = "";
	        document.getElementById("total1-2").value = "";
	        document.getElementById("total5-2").value = "";
	        document.getElementById("total10-2").value = "";
	        document.getElementById("reanimation2").value = "";
	        document.getElementById("malformation2").value = "";
	        document.getElementById("observation2").value = "";
	        document.getElementById("treatment2").value = "";
	        document.getElementById("polio_date2").value = "";
	        document.getElementById("bcg_date2").value = "";
	        document.getElementById("tralive1-2").style.display = "";
	    }
	    else if(document.getElementById("alive_r2-2").checked){
	        document.getElementById("deadtype_r1-2").checked = false;
	        document.getElementById("deadtype_r2-2").checked = false;
	        document.getElementById("tralive2-2").style.display = "";
	    }
    }
    doAlive();
    <%
        tran = sessionContainerWO.getCurrentTransactionVO();
        if(tran!=null){
            tran = MedwanQuery.getInstance().loadTransaction(tran.getServerId(),tran.getTransactionId().intValue());

            if((tran!=null)&&(tran.getHealthrecordId() != sessionContainerWO.getHealthRecordVO().getHealthRecordId().intValue())){
                out.print("transactionForm.saveButton.disabled = true;");
            }
        }
    %>
    function clearDr(){
        if(document.getElementById("drdate").value.length == 0){
            document.getElementById("agedatedr").value = "";
            document.getElementById("drdeldate").value = "";
        }
    }
    function calculateGestAge(){
    	var weeks = 0;
        var trandate = new Date();
        var a = document.getElementById('ageuterineheight').value;
        var bFound=false;
        if(a*1>0){
        	weeks=a*1;
            if(a*1 < 12){
                document.getElementById('trimestre_r1').checked = true;
            }
            else if(a*1 < 24){
                document.getElementById('trimestre_r2').checked = true;
            }
            else {
                document.getElementById('trimestre_r3').checked = true;
            }
			bFound=true;
        }
        else{
            document.getElementById('trimestre_r1').checked = false;
            document.getElementById('trimestre_r2').checked = false;
            document.getElementById('trimestre_r3').checked = false;
        }
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
                    weeks=timeElapsed;
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
                bFound=true;
            }
            else{
                document.getElementById("drdeldate").value = '';
                document.getElementById("agedatedr").value = '';
                if(!bFound){
	                document.getElementById('trimestre_r1').checked = false;
	                document.getElementById('trimestre_r2').checked = false;
	                document.getElementById('trimestre_r3').checked = false;
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
                    weeks=age*1;
                    if(age*1 < 12){
                        document.getElementById('trimestre_r1').checked = true;
                    }
                    else if(age*1 < 24){
                        document.getElementById('trimestre_r2').checked = true;
                    }
                    else {
                        document.getElementById('trimestre_r3').checked = true;
                    }
                    if(age.indexOf(".")>-1){
                        aAge = age.split(".");
                        age = aAge[0]+ " " +aAge[1];
                    }
                    document.getElementById("ageactualecho").value = age;
                }
                bFound=true;
            }
            else{
                document.getElementById("agedateecho").value = '';
                document.getElementById("ageactualecho").value = '';
                document.getElementById("echodeldate").value = '';
                if(!bFound){
	                document.getElementById('trimestre_r1').checked = false;
	                document.getElementById('trimestre_r2').checked = false;
	                document.getElementById('trimestre_r3').checked = false;
                }
            }
        }
        if(weeks>=34){
        	document.getElementById("attermyes").checked=true;
        	document.getElementById("attermno").checked=false;
        }
        else{
        	document.getElementById("attermyes").checked=false;
        	document.getElementById("attermno").checked=false;
        }
    }
    //   calculateGestAge();
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

    var iDilatationIndex = <%=iDilatationTotal%>;
    var sDilatation = "<%=sDilatation%>";
    <%-- Dilatation -------------------------------------------------------------------------%>
    function addDilatation(){
        if(isAtLeastOneDilatationFieldFilled()){
        <%-- set begin time and first time of dilatation the same --%>
            iDilatationIndex++;
            sDilatation += "rowDilatation" + iDilatationIndex + "=" + transactionForm.dilatationHour.value + "£" + transactionForm.dilatationMinutes.value + "£" + transactionForm.dilatationOpening.value + "$";
            var tr;
            tr = tblDilatation.insertRow(tblDilatation.rows.length);
            tr.id = "rowDilatation" + iDilatationIndex;
            var td = tr.insertCell(0);
            td.innerHTML = "<a href='javascript:deleteDilatation(rowDilatation" + iDilatationIndex + "," + transactionForm.dilatationHour.value + convertTimeToNbForGraph(transactionForm.dilatationMinutes.value) + ")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)%>' border='0'></a>";
            tr.appendChild(td);
            td = tr.insertCell(1);
            td.innerHTML = "&nbsp;" + transactionForm.dilatationHour.value + ":" + transactionForm.dilatationMinutes.value;
            tr.appendChild(td);
            td = tr.insertCell(2);
            td.innerHTML = "&nbsp;" + transactionForm.dilatationOpening.value;
            tr.appendChild(td);
            td = tr.insertCell(3);
            td.innerHTML = "&nbsp;";
            tr.appendChild(td);
            setCellStyle(tr);
            setNewDilatation(transactionForm.dilatationHour.value + convertTimeToNbForGraph(transactionForm.dilatationMinutes.value), transactionForm.dilatationOpening.value);
            clearDilatationFields();
            clearGraphDilatation();
            setGraphDilatation();
        }
        return true;
    }
    function isAtLeastOneDilatationFieldFilled(){
        if(transactionForm.dilatationHour.value != "") return true;
        if(transactionForm.dilatationOpening.value != "") return true;
        return false;
    }
    function clearDilatationFields(){
        transactionForm.dilatationHour.selectedIndex = -1;
        //transactionForm.dilatationMinutes.selectedIndex = -1;
        transactionForm.dilatationOpening.selectedIndex = -1;
    }
    function deleteDilatation(rowid, dilatationHours){
        if(yesnoDeleteDialog()){
            sDilatation = deleteRowFromArrayString(sDilatation, rowid.id);
            tblDilatation.deleteRow(rowid.rowIndex);
            graphDilatation.unset(dilatationHours);
            iDilatationIndex--;
            clearDilatationFields();
            clearGraphDilatation();
            setGraphDilatation();
        }
    }
    var iEngagementIndex = <%=iEngagementTotal%>;
    var sEngagement = "<%=sEngagement%>";
    <%-- Engagement -------------------------------------------------------------------------%>
    function addEngagement(){
        if(isAtLeastOneEngagementFieldFilled()){
            <%-- set begin time and first time of engagment the same --%>
            iEngagementIndex++;
            sEngagement += "rowEngagement" + iEngagementIndex + "=" + transactionForm.engagementHour.value + "£" + transactionForm.engagementMinutes.value + "£" + transactionForm.engagementDegree.value + "$";
            var tr;
            tr = tblEngagement.insertRow(tblEngagement.rows.length);
            tr.id = "rowEngagement" + iEngagementIndex;
            var td = tr.insertCell(0);
            td.innerHTML = "<a href='javascript:deleteEngagement(rowEngagement" + iEngagementIndex + "," + transactionForm.engagementHour.value + convertTimeToNbForGraph(transactionForm.engagementMinutes.value) + ")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)%>' border='0'></a>";
            tr.appendChild(td);
            td = tr.insertCell(1);
            td.innerHTML = "&nbsp;" + transactionForm.engagementHour.value + ":" + transactionForm.engagementMinutes.value;
            tr.appendChild(td);
            td = tr.insertCell(2);
            td.innerHTML = "&nbsp;" + transactionForm.engagementDegree.value;
            tr.appendChild(td);
            td = tr.insertCell(3);
            td.innerHTML = "&nbsp;";
            tr.appendChild(td);
            setCellStyle(tr);
            setNewEngagement(transactionForm.engagementHour.value + convertTimeToNbForGraph(transactionForm.engagementMinutes.value), transactionForm.engagementDegree.value);
            clearEngagementFields();
            clearGraphEngagement();
            setGraphEngagement();
        }
        return true;
    }
    function isAtLeastOneEngagementFieldFilled(){
        if(transactionForm.engagementHour.value != "") return true;
        if(transactionForm.engagementDegree.value != "") return true;
        return false;
    }
    function clearEngagementFields(){
        transactionForm.engagementHour.selectedIndex = -1;
        transactionForm.engagementDegree.selectedIndex = -1;
    }
    function deleteEngagement(rowid, engagementHour){
        if(yesnoDeleteDialog()){
        sEngagement = deleteRowFromArrayString(sEngagement, rowid.id);
        tblEngagement.deleteRow(rowid.rowIndex);
        graphEngagement.unset(engagementHour);
        iEngagementIndex--;
        clearEngagementFields();
        clearGraphEngagement();
        setGraphEngagement();
      }
    }
    var iActionIndex = <%=iActionTotal%>;
    var sAction = "<%=sAction%>";
    <%-- Action -------------------------------------------------------------------------%>
    function addAction(){
        if(isAtLeastOneActionFieldFilled()){
              <%-- set begin time and first time of engagment the same --%>
            iActionIndex++;
            sAction += "rowAction" + iActionIndex + "=" + transactionForm.actionHour.value + "£" + transactionForm.actionMinutes.value + "£" + transactionForm.actionLetter.value + "$";

            var tr;
            tr = tblAction.insertRow(tblAction.rows.length);
            tr.id = "rowAction" + iActionIndex;
            var td = tr.insertCell(0);
            td.innerHTML = "<a href='javascript:deleteAction(rowAction" + iActionIndex + ",\"" + transactionForm.actionHour.value + transactionForm.actionMinutes.value + transactionForm.actionLetter.value + "\");'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)%>' border='0'></a>";
            tr.appendChild(td);
            td = tr.insertCell(1);
            td.innerHTML = "&nbsp;" + transactionForm.actionHour.value + ":" + transactionForm.actionMinutes.value;
            tr.appendChild(td);
            td = tr.insertCell(2);
            td.innerHTML = "&nbsp;" + transactionForm.actionLetter.value;
            tr.appendChild(td);
            td = tr.insertCell(3);
            td.innerHTML = "&nbsp;";
            tr.appendChild(td);
            setCellStyle(tr);

            var sIndex = transactionForm.actionLetter.value;
            if(sIndex.length==0){
                sIndex = "0";
            }
            graphAction.set(transactionForm.actionHour.value + transactionForm.actionMinutes.value + sIndex, transactionForm.actionLetter.value);
            clearActionFields();
        }
        setGraphAction();
        return true;
    }
    function isAtLeastOneActionFieldFilled(){
      if(transactionForm.actionHour.value != "") return true;
      if(transactionForm.actionLetter.value != "") return true;
      return false;
    }
    function clearActionFields(){
      transactionForm.actionHour.selectedIndex = -1;
      //transactionForm.actionMinutes.selectedIndex = -1;
      transactionForm.actionLetter.selectedIndex = -1;
    }
    function deleteAction(rowid, actionHour){
        if(yesnoDeleteDialog()){
        sAction = deleteRowFromArrayString(sAction, rowid.id);
        tblAction.deleteRow(rowid.rowIndex);
        graphAction.unset(actionHour);
        clearActionFields();
        clearGraphAction();
        setGraphAction();
      }
    }
    <!-- GENERAL FUNCTIONS -->
    function deleteRowFromArrayString(sArray, rowid){
      var array = sArray.split("$");
      for(var i = 0; i < array.length; i++){
        if(array[i].indexOf(rowid) > -1){
          array.splice(i, 1);
        }
      }
      return array.join("$");
    }
    function getRowFromArrayString(sArray, rowid){
        var array = sArray.split("$");
        var row = "";
        for(var i = 0; i < array.length; i++){
            if(array[i].indexOf(rowid) > -1){
                row = array[i].substring(array[i].indexOf("=") + 1);
                break;
            }
        }
        return row;
    }
    function getCelFromRowString(sRow, celid){
        var row = sRow.split("£");
        return row[celid];
    }
    function replaceRowInArrayString(sArray, newRow, rowid){
        var array = sArray.split("$");
        for(var i = 0; i < array.length; i++){
            if(array[i].indexOf(rowid) > -1){
                array.splice(i, 1, newRow);
                break;
            }
        }
        return array.join("$");
    }
    function setCellStyle(row){
      for(var i = 0; i < row.cells.length; i++){
        row.cells[i].style.color = "#333333";
        row.cells[i].style.fontFamily = "arial";
        row.cells[i].style.fontSize = "10px";
        row.cells[i].style.fontWeight = "normal";
        row.cells[i].style.textAlign = "left";
        row.cells[i].style.paddingLeft = "5px";
        row.cells[i].style.paddingRight = "1px";
        row.cells[i].style.paddingTop = "1px";
        row.cells[i].style.paddingBottom = "1px";
        row.cells[i].style.backgroundColor = "#E0EBF2";
      }
    }
    function setRightUnits(vv){
        var r = "";
        switch (vv){
            case 1:
                r = "+4";
                break;
            case 3:
                r = "+2";
                break;
            case 5:
                r = "0";
                break;
            case 7:
                r = "-2";
                break;
            case 9:
                r = "-4";
                break;
        }
        return("<nobr>" + r + "</nobr>");
    }
    var D = new Diagram();
    _BFont = "font-family:arial;font-size:8pt;line-height:9pt;";
    D.SetFrame(0, 30, 720, 335);
    D.SetBorder(0, 24, 0, 10);
    D.SetGridColor("#808080", "#CCCCCC");
    var i, j, x, y;
    j = D.ScreenY(0);
    P = new Array(720);
    D.XScale = "h";
    D.YGridDelta = 1;
    D.XGridDelta = 1;
    D.XSubGrids = 4;
    _DivDiagram = 'glycemyGraph';
    D.Draw("#FFEECC", "#663300", false);
    var t, T0, T1;
    D.GetYGrid();
    D.GetXGrid();
    D.XGrid[1] = 0.25;
    //----------------------- SET RIGHT UNITS -----------------//
    for(t = D.YGrid[0]; t <= D.YGrid[2]; t += D.YGrid[1]){
        new Bar(D.right + 6, D.ScreenY(t) - 8, D.right + 6, D.ScreenY(t) + 8, "", setRightUnits(t), "#663300");
    }
    //------------------------ SET DEFAULT LINES --------------//
    new Line(D.ScreenX(0), D.ScreenY(4), D.ScreenX(8), D.ScreenY(4), "#0a0e70", 2, "<%=getTranNoLink("gynae", "dilatation.opening", sWebLanguage)%>");
    new Line(D.ScreenX(8), D.ScreenY(4), D.ScreenX(15), D.ScreenY(10), "#0a0e70", 2, "<%=getTranNoLink("gynae", "dilatation.opening", sWebLanguage)%>");
    new Line(D.ScreenX(12), D.ScreenY(4), D.ScreenX(19), D.ScreenY(10), "#610202", 2, "<%=getTranNoLink("gynaeco", "work.engagement", sWebLanguage)%>");
    new Line(D.ScreenX(8), D.ScreenY(0), D.ScreenX(8), D.ScreenY(10), "black", 2, "<%=getTranNoLink("gynaeco", "work.engagement", sWebLanguage)%>");
    //------------------------ SET DESCRIPTIONS ---------------//
    new Bar(40, 35, 170, 50, "", "<%=getTranNoLink("gynae", "phase.latente", sWebLanguage)%>", "#000");
    new Bar(225, 35, 360, 50, "", "<%=getTranNoLink("gynaeco", "phase.active", sWebLanguage)%>", "#000");
    //------------------------ SET LEGEND ---------------------//
    new Bar(20, -15, 170, 0, "#0000FF", "<%=getTranNoLink("gynae", "dilatation.opening", sWebLanguage)%>", "#FFFFFF");
    new Bar(190, -15, 360, 0, "#FF0000", "<%=getTranNoLink("gynaeco", "work.engagement", sWebLanguage)%>", "#FFFFFF");
    new Bar(380, -15, 520, 0, "#FFFF00", "<%=getTranNoLink("gynae", "action", sWebLanguage)%>", "#000");
    //---------------------------------------------- DILATATION GRAPH -------------------------------------//
    function sortNumber(a, b){
        return a - b;
    }
    function convertDilatationYtoDegree(s){
        var y = parseFloat((s+'').replace(",","."));
        var t = 5;
        if(y > 0){
            for(var ia = 1; ia <= y; ia++){
                t--;
            }
            y = parseFloat((t+'').replace(",","."));
        } else if(y < 0){
            for(var ia = -1; ia >= y; ia--){
                t++;
            }
            y = parseFloat((t+'').replace(",","."));
        } else {
            y = parseFloat('5');
        }
        return y;
    }
    function setGraphDilatation(){
        var graphDilatation_keys = graphDilatation.keys();
        if(graphDilatation_keys.length > 1){
            graphDilatation_keys.sort(sortNumber);
            for(i = 0; i < graphDilatation_keys.length - 1; i++){
                var p1x = graphDilatation_keys[i] - getEarlierTime();
                var p1y = graphDilatation.get(graphDilatation_keys[i]);
                var p2x = graphDilatation_keys[i + 1] - getEarlierTime();
                var p2y = graphDilatation.get(graphDilatation_keys[i + 1]);
                graphDilatationObjects.push(new Line(D.ScreenX(p1x / 100), D.ScreenY(p1y), D.ScreenX(p2x / 100), D.ScreenY(p2y), "#0000FF", 2, ""));
            }
        } else {
            graphDilatation.each(function(index){
                var x = index.key - getEarlierTime();
                graphDilatationObjects.push(new Dot(D.ScreenX(x / 100), D.ScreenY(index.value), 7, 18, '#0000FF', "dot"));
            });
        }
    }
    function clearGraphDilatation(){
        graphDilatationObjects.each(function(obj){
            obj.Delete();
        });
        graphDilatationObjects.clear();
    }
    //------------------------------------------------ ENGAGEMENT GRAPH ---------------------------------------//
    function setGraphEngagement(){
        var graphEngagement_keys = graphEngagement.keys();
        if(graphEngagement_keys.length > 1){
            graphEngagement_keys.sort(sortNumber);
            for(var iq = 0; iq < graphEngagement_keys.length - 1; iq++){
                var p1x = graphEngagement_keys[iq] - getEarlierTime();
                var p1y = graphEngagement.get(graphEngagement_keys[iq]);
                var p2x = graphEngagement_keys[iq + 1] - getEarlierTime();
                var p2y = graphEngagement.get(graphEngagement_keys[iq + 1]);
                graphEngagementObjects.push(new Line(D.ScreenX(p1x / 100), D.ScreenY(convertDilatationYtoDegree(p1y)), D.ScreenX(p2x / 100), D.ScreenY(convertDilatationYtoDegree(p2y)), "#FF0000", 2, ""));
            }
        } else {
            graphEngagement.each(function(index){
                y = convertDilatationYtoDegree(index.value);
                x = index.key - getEarlierTime();
                graphEngagementObjects.push(new Dot(D.ScreenX(x / 100), D.ScreenY(y), 7, 18, '#FF0000', "dot"));
            });
        }
    }
    function clearGraphEngagement(){
        graphEngagementObjects.each(function(obj){
            obj.Delete();
        });
        graphEngagementObjects.clear();
    }
    //------------------------------------------------ ACTION GRAPH ---------------------------------------//
    var divHeigth = $('glycemyGraph').style.height;
    function setGraphAction(){
        var graphAction_keys = graphAction.keys();
        var moreHeigth = 0;
        if(graphAction_keys.length > 0){
            graphAction_keys.sort();
            var y = D.bottom;
            for(i = 0; i < graphAction_keys.length; i++){
                var x = Math.floor(graphAction_keys[i].substring(0, graphAction_keys[i].length - 1) / 100);
                var l = graphAction.get(graphAction_keys[i]);
                if(i > 0 && Math.floor(graphAction_keys[i - 1].substring(0, graphAction_keys[i - 1].length - 1) / 100) == x){
                    y = y + 15;
                    if(moreHeigth < y - D.bottom){
                        moreHeigth = y - D.bottom;
                    }
                } else {
                    y = D.bottom;
                }
                var earlierTime = getEarlierTime();
                x -=(earlierTime.substring(0,earlierTime.length-2));
                graphActionObjects.push(new Bar(D.ScreenX(x + 0.2), y + 30, D.ScreenX(x + 0.8), y + 45, "#FFFF00", l, "#000"));
            }
        }
        $('glycemyGraph').style.height = parseInt(divHeigth.replace("px", "")) + moreHeigth;
    }
    function clearGraphAction(){
        graphActionObjects.each(function(obj){
            obj.Delete();
        });
        graphActionObjects.clear();
    }

    setGraphAction();
    setGraphDilatation();
    setGraphEngagement();
    clearType2(document.getElementById("type_r2"));
    clearType3(document.getElementById("type_r3"));
    sReanimationDestination = "<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION" property="value"/>";
    for(var n = 0; n < transactionForm.EditReanimationDestination.length; n++){
        if(transactionForm.EditReanimationDestination.options[n].value == sReanimationDestination){
            transactionForm.EditReanimationDestination.selectedIndex = n;
            break;
        }
    }

    function setTopUnits(){
      _BFont = "font-family:arial;font-size:6pt;font-weight:bold;";
      if(barTop!=undefined){
        barTop.each(function(obj){
          obj.Delete();
        });
      }

      barTop = new Array();
      var time = ($("beginHourSelect").value) + convertTimeToNbForGraph($("beginMinutSelect").value);
      if(earlierBackupTime != time){
        earlierBackupTime = time;
      }

//        earlierBackupTime = $("ITEM_TYPE_DELIVERY_STARTHOUR").value;
        earlierBackupTime = ($("beginHourSelect").value) +":"+ convertTimeToNbForGraph($("beginMinutSelect").value);

        //----------------------- SET TOP UNITS -----------------//
        for(t = D.XGrid[0]; t <= D.XGrid[2]; t += 1){
//            var h = parseInt(earlierBackupTime.substring(0, earlierBackupTime.length - 2));
  //          var m = earlierBackupTime.substring(earlierBackupTime.length - 2);

            var h = $("beginHourSelect").value;
            var m = $("beginMinutSelect").value;
//            var m = convertTimeToNbForGraph($("beginMinutSelect").value);

            if(t != D.XGrid[0]){
                h = h*1+t;
                if(h > 23){
                    h -= 24;
                }
            }
            barTop.push(new Bar(D.ScreenX(t) - 10, D.top - 20, D.ScreenX(t) + 5, D.top - 10, "", h + ":" + m + " &nbsp |", "#663300"));
        }
    }

  function setNewTime(){
    if(($("beginHourSelect").value.length>0)&&($("beginMinutSelect").value.length>0)){
      setTopUnits();
      clearGraphAction();
      setGraphAction();
      clearGraphDilatation();
      setGraphDilatation();
      clearGraphEngagement();
      setGraphEngagement();
    }
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>
<%
	}
catch(Exception e){
	e.printStackTrace();
}
%>