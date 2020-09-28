<%@page import="be.openclinic.medical.*"%>
<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%@include file="/includes/validateUser.jsp"%>
<%
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","activedrugprescriptions",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getDrugs.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						%>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","activedrugprescriptions",sWebLanguage) %></td>
				</tr>
				<%
			        String sProductUnit, timeUnitTran, sPrescrRule;
			        Vector chronicMedications = ChronicMedication.find(activePatient.personid,"","","","OC_CHRONICMED_BEGIN","ASC");
			        if(chronicMedications.size()>0){
			            %>
			            	<tr>
				                <td colspan='2' class='mobileadmin' style='font-size: 6vw'>
				                	<%=getTran(request,"curative","medication.chronic",sWebLanguage)%>
									<img onclick='newChronic();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
				                </td>
				            </tr>
			            <%
			        }
			        
			        ChronicMedication chronicMedication;
			        for(int n=0; n<chronicMedications.size(); n++){
			            chronicMedication = (ChronicMedication)chronicMedications.elementAt(n);
			            
			            sPrescrRule = getTran(request,"web.prescriptions","prescriptionrule",sWebLanguage);
			            sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#",chronicMedication.getUnitsPerTimeUnit()+"");
	
			            // productunits
			            if(chronicMedication.getUnitsPerTimeUnit()==1){
			                sProductUnit = getTran(request,"product.unit",chronicMedication.getProduct().getUnit(),sWebLanguage);
			            }
			            else{
			                sProductUnit = getTran(request,"product.unit",chronicMedication.getProduct().getUnit(),sWebLanguage);
			            }
			            sPrescrRule = sPrescrRule.replaceAll("#productunit#",sProductUnit.toLowerCase());
	
			            // timeunits
			            if(chronicMedication.getTimeUnitCount()==1){
			                sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#","");
			                timeUnitTran = getTran(request,"prescription.timeunit",chronicMedication.getTimeUnit(),sWebLanguage);
			            }
			            else{
			                sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#",chronicMedication.getTimeUnitCount()+"");
			                timeUnitTran = getTran(request,"prescription.timeunits",chronicMedication.getTimeUnit(),sWebLanguage);
			            }
			            
			            sPrescrRule = sPrescrRule.replaceAll("#timeunit#",timeUnitTran.toLowerCase());
			            %>
			            	<tr onclick='editChronic(\"<%=chronicMedication.getUid()%>\")'>
				                <td colspan='2' class='mobileadmin2' style='font-size: 6vw'>
				                	<%=chronicMedication.getProduct().getName()%><span style='font-size: 4vw'><br/><%=sPrescrRule %></span>
				                </td>
				            </tr>
			            <%
			        }
	
			        //--- 2:ACTIVE ----------------------------------------------------------------------------
			        Vector activePrescriptions = Prescription.getActivePrescriptions(activePatient.personid,0);
			        if(activePrescriptions!=null && activePrescriptions.size()>0){
			            %>
			            	<tr>
				                <td colspan='2' class='mobileadmin' style='font-size: 6vw'>
				                	<%=getTran(request,"curative","medication.prescription",sWebLanguage)%>
									<img onclick='newActive();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
				                </td>
				            </tr>
			            <%
					    
				        Prescription prescription;	    
				        for(int n=0; n<activePrescriptions.size(); n++){
				            prescription = (Prescription)activePrescriptions.elementAt(n);
				            
				            if(prescription!=null && prescription.getProduct()!=null){
				                sPrescrRule = getTran(request,"web.prescriptions","prescriptionrule",sWebLanguage);
				                sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#",prescription.getUnitsPerTimeUnit()+"");
				
				                // productunits
				                if(prescription.getUnitsPerTimeUnit()==1){
				                    sProductUnit = getTran(request,"product.unit",prescription.getProduct().getUnit(),sWebLanguage);
				                }
				                else{
				                    sProductUnit = getTran(request,"product.unit",prescription.getProduct().getUnit(),sWebLanguage);
				                }
				                sPrescrRule = sPrescrRule.replaceAll("#productunit#",sProductUnit.toLowerCase());
				
				                // timeunits
				                if(prescription.getTimeUnitCount()==1){
				                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#","");
				                    timeUnitTran = getTran(request,"prescription.timeunit",prescription.getTimeUnit(),sWebLanguage);
				                }
				                else{
				                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#",prescription.getTimeUnitCount()+"");
				                    timeUnitTran = getTran(request,"prescription.timeunits",prescription.getTimeUnit(),sWebLanguage);
				                }
				                
				                sPrescrRule = sPrescrRule.replaceAll("#timeunit#",timeUnitTran.toLowerCase());
					            %>
					            	<tr>
						                <td colspan='2' class='mobileadmin2'>
						                	<span onclick='editActive("<%=prescription.getUid()%>")' style='font-size: 6vw'><%=prescription.getProduct().getName()%></span><span onclick='editActive("<%=prescription.getUid()%>")' style='font-size: 4vw'><br/><%=sPrescrRule %></span>
											<img onclick='deletedrug("<%=prescription.getUid() %>");' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/delete.png'/>
						                </td>
						            </tr>
					            <%
				            }
				        }
				        
			    		%>
					            </table>
					        </td>
						<%
			    	}
			        else if(activePrescriptions.size()==0){
			        %>
		            	<tr>
			                <td colspan='2' class='mobileadmin2' style='font-size: 4vw; text-align: center'>
								<%=getTran(request,"web","noactivedrugprescriptions",sWebLanguage) %>
								<img onclick='newActive();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
			                </td>
			            </tr>
		            <%
			        }
				%>
			</table>
		</form>
		<script>
			function editActive(uid){
				window.location.href='<%=sCONTEXTPATH%>/html5/editDrugPrescription.jsp?uid='+uid;
			}
			
			function newActive(){
				window.location.href='<%=sCONTEXTPATH%>/html5/newDrugPrescription.jsp';
			}
			
			function deletedrug(uid){
				if(window.confirm('<%=getTranNoLink("web","stopprescription",sWebLanguage)%>')==1){
					window.location.href='<%=sCONTEXTPATH%>/html5/editDrugPrescription.jsp?formaction=delete&uid='+uid;
				}
			}
			
		</script>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>
<%
	}
%>
				