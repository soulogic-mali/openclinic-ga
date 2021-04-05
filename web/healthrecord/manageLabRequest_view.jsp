<%@page import="be.mxs.common.util.system.*,be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.openclinic.medical.*,
                java.util.Vector,
                java.util.Hashtable,
                java.util.Collections"%>
<%@page import="be.openclinic.medical.Labo"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.labrequest","select",activeUser)%>
<%=sJSSORTTABLE%>
<%=sJSEMAIL%>
<%
    // LabAnalyses are saved by SaveLabAnalysesAction after the transaction itself has been saved.
    // That duality makes this code might appear complicated.
%>

<%!
    //--- ADD LABANALYSIS -------------------------------------------------------------------------
    private String addLA(int iTotal, String serverId, String transactionId, String sCode, String sType,
                         String sLabel, String sComment, String sMonster, String sResultValue,
                         String sResultModifier, String sResultRefMin, String sResultRefMax, String sWebLanguage){
        // translate comment
        if(sComment.trim().length() > 0){
            sComment = getTranNoLink("web.analysis",sComment,sWebLanguage);
        }

        // alternate row-style; 
        String sClass;
        String abnormal = MedwanQuery.getInstance().getConfigString("abnormalModifiers","*+*++*+++*-*--*---*h*hh*hhh*l*ll*lll*");
        boolean bAbnormal = (sResultValue.length()>0 && !sResultValue.equalsIgnoreCase("?") && abnormal.toLowerCase().indexOf("*"+checkString(sResultModifier).toLowerCase()+"*")>-1);
        if(bAbnormal){
        	//red when abnormal
            sClass = "redbold";
        }
        else if(sResultValue.equalsIgnoreCase("?") || checkString(sResultValue).length()==0){
        	//grey when waiting 
            sClass = "listDisabled1";
        }
        else{
            sClass = "listbold";
        }

        String detailsTran = getTran(null,"web","showDetails",sWebLanguage);
        StringBuffer buf = new StringBuffer();
        buf.append("<tr id='rowLA"+iTotal+"' class='"+sClass+"' title='"+detailsTran+"' onmouseover=\"this.style.cursor='hand';\" onmouseout=\"this.style.cursor='default';\">")
            .append("<td width='1%' nowrap style='text-align: right'>")
             .append("<img style='text-align: right' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick=\"deleteLA(rowLA"+iTotal+",'"+sMonster+"');\" title='").append(getTranNoLink("Web","delete",sWebLanguage)).append("'>")
            .append("</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+sCode+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+sType+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+sLabel+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+sResultValue+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+(checkString(sResultRefMin).length()==0 && checkString(sResultRefMax).length()==0?"":"["+checkString(sResultRefMin)+(checkString(sResultRefMin).length()*checkString(sResultRefMax).length()>0?" - ":"")+checkString(sResultRefMax)+"] ")+checkString(sResultModifier)+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+sComment+"</td>")
            .append("<td onClick=\"showResultDetails('"+serverId+"','"+transactionId+"','"+sCode+"');\">&nbsp;"+getTran(null,"labanalysis.monster",sMonster,sWebLanguage)+"</td>")
           .append("</tr>");

        return buf.toString();
    }
%>
<script>
  var labAnalysisArray = new Array();
  var selectedMonsters = new Array();
  var labanalysisCodes = new Array();
</script>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
  <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

  <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
  <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
  <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>

  <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
  <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

  <input type="hidden" name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
  <input type="hidden" name="LAOther" value=""/>
  <input type="hidden" name="Action" value=""/>

<%
    // variables
    String sTmpCode, sTmpComment, sTmpModifier, sTmpResultUnit, sTmpResultValue, sTmpResult,
            sTmpType = "", sTmpLabel = "", sTmpMonster = "", sTmpRefMin="", sTmpRefMax="", sTmpServerId, sTmpTransactionId;
    StringBuffer sScriptsToExecute = new StringBuffer();
    TransactionVO tran = (TransactionVO)transaction;
    Hashtable labAnalyses = new Hashtable();
    RequestedLabAnalysis labAnalysis;
    String sLA = "", sDivLA = "";
    int iTotal = 1;

    // get chosen labanalyses from existing transaction.
    if (tran != null && (tran.getTransactionId().intValue() > 0 || MedwanQuery.getInstance().getConfigInt("enableSlaveServer",0)==1)){
        labAnalyses = RequestedLabAnalysis.getLabAnalysesForLabRequest(tran.getServerId(), tran.getTransactionId().intValue());
    }

    // sort analysis-codes
    Vector codes = new Vector(labAnalyses.keySet());
    Collections.sort(codes);
	Hashtable hLabRequestData = Labo.getLabRequestDefaultData(sWebLanguage);

    // run thru saved labanalysis
    for(int i = 0; i < codes.size(); i++){
        sTmpCode = (String) codes.get(i);
        labAnalysis = (RequestedLabAnalysis) labAnalyses.get(sTmpCode);

        sTmpServerId = labAnalysis.getServerId();
        sTmpTransactionId = labAnalysis.getTransactionId();
        sTmpComment = labAnalysis.getResultComment();
        sTmpModifier = labAnalysis.getResultModifier();
        sTmpResultUnit = getTranNoLink("labanalysis.resultunit", labAnalysis.getResultUnit(), sWebLanguage);
        sTmpResult = "";
        sTmpRefMin = labAnalysis.getResultRefMin();
        sTmpRefMax = labAnalysis.getResultRefMax();
        
        // get resultvalue
        if(labAnalysis.getFinalvalidation()>0){
            sTmpResultValue = labAnalysis.getResultValue();
        	LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(labAnalysis.getAnalysisCode());
        	if(analysis!=null){
	        	if(analysis.getEditor().equalsIgnoreCase("antivirogram")){
	        		String[] arvs = sTmpResultValue.split(";");
	        		sTmpResultValue="";
	        		for(int n=0;n<arvs.length;n++){
	        			if(arvs[n].split("=").length>1){
	        				if(sTmpResultValue.length()>0){
	        					sTmpResultValue+=", ";
	        				}
	        				try{
	        					sTmpResultValue+=getTran(request,"arv"+arvs[n].split("=")[0].split("\\.")[0],arvs[n].split("=")[0].split("\\.")[1],sWebLanguage)+": "+getTran(request,"arvresistance",arvs[n].split("=")[1],sWebLanguage);
	        				}
	        				catch(Exception e){}
	        			}
	        		}
	        	}
            	else if(analysis.getEditor().equalsIgnoreCase("antibiogram")||analysis.getEditor().equalsIgnoreCase("antibiogramnew")){
            		sTmpResultValue="";
                	Map ab = RequestedLabAnalysis.getAntibiogrammes(labAnalysis.getServerId()+"."+labAnalysis.getTransactionId()+"."+labAnalysis.getAnalysisCode());
                	if(ab.get("germ1")!=null && !(ab.get("germ1")+"").equalsIgnoreCase("")){
                		sTmpResultValue+=ab.get("germ1");
                	}
                	if(ab.get("germ2")!=null && !(ab.get("germ2")+"").equalsIgnoreCase("")){
        				if(sTmpResultValue.length()>0){
        					sTmpResultValue+="<br/>";
        				}
        				sTmpResultValue+=ab.get("germ2");
                	}
                	if(ab.get("germ3")!=null && !(ab.get("germ3")+"").equalsIgnoreCase("")){
        				if(sTmpResultValue.length()>0){
        					sTmpResultValue+="<br/>";
        				}
        				sTmpResultValue+=ab.get("germ3");
                	}
            	}
        	}
            sTmpResult = sTmpResultValue+" "+sTmpResultUnit;
        }
        else{
            sTmpResultValue = "?";
        	LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(labAnalysis.getAnalysisCode());
        	if(analysis!=null){
	        	if(analysis.getEditor().equalsIgnoreCase("calculated")){
	        		String expression = analysis.getEditorparametersParameter("OP").split("\\|")[0];
	        		Hashtable pars = new Hashtable();
	        		if(analysis.getEditorparameters().split("@").length>0){
	        			String[] sPars = analysis.getEditorparametersParameter("OP").split("\\|")[1].replaceAll(" ", "").split(",");
	        			for(int n=0;n<sPars.length;n++){
	        				try{
	        					pars.put(sPars[n],((RequestedLabAnalysis)labAnalyses.get(sPars[n].replaceAll("@", ""))).getResultValue());
	        				}
	        				catch(Exception p){}
	        			}
	        		}
					try{
						sTmpResultValue = Evaluate.evaluate(expression, pars,analysis.getEditorparametersParameter("OP").split("\\|").length>2?Integer.parseInt(analysis.getEditorparametersParameter("OP").replaceAll(" ", "").split("\\|")[2]):5);
			            sTmpResult = sTmpResultValue+" "+sTmpResultUnit;
					}
					catch(Exception e){
						sTmpResultValue = "?";
						sTmpResult = sTmpResultValue;
					}
	        	}
	        	else {
					sTmpResult = sTmpResultValue;
	        	}
        	}
        	else{
				sTmpResult = sTmpResultValue;
        	}
        }

        // get default-data from DB
		if(hLabRequestData!=null){
	        Hashtable hLabRequestDataDetail = (Hashtable)hLabRequestData.get(sTmpCode);
	
	        if (hLabRequestDataDetail != null) {
	            sTmpType = (String) hLabRequestDataDetail.get("labtype");
	            sTmpLabel = (String) hLabRequestDataDetail.get("OC_LABEL_VALUE");
	            sTmpMonster = (String) hLabRequestDataDetail.get("monster");
	        }
		}
        // translate labtype
        if (sTmpType.equals("1")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.blood", sWebLanguage);
        else if (sTmpType.equals("2")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.urine", sWebLanguage);
        else if (sTmpType.equals("3")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.other", sWebLanguage);
        else if (sTmpType.equals("4")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.stool", sWebLanguage);
        else if (sTmpType.equals("5")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.sputum", sWebLanguage);
        else if (sTmpType.equals("6")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.smear", sWebLanguage);
        else if (sTmpType.equals("7")) sTmpType = getTran(request,"Web.occup", "labanalysis.type.liquid", sWebLanguage);

        // compose sLA
        sLA += "rowLA"+iTotal+"="+sTmpCode+"@"+sTmpComment+"$";
        sDivLA += addLA(iTotal, sTmpServerId, sTmpTransactionId, sTmpCode, sTmpType, sTmpLabel, sTmpComment, sTmpMonster, sTmpResult, sTmpModifier, sTmpRefMin, sTmpRefMax, sWebLanguage);
        sScriptsToExecute.append("addToMonsterList('"+(sTmpMonster.length()>0?getTranNoLink("labanalysis.monster",sTmpMonster,sWebLanguage):"")+"');");
        iTotal++;
    }

    // supported languages
    String supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages");
    if (supportedLanguages.length() == 0) supportedLanguages = "nl,fr";
    supportedLanguages = supportedLanguages.toLowerCase();
%>

<%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
<%=contextHeader(request,sWebLanguage)%>

<%-- DATE --%>
<table width="100%" class="list" cellspacing="1">
    <tr>
        <td class="admin" width="<%=sTDAdminWidth%>">
            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
        </td>
        <td class="admin2">
            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" onBlur='checkDate(this)'>
            <script>writeTranDate();</script>&nbsp;&nbsp;&nbsp;
            <input type="button" class="button" name="ButtonSearchLA" value="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick='openSearchWindow();'/>
            <input type="button" class="button" name="ButtonQuickList" value="<%=getTranNoLink("Web","quicklist",sWebLanguage)%>" onclick='openQuickListWindow();'/>
        </td>
    </tr>
</table>

<br>

<%-- LABANALYSIS --------------------------------------------------------------------------------%>
<table id="tblLA" width="100%" cellspacing="1" class="sortable">
    <%-- HEADER --%>
    <tr class="admin">
        <td width="18"></td>

        <%-- default data --%>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.code",sWebLanguage)%></td>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.type",sWebLanguage)%></td>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.name",sWebLanguage)%></td>

        <%-- result data --%>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.resultvalue",sWebLanguage)%></td>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.refrange",sWebLanguage)%></td>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.comment",sWebLanguage)%></td>
        <td><%=getTran(request,"Web.manage","labanalysis.cols.monster",sWebLanguage)%></td>
    </tr>

    <%-- chosen LabAnalysis --%>
    <%=sDivLA%>
</table>

<%-- delete all --%>
<a href="javascript:deleteAllLA();"><%=getTran(request,"Web.manage","deleteAllLabAnalysis",sWebLanguage)%></a>

<br><br>

<table width="100%" class="list" cellspacing="1">
    <%-- MONSTERS --%>
    <tr>
        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web.Occup","labrequest.monsters",sWebLanguage)%></td>
        <td class="admin2">
            <input type="text" class="text" size="80" id="monsterList" READONLY>
        </td>
    </tr>

    <%-- MONSTER HOUR --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web.Occup","labrequest.hour",sWebLanguage)%></td>
        <td class="admin2">
            <input id="hour" size="5" type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_HOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_HOUR" property="value"/>" onblur="limitLength(this);"/>
            <a href="javascript:setCurrentTime('hour');"><img src="<c:url value="/_img/icons/icon_compose.png"/>" class="link" style='vertical-align:bottom' title="<%=getTranNoLink("web","currenttime",sWebLanguage)%>" border="0"/></a>
            <%if(!activePatient.gender.equalsIgnoreCase("m")){ %>
	        &nbsp;&nbsp;&nbsp;<input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PREGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PREGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","patient.pregnant",sWebLanguage)%>
	        <%}%>
	        &nbsp;&nbsp;&nbsp;<input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EXTERNAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EXTERNAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","patient.externe",sWebLanguage)%>
        </td>
    </tr>

    <%-- DOCUMENT ID --%>
    <% if(((TransactionVO)transaction).getTransactionId()>0){ %>
	    <tr>
	        <td class="admin"><%=getTran(request,"Web","documentid",sWebLanguage)%></td>
	        <td class="admin2">
	            <b><%=((TransactionVO)transaction).getServerId()+"."+((TransactionVO)transaction).getTransactionId() %></b>
	        </td>
	    </tr>
	    <%-- BARCODE IDS --%>
	    <% 
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    	Vector barcodeids = Labo.getLabBarcodes(((TransactionVO)transaction).getServerId()+"."+((TransactionVO)transaction).getTransactionId(), false, conn);
	    	if(barcodeids.size()>0){
		    %>
		    <tr>
		        <td class="admin"><%=getTran(request,"Web","barcodeids",sWebLanguage)%></td>
		        <td class="admin2">
		            <%
		            	for(int n=0;n<barcodeids.size();n++){
		            		String barcode = ((String)barcodeids.elementAt(n)).split(";")[0];
		            		String sample=((String)barcodeids.elementAt(n)).split(";")[1];
		            		if(n>0){
		            			out.println(" - ");
		            		}
		            		out.println("<a href='javascript:printLabel(\""+sample+"\")'>"+barcode+"</a> [<b>"+getTran(request,"labanalysis.monster",sample.replaceAll(sample.split("\\.")[0]+"."+sample.split("\\.")[1]+".",""),sWebLanguage)+"</b>]");
		            	}
		            %>
		        </td>
		    </tr>
		    <%
		    }
		    Vector hl7results=Labo.getHL7Results(((TransactionVO)transaction).getTransactionId(), conn);
		    if(hl7results.size()>0){
			    %>
			    <tr>
			        <td class="admin"><%=getTran(request,"Web","receivedhl7messages",sWebLanguage)%></td>
			        <td class="admin2">
			            <%
			            	for(int n=0;n<hl7results.size();n++){
			            		String msgid = ((String)hl7results.elementAt(n)).split(";")[0];
			            		String date=((String)hl7results.elementAt(n)).split(";")[1];
			            		if(n>0){
			            			out.println(" - ");
			            		}
			            		out.println("<a href='javascript:printHL7Message(\""+msgid+"\")'>"+msgid+"</a> [<b>"+date+"</b>]");
			            	}
			            %>
			        </td>
			    </tr>
			    <%
		    }
		    conn.close();
	    } 
	%>

    <%-- PRESCRIBER --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","internalprescriber",sWebLanguage)%></td>
        <td class="admin2">
           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_INTERNALPRESCRIBER" property="itemId"/>]>.value' id='internalprescriber'>
           		<option value=''></option>
	            <%
	            	Vector users = UserParameter.getUserIdsExtended("invoicingcareprovider", "on");
	            	SortedSet usernames = new TreeSet();
	            	for(int n=0;n<users.size();n++){
	            		usernames.add(users.elementAt(n));
	            	}
	            	//Determine selected value
	            	String sSelectedValue=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_INTERNALPRESCRIBER");
	            	if(sSelectedValue.length()==0){
	            		sSelectedValue=activeUser.userid;
	            	}
	            	Iterator i = usernames.iterator();
	            	while(i.hasNext()){
	            		String u=(String)i.next();
	            		out.println("<option value='"+u.split(";")[2]+"'"+(sSelectedValue.equals(u.split(";")[2])?" selected":"")+">"+u.split(";")[0].toUpperCase()+", "+u.split(";")[1]+" ("+u.split(";")[2]+")</option>");
	            	}
	            %>
           	</select>
        </td>
    </tr>
    <%-- PRESCRIBER --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","externalprescriber",sWebLanguage)%></td>
        <td class="admin2">
            <input type='text' id="prescriber" <%=setRightClick(session,"ITEM_TYPE_LAB_PRESCRIBER")%> class="text" size="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PRESCRIBER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PRESCRIBER" property="value"/>"/>
        </td>
    </tr>

    <%-- STOCKAGE ECHANTILLON --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","sample.storage",sWebLanguage)%></td>
        <td class="admin2">
            <%=getTran(request,"Web","sample.storage.freezer",sWebLanguage)%>: <input type='text' id="samplestorage" <%=setRightClick(session,"ITEM_TYPE_LAB_SAMPLE_STORAGE_FREEZER")%> class="text" size="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_FREEZER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_FREEZER" property="value"/>"/>
            <%=getTran(request,"Web","sample.storage.box",sWebLanguage)%>: <input type='text' id="samplestorage" <%=setRightClick(session,"ITEM_TYPE_LAB_SAMPLE_STORAGE_BOX")%> class="text" size="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_BOX" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_BOX" property="value"/>"/>
            <%=getTran(request,"Web","sample.storage.position",sWebLanguage)%>: <input type='text' id="samplestorage" <%=setRightClick(session,"ITEM_TYPE_LAB_SAMPLE_STORAGE_POSITION")%> class="text" size="20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_POSITION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SAMPLE_STORAGE_POSITION" property="value"/>"/>
        </td>
    </tr>

    <%-- CLINICAL INFORMATION --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","clinical.information",sWebLanguage)%></td>
        <td class="admin2">
            <textarea id="clinicalinformation" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_LAB_CLINICAL_INFORMATION")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_CLINICAL_INFORMATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_CLINICAL_INFORMATION" property="value"/></textarea>
        </td>
    </tr>

    <%-- COMMENT --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","conclusion",sWebLanguage)%></td>
        <td class="admin2">
            <textarea id="conclusion" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_LAB_COMMENT")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_COMMENT" property="value"/></textarea>
        </td>
    </tr>

    <%-- REMARK --%>
    <tr>
        <td class="admin"><%=getTran(request,"lab","comment",sWebLanguage)%></td>
        <td class="admin2">
            <textarea id="remark" onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_LAB_REMARK")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_REMARK" property="value"/></textarea>
        </td>
    </tr>
	<%
		if(MedwanQuery.getInstance().getConfigString("edition").equalsIgnoreCase("bloodbank")){
	%>
	    <%-- Bloodgift reference --%>
	    <%
	        ItemVO item = ((TransactionVO)transaction).getItem(sPREFIX+"ITEM_TYPE_LAB_OBJECTID");
	        String sObjectId = "";
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
	        </td>
	    </tr>
	<%
		}
	%>
    <%-- URGENCY --%>
    <%
        ItemVO item = ((TransactionVO)transaction).getItem(sPREFIX+"ITEM_TYPE_LAB_URGENCY");
        String sUrgency = "";
        if(item!=null) sUrgency = item.getValue();
    %>
    <tr>
        <td class="admin"><%=getTran(request,"Web.Occup","urgency",sWebLanguage)%></td>
        <td class="admin2">
            <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY" property="itemId"/>]>.value">
                <option><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                <%=ScreenHelper.writeSelect(request,"labrequest.urgency",sUrgency,sWebLanguage)%>
            </select>
        </td>
    </tr>

    <%-- SMS --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","warnSms",sWebLanguage)%></td>
        <td class="admin2" >
	        <%
				String labSMS="";
				if(SH.ci("useraddressforlabsms",1)==1){
					labSMS=UserParameter.getParameter(activeUser.userid,"lastLabSMS");
				}
				else{
					labSMS=SH.c(activePatient.getActivePrivate().mobile);
				}
	    		if(SH.ci("autofilllabsms",0)==1){
	    			((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS").setValue(labSMS);
	    		}
	        %>
            <input type='text' id="labsms" <%=setRightClick(session,"ITEM_TYPE_LAB_SMS")%> class="text" size="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS" property="value"/>"/>
	        <%
	        	if(tran.getTransactionId()<=0){
	        		if(checkString(labSMS).length()>0){
	        			%><a href="javascript:set('labsms','<%=labSMS %>')"><img class='link' src='<c:url value="/_img/themes/default/valid.gif"/>'/> <%=labSMS%></a><%
	        		}
	        	}
	        %>
	        <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS_ABNORMALONLY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS_ABNORMALONLY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","abnormal.only",sWebLanguage)%>
        </td>
    </tr>
    <script>
      function set(fieldid,val){
        document.getElementById(fieldid).value=val
      }
    </script>

    <%-- EMAIL --%>
    <tr>
        <td class="admin"><%=getTran(request,"Web","warnEmail",sWebLanguage)%></td>
        <td class="admin2">
        	<%
	    		String labMail="";
	    		if(SH.ci("useraddressforlabmail",1)==1){
	        		labMail=UserParameter.getParameter(activeUser.userid,"lastLabEmail");
	    		}
	    		else{
	        		labMail=SH.c(activePatient.getActivePrivate().email);
	    		}
	    		if(SH.ci("autofilllabmail",0)==1){
	    			((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL").setValue(labMail);
	    		}
        	%>
            <input type='text' id="labmail" <%=setRightClick(session,"ITEM_TYPE_LAB_EMAIL")%> class="text" size="50" onBlur="checkEmailAddress(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL" property="value"/>"/>
	        <%
	        	if(tran.getTransactionId()<=0){
	        		if(checkString(labMail).length()>0){
	        			%><a href="javascript:set('labmail','<%=labMail %>')"><img class='link' src='<c:url value="/_img/themes/default/valid.gif"/>'/> <%=labMail%></a><%
	        		}
	        	}
	        %>
	        <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL_ABNORMALONLY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL_ABNORMALONLY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"> <%=getTran(request,"web","abnormal.only",sWebLanguage)%>
        </td>
    </tr>

    <%-- hidden fields --%>
    <input type="hidden" name="selectedLabCodes" value="">

    <%-- BUTTONS --------------------------------------------------------------------------------%>
    <tr>
        <td class="admin"/>
        <td class="admin2">
            <%
                String sPrintLanguage = sWebLanguage;
                if(activeUser.getAccessRight("occup.labrequest.add") || activeUser.getAccessRight("occup.labrequest.edit")){
                    // only display print-button and language-selector if transaction is saved
                    if(((TransactionVO)transaction).getTransactionId().intValue() > 0){
                        %>
                            <input class="button" type="button" name="showStatus" value="<%=getTranNoLink("Web","details",sWebLanguage)%>" onclick="showRequest(<bean:write name="transaction" scope="page" property="serverId"/>,<bean:write name="transaction" scope="page" property="transactionId"/>);">
                            <input class="button" type="button" name="receive" value="<%=getTranNoLink("Web","receive",sWebLanguage)%>" onclick="receiveSamples();">&nbsp;
                        <%
                    }

                    %>
                        <input type='button' accesskey="<%=ScreenHelper.getAccessKey(getTranNoLink("accesskey","save",sWebLanguage))%>" style='display: none' onclick="doSave(false);"/>
                        <input type='button' class="button" name="labSaveButton" id="labSaveButton" onclick="doSave(false);" value='<%=getTran(null,"accesskey","save",sWebLanguage)%>'/>
                        <input class="button" type="button" name="printLabelsButton" value="<%=getTranNoLink("Web","saveandprintlabels",sWebLanguage)%>" onclick="doSave(true)"/>&nbsp;
               <%}
            %>
            <input class="button" type="button" name="backButton" value="<%=getTranNoLink("Web","back",sWebLanguage)%>" onclick="doBack();">
            <input type="hidden" name="monsterids"/>
        </td>
    </tr>
</table>

<input type="hidden" name="exitmessage"/>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>

  var maxSelectedLabAnalysesAlerted = false;
  var iIndexLA = <%=iTotal%>;
  var sLA = "<%=sLA%>";

  function doReferral(){
	  var tranID = '<%=checkString(request.getParameter("be.mxs.healthrecord.transaction_id"))%>';
	  var serverID = '<%=checkString(request.getParameter("be.mxs.healthrecord.server_id"))%>';
	  openPopup('healthrecord/sendTransactionSelect.jsp&transactionId='+tranID+'&serverId='+serverID+'&ts=<%=getTs()%>',500,500);
  }
  
  <%-- CHECK EMAIL ADDRESS --%>
  function checkEmailAddress(inputField){
    if(inputField.value.length > 0){
      if(!validEmailAddress(inputField.value)){
    	alertDialog("web","invalidemailaddress");
        inputField.focus();
      }
    }
  }
  
  <%-- SHOW REQUEST --%>
  function showRequest(serverid,transactionid){
    window.open("<c:url value='/labos/manageLabResult_view.jsp'/>?ts=<%=getTs()%>&show."+serverid+"."+transactionid+"=1","Popup"+new Date().getTime(),"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=1024,height=600,menubar=no");
  }

  <%
      // set time when creating the labRequest
      if(tran.getTransactionId().intValue() < 0){
          %>setCurrentTime('hour');<%
      }

      int maxSelectedLabAnalyses;
      if(MedwanQuery.getInstance().getConfigString("maxSelectedLabAnalyses").length() == 0){
          %>var maxSelectedLabAnalyses = 10;<%
      }
      else{
          try{
              maxSelectedLabAnalyses = Integer.parseInt(MedwanQuery.getInstance().getConfigString("maxSelectedLabAnalyses"));
              %>var maxSelectedLabAnalyses = <%=maxSelectedLabAnalyses%>;<%
          }
          catch(Exception e){
              Debug.println("ERROR : Invalid value for configstring 'maxSelectedLabAnalyses'.");
              %>var maxSelectedLabAnalyses = 10;<%
          }
      }
  %>

  <%-- OPEN SEARCH WINDOW --%>
  function openSearchWindow(){
    maxSelectedLabAnalysesAlerted = false;
    openPopup("/_common/search/searchLabAnalysisForPatient.jsp"+
    		  "&VarID=LabID&VarType=LabType&VarCode=LabCode&VarText=LabLabel"+
              "&selectedLabCodes="+transactionForm.selectedLabCodes.value,600,460);
  }

  function openQuickListWindow(){
    openPopup("/labos/quicklist.jsp&selectedLabCodes="+transactionForm.selectedLabCodes.value,800,600);
  }

  <%-- CREATE OFFICIAL PDF --%>
  function createOfficialPdf(printLang){
    var tranID   = "<%=checkString(request.getParameter("be.mxs.healthrecord.transaction_id"))%>";
    var serverID = "<%=checkString(request.getParameter("be.mxs.healthrecord.server_id"))%>";

    window.location.href = "<%=sCONTEXTPATH%>/healthrecord/createOfficialPdf.jsp?tranAndServerID_1="+tranID+"_"+serverID+"&PrintLanguage="+printLang+"&ts=<%=getTs()%>";

    window.opener.document.transactionForm.labSaveButton.disabled = false;
    window.opener.document.transactionForm.SaveAndPrint.disabled = false;
    window.opener.bSaveHasNotChanged = true;
    window.opener.location.reload();
  }

  <%
      boolean printPDF = checkString(request.getParameter("printPDF")).equals("true");
      if(printPDF){
          %>createOfficialPdf('<%=sPrintLanguage%>');<%
      }
  %>

  <%-- DO SAVE --%>
  function doSave(printDocument){
	  //First check mandatory fields
		<%if(MedwanQuery.getInstance().getConfigString("mandatoryLabOrderFields","").contains("prescriber")){%>
		if(document.getElementById('prescriber').value.length==0){
		    alertDialog("web","datamissing");
		    document.getElementById('prescriber').focus();
		    return;
		}
	<%}
	if(MedwanQuery.getInstance().getConfigString("mandatoryLabOrderFields","").contains("clinicalinformation")){%>
	if(document.getElementById('clinicalinformation').value.length==0){
	    alertDialog("web","datamissing");
	    document.getElementById('clinicalinformation').focus();
	    return;
	}
	<%}%>
	if(tblLA.rows.length > 1){
      if(printDocument==true){
        document.getElementsByName('exitmessage')[0].value='printlabels';
      }

      doSubmit();
    }
    else{
      alertDialog("web.manage","selectAtLeastOneAnalysis");
    }
  }

  <%-- DO PRINT --%>
  function doPrint(){
    var tranID    = document.getElementById('transactionId').value;
    var serverID  = document.getElementById('serverId').value;
    var printLang = transactionForm.PrintLanguage.value;

    var url = "<c:url value='/healthrecord/createOfficialPdf.jsp'/>?tranAndServerID_1="+tranID+"_"+serverID+"&PrintLanguage="+printLang+"&ts=<%=getTs()%>";
    window.open(url,"_new","height=600, width=850, toolbar=yes, status=yes, scrollbars=yes, resizable=yes, menubar=yes");
  }

  <%-- SET CURRENT TIME --%>
  function setCurrentTime(objName){
    var now = new Date();

    var minutes = now.getMinutes();
    if(minutes<10) minutes = "0"+minutes;

    var hours = now.getHours();
    if(hours<10) hours = "0"+hours;

    document.getElementById(objName).value = hours+":"+minutes;
  }

  <%-- INDICATE LA --%>
  var sLASaved;
  function indicateLA(){
    sLASaved = sLA;
  }

  indicateLA();

  <%-- DO SUBMIT --%>
  function doSubmit(){
    <%-- remove row id --%>
    while(sLA.indexOf("rowLA") > -1){
      sTmpBegin = sLA.substring(sLA.indexOf("rowLA"));
      sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
      sLA = sLA.substring(0,sLA.indexOf("rowLA"))+sTmpEnd;
    }
	<%
	if(MedwanQuery.getInstance().getConfigString("edition").equalsIgnoreCase("bloodbank")){
	%>
	
	    if(document.getElementById("cntsobjectid").value.length==0){
		    var donorCode='<%=MedwanQuery.getInstance().getConfigString("cntsDonorCode","9999")%>';
		    var testLA=sLA.split("$");
			for(n=0;n<testLA.length;n++){
				if(testLA[n].replace('|','')==donorCode){
					alert('<%=getTranNoLink("Web.Occup","bloodgiftreference",sWebLanguage)%> <%=getTranNoLink("web","ismandatory",sWebLanguage)%>');
					document.getElementById("cntsobjectid").focus;
					return;
				}
			}
	    }
	
	<%
	}
	%>
    <%-- remove row id --%>
    while(sLASaved.indexOf("rowLA") > -1){
      sTmpBegin = sLASaved.substring(sLASaved.indexOf("rowLA"));
      sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
      sLASaved = sLASaved.substring(0,sLASaved.indexOf("rowLA"))+sTmpEnd;
    }

    <%-- set the forward key --%>
    if(sLASaved != sLA){
      <%-- when some labanalyses were removed or added, update the transaction and reload this page in order to save the labanalyses --%>
      var objectid='';
      if(document.getElementById("cntsobjectid")){
    	  objectid=document.getElementById("cntsobjectid").value;
      }
      document.getElementsByName('be.mxs.healthrecord.updateTransaction.actionForwardKey')[0].value = "<c:url value='../healthrecord/saveLabAnalyses.do'/>?ForwardUpdateTransactionId&labAnalysesToSave="+sLA+"&savedLabAnalyses="+sLASaved+"&patientId=<%=activePatient.personid%>&userId=<%=activeUser.userid%>&ts=<%=getTs()%>&objectId="+objectid+"&internalprescriberId="+document.getElementById("internalprescriber").value;
    }
    else{
      <%-- when no labanalyses were removed or added, update the transaction and go to the consultation-overview --%>
      document.getElementsByName('be.mxs.healthrecord.updateTransaction.actionForwardKey')[0].value = "<c:url value="../main.do"/>?Page=curative/index.jsp&ts=<%=getTs()%>";
    }

    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }

  <%-- SORT LABANALYSES --%>
  function sortLabAnalyses(){
    var sortLink = document.getElementById('lnk1');
    if(sortLink!=null){
      ts_resortTable(sortLink,1,false);
    }
  }

  <%-- ASSEMBLE A LIST OF ALL UNIQUE MONSTERS USED IN THE SELECTED LABANALYSES --%>
  function addToMonsterList(monster){
    if(monster != ""){
      var monsterList = document.getElementById('monsterList');

      var monsterArray;
      if(monsterList.value == ""){
        monsterArray = new Array();
      }
      else{
        monsterArray = monsterList.value.split(",");
      }

      var monsterExists = false;
      for(var i=0; i<monsterArray.length; i++){
        if(monsterArray[i] == monster){
          monsterExists = true;
          break;
        }
      }

      if(!monsterExists){
        monsterArray.push(monster);
      }

      monsterArray.sort();
      monsterList.value = monsterArray.join(",");
      selectedMonsters.push(monster);
    }
  }

  <%-- REMOVE MONSTER FROM MONSTERLIST IF IT OCCURS ONCE --%>
  function removeFromMonsterList(monster){
    if(monster != ""){
      var monsterList = document.getElementById('monsterList');

      var monsterArray;
      if(monsterList.value == ""){
        monsterArray = new Array();
      }
      else{
        monsterArray = monsterList.value.split(",");
      }

      var monsterOccurences = 0;
      for(var i=0; i<selectedMonsters.length; i++){
        if(selectedMonsters[i] == monster){
          monsterOccurences++;
        }
      }

      if(monsterOccurences == 1){
        monsterArray.pop(monster);
      }

      monsterArray.sort();
      monsterList.value = monsterArray.join(",");

      for(var i=0; i<selectedMonsters.length; i++){
        if(selectedMonsters[i] == monster){
          selectedMonsters.splice(i,1);
        }
      }
    }
  }

  <%-- DELETE LAB ANALYSIS --%>
  function deleteLA(rowid,monster){
      if(yesnoDeleteDialog()){
      sLA = deleteRowFromArrayString(sLA,rowid.id);
      initLabAnalysisArray(sLA);
      removeFromMonsterList(monster);
      tblLA.deleteRow(rowid.rowIndex);
      updateRowStyles();
    }
  }

  <%-- INIT LAB ANALYSIS ARRAY --%>
  function initLabAnalysisArray(sArray){
    labAnalysisArray = new Array();
    labAnalysisCodes = new Array();
    transactionForm.selectedLabCodes.value = "";

    if(sArray != ''){
      var sOneLA;
      for(var i=0; i<iIndexLA-1; i++){
        sOneLA = getRowFromArrayString(sLA,"rowLA"+(i+1));
        if(sOneLA != ''){
          var oneLA = sOneLA.split("@");
          labAnalysisArray.push(oneLA);
          labAnalysisCodes.push(oneLA[0]);
        }
      }
      transactionForm.selectedLabCodes.value = labAnalysisCodes.join(",");
    }
  }

  function addQuickListAnalyses(sSelectedAnalyses){
	// lijst van bijhorende analyses ophalen via Ajax
    var params = "newanalyses="+sSelectedAnalyses+
                 "&existinganalyses="+transactionForm.selectedLabCodes.value;
    var url = '<c:url value="/labos/getLabAnalyses.jsp"/>?ts='+new Date();
	new Ajax.Request(url,{
	  method: "POST",
      parameters: params,
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        var analysestoadd = label.analyses.split("@");
        for(n=0; n<analysestoadd.length; n++){
          addLabAnalysis(analysestoadd[n].split("$")[0],analysestoadd[n].split("$")[1],analysestoadd[n].split("$")[2],analysestoadd[n].split("$")[3],analysestoadd[n].split("$")[4]);
        }
        updateRowStyles();
      },
      onFailure: function(){
        alert("error");
      }
	});
  }
  
  <%-- CALLED BY SEARCHPOPUP : ADD THE LABANALYSE, CHOSEN IN THE POPUP, TO THIS LABREQUEST --%>
  function addLabAnalysis(code,type,label,comment,monster){
    if(labAnalysisArray.length >= maxSelectedLabAnalyses){
      if(!maxSelectedLabAnalysesAlerted){
        maxSelectedLabAnalysesAlerted = true;
        alertDialogDirectText("<%=getTranNoLink("Web.Occup","maxselectedlabanalysisreached",sWebLanguage)%> ("+maxSelectedLabAnalyses+")");
      }
    }
    else{
      if(!allreadySelected(code,comment)){
        sLA+= "rowLA"+iIndexLA+"="+code+"@"+comment+"$";

        var tr = tblLA.insertRow(tblLA.rows.length);
        tr.id = "rowLA"+iIndexLA;

        if(tblLA.rows.length%2==0){
          tr.className = "list";
        }

        <%-- insert cells in row --%>
        var td = tr.insertCell(0);
        td.width='18';
        td.innerHTML = "<center><a href=\"#\" onclick=\"deleteLA(rowLA"+iIndexLA+",'"+monster+"');\"><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web","delete",sWebLanguage)%>' border='0'></a></center>";
        tr.appendChild(td);

        <%-- default data --%>
        td = tr.insertCell(1);
        td.innerHTML =  "&nbsp;"+code;
        tr.appendChild(td);

        td = tr.insertCell(2);
        td.innerHTML = "&nbsp;"+type;
        tr.appendChild(td);

        td = tr.insertCell(3);
        td.innerHTML = "&nbsp;"+label;
        tr.appendChild(td);

        td = tr.insertCell(4);
        td.innerHTML = "&nbsp;"+comment;
        tr.appendChild(td);

        td = tr.insertCell(5);
        td.innerHTML = "&nbsp;"+monster;
        tr.appendChild(td);

        <%-- result data --%>
        td = tr.insertCell(6);
        td.innerHTML = "&nbsp;";
        tr.appendChild(td);

        td = tr.insertCell(7);   // resultmodifier
        td.innerHTML = "&nbsp;";
        tr.appendChild(td);

        iIndexLA++;
        labAnalysisArray[labAnalysisArray.length] = new Array(code,comment);
        labAnalysisCodes.push(code);
        transactionForm.selectedLabCodes.value = labAnalysisCodes.join(",");
        addToMonsterList(monster);
      }
    }
    updateRowStyles();

  }
  <% if(((TransactionVO)transaction).getTransactionId()<0){
  		if(SH.cs("prefillLabAnalyses","").length()>0){
  			for(int n=0;n<SH.cs("prefillLabAnalyses","").split(";").length;n++){
  				LabAnalysis lb = LabAnalysis.getLabAnalysisByLabcode(SH.cs("prefillLabAnalyses","").split(";")[n]);
  				if(lb!=null){
  					%>
  			  		addLabAnalysis('<%=lb.getLabcode()%>','<%=lb.getLabtype()%>','<%=getTranNoLink("labanalysis",lb.getLabId()+"",sWebLanguage)%>','<%=lb.getComment()%>','<%=lb.getMonster()%>');
  					<%
  				}
  			}
  		}
  %>
  <%}%>
  <%-- DO BACK --%>
  function doBack(){
    if(checkSaveButton()){
      window.location.href = '<c:url value="/main.do"/>?Page=curative/index.jsp&ts=<%=getTs()%>';
    }
  }

  <%-- ALLREADY SELECTED --%>
  function allreadySelected(code,comment){
    for(var i=0; i<labAnalysisArray.length; i++){
      if(labAnalysisArray[i][0] == code){
        if(comment != ''){
          if(labAnalysisArray[i][1] == comment){ return true; }
          else{ return false; }
        }
        else{
          return true;
        }

        return false;
      }
    }
  }

  <%-- GET ROW FROM ARRAY STRING --%>
  function getRowFromArrayString(sArray,rowid){
    var array = sArray.split("$");
    var row = "";
    for(var i=0;i<array.length;i++){
      if(array[i].indexOf(rowid)>-1){
        row = array[i].substring(array[i].indexOf("=")+1);
        break;
      }
    }
    return row;
  }

  <%-- DELETE ROW FROM ARRAY STRING --%>
  function deleteRowFromArrayString(sArray,rowid){
    var array = sArray.split("$");
    for(var i=0; i<array.length; i++){
      if(array[i].indexOf(rowid) > -1){
        array.splice(i,1);
      }
    }
    return array.join("$");
  }

  <%-- DELETE ALL LABANALYSIS --%>
  function deleteAllLA(){
    if(tblLA.rows.length > 1){
        if(yesnoDeleteDialog()){
        deleteAllLANoConfirm();
      }
    }
  }

  <%-- CLEAR ALL LABANALYSIS --%>
  function deleteAllLANoConfirm(){
    if(tblLA.rows.length > 1){
      var len = tblLA.rows.length;
      for(i=len-1; i!=0; i--){
        tblLA.deleteRow(i);
      }

      sLA = "";
      initLabAnalysisArray("");
      clearMonsterList();
    }
  }

  <%-- CLEAR MONSTER LIST --%>
  function clearMonsterList(){
    document.getElementById('monsterList').value = "";
    monsterArray = new Array();
    selectedMonsters = new Array();
  }

  <%-- UPDATE ROW STYLES (especially after sorting, red row when no resultmodifier) --%>
  function updateRowStyles(){
    for(i=1; i<tblLA.rows.length; i++){
      tblLA.rows[i].className = "";
      tblLA.rows[i].style.cursor = 'hand';
    }

    for(i=1; i<tblLA.rows.length; i++){
      if(tblLA.rows[i].cells[7].innerHTML == "&nbsp;"){
        tblLA.rows[i].className = "red";
      }
      else if(i%2>0){
        tblLA.rows[i].className = "list";
      }
    }
  }

  <%-- SHOW LAB LABRESULT DETAILS --%>
  function showResultDetails(serverId,transactionId,analysisCode){
    openPopup("/healthrecord/labResultPopup.jsp&serverId="+serverId+"&transactionId="+transactionId+"&analysisCode="+analysisCode+"&editable=false");
  }

  <%-- REFRESH CONTENT --%>
  function refreshContent(){
    window.location.href = "<c:url value='/main.do'/>?Page=healthrecord/manageLabRequest_view.jsp&ts=<%=getTs()%>";
  }

  <%-- PRINT LABELS --%>
  function printLabels(){
    window.open("<c:url value="/healthrecord/createLabSampleLabelPdf.jsp"/>?serverid=<bean:write name="transaction" scope="page" property="serverId"/>&transactionid=<bean:write name="transaction" scope="page" property="transactionId"/>&ts=<%=getTs()%>","Popup"+new Date().getTime(),"toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=400, height=300, menubar=no").moveTo((screen.width-400)/2,(screen.height-300)/2);
  }

  function printLabel(specimenid){
	  window.open("<c:url value='/healthrecord/createLabSampleLabelPdf.jsp'/>?execute."+specimenid, "Popup"+new Date().getTime(), "toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=400, height=300, menubar=no").moveTo((screen.width - 400) / 2, (screen.height - 300) / 2);
  }

  function printHL7Message(msgid){
	  window.open("<c:url value='/labos/showHL7Message.jsp'/>?msgid="+msgid, "Popup"+new Date().getTime(), "toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=1024, height=600, menubar=no").moveTo((screen.width - 1024) / 2, (screen.height - 600) / 2);
  }

  <%-- RECEIVE SAMPLES --%>
  function receiveSamples(){
    openPopup("/labos/manageLabSampleReception.jsp&labrequestid=<bean:write name="transaction" scope="page" property="serverId"/>.<bean:write name="transaction" scope="page" property="transactionId"/>&PopupWidth=500&PopupHeight=300&ts=<%=getTs()%>");
  }

  initLabAnalysisArray(sLA);

  <%=sScriptsToExecute%>
  
  <%
	  boolean sendPDF = checkString(request.getParameter("sendPDF")).equals("true");
	  if(sendPDF){
	      out.print("window.setTimeout('doReferral();',500);");
	  }
  %>
</script>

<%=writeJSButtons("transactionForm","saveButton")%>