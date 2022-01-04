<%@page import="be.openclinic.pharmacy.AdministrationSchema,
                be.openclinic.common.KeyValue,
                be.mxs.webapp.wl.servlet.http.RequestParameterParser,
                be.mxs.common.util.system.*,
                java.util.Hashtable,
                be.openclinic.medical.CarePrescriptionAdministrationSchema"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"nursing","select",activeUser)%>

<%
	try{
    int adminDays = MedwanQuery.getInstance().getConfigInt("administrationSchemaDays",5);

	// start date
	java.util.Date dStart = new java.util.Date(ScreenHelper.getDate(new java.util.Date()).getTime() - 1 * 24 * 3600 * 1000);
	String sStartDate = checkString(request.getParameter("startdate"));
	if(sStartDate.length() > 0){
	    dStart = new java.util.Date(ScreenHelper.parseDate(sStartDate).getTime() - 1 * 24 * 3600 * 1000);
	}
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n******************* nursing/manageAdministrations.jsp *****************");
    	Debug.println("adminDays  : "+adminDays);
    	Debug.println("sStartDate : "+sStartDate+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    SimpleDateFormat compactDateFormat = new SimpleDateFormat("yyyyMMdd");
    String sMsg = "";
    

    //--- SAVE ------------------------------------------------------------------------------------
    if(request.getParameter("saveButton")!=null){
    	//*** 1 - drugprescr *** 
        Hashtable requestParameters = RequestParameterParser.getInstance().parseRequestParameters(request,"drugprescr");
        String parameter, sDay, prescriptionUid, time, value;
        
        if(requestParameters.size() > 0){
            Iterator iterator = requestParameters.keySet().iterator();
	        while(iterator.hasNext()){
	            parameter = (String)iterator.next();
	            sDay = parameter.substring(10).split("_")[0];
	            prescriptionUid = parameter.substring(10).split("_")[1];
	            time = parameter.substring(10).split("_")[2];
	            value = (String) requestParameters.get(parameter);
	            value=value.replace(",", ".");
	
	            AdministrationSchema.storeAdministration(prescriptionUid,compactDateFormat.parse(sDay),Integer.parseInt(time),
	            		                                 Double.parseDouble(value));
	        }
            sMsg = getTran(request,"web","dataIsSaved",sWebLanguage);
        }
        
        //*** 2 - careprescr ***
        requestParameters = RequestParameterParser.getInstance().parseRequestParameters(request,"careprescr");
        if(requestParameters.size() > 0){
	        Iterator iterator = requestParameters.keySet().iterator();	                
	        while(iterator.hasNext()){
	            parameter = (String)iterator.next();
	            sDay = parameter.substring(10).split("_")[0];
	            prescriptionUid = parameter.substring(10).split("_")[1];
	            time = parameter.substring(10).split("_")[2];
	            value = (String)requestParameters.get(parameter);
	
	            CarePrescriptionAdministrationSchema.storeAdministration(prescriptionUid,compactDateFormat.parse(sDay),
	            		                                                 Integer.parseInt(time),new Double(Double.parseDouble(value)).intValue());
	        }
            sMsg = getTran(request,"web","dataIsSaved",sWebLanguage);
        }
    }
%>
<form name="formAdministrations" method="post">
    <%
    	long lHour=3600*1000;
	    java.util.Date day;
	    double val, adminVal;
	    String sClass;
	    
        AdministrationSchema schema = new AdministrationSchema(dStart,new java.util.Date(dStart.getTime()+adminDays * 24 * 3600 * 1000),activePatient.personid);
        if(schema.getPrescriptionSchemas()==null || schema.getPrescriptionSchemas().size() == 0){
			%>
            <%-- 1 - TREATMENT DIAGRAM ------------------------------------------------------------------%>
			<div id='divscroll' class='tscroll'>
            <table width="100%" cellspacing="0" cellpadding="0">
            <tr class='admin'><td class='tscrollcol'><%=getTran(request,"web","medicationschema",sWebLanguage)%></td><td class='tscrolladmin' colspan='5'></td></tr>
			<%
            // Day header
            out.print("<tr>"+
                       "<td width='1%' nowrap/><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");
            for(int d=0; d<adminDays; d++){
                %>
                    <td class="admin" width="<%=(100/(adminDays))%>%">
                        <center><%=d==0?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-left.png'>":""%>&nbsp;<a href="<c:url value='/main.do'/>?Page=nursing/manageAdministrations.jsp&startdate=<%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%>"><%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%></a>&nbsp;<%=d>=adminDays-1?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-right.png'>":""%></center>
                    </td>
                <%
            }
            out.print("</tr></table></td></tr>");
        }
        else{
            AdministrationSchema.AdministrationSchemaLine line = (AdministrationSchema.AdministrationSchemaLine)schema.getPrescriptionSchemas().elementAt(0);
			int tablewidth=100;
			if(line.getTimeQuantities().size()>8-adminDays){
				//	tablewidth=100*line.getTimeQuantities().size()/(8-adminDays);
			}
			%>
            <%-- 1 - TREATMENT DIAGRAM ------------------------------------------------------------------%>
            <table width="<%=tablewidth%>%" cellspacing="0" cellpadding="0">
            <tr class='admin'><td class='tscrollcol'><%=getTran(request,"web","medicationschema",sWebLanguage)%></td><td class='tscrolladmin' colspan='5'></td></tr>
			<%
            // Day header
            out.print("<tr>"+
                       "<td bgcolor='white' width='1%' nowrap class='tscrollcolwhite'/><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");
            String hours = line.getTimeQuantities().size()+"";
            for(int d=0; d<adminDays; d++){
                %>
                    <td class="admin" colspan="<%=hours%>" width="<%=(100/(adminDays))%>%">
                        <center><%=d==0?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-left.png'>":""%>&nbsp;<a href="<c:url value='/main.do'/>?Page=nursing/manageAdministrations.jsp&startdate=<%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%>"><%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%></a>&nbsp;<%=d>=adminDays-1?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-right.png'>":""%></center>
                    </td>
                <%
            }
            out.print("</tr></table></td></tr>");

            // Hour header
            out.print("<tr>"+
                       "<td bgcolor='white' class='tscrollcolwhite'/><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");
            for(int d=0; d<adminDays; d++){
                for(int i=0; i<line.getTimeQuantities().size(); i++){
                    out.print("<td width='"+(100/((adminDays)*line.getTimeQuantities().size()))+"%' class='admin'><center>"+((KeyValue)line.getTimeQuantities().elementAt(i)).getKey()+getTran(request,"web","abbreviation.hour", sWebLanguage)+"</center></td>");
                }
            }
            out.print("</tr></table></td></tr>");
	        for(int n=0; n<schema.getPrescriptionSchemas().size(); n++){
	            line = (AdministrationSchema.AdministrationSchemaLine)schema.getPrescriptionSchemas().elementAt(n);
				HashSet hPrestations = new HashSet();
	            out.print("<tr style='vertical-align: top'>");
	             out.print("<td bgcolor='lightgrey' nowrap class='tscrollcolgrey'>&nbsp;<b>"+(line.getPrescription().getProduct()!=null?line.getPrescription().getProduct().getName():"Unknown product")+"</b>&nbsp;</td><td><table style='table-layout: fixed' width='100%' cellspacing='1' cellpadding='0'><tr>");
	
	            for(int d=0; d<adminDays; d++){
	                
	            	day = new java.util.Date(dStart.getTime()+d*24*lHour);
		            Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		            PreparedStatement ps = conn.prepareStatement("select OC_NURSINGDEBET_KEY from OC_NURSINGDEBETS where OC_NURSINGDEBET_KEY like ?");
		            ps.setString(1, activePatient.personid+"_"+compactDateFormat.format(day)+"_"+line.getPrescription().getUid()+"%");
		            ResultSet rs = ps.executeQuery();
		            while(rs.next()){
		            	hPrestations.add(rs.getString("OC_NURSINGDEBET_KEY"));
		            }
		            rs.close();
		            ps.close();
		            conn.close();
	
	                for(int i=0; i<line.getTimeQuantities().size(); i++){
	                    if(!line.getPrescription().getBegin().after(day) && !(line.getPrescription().getEnd()!=null && line.getPrescription().getEnd().before(day))){
	                        val = ((KeyValue)line.getTimeQuantities().elementAt(i)).getValueDouble();
	                        String sval = "&nbsp;";
	                        if(val>0){
	                        	if(val>new Double(val).intValue()){
	                        		sval=val+"";
	                        	}
	                        	else{
	                        		sval=new Double(val).intValue()+"";
	                        	}
	                        }
	                        out.print("<td bgcolor='lightgrey' nowrap style='width: 50px;vertical-align: middle;text-align: center'>"+sval);
	                        try{
	                            adminVal = Double.parseDouble(line.getTimeAdministration(compactDateFormat.format(day)+"."+((KeyValue)line.getTimeQuantities().elementAt(i)).getKey()));
	                        }
	                        catch(Exception e){
	                            adminVal = 0;
	                        }
	                        if(activeUser.getAccessRightNoSA("nursing.edit") && (activeUser.getAccessRightNoSA("nursingforceedit.edit") || (!day.before(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("maximumNursingDataEditableHours",48)*lHour-((KeyValue)line.getTimeQuantities().elementAt(i)).getKeyInt()*lHour))) && val > 0)){
	
	                            sClass = "textbold";
	                            if(adminVal ==0){
	                                sClass = "textred";
	                            }
	                            sval = new Double(adminVal).intValue()+"";
	                        	if(adminVal>new Double(adminVal).intValue()){
	                        		sval=adminVal+"";
	                        	}
	                        	String sKey=compactDateFormat.format(day)+"_"+line.getPrescription().getUid()+"_"+((KeyValue)line.getTimeQuantities().elementAt(i)).getKey();
	                            out.print("&nbsp;<input name='drugprescr"+sKey+"' type='text' class='"+sClass+"' style='width:20px;height: 16px;vertical-align: top' size='1' value='"+sval+"'/>");
	                            if(hPrestations.contains(activePatient.personid+"_"+sKey)){
	                            	out.println("<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='addPrestation(\""+activePatient.personid+"_"+sKey+"\");' title='"+Pointer.getPointer(activePatient.personid+"_"+sKey)+"'/>");
	                            }
	                            else{
	                            	out.println("<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_add.gif' onclick='addPrestation(\""+activePatient.personid+"_"+sKey+"\");' title='"+Pointer.getPointer(activePatient.personid+"_"+sKey)+"'/>");
	                            }
	                        }
	                        else{
	                            sval = new Double(adminVal).intValue()+"";
	                        	if(adminVal>new Double(adminVal).intValue()){
	                        		sval=adminVal+"";
	                        	}
	                        	out.print(" [<b>"+sval+"</b>]");
	                        }
	                        out.print( "</td>");
	                    }
	                    else{
	                        out.print("<td bgcolor='lightgrey' style='width:50px;min-width:50px'>&nbsp;</td>");
	                    }
	                }
	            }
	            out.print("</tr></table></td></tr>");
	        }
        }
    %>
    
    <%
        CarePrescriptionAdministrationSchema.AdministrationSchemaLine cLine;
        CarePrescriptionAdministrationSchema cSchema = new CarePrescriptionAdministrationSchema(dStart,new java.util.Date(dStart.getTime()+adminDays * 24 * 3600 * 1000),activePatient.personid);
        if(cSchema.getCarePrescriptionSchemas().size() > 0){
        	%>
		    <%-- 2 - CARE DIAGRAM -----------------------------------------------------------------------%>
		    <tr class='admin'><td class='tscrollcol'><%=getTran(request,"web","careschema",sWebLanguage)%></td><td class='tscrolladmin' colspan='5'></tr>
        	<%
            cLine = (CarePrescriptionAdministrationSchema.AdministrationSchemaLine)cSchema.getCarePrescriptionSchemas().elementAt(0);

            // Day header
            out.print("<tr>"+
                       "<td bgcolor='white' class='tscrollcolwhite'/><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");
            String hours = cLine.getTimeQuantities().size()+"";
            for(int d=0; d<adminDays; d++){
                %>
                    <td class="admin" colspan="<%=hours%>" width="<%=(100/(adminDays))%>%">
                        <center><a href="<c:url value='/main.do'/>?Page=nursing/manageAdministrations.jsp&startdate=<%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%>"><%=ScreenHelper.formatDate(new java.util.Date(dStart.getTime()+d * 24 * 3600 * 1000))%></a></center>
                    </td>
                <%
            }
            out.print("</tr></table></td></tr>");

            // Hour header
            out.print("<tr>"+
                       "<td bgcolor='white' class='tscrollcolwhite'/><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");
            for(int d=0; d<adminDays; d++){
                for(int i=0; i<cLine.getTimeQuantities().size(); i++){
                    out.print("<td class='admin' width='"+(100/((adminDays)*cLine.getTimeQuantities().size()))+"%'><center>"+((KeyValue)cLine.getTimeQuantities().elementAt(i)).getKey()+getTran(request,"web","abbreviation.hour",sWebLanguage)+"</center></td>");
                }
            }
            out.print("</tr></table></td></tr>");
        }

        // display days
        for(int n=0; n<cSchema.getCarePrescriptionSchemas().size(); n++){
            cLine = (CarePrescriptionAdministrationSchema.AdministrationSchemaLine)cSchema.getCarePrescriptionSchemas().elementAt(n);

            out.print("<tr>");
             out.print("<td bgcolor='lightgrey' nowrap class='tscrollcolgrey'>&nbsp;<b>"+(cLine.getCarePrescription().getCareUid()!=null?getTran(request,"care_type",cLine.getCarePrescription().getCareUid(),sWebLanguage):"Unknown care type")+"&nbsp;</b></td><td><table width='100%' cellspacing='1' cellpadding='0'><tr>");

            for(int d=0; d<adminDays; d++){
                day = new java.util.Date(dStart.getTime()+d * 24 * lHour);
                
                for(int i=0; i<cLine.getTimeQuantities().size(); i++){
                    if(!cLine.getCarePrescription().getBegin().after(day) && !(cLine.getCarePrescription().getEnd()!=null && cLine.getCarePrescription().getEnd().before(day))){
                        val = ((KeyValue)cLine.getTimeQuantities().elementAt(i)).getValueInt();
                        out.print("<td bgcolor='lightgrey' nowrap style='min-width: 50px;width: 50px;height: 18px;vertical-align: middle;text-align: center'>"+(val>0?new Double(val).intValue()+"":"&nbsp;"));
                        try{
                            adminVal = Integer.parseInt(cLine.getTimeAdministration(compactDateFormat.format(day)+"."+((KeyValue)cLine.getTimeQuantities().elementAt(i)).getKey()));
                        }
                        catch(Exception e){
                            adminVal = 0;
                        }
                        if(activeUser.getAccessRightNoSA("nursing.edit") && !day.before(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("maximumNursingDataEditableHours",48)*lHour-((KeyValue)cLine.getTimeQuantities().elementAt(i)).getKeyInt()*lHour)) && val > 0){

                            sClass = "textbold";
                            if(adminVal ==0){
                                sClass = "textred";
                            }

                            out.print("&nbsp;<input style='width: 20px; height: 16px' name='careprescr"+compactDateFormat.format(day)+"_"+cLine.getCarePrescription().getUid()+"_"+((KeyValue)cLine.getTimeQuantities().elementAt(i)).getKey()+"' type='text' class='"+sClass+"' size='1' value='"+new Double(adminVal).intValue()+"'/>");
                            if(ScreenHelper.checkString(cLine.getCarePrescription().getComment()).length()>0){
                            	out.print(" <img src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' title='"+cLine.getCarePrescription().getComment()+"'/>");
                            }
                        }
                        else{
                        	out.print(" [<b>"+adminVal+"</b>]");
                        }

                        out.print("</td>");
                    }
                    else{
                        out.print("<td bgcolor='lightgrey' style='min-width: 50px;width: 50px;'>&nbsp;</td>");
                    }
                }
            }
            out.print("</tr></table></td></tr>");
        }
    %>
    <tr>
    	<td class='tscrollcolwhite' nowrap>
    		<br/>
	    	<%if(activeUser.getAccessRightNoSA("nursing.edit")){ %>
	        	<input class="button" type="submit" name="saveButton" value="<%=getTranNoLink("Web","save",sWebLanguage)%>"/>
	        	<input class="button" type="button" name="addPrestationButton" value="<%=getTranNoLink("Web","prestations",sWebLanguage)%>" onclick='addPrestation("<%=activePatient.personid%>_")'/>
	        <%} %>
	        <input class="button" type="button" name="todayButton" value="<%=getTranNoLink("Web","today",sWebLanguage)%>" onclick="doToday();"/>
	    </td>
	    <td colspan='5'/>
    </tr>
    </table>
    <br/>
    
    <%
        if(sMsg.length() > 0){
            %><%=sMsg%><br><%
        }
    %>
    
</form>

<script>
  <%-- DO TODAY --%>
  function doToday(){
    window.location.href = "<c:url value='main.do'/>?Page=nursing/manageAdministrations.jsp&startdate=<%=ScreenHelper.formatDate(new java.util.Date())%>";
  }
  
  function addPrestation(id){
	    openPopup("/nursing/manageNursingPrestations.jsp&key="+id+"&ts=<%=getTs()%>",800,400).focus();
  }
</script>

<%
	}
	catch(Exception t){
		t.printStackTrace();
	}
%>
