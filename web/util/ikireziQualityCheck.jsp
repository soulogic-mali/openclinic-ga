<%@page import="be.openclinic.medical.*,be.openclinic.knowledge.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select distinct oc_symptom_encounteruid from oc_ikirezisymptoms order by oc_symptom_encounteruid");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String encounteruid = rs.getString("oc_symptom_encounteruid");
		Encounter encounter = Encounter.get(encounteruid);
		if(encounter!=null){
			//We do have an encounter. Now we get the list of all matching symptoms and signs
			Hashtable symptoms = encounter.getIkireziSymptoms();
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
			HashSet hDiagnoses = new HashSet();
			Vector encounterDiagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "");
			for(int n=0;n<encounterDiagnoses.size();n++){
				Diagnosis diagnosis = (Diagnosis)encounterDiagnoses.elementAt(n);
				hDiagnoses.add(diagnosis.getCode());
			}
			HashSet hDiags = new HashSet();
			Vector diseases = Ikirezi.getDiagnosisProbabilities(Ikirezi.getEncounterSymptomsBoolean(encounter.getUid()), sWebLanguage, session.getId());
			HashSet treated =new HashSet();
			if(diseases.size()>0){
				for(int n=0;n<diseases.size();n++){
					String diag=(String)diseases.elementAt(n);
					String id = (diag).split(";")[0];
					if(!hDiags.contains(id)){
						hDiags.add(id);
					}
				}
			}
		}
	}
	rs.close();
	ps.close();
	conn.close();
	
%>
