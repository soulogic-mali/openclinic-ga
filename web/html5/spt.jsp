<%@page import="be.mxs.common.util.system.Pointer"%>
<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>

<%!
	String serializeSptSigns(Hashtable signs){
		String s="";
		Enumeration eS = signs.keys();
		while(eS.hasMoreElements()){
			String key = (String)eS.nextElement();
			s+=(key+"="+signs.get(key)+";");
		}
		return s;
	}
	
	Hashtable unSerializeSigns(String signs){
		Hashtable st = new Hashtable();
		for(int n=0;n<signs.split(";").length;n++){
			if(signs.split(";")[n].split("=").length>1){
				st.put(signs.split(";")[n].split("=")[0],signs.split(";")[n].split("=")[1]);
			}
		}
		return st;
	}
	
	class Sheet {
		String id;
		String href;
		String text;
	}
	
	class Concept {
		String[] values;
		String text;
	}
	
	class Treatment {
		String id;
		String document;
		String text;
		Vector sheets;
	}
	
	String getLabel(Element element, String language){
		String label = null;
		Iterator labels = element.elementIterator("label");
		while(labels.hasNext()){
			Element eLabel = (Element)labels.next();
			if(checkString(eLabel.attributeValue("language")).equalsIgnoreCase(language)){
				label=eLabel.getText();
			}
		}
		if(label == null){
			if(element.element("label")!=null){
				label = element.element("label").getText();
			}
			else{
				label = "";
			}
		}
		return label;
	}

	boolean checkArguments(Element element, Hashtable signs){
		int nPositive=0;
		int nArgumentsTreated=0;
		int nTotalArguments=element.elements("argument").size()+element.elements("arguments").size();
		Iterator arguments = element.elementIterator();
		while(arguments.hasNext()){
			if(element.getName().equalsIgnoreCase("arguments")){
				if(!element.attributeValue("select").equalsIgnoreCase("all")){
					if(nTotalArguments-nArgumentsTreated<Integer.parseInt(element.attributeValue("select"))-nPositive){
						return false;
					}
				}
			}
			nArgumentsTreated++;
			Element e = (Element)arguments.next();
			if(e.getName().equalsIgnoreCase("arguments")){
				Element eArguments = e;
				boolean bCheck = checkArguments(eArguments,signs);
				if(bCheck){
					nPositive++;
					if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
						if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
							return true;
						}
					}
				}
				else {
					if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
						return false;
					}
				}
			}
			else if(e.getName().equalsIgnoreCase("argument")){
				Element eArgument = e;
				boolean bCheck=false;
				if(eArgument.attributeValue("type").equalsIgnoreCase("ikirezi")){
					Hashtable hSigns = (Hashtable)signs.get("ikirezi");
					if(hSigns!=null){
						Integer iArgument = (Integer)(hSigns.get(Integer.parseInt(eArgument.attributeValue("id"))));
						bCheck = iArgument!=null && ((eArgument.attributeValue("value").equalsIgnoreCase("yes") && iArgument==1) || (eArgument.attributeValue("value").equalsIgnoreCase("no") && iArgument!=1));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("spt")){
					Hashtable hSigns = (Hashtable)signs.get("spt");
					if(hSigns!=null){
						String sArgument = (String)(hSigns.get(eArgument.attributeValue("id")));
						bCheck = sArgument!=null && sArgument.equalsIgnoreCase(eArgument.attributeValue("value"));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icpc2")){
					Hashtable hSigns = (Hashtable)signs.get("icpc2");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icd10")){
					Hashtable hSigns = (Hashtable)signs.get("icd10");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("ageinmonths")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
						if(ageinmonths!=null){
							if(eArgument.attributeValue("compare").equalsIgnoreCase("greaterthan")){
								bCheck = ageinmonths>Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("lessthan")){
								bCheck = ageinmonths<Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notlessthan")){
								bCheck = ageinmonths>=Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
								bCheck = ageinmonths<=Integer.parseInt(eArgument.attributeValue("value"));
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("gender")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						String gender = (String)hSigns.get("gender");
						if(gender!=null){
							bCheck = gender.equalsIgnoreCase(eArgument.attributeValue("value"));
						}
					}
				}
				if(bCheck){
					nPositive++;
					if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
						if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
							return true;
						}
					}
				}
				else {
					if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
						return false;
					}
				}
			}
		}
		if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
			if(nPositive<Integer.parseInt(element.attributeValue("select"))){
				return false;
			}
		}
		return true;
	}

	boolean isPathwayApplicable(Element pathway, Hashtable signs){
		Iterator rootNodes = pathway.elementIterator("node");
		while(rootNodes.hasNext()){
			Element rootNode = (Element)rootNodes.next();
			if(checkArguments(rootNode,signs)){
				return true;
			}
		}
		return false;
	}
	
	int checkPositiveArguments(Element element, Hashtable signs){
		int nPositive=0;
		Iterator arguments = element.elementIterator();
		while(arguments.hasNext()){
			Element e = (Element)arguments.next();
			if(e.getName().equalsIgnoreCase("arguments")){
				Element eArguments = e;
				boolean bCheck = checkArguments(eArguments,signs);
				if(bCheck){
					nPositive++;
				}
			}
			else if(e.getName().equalsIgnoreCase("argument")){
				Element eArgument = e;
				boolean bCheck=false;
				if(eArgument.attributeValue("type").equalsIgnoreCase("ikirezi")){
					Hashtable hSigns = (Hashtable)signs.get("ikirezi");
					if(hSigns!=null){
						Integer iArgument = (Integer)(hSigns.get(Integer.parseInt(eArgument.attributeValue("id"))));
						bCheck = iArgument!=null && ((eArgument.attributeValue("value").equalsIgnoreCase("yes") && iArgument==1) || (eArgument.attributeValue("value").equalsIgnoreCase("no") && iArgument!=1));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("spt")){
					Hashtable hSigns = (Hashtable)signs.get("spt");
					if(hSigns!=null){
						String sArgument = (String)(hSigns.get(eArgument.attributeValue("id")));
						bCheck = sArgument!=null && sArgument.equalsIgnoreCase(eArgument.attributeValue("value"));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icpc2")){
					Hashtable hSigns = (Hashtable)signs.get("icpc2");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icd10")){
					Hashtable hSigns = (Hashtable)signs.get("icd10");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("ageinmonths")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
						if(ageinmonths!=null){
							if(eArgument.attributeValue("compare").equalsIgnoreCase("greaterthan")){
								bCheck = ageinmonths>Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("lessthan")){
								bCheck = ageinmonths<Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notlessthan")){
								bCheck = ageinmonths>=Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
								bCheck = ageinmonths<=Integer.parseInt(eArgument.attributeValue("value"));
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("gender")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						String gender = (String)hSigns.get("gender");
						if(gender!=null){
							bCheck = gender.equalsIgnoreCase(eArgument.attributeValue("value"));
						}
					}
				}
				if(bCheck){
					nPositive++;
				}
			}
		}
		return nPositive;
	}

	Vector getMissingArguments(Element argumentsElement, Hashtable signs){
		Hashtable sptSigns = (Hashtable)signs.get("spt");
		Vector hInformation=new Vector();
		Iterator childArguments = argumentsElement.elementIterator("arguments");
		while(childArguments.hasNext()){
			Element childArgumentsElement = (Element)childArguments.next();
			Vector hSubInformation = getMissingArguments(childArgumentsElement,signs);
			Iterator iSubInformation = hSubInformation.iterator();
			while(iSubInformation.hasNext()){
				Object o = iSubInformation.next();
				if(!hInformation.contains(o)){
					hInformation.add(o);
				}
			}
		}
		Iterator childArgumentElements = argumentsElement.elementIterator("argument");
		while(childArgumentElements.hasNext()){
			Element childArgumentElement = (Element)childArgumentElements.next();
			if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && sptSigns!=null && sptSigns.get(childArgumentElement.attributeValue("id"))!=null){
				if((!argumentsElement.getName().equalsIgnoreCase("arguments") || argumentsElement.attributeValue("select").equalsIgnoreCase("all")) && !childArgumentElement.attributeValue("value").equalsIgnoreCase((String)sptSigns.get(childArgumentElement.attributeValue("id")))){
					return(new Vector());
				}
			}
			else if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && (sptSigns==null || sptSigns.get(childArgumentElement.attributeValue("id"))==null)){
				if(checkString(childArgumentElement.attributeValue("equivalent")).length()>0){
					//Check that equivalents do not exist
					String[] equivalents=childArgumentElement.attributeValue("equivalent").split(",");
					for(int n=0;n<equivalents.length;n++){
						Hashtable tSigns = (Hashtable)signs.get(equivalents[n].split(";")[0]);
						if(tSigns.get(equivalents[n].split(";")[1])==null){
							hInformation.add(childArgumentElement.attributeValue("id"));
							break;
						}
					}
				}
				else{
					hInformation.add(childArgumentElement.attributeValue("id"));
				}
			}
			else if(childArgumentElement.attributeValue("type").equalsIgnoreCase("ageinmonths")){
				Hashtable hSigns = (Hashtable)signs.get("patient");
				Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
				boolean bCheck=true;
				if(ageinmonths!=null){
					if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("greaterthan")){
						bCheck = ageinmonths>Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("lessthan")){
						bCheck = ageinmonths<Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("notlessthan")){
						bCheck = ageinmonths>=Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
						bCheck = ageinmonths<=Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
				}
				if(!bCheck){
					return(new Vector());
				}
			}
		}
		if(argumentsElement.getName().equalsIgnoreCase("arguments")){
			int nPositiveArguments = checkPositiveArguments(argumentsElement, signs);
			int nTotalArguments=argumentsElement.elements("argument").size()+argumentsElement.elements("arguments").size();
			int nNeededArguments = nTotalArguments;
			if(!argumentsElement.attributeValue("select").equalsIgnoreCase("all")){
				nNeededArguments=Integer.parseInt(argumentsElement.attributeValue("select"));
			}
			if(nNeededArguments>nPositiveArguments+hInformation.size()){
				return new Vector();
			}
			if(nNeededArguments<=nPositiveArguments){
				return new Vector();
			}
		}
		return hInformation;
	}
	
	Vector getNodePath(Element node,Hashtable signs,String language){
		Vector paths=new Vector();
		getNodePath(node,"",signs,paths,language);
		return paths;
	}

	void getNodePath(Element node,String prefix, Hashtable signs,Vector paths,String language){
		if(checkArguments(node, signs)){
			if(prefix.length()>0){
				prefix+="> ";
			}
			prefix+=getLabel(node, language);
			if(node.element("treatment")!=null){
				prefix+="$"+node.element("treatment").attributeValue("id");
			}
			Iterator nodes = node.elementIterator("node");
			if(nodes.hasNext()){
				while(nodes.hasNext()){
					Element childNode = (Element)nodes.next();
					getNodePath(childNode, prefix, signs, paths, language);
				}
			}
			else{
				paths.add(prefix+"|");
			}
		}
		else{
			Vector missingArguments = getMissingArguments(node, signs);
			String sMissingArguments="";
			Iterator iArguments = missingArguments.iterator();
			while(iArguments.hasNext()){
				if(sMissingArguments.length()>0){
					sMissingArguments+=";";
				}
				sMissingArguments+=iArguments.next();
			}
			paths.add(prefix+"|"+sMissingArguments);
		}
	}
	
	String formatTitle(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				if(n<title.split(">").length-1){
					sTitle+=title.split(">")[n].split("\\$")[0];
				}
				else{
					sTitle+="<b>"+title.split(">")[n].split("\\$")[0]+"</b>";
				}
			}
		}
		else{
			sTitle="<b>"+title.split("\\$")[0]+"</b>";
		}
		return sTitle;
	}
	
	String formatTitleNoBold(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				sTitle+=title.split(">")[n].split("\\$")[0];
			}
		}
		else{
			sTitle=title.split("\\$")[0];
		}
		return sTitle;
	}
	
	boolean hasLaterNode(SortedMap hPaths,String path){
		Iterator iPaths = hPaths.keySet().iterator();
		while(iPaths.hasNext()){
			String iPath = (String)iPaths.next();
			if(iPath.startsWith(path+">")){
				return true;
			}
		}
		return false;
	}
	
