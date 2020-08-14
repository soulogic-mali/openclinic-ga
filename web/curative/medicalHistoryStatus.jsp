<%@page import="be.openclinic.finance.*,be.openclinic.adt.Encounter" %>
<%@ page import="java.util.Vector" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
	double saldo = Balance.getPatientBalance(activePatient.personid);
	Balance balance = Balance.getActiveBalance(activePatient.personid);
%>
<%
try{
    // context
    String contextSelector =(String)session.getAttribute("contextSelector");
    if(contextSelector==null){
        contextSelector = activeUser.activeService.code;
    }
%>
<table width="100%" class="list" cellspacing="0">
    <form name="transactionForm" method="post">
        <input type="hidden" name="Page" value="curative/index.jsp"/>
        
        <%-- PAGE TITLE --%>
        <tr class="admin">
            <td>
                <%=getTran(request,"curative","clinicaldocuments.status.title",sWebLanguage)%>&nbsp;
                <a href="javascript:newExamination();"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_newpage.png'/>" class="link" alt="<%=getTranNoLink("web","manageExaminations",sWebLanguage)%>" style="vertical-align: middle"></a>
				<%if(MedwanQuery.getInstance().getConfigString("quickTransaction1."+activeUser.userid,"").length()>0){ %>
                    <a href="javascript:newFastTransaction('<%=MedwanQuery.getInstance().getConfigString("quickTransaction1."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new1.png'/>" class="link" title="<%=getTranNoLink("web.occup",MedwanQuery.getInstance().getConfigString("quickTransaction1."+activeUser.userid).split("\\&")[0],sWebLanguage)%>" style="vertical-align:-4px;"></a>
                <%} %>
				<%if(MedwanQuery.getInstance().getConfigString("quickTransaction2."+activeUser.userid,"").length()>0){ %>
                    <a href="javascript:newFastTransaction('<%=MedwanQuery.getInstance().getConfigString("quickTransaction2."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new2.png'/>" class="link" title="<%=getTranNoLink("web.occup",MedwanQuery.getInstance().getConfigString("quickTransaction2."+activeUser.userid).split("\\&")[0],sWebLanguage)%>" style="vertical-align:-4px;"></a>
                <%} %>
				<%if(MedwanQuery.getInstance().getConfigString("quickTransaction3."+activeUser.userid,"").length()>0){ %>
                    <a href="javascript:newFastTransaction('<%=MedwanQuery.getInstance().getConfigString("quickTransaction3."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new3.png'/>" class="link" title="<%=getTranNoLink("web.occup",MedwanQuery.getInstance().getConfigString("quickTransaction3."+activeUser.userid).split("\\&")[0],sWebLanguage)%>" style="vertical-align:-4px;"></a>
                <%} %>
				<%if(MedwanQuery.getInstance().getConfigString("quickTransaction4."+activeUser.userid,"").length()>0){ %>
                    <a href="javascript:newFastTransaction('<%=MedwanQuery.getInstance().getConfigString("quickTransaction4."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new4.png'/>" class="link" title="<%=getTranNoLink("web.occup",MedwanQuery.getInstance().getConfigString("quickTransaction4."+activeUser.userid).split("\\&")[0],sWebLanguage)%>" style="vertical-align:-4px;"></a>
                <%} %>
				<%if(MedwanQuery.getInstance().getConfigString("quickTransaction5."+activeUser.userid,"").length()>0){ %>
                    <a href="javascript:newFastTransaction('<%=MedwanQuery.getInstance().getConfigString("quickTransaction5."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new5.png'/>" class="link" title="<%=getTranNoLink("web.occup",MedwanQuery.getInstance().getConfigString("quickTransaction5."+activeUser.userid).split("\\&")[0],sWebLanguage)%>" style="vertical-align:-4px;"></a>
                <%} %>
            </td>
        </tr>

        <tr>
            <td style="padding:0;">
                <%-- EXAMINATIONS OVERVIEW ------------------------------------------------------%>
                <%
                    if (activePatient != null){
                        SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
                        sessionContainerWO.init(activePatient.personid);

                        if (sessionContainerWO.getTransactionsLimited() != null && sessionContainerWO.getTransactionsLimited().size() > 0){
                            %>
                                <logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
                                <table width="100%" cellspacing="0" class="sortable" id="searchresults" style="border:0;">

                                    <%-- HEADER --%>
                                    <tr class='gray'>
                                        <td width='30'>&nbsp;</td>
                                        <td align="center" width='100'><%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%></td>
                                        <td align="center" width='42%'><%=getTran(request,"Web.Occup","medwan.common.contacttype",sWebLanguage)%></td>
                                        <td align="center" width='20%'><%=getTran(request,"Web.Occup","medwan.common.user",sWebLanguage)%></td>
                                        <td align="center" width='*'>
                                            <select class="text" name="contextSelector" id="contextSelector" onchange="transactionForm.submit();">
                                                <%
                                                    String sTmpContextSelector = checkString(request.getParameter("contextSelector"));
                                                %>
                                                <option value=""<%if(sTmpContextSelector.equals("")){out.print(" selected");}%>/>
                                                <%
                                                    if(!sTmpContextSelector.equalsIgnoreCase(contextSelector)){
                                                        contextSelector = sTmpContextSelector;
                                                        session.setAttribute("contextSelector",contextSelector);
                                                        sessionContainerWO.getFlags().setContext(contextSelector);
                                                    }

                                                    Debug.println("--> contextSelector : "+contextSelector);
                                                    Service service;
                                                    for(int i=0; i<activeUser.vServices.size(); i++){
                                                        service = (Service)activeUser.vServices.elementAt(i);
                                                        
                                                        if(service.code.length() > 0){
                                                            %><option value="<%=service.code%>" <%=(service.code.equals(contextSelector)?"selected":"")%>><%=getTranNoLink("Service",service.code,sWebLanguage)%></option><%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <%
                                        Vector vTransactions = new Vector();
                                    	Hashtable hTransactions = new Hashtable();
                                    	HashSet hMasterTransactions = new HashSet();
                                        try{
                                            if ("1".equalsIgnoreCase(request.getParameter("showAll"))){
                                                vTransactions = new Vector(sessionContainerWO.getHealthRecordVO().getTransactions());
                                            } 
                                            else {
                                                vTransactions = new Vector(sessionContainerWO.getTransactionsLimited());
                                            }
                                        }
                                        catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        //Sort transactions
                                        Iterator transactions = vTransactions.iterator();
                                        SortedMap sTransactions = new TreeMap();
										while(transactions.hasNext()){
											TransactionVO transaction = (TransactionVO)transactions.next();
											String key=new SimpleDateFormat("yyyyMMdd").format(transaction.getUpdateTime())+"."+transaction.getTransactionType()+"."+new SimpleDateFormat("yyyyMMddHHmm").format(transaction.getUpdateTime())+"."+Math.random();
											sTransactions.put(key,transaction);
										}
										vTransactions = new Vector();
										transactions = sTransactions.keySet().iterator();
										while(transactions.hasNext()){
											String key=(String)transactions.next();
											TransactionVO transaction = (TransactionVO)sTransactions.get(key);
											vTransactions.add(transaction);
										}
										Collections.reverse(vTransactions);
                                        transactions = vTransactions.iterator();
										while(transactions.hasNext()){
											TransactionVO transaction = (TransactionVO)transactions.next();
											String key=ScreenHelper.formatDate(transaction.getUpdateDateTime())+"."+transaction.getTransactionType();
											if(hTransactions.get(key)!=null){
												hTransactions.put(key,((Integer)hTransactions.get(key))+1);
											}
											else{
												hTransactions.put(key,1);
												hMasterTransactions.add(transaction.getServerId()+"."+transaction.getTransactionId());
											}
										}
                                        
                                        String sClass, transactionType, sList = "", docType, servicecode;
                                        TransactionVO transactionVO;
                                        ItemVO contextItem, itemVO, item, encounteritem;
                                        Encounter encounter;
                                        Encounter activeEncounter;

                                        transactions = vTransactions.iterator();
                                        boolean bHiddenSectionOpened=false;
                                        while(transactions.hasNext()){
                                            transactionVO = (TransactionVO) transactions.next();
                                            contextItem = transactionVO.getContextItem();
                                            encounteritem = transactionVO.getItem(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CONTEXT_ENCOUNTERUID");
                                            servicecode="";
                                            if(encounteritem!=null){
                                            	encounter = Encounter.get(encounteritem.getValue());
                                            	if(encounter!=null){
                                            		servicecode= encounter.getServiceUID(transactionVO.getUpdateDateTime());
                                            	}
                                            }
                                                                                        
                                            if(contextSelector == null || contextSelector.length() == 0 || (servicecode.equalsIgnoreCase(contextSelector)) || (contextItem != null && contextItem.getValue()!=null && contextItem.getValue().equalsIgnoreCase(contextSelector))){
                                                activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
                                                sClass = "disabled";

                                                try{
                                                    if(activeEncounter != null && transactionVO.getUpdateTime()!=null && activeEncounter!=null && !transactionVO.getUpdateTime().before(ScreenHelper.parseDate(ScreenHelper.stdDateFormat.format(activeEncounter.getBegin()))) && (activeEncounter.getEnd() == null || !transactionVO.getUpdateTime().after(ScreenHelper.parseDate(ScreenHelper.stdDateFormat.format(activeEncounter.getEnd()))))){
                                                        sClass = "bold";
                                                    }
                                                }
                                                catch(Exception e){
                                                    e.printStackTrace();
                                                }
                                                
                                                if(hMasterTransactions!=null && transactionVO!=null && hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId())){
	                                                // alternate row-styles
	                                                if(sList.equals("")) sList = "1";
	                                                else                 sList = "";
                                                }	  

                                                String key=ScreenHelper.formatDate(transactionVO.getUpdateDateTime())+"."+transactionVO.getTransactionType();
                                                
                                                //If this is a new master line, close any opened slave lines
                                                if(hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId())){
                                                	if(bHiddenSectionOpened){
                                                		out.println("</table></td></tr>");
                                                		bHiddenSectionOpened=false;
                                                	}
                                                }
                                            	out.println("<tr id='"+sClass+"' class='list"+(hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId())?sClass+sList:"Text2")+"' >");
												%>
	                                                    <td  nowrap width='1%' class="modal" nowrap onmouseover='this.style.cursor="hand"' onmouseout='this.style.cursor="default"'>
	                                                    	<%if(activeUser.getAccessRightNoSA("examinations.delete")){ %>
                                                            	<img class='hand' src="<c:url value='/_img/icons/icon_delete.png'/>" alt="<%=getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)%>" border="0"  onclick="deltran(<%=transactionVO.getTransactionId()%>,<%=transactionVO.getServerId()%>,<%=transactionVO.getUser().getUserId()%>)">
															<%
	                                                    	}
			                                            	if(hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId()) && (Integer)hTransactions.get(key)>1){
			                                                	//This is a master line with slaves
			                                                	out.println("<img class='hand' height='12px' src='"+sCONTEXTPATH+"/_img/themes/default/plus.jpg' alt='"+getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)+"' border='0' onclick='expandtran(\""+transactionVO.getServerId()+"."+transactionVO.getTransactionId()+"\",this)'/>");
			                                                }
			                                    			%>&nbsp;
                                                        </td>
                                                        <td align="center" width='100'><%=hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId())?ScreenHelper.formatDate(transactionVO.getUpdateTime()):""%></td>
                                                        <td align="center" width='42%'>
                                                            <%
                                                                try {
                                                                    transactionType = transactionVO.getTransactionType();

                                                                    //  Document
                                                                    if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DOCUMENT")){
                                                                        %>
                                                                            <a target="refdocument" href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%

                                                                                    docType = "ERROR";
                                                                                    item = transactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOCUMENT_TYPE");

                                                                                    if (item==null){
                                                                                        item = transactionVO.getItem("documentId");

                                                                                        if (item!=null){
                                                                                            docType = item.getValue().replaceAll(".pdf","");
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        docType = item.getValue();
                                                                                    }

                                                                                %>
                                                                                (<%=getTran(request,"web.documents",docType,sWebLanguage)%>)
                                                                            </a>
                                                                        <%
                                                                    }
                                                                    else if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_EXTERNAL_DOCUMENT")){
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%
                                                                                    item = MedwanQuery.getInstance().getItem(transactionVO.getServerId(),transactionVO.getTransactionId().intValue(),"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EXTERNAL_DOCUMENT_TITLE");
                                                                                    String sDocumentTitle = "";
                                                                                    if (item!=null){
                                                                                        sDocumentTitle = checkString(item.getValue());
                                                                                    }
                                                                                    
                                                                                    if(sDocumentTitle.length() > 0){
                                                                                        %>(<%=sDocumentTitle%>)<%                                                                                    	
                                                                                    }
                                                                                %>
                                                                            </a>
                                                                        <%
                                                                    }
                                                                    else if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ARCHIVE_DOCUMENT")){
                                                                    	transactionVO.preload();
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%
	                                                                                String sReference = transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_UDI");
	                                                                                if(sReference.length() > 0){
	                                                                                    %>(<%=sReference%> - <b><%=transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_TITLE").toUpperCase() %></b>)<%
	                                                                                }
                                                                                %>
                                                                            </a>
                                                                        <%
                                                                        
                                                                        String sStorageName = transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_STORAGENAME");
                                                                        if(sStorageName.length()==0){
                                                                            %>&nbsp;<img src='<c:url value="_img/icons/icon_barcode.gif"/>' onclick="printArchiveBarcode('<%=sReference %>');" class="link" />&nbsp;<img src='<c:url value="_img/icons/icon_upload.gif"/>' class="link" onclick='document.getElementById("fileuploadid").value="<%=sReference %>";document.getElementById("uploadtransactionid").value="<%=transactionVO.getServerId()+"."+transactionVO.getTransactionId()%>";document.getElementById("fileupload").click();return false'/><%                                                                                    	
                                                                        }
                                                                    }
                                                                    else if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS")){
                                                                    	transactionVO.preload();
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%
	                                                                                String sSeriesID = transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
	                                                                                String sDescription = "<b>"+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION")+"</b> "+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY");
                                                                                    %>(<%=sSeriesID%> - <%=sDescription %>)<%
                                                                                %>
                                                                            </a>
                                                                        <%
                                                                    }
                                                                    else if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_KINE")){
                                                                    	transactionVO.preload();
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%
	                                                                                String type = transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CARDTYPE");
                                                                                	if(type.length()>0){
	                                                                                    %> [<%=getTranNoLink("cardtype",type,sWebLanguage)%>]<%
                                                                                	}
                                                                                %>
                                                                            </a>
                                                                        <%
                                                                    }
                                                                    else if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PEDIATRIC_TRIAGE")){
                                                                    	transactionVO.preload();
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=getTran(request,"web.occup",transactionType,sWebLanguage)%>
                                                                                <%
	                                                                                String type = transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY");
                                                                                	if(type.length()>0){
	                                                                                    %> [<b><%=getTran(request,"triage","priority",sWebLanguage)+" "+type%></b>]<%
                                                                                	}
                                                                                %>
                                                                            </a>
                                                                        <%
                                                                    }
                                                                    // no Document
                                                                    else{
                                                                        %>
                                                                            <a href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<%=transactionType%>&be.mxs.healthrecord.transaction_id=<%=transactionVO.getTransactionId()%>&be.mxs.healthrecord.server_id=<%=transactionVO.getServerId()%>&ts=<%=getTs()%>" onMouseOver="window.status='';return true;">
                                                                                <%=ScreenHelper.uppercaseFirstLetter(getTran(request,"web.occup",transactionType,sWebLanguage))%>
                                                                        <%

                                                                        // add vaccination type
                                                                        if(transactionType.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_VACCINATION")){
                                                                            ItemVO vItem = transactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_TYPE");
                                                                            if(vItem!=null){
                                                                                %> (<%=getTran(request,"web.occup",vItem.getValue(),sWebLanguage)%>)<%
                                                                            }
                                                                        }

                                                                        %>
                                                                            </a>
                                                                        <%
                                                                        if (MedwanQuery.getInstance().getConfigString("projectPrintTransactions","be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_KINE").contains(transactionType)){
                                                                        	%>
                                                                        	&nbsp;&nbsp;<img style='vertical-align: middle' height='16px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/print.png' onclick='printWordDocuments("<%=transactionVO.getServerId()+"."+transactionVO.getTransactionId()%>")'/>
                                                                        	<%
                                                                        }
                                                                    }
                                                                }
                                                                catch(Exception e){
                                                                    e.printStackTrace();
                                                                }
                                                            %>
                                                        </td>
                                                        <%	if(transactionVO.getServerId()<=1){ %>
                                                        		<td align="center" width='20%'><%=transactionVO.getUser()!=null?transactionVO.getUser().getPersonVO().getFirstname():""%>,&nbsp;<%=transactionVO.getUser()!=null?transactionVO.getUser().getPersonVO().getLastname():""%></td>
                                                        <%	}
                                                        	else {
                                                        %>
                                                        		<td align="center" width='20%'><font color='red'>[<%=transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_USER")%>]</font></td>
                                                        <%	} %>
                                                        <td align="center" width="*">
                                                        <%
                                                        	if(transactionVO.getServerId()==1){
                                                        		out.print(servicecode.length()>0?servicecode+": "+getTran(request,"service",servicecode,sWebLanguage):getTran(request,"service",contextItem!=null?contextItem.getValue():"",sWebLanguage));
                                                        	}
                                                        	else if(transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE").length()>0){
                                                       			out.println("<font color='red'>["+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE")+"]</font>");
                                                        	}
                                                        %>
                                                        </td>
                                                    </tr>
                                                <%
                                            	if(hMasterTransactions.contains(transactionVO.getServerId()+"."+transactionVO.getTransactionId()) && (Integer)hTransactions.get(key)>1){
													//Create a hidden section
													out.println("<tr id='expand."+transactionVO.getServerId()+"."+transactionVO.getTransactionId()+"' style='display: none'><td colspan='5'><table width='100%' cellspacing='0'>");
													bHiddenSectionOpened=true;
                                            	}
                                            }
                                        }
                                    %>
                                </table>
                                </logic:present>

                                <br>
                            <%
                            // SHOW "ALL EXAMINATIONS"-LINK
                            if(sessionContainerWO.getHealthRecordVO()!=null){
                                int totalTransactions =  sessionContainerWO.getHealthRecordVO().getTransactions().size();

                                int numberOfTransToList = MedwanQuery.getInstance().getConfigInt("numberOfTransToListInSummary");
                                if(numberOfTransToList < 0) numberOfTransToList = 25; // default

                                if(!"1".equalsIgnoreCase(request.getParameter("showAll")) && totalTransactions > numberOfTransToList){
                                    %>
                                        <img src='<c:url value="/_img/themes/default/pijl.gif"/>'>
                                        <a href="<c:url value='/main.do?Page=/curative/index.jsp'/>&showAll=1&ts=<%=getTs()%>" onMouseOver="window.status='';return true;"><%=getTran(request,"Web.Occup","medwan.common.all",sWebLanguage)%></a>
                                    <%
                                }

                                if("1".equalsIgnoreCase(request.getParameter("showAll"))){
                                    %>
                                        <img src='<c:url value="/_img/themes/default/pijl.gif"/>'>
                                        <a href="<c:url value='/main.do?Page=/curative/index.jsp'/>&showAll=0&ts=<%=getTs()%>" onMouseOver="window.status='';return true;"><%=getTran(request,"Web.Occup","medwan.common.summary",sWebLanguage)%></a>
                                    <%
                                }
                            }
                        }
                    }
                %>
            </td>
        </tr>
    </form>
