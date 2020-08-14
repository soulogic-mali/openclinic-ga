<%@ page import="be.mxs.common.util.system.*,be.openclinic.finance.*,java.util.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sPatientInvoiceUid=checkString(request.getParameter("patientinvoiceuid"));
	String sInsuranceUid=checkString(request.getParameter("insuranceuid"));
	String sCoverageInsurance=checkString(request.getParameter("extrainsuraruid"));
	String sCoverageInsurance2=checkString(request.getParameter("extrainsurar2uid"));
	String sOpenerFunction=checkString(request.getParameter("openerfunction"));
%>
	<form name='transactionForm' method='post'>
	<input type='hidden' name='patientinvoiceuid' id='patientinvoiceuid' value='<%=sPatientInvoiceUid%>'/>
		<table width='100%'>
			<tr class='admin'>
				<td colspan='2'><%=getTran(request,"Web.finance","transfer.insurer", sWebLanguage) %></td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web", "insurance", sWebLanguage) %></td>
				<td class='admin2'>
					<!-- Create list of active insurances for patient -->
					<select class='text' name='insuranceuid' id='insuranceuid'>
                    	<%
                    		Vector vInsurances = Insurance.getCurrentInsurances(activePatient.personid);
							for(int n=0;n<vInsurances.size();n++){
								Insurance insurance = (Insurance)vInsurances.elementAt(n);
								out.println("<option value='"+insurance.getUid()+"'>"+insurance.getInsurar().getName()+" ("+insurance.getInsuranceCategory().getCategory()+": "+insurance.getInsuranceCategory().getPatientShare()+"/"+(100-Integer.parseInt(insurance.getInsuranceCategory().getPatientShare()))+")</option>");
							}
						%>
                    </select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web", "extrainsurar", sWebLanguage) %></td>
				<td class='admin2'>
					<!-- Create list of active complementary insurances for patient -->
					<select class='text' name='extrainsuraruid' id='extrainsuraruid'>
						<option />
	                    <%=ScreenHelper.writeSelect(request,"patientsharecoverageinsurance","",sWebLanguage)%>
	                </select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web", "complementarycoverage2", sWebLanguage) %></td>
				<td class='admin2'>
					<!-- Create list of active patient share coverages for patient -->
					<select class='text' name='extrainsurar2uid' id='extrainsurar2uid'>
						<option />
	                    <%=ScreenHelper.writeSelect(request,"patientsharecoverageinsurance2","",sWebLanguage)%>
	                </select>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='admin2'>
					<input type='submit' name='submit' value='<%=getTran(null,"web","execute",sWebLanguage)%>'/>
					<input type='button' name='close' value='<%=getTran(null,"web","close",sWebLanguage)%>' onclick='window.close();'/>
				</td>
			</tr>
		</table>
	</form>
<%
	if(request.getParameter("submit")!=null){
		PatientInvoice invoice = PatientInvoice.get(sPatientInvoiceUid);
		Insurance insurance = Insurance.get(sInsuranceUid);
		if(invoice!=null && insurance!=null){
			Vector debets = invoice.getDebets();
			for(int n=0;n<debets.size();n++){
				Debet debet = (Debet)debets.elementAt(n);
				Prestation prestation = Prestation.get(debet.getPrestationUid(),debet.getDate());
			    if (prestation != null) {
					double 	baseInsurar=0, dPatientAmount=0,dInsurarAmount=0,dCoverage1=0,dCoverage2=0;
					double quantity = debet.getQuantity();
					Encounter encounter = debet.getEncounter();
			    	String type = insurance.getType();
			        double dPrice = prestation.getPrice(type);
			        if(checkString(insurance.getInsurarUid()).equals(MedwanQuery.getInstance().getConfigString("MFP","$$$"))){
			            dPrice=prestation.getPrice();
			        }
			        baseInsurar=dPrice*quantity;
			        if(insurance.getInsurar()!=null && insurance.getInsurar().getNoSupplements()==0 && insurance.getInsurar().getCoverSupplements()==1){
			        	dPrice+=prestation.getSupplement();
			        }
			        double dInsuranceMaxPrice = prestation.getInsuranceTariff(insurance.getInsurar().getUid(),insurance.getInsuranceCategoryLetter());
			        if(encounter!=null && encounter.getType().equalsIgnoreCase("admission") && prestation.getMfpAdmissionPercentage()>0){
			        	dInsuranceMaxPrice = prestation.getInsuranceTariff(insurance.getInsurar().getUid(),"*H");
			        }
			        String sShare=checkString(prestation.getPatientShare(insurance)+"");
			        if (sShare.length()>0){
			            dPatientAmount = quantity * dPrice * Double.parseDouble(sShare) / 100;
			            dInsurarAmount = quantity * dPrice - dPatientAmount;
			            if(dInsuranceMaxPrice>=0){
			            	dInsurarAmount=quantity * dInsuranceMaxPrice;
			           		dPatientAmount=quantity * dPrice - dInsurarAmount;
			            }
			            if(insurance.getInsurar()!=null && insurance.getInsurar().getNoSupplements()==0 && insurance.getInsurar().getCoverSupplements()==0){
			            	dPatientAmount+=quantity * prestation.getSupplement();
			            }
			        }
			        if(sCoverageInsurance.length()>0){
			        	Insurar insurar = Insurar.get(sCoverageInsurance);
			        	if(insurar!=null){
			        		if(insurar.getCoverSupplements()==1 || insurance.getInsurar().getCoverSupplements()==1){
			        			dCoverage1=dPatientAmount;
			        		}
			        		else{
			        			dCoverage1=dPatientAmount-quantity * prestation.getSupplement();
			        		}
			        		dPatientAmount=dPatientAmount-dCoverage1;
			        	}
			        }
			        if(sCoverageInsurance2.length()>0){
			        	Insurar insurar = Insurar.get(sCoverageInsurance2);
			        	if(insurar!=null){
			        		dCoverage2=dPatientAmount;
			        	}
			        }
			        InsuranceRule rule = insurance==null?null:Prestation.getInsuranceRule(prestation.getUid(), insurance.getInsurarUid());
			        if(!Prestation.checkMaximumReached(activePatient.personid, rule, quantity)){
			        	debet.setInsuranceUid(insurance.getUid());
			        	debet.setExtraInsurarUid(sCoverageInsurance);
			        	debet.setExtraInsurarUid2(sCoverageInsurance2);
			        	debet.setAmount(dPatientAmount);
			        	debet.setInsurarAmount(dInsurarAmount);
			        	debet.setExtraInsurarAmount(dCoverage1);
			        	debet.store();
			        }
			    	
			    }
			}
		}
		out.println("<script>window.opener."+sOpenerFunction+";window.close();</script>");
		out.flush();
	}
%>