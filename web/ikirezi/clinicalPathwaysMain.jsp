<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%!
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
		Vector complaints;
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
				Debug.println(e.attributeValue("id")+" - "+e.attributeValue("value"));
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
				prefix+=">";
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
					//sTitle+=">";
					sTitle+=" <img style='vertical-align: middle' height='24px' width='14px' src='_img/icons/right.png'/> ";
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
<%
	if(request.getParameter("initPatient")!=null){
		activePatient = new AdminPerson();
		activePatient.personid="-1";
		activePatient.gender=checkString(request.getParameter("initGender"));
		int age = 0;
		try{
			age=Integer.parseInt(request.getParameter("initAge"));
		}
		catch(Exception e){
			age=25;
		}
		long day=24*3600*1000;
		long year=365*day;
		activePatient.dateOfBirth=ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-age*year+day));
		session.setAttribute("activePatient", activePatient);
	}
%>
<form name="transactionForm" id="transactionForm" method="post">
	<table width="100%">
		<tr>
			<td colspan='2'><center><img height='150px' src='<%=sCONTEXTPATH+"/_img/spt.png"%>'/></center></td>
		</tr>
		<tr>
			<td colspan='2'><hr/></font></td>
		</tr>
		<tr>
			<td class='admin'><input type='radio' name='initGender' value='m' <%=activePatient!=null && activePatient.gender.equalsIgnoreCase("m")?"checked":"" %>/><font style='font-size: 15px'>Homme</font> <input type='radio' name='initGender' value='f'<%=activePatient!=null && activePatient.gender.equalsIgnoreCase("f")?"checked":"" %>/><font style='font-size: 15px'>Femme</font></td>
			<td class='admin'><font style='font-size: 15px'>Age: <input style='font-size: 15px' type='text' name='initAge' value='<%=activePatient!=null?activePatient.getAge()+1:"" %>' size='2'/></font> <input style='font-size: 12px' type='submit' class='button' name='initPatient' value='Initialiser Patient'/></td>
		</tr>
