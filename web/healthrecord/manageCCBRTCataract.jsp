<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.cataract","select",activeUser)%>

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

        <tr>
        	<td colspan="2">
	        	<table width='100%'>
	        		<tr class='admin'>
	        			<td colspan="7"><%=getTran(request,"web","preoperative",sWebLanguage)%></td>
	        		</tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","presentingva",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","righteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PRESENTINGVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PRESENTINGVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","lefteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PRESENTINGVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PRESENTINGVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","bestcorrectedva",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","righteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_BESTCORRECTEDVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_BESTCORRECTEDVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","lefteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_BESTCORRECTEDVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_BESTCORRECTEDVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","lensexamination",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","righteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_LENSEXAM_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lensexam",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_LENSEXAM_RIGHT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin2" colspan="3">
			            	<%=getTran(request,"ccbrt.cataract","lefteye",sWebLanguage)%>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_LENSEXAM_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lensexam",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_LENSEXAM_LEFT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","othereyedisease",sWebLanguage)%></td>
			            <td class="admin2" colspan="6">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_OTHEREYEDISEASE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.othereyediseases",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_OTHEREYEDISEASE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","eyetobeoperated",sWebLanguage)%></td>
			            <td class="admin2" colspan="6">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_EYETOBEOPERATED" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.eye",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_EYETOBEOPERATED"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","preoprefraction",sWebLanguage)%></td>
			            <td class="admin2">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPREFRACTION" property="itemId"/>]>.value">
			                	<option/>
			                	<%
			                		for(double n=-10;n<=5;n+=0.25){
			                			out.println("<option value='"+n+"' "+(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPREFRACTION").equalsIgnoreCase((n>0?"+":"")+n)?"selected":"")+">"+(n>0?"+":"")+n+"</option>");
			                		}
			                	%>
			                </select>
			            </td>
			            <td class="admin2" nowrap>
			                <%=getTran(request,"ccbrt.cataract","cyl",sWebLanguage)%>
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPCYL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPCYL" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap>
			                <%=getTran(request,"ccbrt.cataract","axis",sWebLanguage)%>
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPAXIS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPAXIS" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","biometry",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap>
			                K1
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPK1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPK1" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap>
			                K2
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPK2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PREOPK2" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","targetrefraction",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select onchange='calculateDSE();' id="sphtarget" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_TARGETREFRACTION" property="itemId"/>]>.value">
			                	<option/>
			                	<%
			                		for(double n=-10;n<=5;n+=0.25){
			                			out.println("<option value='"+n+"' "+(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_TARGETREFRACTION").equalsIgnoreCase((n>0?"+":"")+n)?"selected":"")+">"+(n>0?"+":"")+n+"</option>");
			                		}
			                	%>
			                </select>
			            </td>
			            <td class="admin2" nowrap colspan='3'>
			                <%=getTran(request,"ccbrt.cataract","axiallength",sWebLanguage)%>
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_AXIALLENGTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_AXIALLENGTH" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
	        		<tr class='admin'>
	        			<td colspan="7"><%=getTran(request,"web","surgery",sWebLanguage)%></td>
	        		</tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","surgerydate",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			            	<input type="hidden" id="surgerydatefield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGERYDATE" property="itemId"/>]>.value"/>
							<%=ScreenHelper.writeDateField("surgerydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGERYDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","eyeoperated",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_EYEOPERATED" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.eye",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_EYEOPERATED"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","typeofsurgery",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGERYTYPE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.surgerytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGERYTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","iol",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOL" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.iol",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOL"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","surgeon",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGEON" property="itemId"/>]>.value">
			                	<option/>
			                	<%
			                		Connection conn = MedwanQuery.getInstance().getAdminConnection();
			                		PreparedStatement ps = conn.prepareStatement("select a.firstname,a.lastname,b.userid,c.value from admin a,users b,userparameters c where a.personid=b.personid and b.userid=c.userid and c.parameter='training' and value in ("+MedwanQuery.getInstance().getConfigString("cataractTrainings","'ophtalmologist'")+") order by lastname,firstname");
			                		ResultSet rs = ps.executeQuery();
			                		while(rs.next()){
										String userid=rs.getString("userid");
			                			out.println("<option value='"+userid+"' "+(userid.equalsIgnoreCase(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGEON"))?"selected":"")+">"+rs.getString("lastname").toUpperCase()+", "+rs.getString("firstname")+" ("+getTranNoLink("userprofile.training",rs.getString("value"),sWebLanguage)+")</option>");
			                		}
			                		rs.close();
			                		ps.close();
			                		conn.close();
			                	%>
			                </select>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","training",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_TRAINING" property="itemId"/>]>.value">
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.training",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_TRAINING"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","periopcomplications",sWebLanguage)%></td>
			            <td class="admin2" colspan='6'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PERIOPCOMPLICATIONS1" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.complications",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PERIOPCOMPLICATIONS1"),sWebLanguage,false,true) %>
			                </select>
			                &nbsp;
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PERIOPCOMPLICATIONS2" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.complications",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_PERIOPCOMPLICATIONS2"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","section",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SECTION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.section",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SECTION"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","iolpower",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOLPOWER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOLPOWER" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","capsulotomy",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_CAPSULOTOMY" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.capsulotomy",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_CAPSULOTOMY"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","suturing",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SUTURING" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.suturing",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SUTURING"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","ioltype",sWebLanguage)%></td>
			            <td class="admin2" colspan='3'>
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOLTYPE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.ioltype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_IOLTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin" nowrap>
			                <%=getTran(request,"ccbrt.cataract","numberofsutures",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap colspan='2'>
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_NUMBEROFSUTURES" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_NUMBEROFSUTURES" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
	        		<tr class='admin'>
	        			<td colspan="7"><%=getTran(request,"web","discharge",sWebLanguage)%></td>
	        			
	        			
	        		</tr>
					<tr>
	        			<td class='admin'><%=getTran(request,"web","discharge",sWebLanguage)%></td>
	        			<td class="admin2" nowrap colspan='6'>
			            	<input type="hidden" id="dischargedatefield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGEDATE" property="itemId"/>]>.value"/>
							<%=ScreenHelper.writeDateField("dischargedate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGEDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>

                
			           </td>
	        		</tr>
	        		
					<tr>
	        			
	        			<td class='admin' colspan='1'><%=getTran(request,"web","presentingvaRightEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","presentingvaLeftEye",sWebLanguage)%></td>
	        			<td class='admin' colspan='1'><%=getTran(request,"web","bestcorrectedvaRightEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","bestcorrectedvaLeftEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","iopright",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","iopleft",sWebLanguage)%></td>
	        			<td class='admin' colspan='2'><%=getTran(request,"web","causeoflowva",sWebLanguage)%></td>
	        		</tr>
		        	<tr>
			            
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_PRESENTINGVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_PRESENTINGVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						 <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_PRESENTINGVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_PRESENTINGVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_BESTCORRECTEDVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_BESTCORRECTEDVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_BESTCORRECTEDVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_BESTCORRECTEDVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_IOP_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_IOP_RIGHT" property="value"/>" class="text" size="5" >mmHg
			            </td>
						<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_IOP_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_IOP_LEFT" property="value"/>" class="text" size="5" >mmHg
			            </td>
			            <td class="admin2" colspan="2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_LOWVAREASON" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lowvareason",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_LOWVAREASON"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
					<tr>
						<td class="admin"><%=getTran(request,"ccbrt.cataract","comment",sWebLanguage)%></td>
						<td class="admin2" nowrap colspan="6">
						<textarea <%=setRightClickMini("ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_COMMENT")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_DISCHARGE_COMMENT" translate="false" property="value"/></textarea>

			            </td>
					</tr>
					<tr class='admin'>
	        			<td colspan="7"><%=getTran(request,"web","postoperative1to3weeks",sWebLanguage)%></td>
	        		</tr>
					
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","postop1to3weeks",sWebLanguage)%></td>
			            <td class="admin2" nowrap colspan="6">
			            	<input type="hidden" id="postop1to3datefield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKSDATE" property="itemId"/>]>.value"/>
							<%=ScreenHelper.writeDateField("postop1to3date", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKSDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
					</tr>
					<tr>
	        			
	        			<td class='admin' colspan='1'><%=getTran(request,"web","presentingvaRightEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","presentingvaLeftEye",sWebLanguage)%></td>
	        			<td class='admin' colspan='1'><%=getTran(request,"web","bestcorrectedvaRightEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","bestcorrectedvaLeftEye",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","dilationright",sWebLanguage)%></td>
						<td class='admin' colspan='1'><%=getTran(request,"web","dilationleft",sWebLanguage)%></td>
	        			<td class='admin' colspan='2'><%=getTran(request,"web","causeoflowva",sWebLanguage)%></td>
	        		</tr>
					<tr>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_PRESENTINGVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_PRESENTINGVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_PRESENTINGVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_PRESENTINGVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_BESTCORRECTEDVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_BESTCORRECTEDVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_BESTCORRECTEDVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_BESTCORRECTEDVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_DILATION_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_DILATION_RIGHT" property="value"/>" class="text" size="5" >
			            </td>
						<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_DILATION_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_DILATION_LEFT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" colspan="2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_LOWVAREASON" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lowvareason",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_LOWVAREASON"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
					<tr>
						<td class="admin"><%=getTran(request,"ccbrt.cataract","iop",sWebLanguage)%></td>
						<td class="admin2" nowrap colspan="1">
			                <%=getTran(request,"ccbrt.cataract","right",sWebLanguage)%>:
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_IOP_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_IOP_RIGHT" property="value"/>" class="text" size="5" >mmHg
			            </td>
						<td class="admin2" nowrap colspan="5">
			                <%=getTran(request,"ccbrt.cataract","left",sWebLanguage)%>:
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_IOP_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_IOP_LEFT" property="value"/>" class="text" size="5" >mmHg
			            </td>
					</tr>
					<tr>
						<td class="admin"><%=getTran(request,"ccbrt.cataract","comment",sWebLanguage)%></td>
						<td class="admin2" nowrap colspan="6">
						<textarea <%=setRightClickMini("ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_COMMENT")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_POSTOP1TO3WEEKS_COMMENT" translate="false" property="value"/></textarea>

			            </td>
					</tr>
	
	            </table>
	        </td>
        </tr>
        <tr>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2" style='vertical-align:top;' colspan="2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.cataract",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
function calculateDSE(){
	var target = 0;
	s= document.getElemenybyId('surgerydatefield').value;
	if(document.getElementById('surgerydatefield').value.length>0 && document.getElementById('dischargedatefield').value.length>0 ){
	document.getElementById('dischargedatefield').value.;
	}
	if(document.getElementById('sph4to11').value.length>0){
		document.getElementById('dse4to11').value=document.getElementById('sph4to11').value*1+document.getElementById('cyl4to11').value*1/2-target;
		if(document.getElementById('dse4to11').value=='NaN'){
			document.getElementById('dse4to11').value='';
		}
	}
	if(document.getElementById('sph12plus').value.length>0){
		document.getElementById('dse12plus').value=document.getElementById('sph12plus').value*1+document.getElementById('cyl12plus').value*1/2-target;
		if(document.getElementById('dse12plus').value=='NaN'){
			document.getElementById('dse12plus').value='';
		}
	}
}
</script>
<script>
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
    transactionForm.saveButton.disabled = true;
       document.getElementById("surgerydatefield").value=document.getElementById("surgerydate").value;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>