%>
		
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
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","spt",sWebLanguage) %></title>
<html>
	<body>
		<table width='100%'>
			<tr>
				<td id='toptable' style='font-size:5vw;text-align: left'>
					<%
						if(activePatient!=null && activePatient.lastname.length()>0){
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						}
					%>
				</td>
				<td style='font-size:8vw;text-align: right' nowrap>
					<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
		</table>

		

		<form name="transactionForm" id="transactionForm" method="post">
			<table width="100%">
		<%
			session.setAttribute(sAPPTITLE+"WebLanguage","fr");
			//Initialize sptconcepts
			Hashtable sptSigns = (Hashtable)session.getAttribute("sptconcepts");
			Hashtable rt = (Hashtable)session.getAttribute("sptconcepts");
			Enumeration te = rt.keys();
			while(te.hasMoreElements()){
				String key = (String)te.nextElement();
			}
			long timestamp = new java.util.Date().getTime();
			//Add selected spt concepts
			Enumeration parameters = request.getParameterNames();
			while(parameters.hasMoreElements()){
				String parameterName = (String)parameters.nextElement();
				if(parameterName.startsWith("concept.")){
					if(request.getParameter(parameterName).length()>0){
						sptSigns.put(parameterName.replaceAll("concept.",""),request.getParameter(parameterName)+";"+timestamp);
					}
				}
			}
			if(request.getParameter("undoButton")!=null){
				//Revert one step in added sptconcepts, don't touch the automatically added ones
				//First find the maximum timestamp
				long maxtimestamp = 0;
				Enumeration eSigns = sptSigns.keys();
				while(eSigns.hasMoreElements()){
					String key = (String)eSigns.nextElement();
					String value = (String)sptSigns.get(key);
					if(value.split(";").length>1){
						long ts = Long.parseLong(value.split(";")[1]);
						if(ts>maxtimestamp){
							maxtimestamp=ts;
						}
					}
				}
				//Now remove all items that have been added at maxtimestamp
				eSigns = sptSigns.keys();
				while(eSigns.hasMoreElements()){
					String key = (String)eSigns.nextElement();
					String value = (String)sptSigns.get(key);
					if(value.split(";").length>1){
						long ts = Long.parseLong(value.split(";")[1]);
						if(ts==maxtimestamp){
							sptSigns.remove(key);
						}
					}
				}		
				session.setAttribute("sptconcepts", sptSigns);
				out.println("<script>window.location.href='spt.jsp';</script>");
				out.flush();
			}
			Enumeration eExcludes = request.getParameterNames();
			while(eExcludes.hasMoreElements()){
				String eName = (String)eExcludes.nextElement();
				if(eName.startsWith("excludeSpt.")){
					eName=eName.split("\\_")[1];
					sptSigns.put(eName, "no");
				}
				else if(eName.startsWith("includeSpt-")){
					eName=eName.split("\\-")[1];
					sptSigns.put(eName.split("\\_")[1], "yes");
					sptSigns.put(eName.split("\\_")[2], "no");
				}
			}
			String addcomplaints = checkString(request.getParameter("addcomplaints"));
			if(addcomplaints.length()>0){
				String[] comp = addcomplaints.split(",");
				for(int n=0;n<comp.length;n++){
					sptSigns.put(comp[n].split(";")[0],comp[n].split(";")[1]);
				}
			}
			//Store spt concepts in session
			session.setAttribute("sptconcepts", sptSigns);
			//Remove timestamps from spt concepts to work with
			Hashtable cleanedSptSigns = new Hashtable();
			Enumeration eSigns = sptSigns.keys();
			while(eSigns.hasMoreElements()){
				String key = (String)eSigns.nextElement();
				String value = (String)sptSigns.get(key);
				cleanedSptSigns.put(key,value.split(";")[0]);
			}
			Hashtable signs = new Hashtable();
			if(activePatient==null){
				signs.put("patient",session.getAttribute("sptpatient"));
			}
			else{
				Hashtable patientSigns = new Hashtable();
				patientSigns.put("ageinmonths",activePatient.getAgeInMonths());
				patientSigns.put("gender",activePatient.gender);
				signs.put("patient",patientSigns);
			}
			if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
				cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
			}
			if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
				cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
			}
			signs.put("spt",cleanedSptSigns);
			if(activePatient!=null && cleanedSptSigns!=null){
				Pointer.deletePointers("activespt."+activePatient.personid);
				Pointer.storePointer("activespt."+activePatient.personid,serializeSptSigns(sptSigns));
				SPT.logSigns(Integer.parseInt(activePatient.personid), serializeSptSigns(sptSigns), new java.util.Date(), Integer.parseInt(activeUser.userid));
			}
			
			//Run through all clinical pathways in order to check which ones are applicable
			String[] pathwayFiles = MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml").split(",");
			for(int n=0;n<pathwayFiles.length;n++){
				String pathwayFile = pathwayFiles[n];
				String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + pathwayFile;
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				//Load documents, concepts and treatments
				Hashtable sheets = new Hashtable();
				if(root.element("documents")!=null){
					Iterator iSheets = root.element("documents").elementIterator("document");
					while(iSheets.hasNext()){
						Element sheet = (Element)iSheets.next();
						Sheet c = new Sheet();
						c.id = checkString(sheet.attributeValue("id"));
						c.href = checkString(sheet.attributeValue("href"));
						c.text = getLabel(sheet,sWebLanguage);
						sheets.put(c.id,c);
					}
				}
				Hashtable concepts = new Hashtable();
				if(root.element("concepts")!=null){
					Iterator iConcepts = root.element("concepts").elementIterator("concept");
					while(iConcepts.hasNext()){
						Element concept = (Element)iConcepts.next();
						Concept c = new Concept();
						c.values = checkString(concept.attributeValue("values")).split(",");
						c.text = getLabel(concept,sWebLanguage);
						concepts.put(concept.attributeValue("id"),c);
					}
				}
				Hashtable treatments = new Hashtable();
				if(root.element("treatments")!=null){
					Iterator iTreatments = root.element("treatments").elementIterator("treatment");
					while(iTreatments.hasNext()){
						Element treatment = (Element)iTreatments.next();
						Treatment t = new Treatment();
						if(treatment.element("document")!=null){
							t.document = checkString(treatment.element("document").attributeValue("href"));
						}
						t.text = getLabel(treatment,sWebLanguage);
						t.id = treatment.attributeValue("id");
						treatments.put(t.id,t);
						t.sheets = new Vector();
						Iterator iSheets = treatment.elementIterator("document");
						while(iSheets.hasNext()){
							t.sheets.add(checkString(((Element)iSheets.next()).attributeValue("id")));
						}
					}
				}
				Hashtable complaints= new Hashtable();
				Element ecomplaints = root.element("complaints");
				if(ecomplaints!=null){
					Iterator sections = ecomplaints.elementIterator("section");
					while(sections.hasNext()){
						Element section = (Element)sections.next();
						Iterator econcepts = section.elementIterator("concept");
						while(econcepts.hasNext()){
							Element concept = (Element)econcepts.next();
							Iterator labels = concept.elementIterator("label");
							while(labels.hasNext()){
								Element label = (Element)labels.next();
								if(label.attributeValue("language").equalsIgnoreCase(sWebLanguage)){
									complaints.put(concept.attributeValue("id"),label.getText());
								}
							}
						}
					}
				}
				
				out.println("<tr><td class='mobileadmin' style='font-size:6vw;' colspan='2'>"+getLabel(root,sWebLanguage)+"</td></tr>");
				out.println("<tr><td class='mobileadmin' style='font-size:6vw;' colspan='2'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/symptom.png' onclick='window.location.href=\"sptcomplaints.jsp?doc="+MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")+"\";'/>&nbsp;&nbsp;&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/mobile/back.png' onclick='window.location.href=\"spt.jsp?undoButton=1\";'/></td></tr>");
				Iterator pathways = root.elementIterator("pathway");
				while(pathways.hasNext()){
					Element pathway = (Element)pathways.next();
					if(isPathwayApplicable(pathway,signs)){
						sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
						Element cave = pathway.element("cave");
						out.println("<tr><td class='mobileadmin' style='font-size:5vw;' colspan='2'>"+getLabel(pathway,sWebLanguage)+(cave!=null && checkString((String)session.getAttribute("activecomplaint")).equals(pathway.attributeValue("complaint"))?"<img onclick='document.getElementById(\"cavetr\").style.display=\"\";this.style.display=\"none\";' src='"+sCONTEXTPATH+"/_img/icons/mobile/question.png'/>":"")+"</td></tr>");
						boolean bSignsToExclude=false;
						boolean bCanceled=false;
						String sExcludeReason="";
						StringBuffer sExcludes = new StringBuffer();
						if(pathway.element("excludes")!=null){
							Iterator excludes = pathway.element("excludes").elementIterator("exclude");
							while(excludes.hasNext()){
								Element exclude=(Element)excludes.next();
								String excludeSpt=exclude.attributeValue("spt");
								if(sptSigns.get(excludeSpt)==null){
									String excludeSign=exclude.getText();
									boolean bMatch=true;
									Hashtable hSigns = (Hashtable)signs.get("patient");
									//Check gender and age
									if(checkString(exclude.attributeValue("minage")).length()>0){
										if(hSigns.get("ageinmonths")!=null && (Integer)hSigns.get("ageinmonths")<Integer.parseInt(exclude.attributeValue("minage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("maxage")).length()>0){
										if(hSigns.get("ageinmonths")!=null && (Integer)hSigns.get("ageinmonths")>Integer.parseInt(exclude.attributeValue("maxage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("gender")).length()>0){
										if(hSigns.get("gender")!=null && !exclude.attributeValue("gender").toUpperCase().contains(((String)hSigns.get("gender")).toUpperCase())){
											bMatch=false;
										}
									}
									if(bMatch){
										if(excludeSpt.startsWith("alert")){
											sExcludes.append("<tr><td class='mobileadmin' style='font-size:5vw;' colspan='3'>"+excludeSign+"</td></tr>");
										}
										else{
											sExcludes.append("<tr><td class='mobileadmin' style='font-size:5vw;'>"+excludeSign+"</td><td nowrap class='mobileadmin' style='font-size:5vw;'><input style='height: 20px;width: 20px' type='radio' id='rbspte"+pathway.attributeValue("complaint")+"_"+excludeSpt+"' name='excludeSpt."+pathway.attributeValue("complaint")+"_"+excludeSpt+"' onclick='document.getElementById(\"rbspti"+pathway.attributeValue("complaint")+"_"+excludeSpt+"\").checked=false;'> "+getTran(request,"web","excludedmini",sWebLanguage)+" <input style='height: 20px;width: 20px' type='radio' id='rbspti"+pathway.attributeValue("complaint")+"_"+excludeSpt+"'  onclick='document.getElementById(\"rbspte"+pathway.attributeValue("complaint")+"_"+excludeSpt+"\").checked=false;' name='includeSpt-"+pathway.attributeValue("complaint")+"_"+excludeSpt+"_"+pathway.attributeValue("complaint")+"'> "+getTran(request,"web","presentmini",sWebLanguage)+"</td></tr>");
										}
										bSignsToExclude=true;
									}
								}
								else if(((String)sptSigns.get(excludeSpt)).equalsIgnoreCase("yes")){
									sExcludeReason=excludeSpt;
									bCanceled=true;
									break;
								}
							}
						}
						if(bCanceled && concepts.get(sExcludeReason)!=null){
							out.println("<tr><td colspan='2' class='mobileadmin' style='font-size:5vw;'><b><font style='font-size:5vw;color: grey'>"+getTran(request,"spt","excludedforreason",sWebLanguage)+" </font><font style='font-size:5vw;color: red'>"+((Concept)concepts.get(sExcludeReason)).text+"</font></b></td></tr>");
							continue;
						}
						if(bSignsToExclude){
							out.println("<tr><td  class='mobileadmin' style='font-size:5vw;' colspan='2'><b><font style='font-size:5vw;color: grey'>"+getTran(request,"spt","signstoexclude",sWebLanguage)+"</font></b></td></tr>");
							out.println(sExcludes.toString());
							out.println("<tr><td/><td><input style='font-size:5vw;height: 8vw;' type='button' value='"+getTranNoLink("web","save",sWebLanguage)+"' onclick='transactionForm.submit()'/></td></tr>");
						}
						else{
							if(cave!=null && !checkString((String)session.getAttribute("activecomplaint")).equals(pathway.attributeValue("complaint"))){
								out.println("<tr valign='top'><td style='font-size:4vw;text-align: left;color: red;border-top: 1px dotted black;border-bottom: 1px dotted black;border-left: 1px dotted black;' nowrap>"+getTran(request,"web","cave",sWebLanguage)+":</td><td style='font-size:4vw;text-align: left;font-weight: bolder;color: red;border-top: 1px dotted black;border-bottom: 1px dotted black;border-right: 1px dotted black;'>"+cave.getText()+"</td></tr>");
							}
							else if(cave!=null){
								out.println("<tr id='cavetr' style='display: none' valign='top'><td style='font-size:4vw;text-align: left;color: red;border-top: 1px dotted black;border-bottom: 1px dotted black;border-left: 1px dotted black;' nowrap>"+getTran(request,"web","cave",sWebLanguage)+":</td><td style='font-size:4vw;text-align: left;font-weight: bolder;color: red;border-top: 1px dotted black;border-bottom: 1px dotted black;border-right: 1px dotted black;'>"+cave.getText()+"</td></tr>");
							}
							session.setAttribute("activecomplaint", pathway.attributeValue("complaint"));
							Iterator childNodes = pathway.elementIterator("node");
							while(childNodes.hasNext()){
								Element childNode = (Element)childNodes.next();
								SortedMap hPaths = new TreeMap();
								Vector paths = getNodePath(childNode, signs, sWebLanguage);
								for(int i=0;i<paths.size();i++){
									String title = ((String)paths.elementAt(i)).split("\\|")[0];
									if(hPaths.get(title)==null){
										hPaths.put(title,new TreeSet());
									}
									if(((String)paths.elementAt(i)).split("\\|").length>1){
										String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
										SortedSet hMissing = (SortedSet)hPaths.get(title);
										//for(int j=0;j<missing.length;j++){
										for(int j=0;j<1;j++){
											hMissing.add(missing[j]);
										}
									}
								}
								boolean bHasTreatments = false;
								Iterator iPaths = hPaths.keySet().iterator();
								boolean bTitlePrinted=false;
								StringBuffer sPrintSigns = new StringBuffer();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									SortedSet hMissing = (SortedSet)hPaths.get(title);
									if(hMissing.size()>0){
										if(!bTitlePrinted){
											sPrintSigns.append("<tr valign='top'><td style='font-size:4vw;text-align: center;'>"+getTran(request,"spt","complaint",sWebLanguage)+"</td><td style='font-size:4vw;text-align: center;'>"+getTran(request,"web","informationneeded",sWebLanguage)+"</td></tr>");
											bTitlePrinted=true;
										}
										sPrintSigns.append("<tr><td class='admin2' style='font-size:4vw;font-weight: bolder'>"+title.split("\\$")[0]+"</td><td class='admin2'><table width='100%'>");
										String sMissing = "";
										Iterator iMissing = hMissing.iterator();
										while(iMissing.hasNext()){
											String sConceptId=(String)iMissing.next();
											Concept concept = (Concept)concepts.get(sConceptId);
											sMissing+="<tr valign='top'><td style='font-size:4vw;border-bottom: 1px solid white'>"+concept.text+"</td><td style='font-size:4vw;border-bottom: 1px solid white'><select style='padding: 5;font-size:4vw' onchange='updatePathway()' name='concept."+sConceptId+"' id='concept."+sConceptId+"' onchange='updateAll(\"concept."+sConceptId+"\",this.value)'><option/>";
											String[] values = concept.values;
											if(values!=null){
												for(int k=0;k<values.length;k++){
													sMissing+="<option  style='font-size:4vw;' value='"+concept.values[k]+"'>"+getTranNoLink("web",concept.values[k],sWebLanguage)+"</option>";
												}
											}
											sMissing+="</select></td></tr>";
											
										}
										sPrintSigns.append(sMissing+"</table></td></tr>");
									}
									if(title.split("\\$").length>1){
										bHasTreatments=true;
									}
								}
								if(bHasTreatments){
									out.println("<tr><td colspan='2' style='border: 1px solid black;'><table width='100%'><tr><td colspan='2'><font style='font-size:5vw;font-weight: bolder;color: grey'>"+getTran(request,"web","treatments",sWebLanguage)+"</font></td></tr>");
									iPaths = hPaths.keySet().iterator();
									while(iPaths.hasNext()){
										String title = (String)iPaths.next();
										if(!hasLaterNode(hPaths, title)){
											String lastpart=title.split(">")[title.split(">").length-1];
											if(lastpart.split("\\$").length>1 && treatments.get(lastpart.split("\\$")[1])!=null){
												out.println("<tr><td class='admin2' style='font-size:4vw;'>"+title.split("\\$")[0]+"</td><td class='admin2' style='font-size:4vw;'>");
												String sTreatment="";
												Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
												if(treatment!=null){
													sTreatment=treatment.text;
													if(!treatment.id.contains(".")){
														sTreatment+="<br/><span style='font-size:4vw;color: red;font-weight: bolder'>"+getTranNoLink("web","spt.result",sWebLanguage)+": ["+treatment.id.toUpperCase()+"]</span> ";
														SPT.logTreatment(activePatient.getPersonId(), treatment.id);
													}
												}
												out.println("<font style='font-size:4vw;color: red'>"+sTreatment+"</font></td></tr>");
												if(treatment.sheets!=null && treatment.sheets.size()>0){
													out.println("<tr><td/><td><table cellpadding='3'><tr>");
													for(int q=0;q<treatment.sheets.size();q++){
														Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
														if(sheet!=null){
															out.println("<td style='border: 1px solid black;'><font style='font-size:4vw;color: red'><a  style='font-size:4vw;' href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
														}
													}
													out.println("</tr></table></td></tr>");
												}
											}
										}
										else{
											String lastpart=title.split(">")[title.split(">").length-1];
											if(lastpart.split("\\$").length>1){
												out.println("<tr><td class='admin2'><i><font style='font-size:4vw;color: grey;'>"+formatTitleNoBold(title)+"</font></i></td><td class='admin2'><i>");
												String sTreatment="";
												Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
												if(treatment!=null){
													sTreatment=treatment.text;
												}
												out.println("<font style='font-size:4vw;color: grey;'>"+sTreatment+" ("+getTran(request,"web","ended",sWebLanguage)+")</font></i></td></tr>");
												if(treatment.sheets!=null && treatment.sheets.size()>0){
													out.println("<tr><td/><td><table cellpadding='3'><tr>");
													for(int q=0;q<treatment.sheets.size();q++){
														Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
														if(sheet!=null){
															out.println("<td style='border: 1px solid black;'><font style='font-size:4vw;color: grey'><a style='font-size:4vw;color: grey' href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
														}
													}
													out.println("</tr></table></td></tr>");
												}
											}
										}
									}
									out.println("</table></td></tr>");
								}
								out.println(sPrintSigns);
							}
						}
					}
				}
				session.setAttribute("sptconcepts", sptSigns);
			}
		%>
			</table>
			
		</form>
		<IFRAME style="display:none" name="hidden-form"></IFRAME>
		
		<script>
			var mywin;
			function showComplaints(doc){
			    window.location.href="sptcomplaints.jsp?doc="+doc+"&ts=<%=getTs()%>";
			}
			function showSheet(doc){
			    mywin=window.open("<c:url value="/"/>documents/"+doc,"_system","location=no");
			    window.setTimeout("if(mywin.location.href.indexOf('pdf')<0){mywin.close();}",5000);
			}
			function updateAll(id,value){
				for(n=0;n<document.getElementsByName(id).length;n++){
					document.getElementsByName(id)[n].value=value;
				}
			}
			function updatePathway(){
				document.getElementById("transactionForm").submit();	
			}
		</script>
	</body>
</html>
<script>
document.getElementById("toptable").scrollIntoView();
</script>