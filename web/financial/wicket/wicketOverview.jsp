<%@page import="be.mxs.common.util.io.ExportSAP_AR_INV"%>
<%@page import="be.openclinic.finance.*,
                java.util.Hashtable,
                java.util.Vector,
                java.util.Collections,
                java.text.DecimalFormat"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"financial.wicketoverview","select",activeUser)%>
<%=sJSSORTTABLE%>

<%
    String sAction = checkString(request.getParameter("Action"));

    // sort dir
    String sSortDir = checkString(request.getParameter("SortDir"));
    if(sSortDir.length() == 0) sSortDir = "DESC"; // default

    String sFindWicketUid      = checkString(request.getParameter("FindWicketUid")),
           sFindWicketUids 	   = checkString(request.getParameter("selectedwicketuids")),
           sFindWicketFromDate = checkString(request.getParameter("FindWicketFromDate")),
           sFindWicketToDate   = checkString(request.getParameter("FindWicketToDate"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n***************** financial/wicket/wicketOverview.jsp *************");
        Debug.println("sAction             : "+sAction);
        Debug.println("sFindWicketUid      : "+sFindWicketUid);
        Debug.println("sFindWicketFromDate : "+sFindWicketFromDate);
        Debug.println("sFindWicketToDate   : "+sFindWicketToDate+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // current date as default search from date
    if(sAction.length()==0){
        if(sFindWicketFromDate.length()==0){
            sFindWicketFromDate = ScreenHelper.getDate();
        }

        if(sFindWicketUid.length()==0 && sFindWicketUids.length()==0){
            sFindWicketUid = activeUser.getParameter("defaultwicket");
            if(sFindWicketUid.length()>0){
                sAction = "search";
            }
        }
    }

    String sWicketBalance = "", sWicketDebetTotal = "", sWicketCreditTotal = "", sWicketAlternateCreditTotal = "";
    Hashtable hDebets  = new Hashtable(),
              hCredits = new Hashtable();
    StringBuffer sDebetsHtml  = new StringBuffer(),
                 sCreditsHtml = new StringBuffer();
    double dCreditsTotal = 0, dDebetsTotal = 0, dAlternateCreditsTotal=0;
    Wicket wicket = null;
    DecimalFormat priceFormat = new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#,##0.00"));
    String sAlternateCurrency = MedwanQuery.getInstance().getConfigString("AlternateCurrency","");

    //*** SEARCH **********************************************************************************
    if(sAction.equals("search")){
    	if(sFindWicketUids.length()>0){
    		sFindWicketUid=sFindWicketUids;
    	}
        WicketDebet debet;
  		WicketCredit credit;
    	for(int n=0;n<sFindWicketUid.split(";").length;n++){
	        wicket = Wicket.get(sFindWicketUid.split(";")[n]);
	
	        // get debets for specified wicket
	        Vector vDebets = Wicket.getDebets(wicket.getUid(),sFindWicketFromDate,sFindWicketToDate);
	        for(int i=0; i<vDebets.size(); i++) {
	            debet = (WicketDebet)vDebets.elementAt(i);
	            hDebets.put(ScreenHelper.fullDateFormatSS.format(debet.getUpdateDateTime())+"."+debet.getUid(),debet);
	        }
	
	        // get credits for specified wicket
	        Vector vCredits = Wicket.getCredits(wicket.getUid(),sFindWicketFromDate,sFindWicketToDate);
	        for(int i=0; i<vCredits.size(); i++){
	            credit = (WicketCredit)vCredits.elementAt(i);
	            hCredits.put(ScreenHelper.fullDateFormatSS.format(credit.getOperationDate())+"."+credit.getUid(),credit);
	        }
    	}
        //*** DISPLAY RESULTS *************************************************************************
        String sClass = "";
        Object key;

        // sort debets on date
        Vector keys = new Vector(hDebets.keySet());
        Collections.sort(keys);
        Iterator iter = keys.iterator();

        while(iter.hasNext()){
            key = iter.next();
            debet = (WicketDebet)hDebets.get(key);

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";

            sDebetsHtml.append("<tr class='list"+sClass+"'>")
                        .append("<td>"+ScreenHelper.stdDateFormat.format(debet.getOperationDate())+"</td>")
                        .append("<td>"+checkString(debet.getUid())+"</td>")
                        .append("<td>"+priceFormat.format(debet.getAmount())+"&nbsp;&nbsp;</td>")
                        .append("<td>"+getTranNoLink("debet.type",debet.getOperationType(),sWebLanguage)+"</td>")
                        .append("<td>"+ScreenHelper.getFullUserName(Integer.toString(debet.getUserUID()))+"</td>")
                        .append("<td>"+debet.getComment()+"</td>")
                       .append("</tr>");

            dDebetsTotal+= debet.getAmount();
        }

        sWicketDebetTotal = priceFormat.format(dDebetsTotal);

        // sort credits on date
        keys = new Vector(hCredits.keySet());
        Collections.sort(keys);
        iter = keys.iterator();

        sClass = "";
        while(iter.hasNext()){
            key = iter.next();
            credit = (WicketCredit)hCredits.get(key);

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";
            
            String sModify="";
            if(credit.getUserUID()!=Integer.parseInt(credit.getUpdateUser())){
            	sModify=" ! "+getTran(request,"web","modified.by",sWebLanguage)+" "+ScreenHelper.getFullUserName(credit.getUpdateUser())+" "+getTran(request,"web","on",sWebLanguage)+" "+ScreenHelper.fullDateFormat.format(credit.getUpdateDateTime());
            }
	        String sAlternateValue="";
	        if(sAlternateCurrency.length()>0 && checkString(credit.getCurrency()).equalsIgnoreCase(sAlternateCurrency)){
	        	sAlternateValue=" <b>("+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(credit.getAmount()/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, credit.getOperationDate()))+" "+sAlternateCurrency+")</b>";
	        	dAlternateCreditsTotal+=credit.getAmount();
	        }

            sCreditsHtml.append("<tr class='list"+sClass+"'>")
                         .append("<td>"+ScreenHelper.stdDateFormat.format(credit.getOperationDate())+"</td>")
                         .append("<td>"+checkString(credit.getUid())+"</td>")
                         .append("<td>"+priceFormat.format(credit.getAmount())+sAlternateValue+"&nbsp;&nbsp;</td>")
                         .append("<td>"+getTranNoLink("credit.type",credit.getOperationType(),sWebLanguage)+"</td>")
                         .append("<td>"+ScreenHelper.getFullUserName(Integer.toString(credit.getUserUID()))+"</td>")
                         .append("<td>"+credit.getComment()+sModify+"</td>")
                        .append("</tr>");

            dCreditsTotal+= credit.getAmount();
        }

        sWicketCreditTotal = priceFormat.format(dCreditsTotal-dAlternateCreditsTotal);
        if(dAlternateCreditsTotal>0){
        	sWicketAlternateCreditTotal = new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(dAlternateCreditsTotal/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, ScreenHelper.parseDate(sFindWicketFromDate)));
        }

        // calculate saldo for specified period
        sWicketBalance = priceFormat.format(dCreditsTotal-dDebetsTotal);
    }
%>

<form name="SearchForm" method="post"onKeyDown="if(enterEvent(event,13)){showOverview();}" action="<c:url value='/main.jsp'/>?Page=/financial/wicket/wicketOverview.jsp&ts=<%=getTs()%>">
    <input type="hidden" name="Action">

    <%=writeTableHeader("wicket","wicketoverview",sWebLanguage," doBack();")%>

    <table class="list" width="100%" cellspacing="1">
        <%-- WICKET --%>
        <tr>
            <td class="admin"><%=getTran(request,"wicket","wicket",sWebLanguage)%>&nbsp;*</td>
            <td class="admin2">
                <select class="text" name="FindWicketUid" id="FindWicketUid">
                    <option value=''><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                    <%
                        Vector userWickets = Wicket.getWicketsForUser(activeUser.userid);
                        Iterator iter = userWickets.iterator();
                        Wicket tmpWicket;

                        while(iter.hasNext()){
                            tmpWicket = (Wicket)iter.next();
                            tmpWicket = Wicket.get(tmpWicket.getUid());
                            if(tmpWicket!=null && tmpWicket.getService()!=null){
								if(checkString(tmpWicket.getService().inactive).equalsIgnoreCase("1")){
                            		continue;
								}
                            }

                            %>
                            <option value="<%=tmpWicket.getUid()%>" <%=sFindWicketUid.equals(tmpWicket.getUid())?" selected":""%>>
                                <%=tmpWicket.getUid()%>&nbsp;<%=getTran(request,"service",tmpWicket.getServiceUID(),sWebLanguage)%>
                            </option>
                            <%
                        }
                    %>
                </select>
                <input type='hidden' name='selectedwicketuids' id='selectedwicketuids' value='<%=sFindWicketUids%>'/>
                <img src='<%=sCONTEXTPATH %>/_img/icons/icon_add.gif' onclick='addWicket();'/>
                <img src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='document.getElementById("selectedwicketuids").value="";document.getElementById("selectedwickets").innerHTML="";'/>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <%
                	String selectedwickets="";
                	if(sFindWicketUids.length()>0){
                		for(int n=0;n<sFindWicketUids.split(";").length;n++){
                			wicket = Wicket.get(sFindWicketUids.split(";")[n]);
                			if(wicket!=null){
                				if(selectedwickets.length()>0){
                					selectedwickets+=" + ";
                				}
                				selectedwickets+="<b>"+wicket.getUid()+" "+getTran(request,"service",wicket.getServiceUID(),sWebLanguage)+"</b>";
                			}
                		}
                	}
                %>
                <span id='selectedwickets'><%=selectedwickets %></span>
            </td>
        </tr>

        <%-- DATE RANGE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <%=getTran(request,"medical.diagnosis","period",sWebLanguage)%>
            </td>
            <td class="admin2">
                <%-- FROM --%>
                <%=getTran(request,"web","from",sWebLanguage)%>&nbsp;
                <%
                    String sFromDate = "";
                    if(sFindWicketFromDate.length() > 0){
                        sFromDate = ScreenHelper.stdDateFormat.format(ScreenHelper.getSQLDate(sFindWicketFromDate));
                    }
                    else {
                        sFromDate = ScreenHelper.stdDateFormat.format(new java.util.Date());
                    }
                    out.print(writeDateField("FindWicketFromDate","SearchForm",sFromDate,sWebLanguage));
                %>&nbsp;

                <%-- TO --%>
                <%=getTran(request,"web","to",sWebLanguage)%>&nbsp;
                <%
                    String sToDate = "";
                    if(sFindWicketToDate.length() > 0){
                        sToDate = ScreenHelper.stdDateFormat.format(ScreenHelper.getSQLDate(sFindWicketToDate));
                    }
                    else {
                        sToDate = ScreenHelper.stdDateFormat.format(new java.util.Date());
                    }
                    out.print(writeDateField("FindWicketToDate","SearchForm",sToDate,sWebLanguage));
                %>

                <%-- clear date range button --%>
                &nbsp;&nbsp;<img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.FindWicketFromDate.value='';SearchForm.FindWicketToDate.value='';">
            </td>
        </tr>

        <%-- BUTTONS --%>
        <tr>
            <td class="admin"></td>
            <td class="admin2">
                <input class="button" type="button" name="searchButton" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="showOverview();">&nbsp;
                <input class="button" type="button" name="backButton" value="<%=getTranNoLink("Web","back",sWebLanguage)%>" onclick="doBack();">&nbsp;
            </td>
        </tr>
    </table>
</form>
<script>
	function addWicket(){
		var wicket=document.getElementById("FindWicketUid").value;
		if(wicket.length>0){
			if(document.getElementById('selectedwicketuids').value.indexOf(wicket+";")<0){
				if(document.getElementById('selectedwicketuids').value.length>0){
					document.getElementById('selectedwickets').innerHTML+=" + ";
				}
				document.getElementById('selectedwickets').innerHTML+="<b>"+document.getElementById("FindWicketUid").options[document.getElementById("FindWicketUid").selectedIndex].text+"</b>";
				document.getElementById('selectedwicketuids').value+=wicket+";";
			}
		}
	}
</script>

<%
    if(sAction.length() > 0){
        %>
            <%-- DEBETS -------------------------------------------------------------------------%>
            <table width="100%" class="list" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="5" class="admin"><%=getTran(request,"web.financial","out",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td colspan="5">
                        <%
                            // show debets
                            if(sDebetsHtml.length() > 0){
                                %>
                                    <div class="searchResults" style="width:100%;height:<%=((hDebets.size()>10?10:hDebets.size())*20+24)%>px;border:none;">
                                        <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults" style="border:none;">
                                            <%-- HEADER --%>
                                            <tr class="admin">
                                                <td><<%=sSortDir%>><%=getTranNoLink("wicket","operation_date",sWebLanguage)%></<%=sSortDir%>></td>
                                                <td>ID</td>
                                                <td><%=getTranNoLink("wicket","amount",sWebLanguage)%> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                                                <td><%=getTranNoLink("wicket","type",sWebLanguage)%></td>
                                                <td><%=getTranNoLink("wicket","user",sWebLanguage)%></td>
                                                <td><%=getTranNoLink("wicket","comment",sWebLanguage)%></td>
                                            </tr>

                                            <%=sDebetsHtml%>
                                        </table>
                                    </div>
                                <%
                            }
                            else{
                                %><%=getTranNoLink("web","norecordsfound",sWebLanguage)%><%
                            }
                        %>
                    </td>
                </tr>

                <%
                    if(hDebets.size() > 0){
                        %>
                            <%-- DEBET TOTAL --%>
                            <tr>
                                <td class="admin2">
                                    <div style="padding-left:2px;">
                                        <table cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="120" style="text-align:right;height:20px;"><%=getTran(request,"web","total",sWebLanguage)%>&nbsp;</td>
                                                <td width="150" style="text-align:right;height:20px;border-top:1px solid black;"><%=sWicketDebetTotal%>&nbsp;</td>
                                                <td width="150" style="height:20px;">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                                             </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        <%
                    }
                %>
            </table>

            <br><br>

            <%-- CREDITS ------------------------------------------------------------------------%>
            <table width="100%" class="list" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="5" class="admin"><%=getTran(request,"web.financial","in",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td colspan="5">
                        <%
                            // show credits
                            if(sCreditsHtml.length() > 0){
                                %>
                                    <div class="searchResults" style="width:100%;height:<%=((hCredits.size()>10?10:hCredits.size())*20+24)%>px;border:none;">
                                        <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults2" style="border:none;">
                                            <%-- HEADER --%>
                                            <tr class="admin">
                                                <td><<%=sSortDir%>><%=getTranNoLink("wicket","operation_date",sWebLanguage)%></<%=sSortDir%>></td>
                                                <td>ID</td>
                                                <td><%=getTranNoLink("wicket","amount",sWebLanguage)%> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                                                <td><%=getTranNoLink("wicket","type",sWebLanguage)%></td>
                                                <td><%=getTranNoLink("wicket","user",sWebLanguage)%></td>
                                                <td><%=getTranNoLink("wicket","comment",sWebLanguage)%></td>
                                            </tr>

                                            <%=sCreditsHtml%>
                                        </table>
                                    </div>
                                <%
                            }
                            else{
                                %><%=getTranNoLink("web","norecordsfound",sWebLanguage)%><%
                            }
                        %>
                    </td>
                </tr>

                <%
                    if(hCredits.size() > 0){
                        %>
                            <%-- CREDIT TOTAL --%>
                            <tr>
                                <td class="admin2">
                                    <div style="padding-left:2px;">
                                        <table cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="120" style="text-align:right;height:20px;"><%=getTran(request,"web","total",sWebLanguage)%>&nbsp;</td>
                                                <td width="150" style="text-align:right;height:20px;border-top:1px solid black;"><%=sWicketCreditTotal%>&nbsp;</td>
                                                <td width="150" style="height:20px;">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                                             </tr>
                                             <%if(sWicketAlternateCreditTotal.length()>0){ %>
	                                            <tr>
	                                                <td width="120" style="text-align:right;height:20px;">+</td>
	                                                <td width="150" style="text-align:right;height:20px;"><%=sWicketAlternateCreditTotal%>&nbsp;</td>
	                                                <td width="150" style="height:20px;">&nbsp;<%=sAlternateCurrency%></td>
	                                             </tr>
                                             <%} %>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        <%
                    }
                %>
            </table>

            <%-- SALDO --------------------------------------------------------------------------%>
            <%
                if(hDebets.size() > 0 || hCredits.size() > 0){
                         if(dDebetsTotal > 0) sWicketDebetTotal = "- "+sWicketDebetTotal;
                    else if(dDebetsTotal < 0) sWicketDebetTotal = "+ "+sWicketDebetTotal;

                         if(dCreditsTotal > 0) sWicketCreditTotal = "+ "+sWicketCreditTotal;
                    else if(dCreditsTotal < 0) sWicketCreditTotal = "- "+sWicketCreditTotal;
                    
                    %>
                        <br><br>

                        <table width="100%" class="list" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="admin2" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","out",sWebLanguage)%>&nbsp;</td>
                                <td class="admin2" style="text-align:right;width:150px;height:20px;"><%=sWicketDebetTotal%>&nbsp;</td>
                                <td class="admin2" style="height:20px;" width="40"></td>
                                <td class="admin2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="admin2" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","in",sWebLanguage)%>&nbsp;</td>
                                <td class="admin2" style="text-align:right;width:150px;height:20px;"><%=sWicketCreditTotal%>&nbsp;</td>
                                <td class="admin2" style="height:20px;" width="40"></td>
                                <td class="admin2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="admin" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","saldo",sWebLanguage).toUpperCase()%>&nbsp;</td>
                                <td class="admin" style="text-align:right;width:150px;height:20px;border-top:1px solid black;"><%=sWicketBalance%>&nbsp;</td>
                                <td class="admin" style="height:20px;" width="40"><%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                                <td class="admin">&nbsp;</td>
                            </tr>
                        </table>
                    <%
                }
            %>

            <%-- WICKET SITUATION ---------------------------------------------------------------%>
            <%
                if(sToDate.length()==0){
                	sToDate = ScreenHelper.stdDateFormat.format(new java.util.Date()); // now
                }
                
                double dBeginBalance = wicket.calculateBalance(new java.util.Date(ScreenHelper.parseDate(sFromDate).getTime()-1)),
                       dEndBalance   = dBeginBalance+dCreditsTotal-dDebetsTotal;


                String sBeginBalance = priceFormat.format(dBeginBalance),
                       sEndBalance   = priceFormat.format(dEndBalance);

                     if(dBeginBalance > 0) sBeginBalance = "+ "+sBeginBalance;
                     if(dBeginBalance < 0) sBeginBalance = "- "+sBeginBalance;

                     if(dCreditsTotal-dDebetsTotal > 0) sWicketBalance = "+ "+sWicketBalance;
                else if(dCreditsTotal-dDebetsTotal < 0) sWicketBalance = "- "+sWicketBalance;
            %>

            <br><br>

            <table width="100%" class="list" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="admin2" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","beginSituation",sWebLanguage)%>&nbsp;</td>
                    <td class="admin2" style="text-align:right;width:150px;height:20px;"><%=sBeginBalance%>&nbsp;</td>
                    <td class="admin2" style="height:20px;" width="50"></td>
                    <td class="admin2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="admin2" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","saldo",sWebLanguage)%>&nbsp;</td>
                    <td class="admin2" style="text-align:right;width:150px;height:20px;"><%=sWicketBalance%>&nbsp;</td>
                    <td class="admin2" style="height:20px;" width="50"></td>
                    <td class="admin2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="admin" style="text-align:right;width:120px;height:20px;"><%=getTran(request,"web.financial","endSituation",sWebLanguage).toUpperCase()%>&nbsp;</td>
                    <td class="admin" style="text-align:right;width:150px;height:20px;border-top:1px solid black;"><%=sEndBalance%>&nbsp;</td>
                    <td class="admin" style="height:20px;" width="50"><%=MedwanQuery.getInstance().getConfigParam("currency","€")%></td>
                    <td class="admin">&nbsp;</td>
                </tr>
            </table>
        <%

        // print button
        if(sFindWicketUid.length() > 0){
        	String sPrintWicketUid=sFindWicketUid;
        	if(sFindWicketUids.length()>0){
        		sPrintWicketUid=sFindWicketUids;
        	}
            %>
                <br>
                <div style="width:100%;text-align:right;">
                    <input class="button" type="button" name="printButton" value="<%=getTranNoLink("web","print",sWebLanguage)%>" onclick="printPdf('<%=sPrintWicketUid%>','<%=sFindWicketFromDate%>','<%=sFindWicketToDate%>');">
                </div>
            <%
        }
    }
