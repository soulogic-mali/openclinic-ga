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
	boolean checkArguments(Element element, Hashtable signs){
		int nPositive=0;
		Iterator arguments = element.elementIterator("arguments");
		if(arguments.hasNext()){
			while(arguments.hasNext()){
				Element eArguments = (Element)arguments.next();
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
			if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
				return false;
			}
		}
		arguments = element.elementIterator("argument");
		while(arguments.hasNext()){
			Element eArgument = (Element)arguments.next();
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
		if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all") && nPositive<Integer.parseInt(element.attributeValue("select"))){
			return false;
		}
		return true;
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
%>
<%
	//Initialize sptconcepts
	Hashtable sptSigns = (Hashtable)session.getAttribute("sptconcepts");
	if(sptSigns==null){
		sptSigns=new Hashtable();
	}
	Hashtable signs = new Hashtable();
	signs.put("spt",sptSigns);
	//Then collect patient specific parameters
	Hashtable patientSigns = new Hashtable();
	patientSigns.put("ageinmonths",activePatient.getAgeInMonths());
	patientSigns.put("gender",activePatient.gender);
	signs.put("patient",patientSigns);

	if(request.getParameter("submitButton")!=null){
		//First clear all spt concepts
		String sDoc = request.getParameter("doc");
		SAXReader reader = new SAXReader(false);
		Document document = reader.read(new URL(sDoc));
		Element root = document.getRootElement();
		Element complaints = root.element("complaints");
		if(complaints!=null){
			Iterator sections = complaints.elementIterator("section");
			while(sections.hasNext()){
				Element section = (Element)sections.next();
				Iterator concepts = section.elementIterator("concept");
				while(concepts.hasNext()){
					Element concept = (Element)concepts.next();
					sptSigns.remove(concept.attributeValue("id"));
				}
			}
		}
		//Add selected spt concepts
		Enumeration parameters = request.getParameterNames();
		while(parameters.hasMoreElements()){
			String parameterName = (String)parameters.nextElement();
			if(parameterName.startsWith("concept.") && request.getParameter(parameterName).length()>0){
				sptSigns.put(parameterName.replaceAll("concept.",""),request.getParameter(parameterName));
			}
		}
		//Store spt concepts in session
		session.setAttribute("sptconcepts", sptSigns);
		out.println("<script>window.opener.location.href='"+sCONTEXTPATH+"/main.jsp?Page=ikirezi/clinicalPathways.jsp';window.close();</script>");
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='doc' value='<%=request.getParameter("doc")%>'/>
	<table width='100%'>
<%
	String sDoc = request.getParameter("doc");
	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new URL(sDoc));
	Element root = document.getRootElement();
	out.println("<tr><td><table width='100%'><tr class='admin'><td>"+getLabel(root,sWebLanguage)+"</td><td><input type='submit' name='submitButton' class='button' value='"+getTranNoLink("web","update",sWebLanguage)+"'/></td></tr></table></td></tr>");
	Element complaints = root.element("complaints");
	if(complaints!=null){
		Iterator sections = complaints.elementIterator("section");
		while(sections.hasNext()){
			Element section = (Element)sections.next();
			int cols=5;
			if(section.attributeValue("cols")!=null){
				cols = Integer.parseInt(section.attributeValue("cols"));
			}
			out.println("<tr><td class='admin'>"+getLabel(section,sWebLanguage)+"</td></tr>");
			Iterator concepts = section.elementIterator("concept");
			//Sort concepts alphabetically
			SortedMap sortedconcepts = new TreeMap();
			while(concepts.hasNext()){
				Element concept = (Element)concepts.next();
				sortedconcepts.put(getLabel(concept,sWebLanguage),concept);
			}	
			Vector vConcepts = new Vector();
			Iterator iConcepts = sortedconcepts.keySet().iterator();
			while(iConcepts.hasNext()){
				vConcepts.add(sortedconcepts.get(iConcepts.next()));
			}
			concepts=vConcepts.iterator();
			//End of sorting procedure
			int counter=0;
			while(concepts.hasNext()){
				Element concept = (Element)concepts.next();
				if(counter % cols ==0){
					out.println("<tr><td><table width='100%'>");
				}
				if(checkArguments(concept, signs)){
					out.println("<td width='"+(100/cols)+"%'><input name='concept."+concept.attributeValue("id")+"' type='checkbox' value='"+concept.attributeValue("value")+"' "+(checkString((String)sptSigns.get(concept.attributeValue("id"))).equalsIgnoreCase(concept.attributeValue("value"))?"checked":"")+"/>"+getLabel(concept,sWebLanguage)+"</td>");
				}
				else{
					out.println("<td width='"+(100/cols)+"%'><input disabled type='checkbox'/><font style='color: lightgrey'>"+getLabel(concept,sWebLanguage)+"</font></td>");
				}
				if(counter % cols ==cols-1){
					out.println("</table></td></tr>");
				}
				counter++;
			}
			if(counter % cols !=0){
				out.println("<td colspan='"+(cols-(counter%cols))+"'/></table></td></tr>");
			}
		}
	}
%>
	</table>
</form>