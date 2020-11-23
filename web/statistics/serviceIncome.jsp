<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSDATE%>

<%
    String sBegin = checkString(request.getParameter("begin"));
    if(sBegin.length()==0){
        sBegin = "01/01/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
    }
    
    String sEnd = checkString(request.getParameter("end"));
    if(sEnd.length()==0){
        //sEnd = ScreenHelper.stdDateFormat.format(new java.util.Date()); // now
        
	    if(ScreenHelper.stdDateFormat.toPattern().equals("dd/MM/yyyy")){
            sEnd = "31/12/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
	    }
	    else{
            sEnd = "12/31/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
	    }
    }
    
    String serviceId = checkString(request.getParameter("serviceid"));
    if(request.getParameter("find")==null && serviceId.length()==0) serviceId = activeUser.activeService.code; 
    
    String serviceName = "";
    if(serviceId.length() > 0){
    	serviceName = getTranNoLink("service",serviceId,sWebLanguage);
    }

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n********************* statistics/serviceIncome.jsp ********************");
    	Debug.println("sBegin      : "+sBegin);
    	Debug.println("sEnd        : "+sEnd);
    	Debug.println("serviceId   : "+serviceId);
    	Debug.println("serviceName : "+serviceName+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
%>
<form method="post" name="serviceIncome" id="serviceIncome">
    <%=writeTableHeader("Web","statistics.serviceIncome",sWebLanguage," doBack();")%>
    
    <table class="menu" width="100%" cellpadding="0" cellspacing="1">
        <%-- PERIOD --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","period",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <%=getTran(request,"web","from",sWebLanguage)%>&nbsp;<%=writeDateField("begin","serviceIncome",sBegin,sWebLanguage)%>&nbsp;
                <%=getTran(request,"web","to",sWebLanguage)%>&nbsp;<%=writeDateField("end","serviceIncome",sEnd,sWebLanguage)%>&nbsp;
                
                <%-- BUTTONS --%>
                <input type="submit" class="button" name="find" value="<%=getTranNoLink("web","find",sWebLanguage)%>"/>&nbsp;
                <input type="button" class="button" name="backButton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBack();">
                <input type="button" class="button" name="printPdfButton" value="<%=getTranNoLink("web","printpdf",sWebLanguage)%>" onclick="doPrintPDF();">
            </td>
        </tr>
        
        <%-- SERVICE --%>
        <tr>
        	<td class="admin"><%=getTran(request,"Web","service",sWebLanguage)%></td>
        	<td class="admin2" colspan='2'>
        	    <input type='hidden' name='serviceid' id='serviceid' value='<%=serviceId%>'>
        		<input class='text' type='text' name='servicename' id='servicename' readonly size='60' value='<%=serviceName %>'>
        		
        		<img src='_img/icons/icon_search.png' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("serviceid","servicename");'>
        		<img src='_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='serviceid.value="";servicename.value="";'>
        	</td>
        </tr>
    </table>
</form>

<%
    //*** SEARCH **********************************************************************************
    if(request.getParameter("find")!=null){
    	java.util.Date begin = ScreenHelper.fullDateFormat.parse(sBegin+" 00:00"),
    	               end   = ScreenHelper.fullDateFormat.parse(sEnd+" 23:59");
        
    	// zoek alle debets van de betreffende periode en ventileer deze per dienst		
        String sQuery = "select sum(number) number, sum(quantity) quantity, sum(total) total, sum(patientincome) patientincome, sum(insurarincome) insurarincome,"+
    	                "       oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
    	                " from ("+
                        "  select count(*) number, sum(oc_debet_quantity) quantity, sum(oc_debet_amount+oc_debet_insuraramount+oc_debet_extrainsuraramount) total,"+
    	                "         sum(oc_debet_amount) patientincome, sum(oc_debet_insuraramount+oc_debet_extrainsuraramount) insurarincome,"+
                        "         oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
                        "   from oc_debets a, oc_prestations b, oc_encounters c, adminview d"+
                        "    where oc_prestation_objectid = replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+ 
                        "     and oc_encounter_objectid = replace(a.oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+ 
                        "     and d.personid = c.oc_encounter_patientuid"+
                        "     and (oc_debet_patientinvoiceuid is not null and oc_debet_patientinvoiceuid<>'')"+
                        "     and oc_debet_date between ? and ?"+
                        "     and oc_debet_serviceuid in ("+Service.getChildIdsAsString(serviceId)+")"+
                        "  group by oc_debet_serviceuid,oc_prestation_description,oc_prestation_code"+
        				" union "+
                        "select count(*) number, sum(oc_debet_quantity) quantity, sum(oc_debet_amount+oc_debet_insuraramount+oc_debet_extrainsuraramount) total,"+
        				"       sum(oc_debet_amount) patientincome, sum(oc_debet_insuraramount+oc_debet_extrainsuraramount) insurarincome,"+
                        "       serviceuid as oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
                        " from ("+
                        "  select oc_debet_amount,oc_debet_insuraramount,oc_debet_quantity,oc_debet_extrainsuraramount,oc_debet_prestationuid,"+
                        "   ("+
                        "    select max(oc_encounter_serviceuid)"+
                        "     from oc_encounters_view"+
                        "       where oc_encounter_objectid = replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
                        "   ) as serviceuid"+	
                        "   from oc_debets"+
                        "    where (oc_debet_patientinvoiceuid is not null"+
                        "     and oc_debet_patientinvoiceuid<>'')"+
                        "     and oc_debet_date between ? and ?"+
                        "     and oc_debet_serviceuid is null) a, oc_prestations b"+
                        "  where oc_prestation_objectid = replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
                        "   and serviceuid in ("+Service.getChildIdsAsString(serviceId)+")"+
                        "    group by serviceuid,oc_prestation_description,oc_prestation_code"+
                        "   ) as q"+
                        " group by oc_debet_serviceuid,oc_prestation_description,oc_prestation_code"+
                        " order by oc_debet_serviceuid,total desc";
    	Debug.println(sQuery);
        Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
        PreparedStatement ps = conn.prepareStatement(sQuery);
        ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
        ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
        ps.setTimestamp(3,new java.sql.Timestamp(begin.getTime()));
        ps.setTimestamp(4,new java.sql.Timestamp(end.getTime()));
        ResultSet rs = ps.executeQuery();
        
        String activeservice = null;
        double totalpatientincome = 0;
        double totalinsurarincome = 0;
        double totalservicepatientincome = 0;
        double totalserviceinsurarincome = 0;
        double recordCount = 0;
        %><table class="list" width="100%" cellpadding="0" cellspacing="1"><%
        
        while(rs.next()){
            String serviceuid = checkString(rs.getString("oc_debet_serviceuid"));
            
            if(activeservice==null || !activeservice.equalsIgnoreCase(serviceuid)){
                
                if(activeservice!=null){
                    out.print("<tr>"+
                               "<td/>"+
                    		   "<td colspan='4'><hr/></td>"+
                              "</tr>"+
                              "<tr>"+
                               "<td colspan='2'/>"+
                               "<td><b>"+SH.getPriceFormat(totalserviceinsurarincome+totalservicepatientincome)+"</b></td>"+
                               "<td><b>"+SH.getPriceFormat(totalservicepatientincome)+"</b></td>"+
                               "<td><b>"+SH.getPriceFormat(totalserviceinsurarincome)+"</b></td>"+
                              "</tr>");
                }
                
                activeservice = serviceuid;
                out.print("<tr class='admin'>"+
                           "<td>"+(activeservice.length()==0?"?":activeservice+": "+getTran(request,"service",activeservice,sWebLanguage))+"</td>"+
                           "<td>#</td>"+
                		   "<td>"+getTran(request,"web","total",sWebLanguage)+"</td>"+
                           "<td>"+getTran(request,"web","patient",sWebLanguage)+"</td>"+
                		   "<td>"+getTran(request,"web","insurar",sWebLanguage)+"</td>"+
                          "</tr>");
                totalpatientincome+= totalservicepatientincome;
                totalinsurarincome+= totalserviceinsurarincome;
                
                totalserviceinsurarincome = 0;
                totalservicepatientincome = 0;
                
                recordCount++;
            }
            
            double patientincome = rs.getDouble("patientincome");
            double insurarincome = rs.getDouble("insurarincome");
            
            totalserviceinsurarincome+= insurarincome;
            totalservicepatientincome+= patientincome;
            
            out.print("<tr>"+
                       "<td class='admin'>"+rs.getString("oc_prestation_code")+": "+rs.getString("oc_prestation_description")+"</td>"+
                       "<td>"+rs.getInt("quantity")+" ("+rs.getInt("number")+" "+getTran(request,"web","invoices",sWebLanguage)+")</td>"+
                       "<td>"+SH.getPriceFormat(patientincome+insurarincome)+"</td>"+
                       "<td>"+SH.getPriceFormat(patientincome)+"</td>"+
                       "<td>"+SH.getPriceFormat(insurarincome)+"</td>"+
                      "</tr>");
        }
        
        if(activeservice!=null){
            out.print("<tr><td/><td colspan='4'><hr/></td></tr>");
            out.print("<tr>"+
                       "<td colspan='2'/>"+
                       "<td><b>"+SH.getPriceFormat(totalserviceinsurarincome+totalservicepatientincome)+"</b></td>"+
                       "<td><b>"+SH.getPriceFormat(totalservicepatientincome)+"</b></td>"+
                       "<td><b>"+SH.getPriceFormat(totalserviceinsurarincome)+"</b></td>"+
                      "</tr>");
            
            totalpatientincome+= totalservicepatientincome;
            totalinsurarincome+= totalserviceinsurarincome;
            
            out.print("<tr class='admin'>"+
                       "<td>"+getTran(request,"web","allservices",sWebLanguage)+"</td>"+
            		   "<td/>"+
                       "<td><b>"+SH.getPriceFormat(totalinsurarincome+totalpatientincome)+"</b></td>"+
            		   "<td><b>"+SH.getPriceFormat(totalpatientincome)+"</b></td>"+
                       "<td><b>"+SH.getPriceFormat(totalinsurarincome)+"</b></td>"+
            		  "</tr>");
        }
        rs.close();
        ps.close();
        
        
        out.print("<tr><td>&nbsp;</td></tr><tr class='admin'><td >"+getTran(request,"web","otherwicketoperations",sWebLanguage)+"</td><td>#</td><td>"+getTran(request,"web","total",sWebLanguage)+"</td><td/><td/></tr>");
        //Autres opérations de caisse
		ps = conn.prepareStatement("select count(*) total,sum(oc_wicket_credit_amount) amount,oc_wicket_credit_type from oc_wicket_credits where oc_wicket_credit_operationdate>=? and oc_wicket_credit_operationdate<? and oc_wicket_credit_type<>'patient.payment' group by oc_wicket_credit_type");
        ps.setTimestamp(1, new java.sql.Timestamp(begin.getTime()));
        ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
        rs=ps.executeQuery();
        totalpatientincome=0;
        while(rs.next()){
        	out.println("<tr><td class='admin'>"+getTran(request,"wicketcredit.type",rs.getString("oc_wicket_credit_type"),sWebLanguage)+"</td><td>"+rs.getInt("total")+"</td><td>"+SH.getPriceFormat(rs.getDouble("amount"))+"</td><td/><td/></tr>");
        	totalpatientincome+=rs.getDouble("amount");
        	recordCount++;
        }
        out.print("<tr class='admin'>"+
                "<td>"+getTran(request,"web","alloperations",sWebLanguage)+"</td>"+
     		   "<td/>"+
                "<td><b>"+SH.getPriceFormat(totalpatientincome)+"</b></td>"+
     		   "<td></td>"+
                "<td></td>"+
     		  "</tr>");
        rs.close();
        ps.close();
        conn.close();
        %></table><%
        if(recordCount==0){
        	%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
        }
        else{
        	%>
        	    <%=recordCount%> <%=getTran(request,"web","recordsFound",sWebLanguage)%>
        	<%
        }
    }
%>

<script>
  <%-- SEARCH SERVICE --%>
  function searchService(serviceUidField,serviceNameField){
    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    document.getElementById(serviceNameField).focus();
  }
  
  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=statistics/index.jsp";
  }
  
  function doPrintPDF(){
	  var parameters = "begin="+document.getElementById('begin').value+"&end="+document.getElementById('end').value+"&service="+document.getElementById('serviceid').value;
      var url= '<c:url value="/financial/printCashDeskCertificatePdf.jsp"/>?ts='+new Date()+"&"+parameters;
      window.open(url,"CashDeskCertificatePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }
</script>