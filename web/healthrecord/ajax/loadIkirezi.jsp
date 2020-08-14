<%@page import="be.openclinic.knowledge.Ikirezi,be.openclinic.medical.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<td>
<%
	try{
		Hashtable ikireziLabels = Encounter.getIkireziSymptomLabels(sWebLanguage);
		SortedSet present = new TreeSet();
		SortedSet absent = new TreeSet();
		//Hashtable symptoms = Ikirezi.getEncounterSymptoms(checkString(request.getParameter("encounteruid")));
		Hashtable symptoms = new Hashtable();
		Encounter encounter = Encounter.get(checkString(request.getParameter("encounteruid")));
		if(encounter!=null){
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
		}
		
		Enumeration eSymptoms = symptoms.keys();
		while(eSymptoms.hasMoreElements()){
			String s = (String)eSymptoms.nextElement();
			int id=Integer.parseInt(s);
			if((Integer)symptoms.get(s)==1){
				present.add(ScreenHelper.uppercaseFirstLetter(checkString((String)ikireziLabels.get(id))));
			}
			else if((Integer)symptoms.get(s)==-1){
				absent.add(ScreenHelper.uppercaseFirstLetter(checkString((String)ikireziLabels.get(id))));
			}
		}
		if(present.size()>0){
			out.println("<table width='100%'><tr><td class='admin'><img src='"+sCONTEXTPATH+"/_img/icons/icon_check.gif'/> "+getTran(request,"web","presentsymptoms",sWebLanguage)+"</td></tr>");
			Iterator i = present.iterator();
			while(i.hasNext()){
				out.println("<tr><td class='admin2'>"+i.next()+"</td></tr>");
			}
			out.println("</table>");
		}
		if(absent.size()>0){
			out.println("<table width='100%'><tr><td class='admin'><img src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif'/> "+getTran(request,"web","absentsymptoms",sWebLanguage)+"</td></tr>");
			Iterator i = absent.iterator();
			while(i.hasNext()){
				out.println("<tr><td class='admin2'>"+i.next()+"</td></tr>");
			}
			out.println("</table>");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</td>