<%@page import="be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>	<table width='100%'>
		<%
		try{
			Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
			if(encounter!=null){
				MedwanQuery.getInstance().getObjectCache().reset();
		%>
				<tr class='admin'>
					<td nowrap width='20%'><%=getTran(request,"web","clinicalassistant",sWebLanguage) %></td>
					<td><%=getTran(request,"web","activeencounter",sWebLanguage) %></td>
				</tr>
				<tr class='admin'>
					<td colspan="2"><%=getTran(request,"web","pharmacy",sWebLanguage) %></td>
				</tr>
		<%
				boolean bErrors = false;
				// Step 1: check for contraindications
				Vector contraindications = ClinicalAssistant.getContraIndicationsForEncounter(encounter.getUid());
				if(contraindications.size()>0){
					bErrors=true;
					for(int n=0;n<contraindications.size();n++){
						String[] c = ((String)contraindications.elementAt(n)).split(";");
						ATCClass atc = ATCClass.get(c[0]);
						out.println("<tr><td nowrap><img width='32' src='"+sCONTEXTPATH+"/_img/forbidden.jpg'/> "+getTran(request,"web","contraindication",sWebLanguage)+"</td><td class='admin2'><b>"+atc.getLabel(sWebLanguage)+"</b>  <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atc.getCode()+"\",\""+encounter.getUid()+"\")'/>"+getTran(request,"web","iscontraindicatedfor",sWebLanguage)+" <b>"+MedwanQuery.getInstance().getCodeTran("icd10code"+c[1], sWebLanguage)+" ("+c[1]+")</b></td></tr>");
					}
				}
				// Step 2: severe drug-drug interactions
				Vector atcs = ClinicalAssistant.getATCClassesForEncounter(encounter.getUid());
				Vector interactions = ClinicalAssistant.getDrugDrugInteractionsForEncounter(encounter.getUid(),MedwanQuery.getInstance().getConfigInt("clinicalAssistantDrugInteractionSeverity",3));
				if(interactions.size()>0){
					bErrors=true;
					for(int n=0;n<interactions.size();n++){
						DrugDrugInteraction interaction = (DrugDrugInteraction)interactions.elementAt(n);
						out.println("<tr><td nowrap><img width='32' src='"+sCONTEXTPATH+"/_img/forbidden.jpg'/> "+getTran(request,"web","drugdruginteraction",sWebLanguage)+"</td><td class='admin2'>");
						out.println("<table width='100%'><tr><td width='80%'>");
						out.println(interaction.getLabel(sWebLanguage)+"</td><td><b>"+getTran(request,"web","interactionseverity",sWebLanguage)+" "+interaction.getSeverity()+"</b></td></tr>");
						Vector atc1 = DrugInteractionClass.getATCForInteraction(interaction.getClass1());
						for(int i=0;i<atc1.size();i++){
							String atccode = (String)atc1.elementAt(i);
							for(int j=0;j<atcs.size();j++){
								ATCClass atcclass = (ATCClass)atcs.elementAt(j);
								if(atcclass.getCode().equalsIgnoreCase(atccode)){
									out.println("<tr><td colspan='2'>"+getTran(request,"web","product",sWebLanguage)+": <b>"+atcclass.getLabel(sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atcclass.getCode()+"\",\""+encounter.getUid()+"\")'/></td></tr>");
								}
							}
						}
						Vector atc2 = DrugInteractionClass.getATCForInteraction(interaction.getClass2());
						for(int i=0;i<atc2.size();i++){
							String atccode = (String)atc2.elementAt(i);
							if(atc1.contains(atccode)){
								continue;
							}
							for(int j=0;j<atcs.size();j++){
								ATCClass atcclass = (ATCClass)atcs.elementAt(j);
								if(atcclass.getCode().equalsIgnoreCase(atccode)){
									out.println("<tr><td colspan='2'>"+getTran(request,"web","product",sWebLanguage)+": <b>"+atcclass.getLabel(sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atcclass.getCode()+"\",\""+encounter.getUid()+"\")'/></td></tr>");
								}
							}
						}
						out.println("</table></td></tr>");
					}
				}
				// Step 3: allergies
				HashSet allergies = ClinicalAssistant.getAllergyATCForPatient(activePatient.personid);
				Iterator iAllergies = allergies.iterator();
				while(iAllergies.hasNext()){
					String allergy = (String)iAllergies.next();
					for(int n=0;n<atcs.size();n++){
						ATCClass atc = (ATCClass)atcs.elementAt(n);
						if(atc.getCode().equalsIgnoreCase(allergy.split(";")[1])){
							//We do have an allergy mismatch!
							out.println("<tr><td nowrap><img width='32' src='"+sCONTEXTPATH+"/_img/forbidden.jpg'/> "+getTran(request,"web","allergy",sWebLanguage)+"</td><td class='admin2'>");
							out.println("<table width='100%'><tr><td width='80%'>");
							out.println(getTran(request,"web","allergy",sWebLanguage)+": <b>"+getTranDb("allergy",allergy.split(";")[0],sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atc.getCode()+"\",\""+encounter.getUid()+"\")'/></td><td><b>"+getTran(request,"web","allergyseverity",sWebLanguage)+" 3</b></td></tr>");
							out.println("</table></td></tr>");
						}
					}
				}
				out.println("<tr><td colspan='3'><hr/></td></tr>");
				// Step 4: non severe drug-drug interactions
				interactions = ClinicalAssistant.getDrugDrugInteractionsForEncounter(encounter.getUid());
				if(interactions.size()>0){
					bErrors=true;
					for(int n=0;n<interactions.size();n++){
						DrugDrugInteraction interaction = (DrugDrugInteraction)interactions.elementAt(n);
						if(interaction.getSeverity()>=MedwanQuery.getInstance().getConfigInt("clinicalAssistantDrugInteractionSeverity",3)){
							continue;
						}
						out.println("<tr><td nowrap><img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> "+getTran(request,"web","drugdruginteraction",sWebLanguage)+"</td><td class='admin3'>");
						out.println("<table width='100%'><tr><td width='80%'>");
						out.println(interaction.getLabel(sWebLanguage)+"</td><td>"+getTran(request,"web","interactionseverity",sWebLanguage)+" "+interaction.getSeverity()+"</td></tr>");
						Vector atc1 = DrugInteractionClass.getATCForInteraction(interaction.getClass1());
						for(int i=0;i<atc1.size();i++){
							String atccode = (String)atc1.elementAt(i);
							for(int j=0;j<atcs.size();j++){
								ATCClass atcclass = (ATCClass)atcs.elementAt(j);
								if(atcclass.getCode().equalsIgnoreCase(atccode)){
									out.println("<tr><td colspan='2'>"+getTran(request,"web","product",sWebLanguage)+": <b>"+atcclass.getLabel(sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atcclass.getCode()+"\",\""+encounter.getUid()+"\")'/></td></tr>");
								}
							}
						}
						Vector atc2 = DrugInteractionClass.getATCForInteraction(interaction.getClass2());
						for(int i=0;i<atc2.size();i++){
							String atccode = (String)atc2.elementAt(i);
							if(atc1.contains(atccode)){
								continue;
							}
							for(int j=0;j<atcs.size();j++){
								ATCClass atcclass = (ATCClass)atcs.elementAt(j);
								if(atcclass.getCode().equalsIgnoreCase(atccode)){
									out.println("<tr><td colspan='2'>"+getTran(request,"web","product",sWebLanguage)+": <b>"+atcclass.getLabel(sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atcclass.getCode()+"\",\""+encounter.getUid()+"\")'/></td></tr>");
								}
							}
						}
						out.println("</table></td></tr>");
					}
				}
				// Step 5: drugs without indications
				Vector icds = ClinicalAssistant.getIcd10CodesForEncounter(encounter.getUid());
				HashSet hICDIndications = new HashSet();
				for(int n=0;n<icds.size();n++){
					Vector icdIndications = Indication.getIndicationsForICD10Code((String)icds.elementAt(n));
					for(int i=0;i<icdIndications.size();i++){
						hICDIndications.add(((Indication)icdIndications.elementAt(i)).getIndicationId());
					}
				}
				for(int n=0;n<atcs.size();n++){
					ATCClass atcClass = (ATCClass)atcs.elementAt(n);
					boolean bHasIndication=false;
					Vector atcIndications = Indication.getIndicationsForATCCode(atcClass.getCode());
					for(int i=0;i<atcIndications.size();i++){
						Indication indication = (Indication)atcIndications.elementAt(i);
						if(hICDIndications.contains(indication.getIndicationId())){
							bHasIndication=true;
							break;
						}
					}
					if(!bHasIndication){
						//This is an ATC code without linked ICD10
						out.println("<tr><td nowrap><img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> "+getTran(request,"web","missingindication",sWebLanguage)+"</td><td class='admin3'>");
						out.println(getTran(request,"web","noindicationregisteredfor",sWebLanguage)+" <b>"+atcClass.getLabel(sWebLanguage)+"</b> <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listatcitems(\""+atcClass.getCode()+"\",\""+encounter.getUid()+"\")'/></td></tr>");
					}
				}
				
				if(!bErrors){
		%>
				<tr>
					<td class='admin2' colspan='2'><%=getTran(request,"web","nothingtomention",sWebLanguage) %></td>
				</tr>
		<%
				}
		%>
		<%
		}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		%>