</table>
<form target="_tab" name="uploadForm" action="<c:url value='/healthrecord/archiveDocumentUpload.jsp'/>" method="post" enctype="multipart/form-data">
	<input type='hidden' name='fileuploadid' id='fileuploadid'/>
	<input type='hidden' name='uploadtransactionid' id='uploadtransactionid'/>
	<input style='display: none' class="text" id='fileupload' name="filename" type="file" title=""  onchange="uploadFile();"/>
</form>

<script>
function expandtran(id,tdobject){
	if(document.getElementById("expand."+id).style.display=="none"){
		document.getElementById("expand."+id).style.display="";
		tdobject.src='<%=sCONTEXTPATH%>/_img/themes/default/minus.jpg';
	}
	else{
		document.getElementById("expand."+id).style.display="none";
		tdobject.src='<%=sCONTEXTPATH%>/_img/themes/default/plus.jpg';
	}
}

function uploadFile(){
    if(uploadForm.filename.value.length>0){
      uploadForm.submit();
    }
    window.setTimeout('checkArchiveDocument()','1000');
  }

function printArchiveBarcode(udi){
	var url = "<%=sCONTEXTPATH%>/archiving/printBarcode.jsp?barcodeValue="+udi+"&numberOfPrints=1";
	var w = 430;
    var h = 200;
    var left = (screen.width/2)-(w/2);
    var topp = (screen.height/2)-(h/2);
    window.open(url,"PrintBarcode<%=getTs()%>","toolbar=no,status=no,scrollbars=yes,resizable=yes,menubar=yes,width="+w+",height="+h+",top="+topp+",left="+left);
}

