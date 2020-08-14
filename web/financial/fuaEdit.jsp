<%@page import="pe.gob.sis.*,be.openclinic.finance.*,be.openclinic.medical.*,be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"financial.fua","edit",activeUser)%>
<%
	String list="1";
	if(checkString(request.getParameter("list")).length()>0){
		list=request.getParameter("list");
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
	<% 
		boolean bExist=false;
		if(list.equalsIgnoreCase("1") && activePatient!=null){
			Encounter lastEncounter = Encounter.getLastEncounter(activePatient.personid);
			//If there is an encounter for this patient, then show why a FUA cannot be created for the last encounter
			if(lastEncounter!=null && FUA.getFUASForEncounter(lastEncounter.getUid()).size()==0 && !FUA.getEncountersWithoutFUA(Integer.parseInt(activePatient.personid)).contains(lastEncounter)){
				out.println("<tr><td colspan='5'><img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> <b>"+getTran(request,"web","reasonnofuas",sWebLanguage)+" ["+getTran(request,"encountertype",lastEncounter.getType(),sWebLanguage)+": "+lastEncounter.getService().getLabel(sWebLanguage)+"&nbsp;&nbsp;&nbsp;"+ScreenHelper.formatDate(lastEncounter.getBegin())+(lastEncounter.getEnd()==null?"":" - "+ScreenHelper.formatDate(lastEncounter.getEnd()))+"]"+":</b></td></tr>");
				if(lastEncounter.getEnd()==null){
					out.println("<tr><td width='2%'/><td colspan='4'><li><a href='"+sCONTEXTPATH+"/main.do?Page=adt/editEncounter.jsp&EditEncounterUID="+lastEncounter.getUid()+"'>"+getTran(request,"fuaerror","encounternotclosed",sWebLanguage)+"</a></li></td></tr>");
				}
				Vector debets=Debet.getEncounterDebets(lastEncounter.getUid());
				if(debets.size()==0){
					out.println("<tr><td width='2%'/><td colspan='4'><li><a href='"+sCONTEXTPATH+"/main.do?Page=financial/debetEdit.jsp'>"+getTran(request,"fuaerror","nodebets",sWebLanguage)+"</a></li></td></tr>");
				}
				out.println("<tr><td colspan='5'><br/><hr/></td></tr>");
			}
			if(lastEncounter!=null){
				StringBuffer sbErrors= new StringBuffer();
				boolean bErrors=false;
				Vector debets=Debet.getEncounterDebets(lastEncounter.getUid());
				if(debets.size()>0){
					boolean bInvoicedDebetExists = false;
					for(int n=0;n<debets.size();n++){
						Debet debet = (Debet)debets.elementAt(n);
						if(checkString(debet.getPatientInvoiceUid()).length()>0){
							bInvoicedDebetExists=true;
							break;
						}
					}
					if(!bInvoicedDebetExists){
						sbErrors.append("<tr><td width='2%'/><td colspan='4'><li><a href='"+sCONTEXTPATH+"/main.do?Page=financial/patientInvoiceEdit.jsp'>"+getTran(request,"fuaerror","noinvoiceddebets",sWebLanguage)+"</a></li></td></tr>");
						bErrors=true;
					}
				}
				debets = Debet.getEncounterDebets(lastEncounter.getUid());
				boolean bUndiagnosedDebets =false;
				for(int n=0;n<debets.size();n++){
					Debet debet = (Debet)debets.elementAt(n);
					if(checkString(debet.getDiagnosisUid()).length()==0){
						bUndiagnosedDebets=true;
						break;
					}
				}
				if(bUndiagnosedDebets){
					sbErrors.append("<tr><td width='2%'/><td colspan='4'><li><a href='javascript:openPopup(\"medical/managePrescriptionsPopup.jsp&skipEmpty=1\",900,400,\"Prescriptions\")'>"+getTran(request,"fuaerror","missingindicationfordebets",sWebLanguage)+"</a></li></td></tr>");
					bErrors=true;
				}
				Vector prescriptions = Prescription.findUndelivered(lastEncounter);
				if(prescriptions.size()>0){
					sbErrors.append("<tr><td width='2%'/><td colspan='4'><li><a href='javascript:openPopup(\"medical/managePrescriptionsPopup.jsp&skipEmpty=1\",900,400,\"Prescriptions\")'>"+getTran(request,"fuaerror","undelivereddrugs",sWebLanguage)+"</a></li></td></tr>");
					bErrors=true;
				}
				prescriptions = Prescription.findUndiagnosed(lastEncounter);
				if(prescriptions.size()>0){
					sbErrors.append("<tr><td width='2%'/><td colspan='4'><li><a href='javascript:openPopup(\"medical/managePrescriptionsPopup.jsp&skipEmpty=1&showDiagnosis=1\",900,400,\"Prescriptions\")'>"+getTran(request,"fuaerror","prescriptionswithoutindication",sWebLanguage)+"</a></li></td></tr>");
					bErrors=true;
				}
				if(bErrors){
					out.println("<tr><td colspan='5'><img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> <b>"+getTran(request,"web","potentialfuaerrors",sWebLanguage)+" ["+getTran(request,"encountertype",lastEncounter.getType(),sWebLanguage)+": "+lastEncounter.getService().getLabel(sWebLanguage)+"&nbsp;&nbsp;&nbsp;"+ScreenHelper.formatDate(lastEncounter.getBegin())+(lastEncounter.getEnd()==null?"":" - "+ScreenHelper.formatDate(lastEncounter.getEnd()))+"]"+":</b></td></tr>");
					out.println(sbErrors.toString());
					out.println("<tr><td colspan='5'><br/><hr/></td></tr>");
				}
			}
			//Encounters without FUA
			Vector encounters = FUA.getEncountersWithoutFUA(Integer.parseInt(activePatient.personid));
			if(encounters.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","fuatobecreated",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='admin' nowrap>"+getTran(request,"web","encounterid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","begindate",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","enddate",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
				bExist=true;
			}
			for(int n=0;n<encounters.size();n++){
				Encounter encounter = (Encounter)encounters.elementAt(n);
				out.println("<tr>");
				if(encounter.getEnd()!=null){
					out.println("<td nowrap class='admin'><a href='javascript:createFUA(\""+encounter.getUid()+"\")'>"+encounter.getUid()+"</a></td>");
				}
				else{
					out.println("<td class='admin'><i>"+encounter.getUid()+"</i></td>");
				}
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(encounter.getBegin())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(encounter.getEnd())+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",encounter.getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",encounter.getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(encounters.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
			
			//Open FUA with financial data that was modified
			Vector fuas = FUA.getFUAToBeUpdated(Integer.parseInt(activePatient.personid));
			if(fuas.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","existingfuatobeupdated",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td nowrap class='admin'>"+getTran(request,"web","fuaid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","date",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","amount",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
				bExist=true;
			}
			for(int n=0;n<fuas.size();n++){
				FUA fua = (FUA)fuas.elementAt(n);
				out.println("<tr>");
				out.println("<td nowrap class='admin'><a href='javascript:updateFUA(\""+fua.getUid()+"\")'>"+fua.getObjectId()+"</a></td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(fua.getDate())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.getPriceFormat(fua.getAmount())+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",fua.getEncounter().getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",fua.getEncounter().getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(fuas.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
			
			//Existing FUA
			fuas = FUA.getEncountersWithFUA(Integer.parseInt(activePatient.personid));
			if(fuas.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","existingfua",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td nowrap class='admin'>"+getTran(request,"web","fuaid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","date",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","amount",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
				bExist=true;
			}
			for(int n=0;n<fuas.size();n++){
				FUA fua = (FUA)fuas.elementAt(n);
				out.println("<tr>");
				out.println("<td nowrap class='admin'><a href='javascript:editFUA(\""+fua.getUid()+"\")'>"+fua.getObjectId()+"</a></td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(fua.getDate())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.getPriceFormat(fua.getAmount())+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",fua.getEncounter().getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",fua.getEncounter().getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(fuas.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
			if(!bExist){
				out.println("<tr><td colspan='5'><br/><br/>"+getTran(request,"web","nofuas",sWebLanguage)+"</td></tr>");
			}
		}
	%>
	</table>
</form>
<script>
	function createFUA(encounteruid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&encounteruid='+encounteruid;
	}
	function editFUA(fuauid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&fuauid='+fuauid;
	}
	function updateFUA(fuauid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&update=1&fuauid='+fuauid;
	}
</script>