<%
	if(activePatient!=null){
		//Initialize sptconcepts
		Hashtable sptSigns = (Hashtable)session.getAttribute("sptconcepts");
		if(sptSigns==null || request.getParameter("resetButton")!=null){
			sptSigns=new Hashtable();
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
		}
		Enumeration eExcludes = request.getParameterNames();
		while(eExcludes.hasMoreElements()){
			String eName = (String)eExcludes.nextElement();
			if(eName.startsWith("excludeSpt.")){
				eName=eName.split("\\_")[1];
				sptSigns.put(eName, "no");
			}
			else if(eName.startsWith("includeSpt-")){
				Debug.println("eName="+eName);
				eName=eName.split("\\-")[1];
				Debug.println("eName="+eName);
				sptSigns.put(eName.split("\\_")[1], "yes");
				sptSigns.put(eName.split("\\_")[2], "no");
				Debug.println("ename= "+eName);
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
			Debug.println("key="+key+" - value="+value.split(";")[0]);
		}
		Hashtable signs = new Hashtable();
		//Then collect patient specific parameters
		Hashtable patientSigns = new Hashtable();
		patientSigns.put("ageinmonths",activePatient.getAgeInMonths());
		patientSigns.put("gender",activePatient.gender);
		signs.put("patient",patientSigns);
		if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
			cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
		}
		if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
			cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
		}
		signs.put("spt",cleanedSptSigns);
		
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
					t.complaints = new Vector();
					Iterator iComplaints = treatment.elementIterator("activate");
					while(iComplaints.hasNext()){
						Element c = (Element)iComplaints.next();
						t.complaints.add(checkString(c.attributeValue("id"))+";"+checkString(c.attributeValue("value")));
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
			
			out.println("<tr class='admin'><td>"+getLabel(root,sWebLanguage)+"</td><td><table width='100%'><tr><td><input type='hidden' name='addcomplaints' id='addcomplaints'/><input type='button' name='complaintButton' onclick='showComplaints(\""+sDoc+"\");' class='button' value='"+getTranNoLink("web","complaints",sWebLanguage)+"'/></td><td><input type='submit' name='submitButton' class='button' value='"+getTranNoLink("web","update",sWebLanguage)+"'/><input type='submit' name='undoButton' class='button' value='"+getTranNoLink("web","undo",sWebLanguage)+"'/><input type='submit' name='resetButton' class='button' value='"+getTranNoLink("web","reset",sWebLanguage)+"'/></td></tr></table></td></tr>");
			Iterator pathways = root.elementIterator("pathway");
			while(pathways.hasNext()){
				Element pathway = (Element)pathways.next();
				if(isPathwayApplicable(pathway,signs)){
					sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
					out.println("<tr class='admin'><td colspan='2'>"+getLabel(pathway,sWebLanguage)+"</td></tr>");
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
									sExcludes.append("<tr><td class='admin2'>"+excludeSign+"</td><td class='admin2'><input type='radio' id='rbspte"+pathway.attributeValue("complaint")+"_"+excludeSpt+"' name='excludeSpt."+pathway.attributeValue("complaint")+"_"+excludeSpt+"' onclick='document.getElementById(\"rbspti"+pathway.attributeValue("complaint")+"_"+excludeSpt+"\").checked=false;'> "+getTran(request,"web","excluded",sWebLanguage)+" <input type='radio' id='rbspti"+pathway.attributeValue("complaint")+"_"+excludeSpt+"'  onclick='document.getElementById(\"rbspte"+pathway.attributeValue("complaint")+"_"+excludeSpt+"\").checked=false;' name='includeSpt-"+pathway.attributeValue("complaint")+"_"+excludeSpt+"_"+pathway.attributeValue("complaint")+"'> "+getTran(request,"web","present",sWebLanguage)+"</td></tr>");
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
					if(bCanceled && (Concept)concepts.get(sExcludeReason)!=null){
						out.println("<tr><td colspan='2' class='admin2'><b><font style='color: grey'>"+getTran(request,"spt","excludedforreason",sWebLanguage)+" </font><font style='color: red'>"+((Concept)concepts.get(sExcludeReason)).text+"</font></b></td></tr>");
						continue;
					}
					if(bSignsToExclude){
						out.println("<tr><td colspan='2'><b><font style='color: grey'>"+getTran(request,"spt","signstoexclude",sWebLanguage)+"</font></b></td></tr>");
						out.println(sExcludes.toString());
						out.println("<tr><td/><td><input type='button' class='button' value='"+getTranNoLink("web","save",sWebLanguage)+"' onclick='transactionForm.submit()'/></td></tr>");
					}
					else{
						Iterator childNodes = pathway.elementIterator("node");
						while(childNodes.hasNext()){
							Element childNode = (Element)childNodes.next();
							SortedMap hPaths = new TreeMap();
							Vector paths = getNodePath(childNode, signs, sWebLanguage);
							for(int i=0;i<paths.size();i++){
								Debug.println("##"+paths.elementAt(i));
								String title = ((String)paths.elementAt(i)).split("\\|")[0];
								if(hPaths.get(title)==null){
									hPaths.put(title,new TreeSet());
								}
								if(((String)paths.elementAt(i)).split("\\|").length>1){
									String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
									SortedSet hMissing = (SortedSet)hPaths.get(title);
									for(int j=0;j<1;j++){
										hMissing.add(missing[j]);
									}
									if(hMissing.size()>0){
										break;
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
										sPrintSigns.append("<tr><td width='60%'><b><font style='color: grey'>"+getTran(request,"spt","complaint",sWebLanguage)+"</font></b></td><td><b><font style='color: grey'>"+getTran(request,"web","informationneeded",sWebLanguage)+"</font></b></td></tr>");
										bTitlePrinted=true;
									}
									sPrintSigns.append("<tr><td class='admin2'>"+formatTitle(title)+"</td><td  style='border: none;' class='admin2'><table width='100%'>");
									String sMissing = "";
									Iterator iMissing = hMissing.iterator();
									while(iMissing.hasNext()){
										String sConceptId=(String)iMissing.next();
										Concept concept = (Concept)concepts.get(sConceptId);
										sMissing+="<tr><td width='50%'><b>"+concept.text+"</b></td><td><select onchange='updatePathway()' name='concept."+sConceptId+"' id='concept."+sConceptId+"' onchange='updateAll(\"concept."+sConceptId+"\",this.value)'><option/>";
										String[] values = concept.values;
										if(values!=null){
											for(int k=0;k<values.length;k++){
												sMissing+="<option value='"+concept.values[k]+"'>"+getTranNoLink("web",concept.values[k],sWebLanguage)+"</option>";
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
								out.println("<tr><td colspan='2' style='border: 1px solid black;'><table width='100%'><tr><td colspan='2'><b><font style='color: grey'>"+getTran(request,"web","treatments",sWebLanguage)+"</font></b></td></tr>");
								iPaths = hPaths.keySet().iterator();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									if(!hasLaterNode(hPaths, title)){
										String lastpart=title.split(">")[title.split(">").length-1];
										if(lastpart.split("\\$").length>1 && treatments.get(lastpart.split("\\$")[1])!=null){
											out.println("<tr><td class='admin2'>"+formatTitle(title)+"</td><td class='admin2'><b>");
											String sTreatment="";
											Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
											if(treatment!=null){
												sTreatment=treatment.text;
												if(!treatment.id.contains(".")){
													sTreatment+=" ("+treatment.id.toUpperCase()+") ";
													SPT.logTreatment(activePatient.getPersonId(), treatment.id);
												}
											}
											out.println("<font style='color: red'>"+sTreatment+"</font></b></td></tr>");
											if(treatment.sheets!=null && treatment.sheets.size()>0){
												out.println("<tr><td/><td><table cellpadding='3'><tr>");
												for(int q=0;q<treatment.sheets.size();q++){
													Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
													if(sheet!=null){
														out.println("<td nowrap style='border: 1px solid black;'><font style='color: red'><a href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
													}
												}
												out.println("</tr></table></td></tr>");
											}
											if(treatment.complaints!=null && treatment.complaints.size()>0){
												out.println("<tr><td/><td><table cellpadding='3'><tr>");
												for(int q=0;q<treatment.complaints.size();q++){
													String c = (String)treatment.complaints.elementAt(q);
													if(c!=null){
														if(sptSigns.get(c.split(";")[0])==null){
															out.println("<td nowrap style='border: 1px solid black;'><font style='color: red'><a href='javascript:doaddcomplaint(\""+c+"\")'>"+getTran(request,"spt","activatespt",sWebLanguage)+" "+complaints.get(c.split(";")[0])+"</a></font></td>");
														}
													}
												}
												out.println("</tr></table></td></tr>");
											}
										}
									}
									else{
										String lastpart=title.split(">")[title.split(">").length-1];
										if(lastpart.split("\\$").length>1){
											out.println("<tr><td class='admin2'><i><font style='color: grey;'>"+formatTitleNoBold(title)+"</font></i></td><td class='admin2'><i>");
											String sTreatment="";
											Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
											if(treatment!=null){
												sTreatment=treatment.text;
											}
											out.println("<font style='color: grey;'>"+sTreatment+" ("+getTran(request,"web","ended",sWebLanguage)+")</font></i></td></tr>");
											if(treatment.sheets!=null && treatment.sheets.size()>0){
												out.println("<tr><td/><td><table cellpadding='3'><tr>");
												for(int q=0;q<treatment.sheets.size();q++){
													Sheet sheet = (Sheet)sheets.get(treatment.sheets.elementAt(q));
													if(sheet!=null){
														out.println("<td nowrap style='border: 1px solid black;'><font style='color: grey'><a href='javascript:showSheet(\""+sheet.href+"\")'>"+checkString(sheet.text)+"</a></font></td>");
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
	}
%>
	</table>
</form>

<script>
	function doaddcomplaint(ids){
		document.getElementById('addcomplaints').value=ids;
		transactionForm.submit();
	}
	function showComplaints(doc){
	    openPopup("/ikirezi/pathwayComplaintsMain.jsp&doc="+doc+"&ts=<%=getTs()%>",800,400).focus();
	}
	function showSheet(doc){
	    window.open("<c:url value="/"/>documents/"+doc,"Document","toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=1,height=1,menubar=no").resizeTo(800,600).focus();
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