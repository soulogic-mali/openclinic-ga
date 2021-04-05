<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.cntslab","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   	<%TransactionVO tran = (TransactionVO)transaction; %>
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
	    <%-- Bloodgift reference --%>
	    <%
	        ItemVO item = ((TransactionVO)transaction).getItem(sPREFIX+"ITEM_TYPE_LAB_OBJECTID");
	        String sObjectId = "-1";
	        if(item!=null) sObjectId = item.getValue();
	    %>
	    <tr>
	        <td class="admin"><%=getTran(request,"Web.Occup","bloodgiftreference",sWebLanguage)%></td>
	        <td class="admin2">
	            <select class="text" id="cntsobjectid" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_OBJECTID" property="itemId"/>]>.value">
	                <option/>
	                <%
	                	//Find all existing bloodgifts with expirydate in the future
	                	Vector bloodgifts = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
	                	for(int n=0;n<bloodgifts.size();n++){
	                		TransactionVO bloodgift = (TransactionVO)bloodgifts.elementAt(n);
	                		String expirydate=bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_EXPIRYDATE");
	                		if(expirydate.length()==10){
	                			try{
	                				java.util.Date expdate = ScreenHelper.parseDate(expirydate);
	                				if(expdate.after(new java.util.Date())){
	                					if(bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true") || bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION").equalsIgnoreCase("medwan.common.true") ){
	                						out.println("<option disabled value='"+bloodgift.getTransactionId()+"'>"+bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEPTIONDATE")+" (ID: "+bloodgift.getTransactionId()+")</option>");
	                					}
	                					else{
	                						out.println("<option value='"+bloodgift.getTransactionId()+"' "+(sObjectId.equalsIgnoreCase(bloodgift.getTransactionId()+"")?"selected":"")+">"+bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEPTIONDATE")+" (ID: "+bloodgift.getTransactionId()+")</option>");
	                					}
	                				}
	                			}
	                			catch(Exception e){}
	                		}
	                	}
	                %>
	            </select>
		        <input type='button' class='button' id='labelButton' name='labelButton' value='<%=getTran(null,"web","printlabels",sWebLanguage) %>' onclick='printBloodgiftLabel()'/>
	        </td>
	    </tr>
	    <tr class='admin'><td colspan='2'><%=getTran(request,"web","bloodproductsprepared",sWebLanguage) %></td></tr>
        <tr>
            <td class="admin"><%=getTran(request,"bloodproducts","pfc",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select onchange="setExpiryDate('cntspfcexpirydate',<%=SH.ci("cntspfcexpirationdays",365) %>);checkPharmacyLink('pfc','pfcdiv');" class='text' id="pfcpockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS" property="itemId"/>]>.value">
            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=0" property="value" outputString="selected"/>>0</option>
            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=1" property="value" outputString="selected"/>>1</option>
            		<option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=2" property="value" outputString="selected"/>>2</option>
            		<option value="3" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=3" property="value" outputString="selected"/>>3</option>
            		<option value="4" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=4" property="value" outputString="selected"/>>4</option>
            		<option value="5" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=5" property="value" outputString="selected"/>>5</option>
            		<option value="6" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=6" property="value" outputString="selected"/>>6</option>
            		<option value="7" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=7" property="value" outputString="selected"/>>7</option>
            		<option value="8" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=8" property="value" outputString="selected"/>>8</option>
            		<option value="9" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCPOCKETS;value=9" property="value" outputString="selected"/>>9</option>
            	</select> 
            	<%=getTran(request,"web","pockets",sWebLanguage) %>
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>
			    <input type="hidden" id="pfcexpirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCEXPIRYDATE" property="itemId"/>]>.value"/>
			    <%=ScreenHelper.writeDateField("cntspfcexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PFCEXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			    &nbsp;&nbsp;
			    <span id="pfcdiv"/>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"bloodproducts","prp",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select onchange="setExpiryDate('cntsprpexpirydate',<%=SH.ci("cntsprpexpirationdays",5) %>);checkPharmacyLink('prp','prpdiv');" class='text' id="prppockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS" property="itemId"/>]>.value">
            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=0" property="value" outputString="selected"/>>0</option>
            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=1" property="value" outputString="selected"/>>1</option>
            		<option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=2" property="value" outputString="selected"/>>2</option>
            		<option value="3" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=3" property="value" outputString="selected"/>>3</option>
            		<option value="4" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=4" property="value" outputString="selected"/>>4</option>
            		<option value="5" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=5" property="value" outputString="selected"/>>5</option>
            		<option value="6" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=6" property="value" outputString="selected"/>>6</option>
            		<option value="7" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=7" property="value" outputString="selected"/>>7</option>
            		<option value="8" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=8" property="value" outputString="selected"/>>8</option>
            		<option value="9" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPPOCKETS;value=9" property="value" outputString="selected"/>>9</option>
            	</select> 
            	<%=getTran(request,"web","pockets",sWebLanguage) %>
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>
			    <input type="hidden" id="prpexpirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPEXPIRYDATE" property="itemId"/>]>.value"/>
			    <%=ScreenHelper.writeDateField("cntsprpexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_PRPEXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			    &nbsp;&nbsp;
			    <span id="prpdiv"/>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"bloodproducts","cgr",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select onchange="setExpiryDate('cntscgrexpirydate',<%=SH.ci("cntscgrexpirationdays",35) %>);checkPharmacyLink('cgr','cgrdiv');" class='text' id="cgrpockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS" property="itemId"/>]>.value">
            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=0" property="value" outputString="selected"/>>0</option>
            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=1" property="value" outputString="selected"/>>1</option>
            		<option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=2" property="value" outputString="selected"/>>2</option>
            		<option value="3" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=3" property="value" outputString="selected"/>>3</option>
            		<option value="4" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=4" property="value" outputString="selected"/>>4</option>
            		<option value="5" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=5" property="value" outputString="selected"/>>5</option>
            		<option value="6" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=6" property="value" outputString="selected"/>>6</option>
            		<option value="7" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=7" property="value" outputString="selected"/>>7</option>
            		<option value="8" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=8" property="value" outputString="selected"/>>8</option>
            		<option value="9" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGRPOCKETS;value=9" property="value" outputString="selected"/>>9</option>
            	</select> 
            	<%=getTran(request,"web","pockets",sWebLanguage) %>
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>
			    <input type="hidden" id="cgrexpirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGREXPIRYDATE" property="itemId"/>]>.value"/>
			    <%=ScreenHelper.writeDateField("cntscgrexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CGREXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			    &nbsp;&nbsp;
			    <span id="cgrdiv"/>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"bloodproducts","st",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select onchange="setExpiryDate('cntsstexpirydate',<%=SH.ci("cntsstexpirationdays",35) %>);checkPharmacyLink('st','stdiv');" class='text' id="stpockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS" property="itemId"/>]>.value">
            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=0" property="value" outputString="selected"/>>0</option>
            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=1" property="value" outputString="selected"/>>1</option>
            		<option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=2" property="value" outputString="selected"/>>2</option>
            		<option value="3" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=3" property="value" outputString="selected"/>>3</option>
            		<option value="4" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=4" property="value" outputString="selected"/>>4</option>
            		<option value="5" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=5" property="value" outputString="selected"/>>5</option>
            		<option value="6" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=6" property="value" outputString="selected"/>>6</option>
            		<option value="7" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=7" property="value" outputString="selected"/>>7</option>
            		<option value="8" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=8" property="value" outputString="selected"/>>8</option>
            		<option value="9" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STPOCKETS;value=9" property="value" outputString="selected"/>>9</option>
            	</select> 
            	<%=getTran(request,"web","pockets",sWebLanguage) %>
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>
			    <input type="hidden" id="stexpirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STEXPIRYDATE" property="itemId"/>]>.value"/>
			    <%=ScreenHelper.writeDateField("cntsstexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_STEXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			    &nbsp;&nbsp;
			    <span id="stdiv"/>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"bloodproducts","cp",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select onchange="setExpiryDate('cntscpexpirydate',<%=SH.ci("cntscpexpirationdays",5) %>);checkPharmacyLink('cp','cpdiv');" class='text' id="cppockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS" property="itemId"/>]>.value">
            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=0" property="value" outputString="selected"/>>0</option>
            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=1" property="value" outputString="selected"/>>1</option>
            		<option value="2" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=2" property="value" outputString="selected"/>>2</option>
            		<option value="3" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=3" property="value" outputString="selected"/>>3</option>
            		<option value="4" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=4" property="value" outputString="selected"/>>4</option>
            		<option value="5" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=5" property="value" outputString="selected"/>>5</option>
            		<option value="6" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=6" property="value" outputString="selected"/>>6</option>
            		<option value="7" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=7" property="value" outputString="selected"/>>7</option>
            		<option value="8" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=8" property="value" outputString="selected"/>>8</option>
            		<option value="9" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPPOCKETS;value=9" property="value" outputString="selected"/>>9</option>
            	</select> 
            	<%=getTran(request,"web","pockets",sWebLanguage) %>
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>
			    <input type="hidden" id="cpexpirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPEXPIRYDATE" property="itemId"/>]>.value"/>
			    <%=ScreenHelper.writeDateField("cntscpexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_CPEXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			    &nbsp;&nbsp;
			    <span id="cpdiv"/>
            </td>
        </tr>
        <%-- DESCRIPTION --%>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup","comment",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_CNTSLAB_COMMENT")%> class="text" cols="100" rows="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.	T" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSLAB_COMMENT" property="value"/></textarea>
            </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.cntslab",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
    <%if(tran.getTransactionId()>-1){ %>
     <!-- Show delivered blood products here -->
     <table width='100%'>
     	<tr class='admin'><td colspan="6"><%=getTran(request,"cnts","stockedbloodproducts",sWebLanguage) %></td></tr>
     	<tr class='admin2'><td colspan='6' id='tdstocked'><%=getTran(request,"web","none",sWebLanguage)%></td></tr>
     </table>
     <table width='100%'>
     	<tr class='admin'><td colspan="6"><%=getTran(request,"cnts","deliveredbloodproducts",sWebLanguage) %></td></tr>
     	<tr>
     		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","product",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","pockets",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","patient",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
     	</tr>
     	<%
     		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
     		PreparedStatement ps = conn.prepareStatement("select * from OC_BLOODDELIVERIES where OC_BLOODDELIVERY_ID=? order by OC_BLOODDELIVERY_DATE"); 
     		ps.setInt(1,Integer.parseInt(sObjectId));
     		ResultSet rs = ps.executeQuery();
     		boolean bResults = false;
     		while(rs.next()){
     			bResults=true;
     			out.println("<tr><td class='admin2'>"+ScreenHelper.formatDate(rs.getDate("OC_BLOODDELIVERY_DATE"))+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_LOCATION")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PRODUCT")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_POCKETS")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PATIENTNAME")+", "+rs.getString("OC_BLOODDELIVERY_PATIENTFIRSTNAME")+" - "+ScreenHelper.formatDate(rs.getDate("OC_BLOODDELIVERY_PATIENTDATEOFBIRTH"))+" - "+rs.getString("OC_BLOODDELIVERY_PATIENTGENDER")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PATIENTTELEPHONE")+"</td>"+
     					"</tr>");
     		}
     		rs.close();
     		ps.close();
     		conn.close();
     		if(!bResults){
     			out.println("<tr><td colspan='6'>"+getTran(request,"web","none",sWebLanguage)+"</td></tr>");
     		}
     	%>
     </table>
  <%} %>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
	function printBloodgiftLabel(){
		if(document.getElementById("cntsobjectid").value.length>0){
			if(document.getElementById("pfcpockets").value*1+document.getElementById("prppockets").value*1+document.getElementById("cgrpockets").value*1+document.getElementById("stpockets").value*1+document.getElementById("cppockets").value*1<=0){
				alert('<%=getTranNoLink("web.manage","zeropockets",sWebLanguage)%>');
			}
			else{
				window.open("<c:url value="/healthrecord/createBloodgiftLabelPdf.jsp"/>?transactiondata="+encodeURIComponent(document.getElementById("cntsobjectid").value+";<%=activePatient.personid%>; ;"+document.getElementById("pfcpockets").value+";"+document.getElementById("cntspfcexpirydate").value+";"+document.getElementById("prppockets").value+";"+document.getElementById("cntsprpexpirydate").value+";"+document.getElementById("cgrpockets").value+";"+document.getElementById("cntscgrexpirydate").value+";"+document.getElementById("stpockets").value+";"+document.getElementById("cntsstexpirydate").value+";"+document.getElementById("cppockets").value+";"+document.getElementById("cntscpexpirydate").value+";"+document.getElementById("cntsobjectid").value));	
			}
		}
		else{
			alert('<%=getTranNoLink("web.manage","datamissing",sWebLanguage)%>');
		}
	}

	<%-- SUBMIT FORM --%>
  function submitForm(){
	  if(document.getElementById('cntsobjectid').value.length>0){
	    transactionForm.saveButton.disabled = true;
	    document.getElementById("pfcexpirydate").value=document.getElementById("cntspfcexpirydate").value;
	    document.getElementById("prpexpirydate").value=document.getElementById("cntsprpexpirydate").value;
	    document.getElementById("cgrexpirydate").value=document.getElementById("cntscgrexpirydate").value;
	    document.getElementById("stexpirydate").value=document.getElementById("cntsstexpirydate").value;
	    document.getElementById("cpexpirydate").value=document.getElementById("cntscpexpirydate").value;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  	  }
	  else{
		  alert('<%=getTranNoLink("web","blooddonationreferenceismandatory",sWebLanguage)%>');
		  document.getElementById('cntsobjectid').focus();
	  }
  }
  
  function setExpiryDate(fieldname,days){
	  var day=24*3600*1000;
	  var d=document.getElementById('cntsobjectid').options[document.getElementById('cntsobjectid').selectedIndex].text.substring(0,10);
	  var expirydate = new Date(d.substring(6,10),d.substring(3,5)*1-1,d.substring(0,2),0,0,0,0);
	  expirydate.setTime(expirydate.getTime()*1+(1*days*day));
	  document.getElementById(fieldname).value=expirydate.getDate()+"/"+(expirydate.getMonth()+1)+"/"+expirydate.getFullYear();
	  document.getElementById(fieldname).onblur();
  }
  
  function checkPharmacyLink(type,divid){
	  if(document.getElementById(type+"pockets").value*1>0){
	      var params = "giftid="+document.getElementById("cntsobjectid").value+
	      "&type="+type+
	      "&quantity="+document.getElementById(type+"pockets").value;
		  var url = '<c:url value="/cnts/checkPharmacyLink.jsp"/>?ts='+new Date().getTime();
		  new Ajax.Request(url,{
			  	method: "POST",
			    parameters: params,
				onSuccess: function(resp){
				document.getElementById(divid).innerHTML = resp.responseText;
			  }
		  });
	  }
	  else{
		  document.getElementById(divid).innerHTML = '';
	  }
  }

  function checkStockedProducts(){
      var params = "giftid="+document.getElementById("cntsobjectid").value;
	  var url = '<c:url value="/cnts/checkStockedProducts.jsp"/>?ts='+new Date().getTime();
	  new Ajax.Request(url,{
		  	method: "POST",
		    parameters: params,
			onSuccess: function(resp){
			document.getElementById("tdstocked").innerHTML = resp.responseText;
		  }
	  });
  }
  
  function transferProducts(giftid,type,quantity){
	  openPopup("cnts/stockBloodProducts.jsp&giftid="+giftid+"&type="+type+"&quantity="+quantity+"&end="+document.getElementById("cnts"+type+"expirydate").value,600,100);
  }
  
  window.setTimeout('checkPharmacyLink("prp","prpdiv")',100);
  window.setTimeout('checkPharmacyLink("pfc","pfcdiv")',200);
  window.setTimeout('checkPharmacyLink("cgr","cgrdiv")',300);
  window.setTimeout('checkPharmacyLink("st","stdiv")',400);
  window.setTimeout('checkPharmacyLink("cp","cpdiv")',500);
  checkStockedProducts();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>