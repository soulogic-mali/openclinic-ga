<%@page import="be.openclinic.medical.Diagnosis,be.openclinic.medical.*"%>
<%@page import="oracle.jdbc.driver.DiagnosabilityMXBean"%>
<%@page import="be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	if(encounter==null){
		out.println("<tr><td colspan='2'>"+getTran(request,"web","noactiveencounter",sWebLanguage)+"</td></tr>");
	}
	else{
		%>
		<tr class='admin'>
			<td><%=getTran(request,"web","ikirezi.cluster",sWebLanguage) %></td>
			<td>
				<%=getTran(request,"web","clinicalinformation",sWebLanguage) %> <a href="javascript:doPanorama('<%=encounter.getUid()%>');"><img src="<c:url value='/_img/icons/icon_panorama.gif'/>" class="link" title="<%=getTranNoLink("ikirezi","panorama",sWebLanguage)%>" style="vertical-align:-4px;"></a>
				<a href='main.jsp?Page=ikirezi/clinicalPathways.jsp'><%=getTran(request,"web","spt",sWebLanguage) %></a>
			</td>
		</tr>
		<%
		try{
			Hashtable ikireziLabels = Encounter.getIkireziSymptomLabels(sWebLanguage);
			SortedSet present = new TreeSet();
			SortedSet absent = new TreeSet();
			Hashtable symptoms = new Hashtable();
			symptoms = encounter.getIkireziSymptoms();
			Hashtable hICPCMappings = new Hashtable();
			Hashtable hICDMappings = new Hashtable();
			//First read all existing mappings from ikirezi.xml
			String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "ikirezi.xml";
			SAXReader reader = new SAXReader(false);
			Document document = reader.read(new URL(sDoc));
			Element element = document.getRootElement();
			Iterator mappings = element.elementIterator("mapping");
			while(mappings.hasNext()){
				Element mapping = (Element)mappings.next();
				if(checkString(mapping.attributeValue("icpc")).length()>0){
					hICPCMappings.put(mapping.attributeValue("icpc"),mapping.attributeValue("id"));
				}
				else if(checkString(mapping.attributeValue("icd10")).length()>0){
					hICDMappings.put(mapping.attributeValue("icd10"),mapping.attributeValue("id"));
				}
			}
			HashSet activecodes = new HashSet();
			Vector rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounter.getUid());
			for(int n=0;n<rfes.size();n++){
				ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
				if(rfe.getCodeType().equalsIgnoreCase("icpc") && hICPCMappings.get(rfe.getCode())!=null && !activecodes.contains(hICPCMappings.get(rfe.getCode())) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+hICPCMappings.get(rfe.getCode())+"*")<0){
					activecodes.add(hICPCMappings.get(rfe.getCode()));
					String date = "";
					try{
						date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
					}
					catch(Exception e){}
					symptoms.put(hICPCMappings.get(rfe.getCode()),1);
				}
			}
			for(int n=0;n<rfes.size();n++){
				ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
				if(rfe.getCodeType().equalsIgnoreCase("icd10") && hICDMappings.get(rfe.getCode())!=null && !activecodes.contains(hICDMappings.get(rfe.getCode())) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+hICDMappings.get(rfe.getCode())+"*")<0){
					activecodes.add(hICDMappings.get(rfe.getCode()));
					String date = "";
					try{
						date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
					}
					catch(Exception e){}
					symptoms.put(hICDMappings.get(rfe.getCode()),1);
				}
			}
			
			Enumeration eSymptoms = symptoms.keys();
			while(eSymptoms.hasMoreElements()){
				String s = (String)eSymptoms.nextElement();
				int id=Integer.parseInt(s);
				if((Integer)symptoms.get(s)==1){
					present.add(ScreenHelper.uppercaseFirstLetter(checkString((String)ikireziLabels.get(id)))+";"+id);
				}
				else if((Integer)symptoms.get(s)==-1){
					absent.add(ScreenHelper.uppercaseFirstLetter(checkString((String)ikireziLabels.get(id)))+";"+id);
				}
			}
			if(present.size()>0){
				out.println("<tr><td class='admin' colspan='2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_check.gif'/> "+getTran(request,"web","presentsymptoms",sWebLanguage)+"</td></tr>");
				Iterator i = present.iterator();
				out.println("<tr><td width='20%'>"+getTran(request,"web","signs",sWebLanguage)+"</td><td class='admin2'>");
				boolean bFirst=true;
				while(i.hasNext()){
					if(!bFirst){
						out.println(", ");
					}
					else{
						bFirst=false;
					}
					String sItem=(String)i.next();
					out.println("<b><img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteSymptom(\""+encounter.getUid()+"\","+sItem.split(";")[1]+");'/>"+sItem.split(";")[0]+"</b>");
				}
				out.println("</td></tr>");
			}
			if(absent.size()>0){
				out.println("<tr><td class='admin' colspan='2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif'/> "+getTran(request,"web","absentsymptoms",sWebLanguage)+"</td></tr>");
				Iterator i = absent.iterator();
				out.println("<tr><td>"+getTran(request,"web","signs",sWebLanguage)+"</td><td class='admin2'>");
				boolean bFirst=true;
				while(i.hasNext()){
					if(!bFirst){
						out.println(", ");
					}
					else{
						bFirst=false;
					}
					String sItem=(String)i.next();
					out.println("<font style='text-decoration:line-through'><img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteSymptom(\""+encounter.getUid()+"\","+sItem.split(";")[1]+");'/>"+sItem.split(";")[0]+"</font>");
				}
				out.println("</td></tr>");
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	%>
	<tr class='admin'>
		<td><%=getTran(request,"web","ikirezi.bayesian",sWebLanguage) %></td>
		<td><%=getTran(request,"web","probablediagnoses",sWebLanguage) %>  <img class='hand' src='<%=sCONTEXTPATH%>/_img/icons/icon_info.gif' onclick='listmissingsigns("-1")'/></td>
	</tr>
	<%
		HashSet hDiagnoses = new HashSet();
		Vector encounterDiagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "");
		for(int n=0;n<encounterDiagnoses.size();n++){
			Diagnosis diagnosis = (Diagnosis)encounterDiagnoses.elementAt(n);
			hDiagnoses.add(diagnosis.getCode());
		}
		Vector diseases = Ikirezi.getDiagnosisProbabilities(Ikirezi.getEncounterSymptomsBoolean(encounter.getUid()), sWebLanguage, session.getId());
		HashSet treated =new HashSet();
		if(diseases.size()>0){
			out.println("<tr>");
			out.println("<td><img src='"+sCONTEXTPATH+"/_img/shortcutIcons/icon_doctor4.png' height='24'/>"+getTran(request,"web","diagnoses",sWebLanguage)+"</td><td class='admin'>");
			boolean bFirst=true;
			for(int n=0;n<diseases.size();n++){
				String id = ((String)diseases.elementAt(n)).split(";")[0];
				if(!treated.contains(id)){
					if(!bFirst){
						out.println(", ");
					}
					else{
						bFirst=false;
					}
					treated.add(id);
					String icd10code = Ikirezi.getDiseaseMapping(Integer.parseInt(id));
					boolean bDiagnosed = icd10code!=null && hDiagnoses.contains(icd10code);
					out.println(Ikirezi.getDiagnosisLabel(id,sWebLanguage)+(MedwanQuery.getInstance().getConfigInt("ikireziShowBayesianProbabilities",0)==1?" ("+new DecimalFormat("#0.00").format(new Double(((String)diseases.elementAt(n)).split(";")[1]))+"%)":"")+" <img class='hand' src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif' onclick='listmissingsigns(\""+id+"\")'/>");
					if(!bDiagnosed){
						String sLine="<img class='hand' height='14' src='"+sCONTEXTPATH+"/_img/icons/icon_plus.png' onclick='addDiagnosis(\""+encounter.getUid()+"\",\""+icd10code+"\")'/>";
						out.println(sLine);
					}
				}
			}
			out.println("</td></tr>");
		}
	}
%>
