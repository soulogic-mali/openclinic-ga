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
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
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
	    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/gynaeDeliveryMSPLSWorkNew.jsp"),pageContext);%>
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
               	</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	<%=getTran(request,"gynaeco", "performer", sWebLanguage)%>
   				<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_PERFORMER")%> type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERFORMER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PERFORMER" property="value"/>">
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"gynecology", "timemdcalled", sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_CALLED", 5) %> h</td>
			<td class='admin'><%=getTran(request,"gynecology", "timemdarrived", sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_ARRIVED", 5) %> h</td>
		</tr>
		<tr>
			<td class="admin">
	               <%=getTran(request,"gynecology", "otheracts", sWebLanguage)%>
			</td>
			<td class='admin2'>
       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_OTHERACTS")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERACTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_OTHERACTS" property="value"/></textarea>
			</td>
			<td class="admin">
	               <%=getTran(request,"gynecology", "deliverydescription", sWebLanguage)%>
			</td>
			<td class='admin2'>
       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_DELIVERY_DESCRIPTION")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DESCRIPTION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DESCRIPTION" property="value"/></textarea>
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
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ABORTION" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_ABORTION;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "abortion", sWebLanguage)%>
			 			</td>
			 		</tr>
 					<tr>
			 			<td>
			                 <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREMATURE" property="itemId"/>]>.value" value="medwan.common.true"
			                 <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                           compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREMATURE;value=medwan.common.true"
			                                           property="value"
			                                           outputString="checked"/>><%=getTran(request,"gynecology", "premature", sWebLanguage)%>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td>
            				<%=getTran(request,"web", "palcentaweight", sWebLanguage)%>
            			</td>
            			<td colspan='2'>
            				<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_PLACENTAWEIGHT", 5, 0, 10000, sWebLanguage) %>g
			 			</td>
			 			<td style='text-align: right'>
            				<%=getTran(request,"web", "anomalies", sWebLanguage)%>
            			</td>
            			<td colspan='2'>
							<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_PLACENTACOMMENT", 50, 1)%>
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
<script>
	if(document.getElementById('deliverydate').value.length==0){
		  document.getElementById('deliverydate').value=document.getElementById('trandate').value;
		  document.getElementById('deliverydatefield').value=document.getElementById('trandate').value;
	}
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


    <%-- SUBMIT FORM --%>
    function submitForm(){
        if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
    		alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
    		searchEncounter();
    	}	
        else {
	        var maySubmit = true;
	        //setBeginHourSelect int hidden field;
	        if($("beginHourSelect").value.length==0){
	            $("ITEM_TYPE_DELIVERY_STARTHOUR").value = '';
	        }else{
	            $("ITEM_TYPE_DELIVERY_STARTHOUR").value = $("beginHourSelect").value+":"+$("beginMinutSelect").value;
	        }

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
    if(itemDateEcho!=null){
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
    clearType2(document.getElementById("type_r2"));
    clearType3(document.getElementById("type_r3"));
    sReanimationDestination = "<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DESTINATION" property="value"/>";
    for(var n = 0; n < transactionForm.EditReanimationDestination.length; n++){
        if(transactionForm.EditReanimationDestination.options[n].value == sReanimationDestination){
            transactionForm.EditReanimationDestination.selectedIndex = n;
            break;
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