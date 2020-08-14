<%@page import="be.mxs.common.model.vo.healthrecord.VaccinationInfoVO,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width="100%" class="list" height="100%" cellspacing="0">
    <tr class="admin">
        <td colspan="3"><%=getTran(request,"curative","vaccination.status.title",sWebLanguage)%>
            &nbsp;<a href="<%=request.getRequestURI().replaceAll(request.getServletPath(),"")+MedwanQuery.getInstance().getConfigString("vaccinationForwardKey","/healthrecord/showVaccinationSummary.do")%>?ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_edit2.png'/>" class="link" alt="<%=getTranNoLink("web","editVaccinations",sWebLanguage)%>" ></a>
        </td>
    </tr>

    <%
        try{
	        if(activePatient != null){
	        	if(MedwanQuery.getInstance().getConfigInt("enableMaliVaccinations",0)==1){
	        		HashSet vaccinations = Vaccination.getVaccinationsTodo(activePatient.personid);
	        		Iterator iVaccinations = vaccinations.iterator();
	                String sClass = "";
	                int counter=0;
                    // alternate row-style
                    if(sClass.length()==0) sClass = "1";
                    else                   sClass = "";
                    out.print("<tr><td colspan='3'><table width='100%'><tr class='list"+sClass+"'>");
	        		while(iVaccinations.hasNext()){
	        			String vaccin = (String) iVaccinations.next();
                        %><td width="1"><img src="<c:url value='/_img/icons/icon_warning.gif'/>" alt=""><%
	                    out.print(" <b>"+getTran(request,"web",vaccin,sWebLanguage)+"</b></td>");
                        counter++;
                        if(counter>=5){
    	                    // alternate row-style
    	                    if(sClass.length()==0) sClass = "1";
    	                    else                   sClass = "";
    	                    out.print("</tr><tr class='list"+sClass+"'>");
    	                    counter=0;
                        }
	        		}
   	        		out.println("</tr></table></td></tr>");
	        	}
	        	else {
		            SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
		            sessionContainerWO.init(activePatient.personid);
		            
		            if(sessionContainerWO.getPersonVO()!=null){
		                Iterator vaccinations = MedwanQuery.getInstance().getPersonalVaccinationsInfo(sessionContainerWO.getPersonVO(), sWebLanguage).getVaccinationsInfoVO().iterator();
		                VaccinationInfoVO vaccInfoVO;
		                String nextDate;
		                boolean bWarning;
		                String sClass = "";
		
		                while(vaccinations.hasNext()){
		                    vaccInfoVO = (VaccinationInfoVO)vaccinations.next();
		                    
		                    nextDate = checkString(vaccInfoVO.getTransactionVO().getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_VACCINATION_NEXT_DATE"));
		                    
		                    // alternate row-style
		                    if(sClass.length()==0) sClass = "1";
		                    else                   sClass = "";
		                    
		                    // warning when due
		                    bWarning = false;	
		                    try{
		                        bWarning = ScreenHelper.parseDate(vaccInfoVO.getTransactionVO().getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_VACCINATION_NEXT_DATE")).before(new java.util.Date());
		                    }
		                    catch(Exception e){
		                        // nothing
		                    }
		                    
		                    out.print("<tr class='list"+sClass+"'>");
		
		                    if(bWarning){
		                        %><td width="1"><img src="<c:url value='/_img/icons/icon_warning.gif'/>" alt=""></td><%
		                    }
		                    else{
		                        %><td width="1"/><%
		                    }
		
		                    out.print("<td><b>"+getTran(request,"web.occup",vaccInfoVO.getType(),sWebLanguage)+" ("+checkString(vaccInfoVO.getTransactionVO().getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_DATE").getValue())+")</b></td><td>"+(nextDate.length()>0?"<img src='_img/themes/default/pijl.gif'> ":"")+nextDate+"</td></tr>");
		                }
		            }
	        	}
	        }
	    }
	    catch(Exception e){
	        e.printStackTrace();    
	    }
    %>
    <tr height="99%"><td/></tr>
</table>