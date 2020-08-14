<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.clubfoot","select",activeUser)%>

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
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
            <td class="admin2">
                <font style="font-size: 12px;font-weight:bold;">
                <%=getTran(request,"web","age",sWebLanguage) %>: 
                <%
                	//Calculate the age of the patient on the date of transaction
                	long day = 24*3600*1000;
                	long week = day*7;
                	long month = day*30;
                	long year = day*365;
                	try{
                		long patientage=((TransactionVO)transaction).getUpdateTime().getTime()-ScreenHelper.parseDate(activePatient.dateOfBirth).getTime();
                		if(patientage<52*week){
                			out.println((patientage/week)+" "+getTran(request,"web","weeks",sWebLanguage));
                		}
                		else if(patientage<24*month){
                			out.println((patientage/month)+" "+getTran(request,"web","months",sWebLanguage));
                		}
                		else{
                			out.println((patientage/year)+" "+getTran(request,"web","years",sWebLanguage)+ " "+((patientage%year)/month)+" "+getTran(request,"web","months",sWebLanguage));
                		}
                	}
                	catch(Exception e){
                		out.println("?");
                	}
                %>
                </font>
            </td>
        </tr>

        <tr>
        	<td width="50%">
	        	<table width='100%'>
	        		<tr class='admin'>
			            <td colspan='7'><%=getTran(request,"web","history",sWebLanguage)%>&nbsp;</td>
	        		</tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","pregnancy",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="pregnancy" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_PREGNANCY")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_PREGNANCY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_PREGNANCY" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","delivery",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="delivery" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_DELIVERY")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_DELIVERY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_DELIVERY" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","postdelivery",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="postdelivery" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_POSTDELIVERY")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_POSTDELIVERY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_POSTDELIVERY" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","familyhistory",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="familyhistory" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_FAMILYHISTORY")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FAMILYHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FAMILYHISTORY" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","treatmenttodate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="treatmenttodate" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_TREATMENTTODATE")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_TREATMENTTODATE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_TREATMENTTODATE" property="value"/></textarea>
			            </td>
			        </tr>
	        		<tr class='admin'>
			            <td colspan='7'><%=getTran(request,"web","examination",sWebLanguage)%>&nbsp;</td>
	        		</tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","general",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="general" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_GENERAL")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_GENERAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_GENERAL" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","spine",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="spine" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_SPINE")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_SPINE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_SPINE" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","hips",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="hips" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_HIPS")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_HIPS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_HIPS" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","upperlimb",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="upperlimb" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_UPPERLIMB")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_UPPERLIMB" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_UPPERLIMB" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","lowerlimb",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="lowerlimb" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_LOWERLIMB")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_LOWERLIMB" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_LOWERLIMB" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","other",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="other" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_OTHER")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_OTHER" property="value"/></textarea>
			            </td>
			        </tr>
	            </table>
	        </td>
	        <%-- DIAGNOSES --%>
	    	<td valign='top'>
		      	<table width='100%'>
	        		<tr class='admin'>
			            <td colspan='7'><%=getTran(request,"web","additionalnotes",sWebLanguage)%>&nbsp;</td>
	        		</tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","notes",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="notes" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","followup",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="4">
			            	<select class='text' id='frequency' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='1'>1</option>
			            		<option value='2'>2</option>
			            		<option value='3'>3</option>
			            		<option value='4'>4</option>
			            		<option value='5'>5</option>
			            		<option value='6'>6</option>
			            		<option value='7'>7</option>
			            		<option value='8'>8</option>
			            		<option value='9'>9</option>
			            		<option value='10'>10</option>
			            		<option value='11'>11</option>
			            		<option value='12'>12</option>
			            	</select>
			            	<select class='text' id='frequencytype' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='week'><%=getTran(request,"web","weeks",sWebLanguage) %></option>
			            		<option value='month'><%=getTran(request,"web","months",sWebLanguage) %></option>
			            		<option value='year'><%=getTran(request,"web","year",sWebLanguage) %></option>
			            	</select>
			                <input type="hidden" id="ccbrtdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FOLLOWUPDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("followupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			            <td class="admin2" colspan="2">
			            	<a href="javascript:openPopup('planning/findPlanning.jsp&FindDate='+document.getElementById('followupdate').value+'&isPopup=1&FindUserUID=<%=activeUser.userid %>',1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
			            </td>
			        </tr>
			    </table>
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
        <tr>
        	<td colspan='2'>
		      	<table width='100%'>
	        		<tr class='admin'>
			            <td colspan='11'><%=getTran(request,"web","initialmetrics",sWebLanguage)%>&nbsp;</td>
	        		</tr>
	        		<tr>
	        			<td class='admin'/>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","pc",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","re",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","eh",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","hindfootscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","clb",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","mc",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","lht",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","midfootscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","totalscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","treatment",sWebLanguage) %></td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","rightfoot",sWebLanguage)%>&nbsp;</td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="re_pc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.pc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td>
			            	<select onchange='calculatescores()'  style='width: 60px' id="re_re" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.re",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()'  style='width: 60px' id="re_eh" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.he",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='re_hindfootscore'/>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="re_clb"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.clb",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="re_mc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.mc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="re_lht"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.lht",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='re_midfootscore'/>
			            </td>
			            <td class='admin2'>
			            	<span id='re_totalfootscore'/>
			            </td>
			            <td >
			            	<select  style='width: 60px' id="re_treatment"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_TREATMENT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.treatment",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_TREATMENT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","leftfoot",sWebLanguage)%>&nbsp;</td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_pc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.pc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_re"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.re",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_eh"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.he",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='le_hindfootscore'/>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_clb" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.clb",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_mc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.mc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select onchange='calculatescores()' style='width: 60px' id="le_lht" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.lht",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='le_midfootscore'/>
			            </td>
			            <td class='admin2'>
			            	<span id='le_totalfootscore'/>
			            </td>
			            <td >
			            	<select  style='width: 60px' id="le_treatment" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_TREATMENT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.treatment",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_TREATMENT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
	        		</tr>
			    </table>
			</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.clubfoot",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