function checkArchiveDocument(){
    var url = "<%=sCONTEXTPATH%>/util/checkArchiveDocument.jsp?ts="+new Date().getTime();
    new Ajax.Request(url,{
      parameters: "tranid="+document.getElementById('uploadtransactionid').value,
         onSuccess: function(resp){
        	 if(trim(resp.responseText).indexOf("true")>-1){
        		 window.location.href = "<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp";	 
        	 }
        	 else {
       		    window.setTimeout('checkArchiveDocument()','1000');
        	 }
         },
      onFailure: function(resp){
        alert("ERROR :\n"+resp.responseText);
      }
    });
}

  <%-- DEL TRAN --%>
  function deltran(transactionId,serverId,userId){
    var modalities = "dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";

    if(userId!=<%=activeUser.userid%>){
      if(window.prompt('<%=getTran(null,"web.occup","medwan.transaction.delete.question",sWebLanguage)%>')=="deleteit"){
        window.location.href = "<c:url value='/healthrecord/manageDeleteTransaction.do'/>?transactionId="+transactionId+"&serverId="+serverId+"&ts=<%=getTs()%>&be.mxs.healthrecord.updateTransaction.actionForwardKey=/main.do?Page=curative/index.jsp&ts=<%=getTs()%>";
      }
      else{
        alertDialog("web.occup","medwan.transaction.delete.wrong-password");
      }
    }
    else{
        if(yesnoDeleteDialog()){
        window.location.href="<c:url value='/healthrecord/manageDeleteTransaction.do'/>?transactionId="+transactionId+"&serverId="+serverId+"&ts=<%=getTs()%>&be.mxs.healthrecord.updateTransaction.actionForwardKey=/main.do?Page=curative/index.jsp&ts=<%=getTs()%>";
      }
    }
  }

  <%-- COMPARE.. --%>
  function compareText(option1,option2){
    return option1.text < option2.text ? -1 : (option1.text > option2.text ? 1 : 0);
  }

  function compareValue(option1,option2){
    return option1.value < option2.value ? -1 : (option1.value > option2.value ? 1 : 0);
  }

  function compareTextAsFloat(option1,option2){
    var value1 = parseFloat(option1.text.replace(",","."));
    var value2 = parseFloat(option2.text.replace(",","."));

    return value1 < value2 ? -1 : (value1 > value2 ? 1 : 0);
  }

  function compareValueAsFloat(option1,option2){
    var value1 = parseFloat(option1.value.replace(",","."));
    var value2 = parseFloat(option2.value.replace(",","."));

    return value1 < value2 ? -1 : (value1  > value2 ? 1 : 0);
  }

  <%-- SORT SELECT --%>
  function sortSelect(select,compareFunction){
    if(select!=null){
      if(!compareFunction) compareFunction = compareText;

      var options = new Array (select.options.length);
      for(var i=0; i<options.length; i++){
        options[i] =
          new Option (
            select.options[i].text,
            select.options[i].value,
            select.options[i].defaultSelected,
            select.options[i].selected
          );
      }

      options.sort(compareFunction);
      select.options.length = 0;

      for(var i=0; i<options.length; i++){
        select.options[i] = options[i];
        if(select.options[i].value=='<%=contextSelector%>'){
          select.options[i].selected=true;
        }
      }
    }
  }

  <%-- UPDATE ROW STYLES --%>
  function updateRowStyles(){
    var sClassName;

    for(var i=1; i<searchresults.rows.length; i++){
      searchresults.rows[i].style.cursor = "hand";
      sClassName = searchresults.rows[i].className;

      if(sClassName.indexOf("disabled") > -1){
        searchresults.rows[i].className = "listdisabled";
      }
      else if(sClassName.indexOf("bold") > -1){
        searchresults.rows[i].className = "listbold";
      }
      else{
        searchresults.rows[i].className = "list";
      }

      if(i%2>0){
        searchresults.rows[i].className+= "1";
      }

      if(i%2>0){
        searchresults.rows[i].onmouseout = function(){
          if(this.id.indexOf("disabled")==0){
            this.className = "listdisabled1";
          }
          else{
            this.className = "listbold1";
          }
        }
      }
      else{
        searchresults.rows[i].onmouseout = function(){
          if(this.id.indexOf("disabled")==0){
            this.className = "listdisabled";
          }
          else{
            this.className = "listbold";
          }
        }
      }
    }
  }

  sortSelect(document.getElementById('contextSelector'));

  function newExamination(){
	if(<%=Encounter.selectEncounters("","","","","","","","",activePatient.personid,"").size()%>>0){
	  window.location.href="<c:url value='/main.do'/>?Page=curative/manageExaminations.jsp&ts=<%=getTs()%>";
	}
	else{
	  alertDialog("web","create.encounter.first");
	}
  }
</script>
<%
}
catch(Exception e){
	e.printStackTrace();
}
%>