%>

<script>
  SearchForm.FindWicketUid.focus();

  <%-- SHOW OVERVIEW --%>
  function showOverview(){
    if(SearchForm.FindWicketUid.value.length==0){
                window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
      SearchForm.FindWicketUid.focus();
    }
    else{
      var beginDate = SearchForm.FindWicketFromDate.value,
          endDate   = SearchForm.FindWicketToDate.value;

      if((beginDate.length>0 && endDate.length>0) && after(beginDate,endDate)){
    	alertDialog("Web.Occup","endMustComeAfterBegin");
        SearchForm.FindWicketToDate.focus();
      }
      else{
        SearchForm.Action.value = "search";
        SearchForm.searchButton.disabled = true;
        SearchForm.submit();
      }
    }
  }

  <%-- DO NEW OPERATION --%>
  function doNewOperation(id){
    window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperations.jsp"+
                           "&EditWicketOperationWicket="+id+
                           "&FindWicketUid="+id+
                           "&Action=NEW"+
                           "&ShowReturn=TRUE"+
                           "&ts=<%=getTs()%>";
  }

  <%-- DO DEBET --%>
  function doDebet(id){
    window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationDebet.jsp"+
                           "&EditWicketOperationWicket="+id+
                           "&FindWicketUid="+id+
                           "&ShowReturn=TRUE"+
                           "&ts=<%=getTs()%>";
  }

  <%-- DO CREDIT --%>
  function doCredit(id){
    window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationCredit.jsp"+
                           "&EditWicketOperationWicket="+id+
                           "&FindWicketUid="+id+
                           "&ShowReturn=TRUE"+
                           "&ts=<%=getTs()%>";
  }

  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=financial/index.jsp&ts=<%=getTs()%>";
  }

  <%-- SELECT WICKET OPERATION --%>
  function selectWicketOperation(wicketOpUid,type,wicketUid){
    if(type=="Debet"){
      window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationDebet.jsp"+
                             "&EditWicketOperationUid="+wicketOpUid+
                             "&FindWicketUid="+wicketUid+
                             "&ShowReturn=TRUE"+
                             "&ts=<%=getTs()%>";
    }
    else if(type=="Credit"){
      window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationCredit.jsp"+
                             "&EditWicketOperationUid="+wicketOpUid+
                             "&FindWicketUid="+wicketUid+
                             "&ShowReturn=TRUE&ts=<%=getTs()%>";
    }
  }

  <%-- DELETE WICKET OPERATION --%>
  function deleteWicketOperation(wicketOpUid,type,wicketUid){
      if(yesnoDeleteDialog()){
      if(type=="Debet"){
        window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationDebet.jsp"+
                               "&EditWicketOperationUid="+wicketOpUid+
                               "&FindWicketUid="+wicketUid+
                               "&Action=DELETE"+
                               "&ShowReturn=TRUE"+
                               "&ts=<%=getTs()%>";
      }
      else if(type=="Credit"){
        window.location.href = "<c:url value='/main.do'/>?Page=financial/wicket/manageWicketOperationCredit.jsp"+
                               "&EditWicketOperationUid="+wicketOpUid+
                               "&FindWicketUid="+wicketUid+
                               "&Action=DELETE"+
                               "&ShowReturn=TRUE"+
                               "&ts=<%=getTs()%>";
      }
    }
  }

  <%-- PRINT PDF --%>
  function printPdf(wicketUid,sWicketFromDate,sWicketToDate){
    var url = "<c:url value='/financial/createWicketOverviewPdf.jsp'/>"+
              "?WicketUid="+wicketUid+
              "&WicketFromDate="+sWicketFromDate+
              "&WicketToDate="+sWicketToDate+
              "&ts=<%=getTs()%>";
    window.open(url,"WicketOverviewPdf<%=getTs()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }

  <%-- UPDATE ROW STYLES --%>
  function updateRowStyles(){
    <%-- first table --%>
    for(var i=1; i<searchresults.rows.length; i++){
      searchresults.rows[i].className = "";
      searchresults.rows[i].style.cursor = "hand";
    }

    for(var i=1; i<searchresults.rows.length; i++){
      if(i%2==0){
        searchresults.rows[i].className = "list";
      }
      else{
        searchresults.rows[i].className = "list1";
      }
    }

    <%-- second table --%>
    for(var i=1; i<searchresults2.rows.length; i++){
      searchresults2.rows[i].className = "";
      searchresults2.rows[i].style.cursor = "hand";
    }

    for(var i=1; i<searchresults2.rows.length; i++){
      if(i%2==0){
        searchresults2.rows[i].className = "list";
      }
      else{
        searchresults2.rows[i].className = "list1";
      }
    }
  }
</script>