function calculatescores(){
	if(document.getElementById('re_pc').value.length>0 && document.getElementById('re_re').value.length>0 && document.getElementById('re_eh').value.length>0){
		document.getElementById('re_hindfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_pc').value*1+document.getElementById('re_re').value*1+document.getElementById('re_eh').value*1)+'</font>';
	}
	else{
		document.getElementById('re_hindfootscore').innerHTML='';
	}
	if(document.getElementById('re_clb').value.length>0 && document.getElementById('re_mc').value.length>0 && document.getElementById('re_lht').value.length>0){
		document.getElementById('re_midfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_clb').value*1+document.getElementById('re_mc').value*1+document.getElementById('re_lht').value*1)+'</font>';
	}
	else{
		document.getElementById('re_midfootscore').innerHTML='';
	}
	if(document.getElementById('re_hindfootscore').innerHTML.length>0 && document.getElementById('re_midfootscore').innerHTML.length>0){
		document.getElementById('re_totalfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_pc').value*1+document.getElementById('re_re').value*1+document.getElementById('re_eh').value*1+document.getElementById('re_clb').value*1+document.getElementById('re_mc').value*1+document.getElementById('re_lht').value*1)+'</font>';
	}
	if(document.getElementById('le_pc').value.length>0 && document.getElementById('le_re').value.length>0 && document.getElementById('le_eh').value.length>0){
		document.getElementById('le_hindfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_pc').value*1+document.getElementById('le_re').value*1+document.getElementById('le_eh').value*1)+'</font>';
	}
	else{
		document.getElementById('le_hindfootscore').innerHTML='';
	}
	if(document.getElementById('le_clb').value.length>0 && document.getElementById('le_mc').value.length>0 && document.getElementById('le_lht').value.length>0){
		document.getElementById('le_midfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_clb').value*1+document.getElementById('le_mc').value*1+document.getElementById('le_lht').value*1)+'</font>';
	}
	else{
		document.getElementById('le_midfootscore').innerHTML='';
	}
	if(document.getElementById('le_hindfootscore').innerHTML.length>0 && document.getElementById('le_midfootscore').innerHTML.length>0){
		document.getElementById('le_totalfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_pc').value*1+document.getElementById('le_re').value*1+document.getElementById('le_eh').value*1+document.getElementById('le_clb').value*1+document.getElementById('le_mc').value*1+document.getElementById('le_lht').value*1)+'</font>';
	}
}
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  <%-- SUBMIT FORM --%>
  function calculateNextDate(){
	  var nextdate = new Date();
	  if(document.getElementById('frequencytype').value.length>0 && document.getElementById('frequency').value.length>0){
		  if(document.getElementById('frequencytype').value=='month'){
			  nextdate.setMonth(nextdate.getMonth()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='year'){
			  nextdate.setYear(nextdate.getFullYear()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='week'){
			  nextdate.setDate(nextdate.getDate()+document.getElementById('frequency').value*7);
		  }
		  document.getElementById('followupdate').value=("0"+nextdate.getDate()).substring(("0"+nextdate.getDate()).length-2,("0"+nextdate.getDate()).length)+"/"+("0"+(nextdate.getMonth()+1)).substring(("0"+(nextdate.getMonth()+1)).length-2,("0"+(nextdate.getMonth()+1)).length)+"/"+nextdate.getFullYear();
  	 }
  }
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTOrthoRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}

  function submitForm(){
	  document.getElementById("ccbrtdate").value=document.getElementById("followupdate").value;
      transactionForm.saveButton.disabled = true;
 		    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  }
  calculatescores();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>