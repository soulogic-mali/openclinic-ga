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
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
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
	
	Hashtable getComplaints(String sWebLanguage){
		Hashtable complaints = new Hashtable();
		try{
			//Run through all clinical pathways in order to check which ones are applicable
			String[] pathwayFiles = MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml").split(",");
			for(int n=0;n<pathwayFiles.length;n++){
				String pathwayFile = pathwayFiles[n];
				String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + pathwayFile;
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				Iterator iComplaints = root.elementIterator("pathway");
				while(iComplaints.hasNext()){
					Element pathway = (Element)iComplaints.next();
					complaints.put(pathway.attributeValue("complaint"),getLabel(pathway,sWebLanguage));
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return complaints;
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
					<%if(!checkString(request.getParameter("nohome")).equalsIgnoreCase("1")){ %>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					<%}else{ %>
						<img onclick="parent.window.close();" src='<%=sCONTEXTPATH%>/_img/icons/mobile/logout.png'/>
					<%} %>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
					<%
						Hashtable complaints = getComplaints(sWebLanguage);
						String complaint="";
						String[] codes = Pointer.getPointer("activespt."+activePatient.personid).split(";");
						for(int n=0;n<codes.length && complaint.length()==0;n++){
							if(codes[n].split("=").length>=2){
								if(complaints.get(codes[n].split("=")[0])!=null && codes[n].split("=")[1].equalsIgnoreCase("yes")){
									complaint=(String)complaints.get(codes[n].split("=")[0]);
								}
							}
						}
						out.println(ScreenHelper.formatDate(Pointer.getPointerDate("activespt."+activePatient.personid))+"<br/>"+complaint);
					%>
				</td>
			</tr>
			<tr>
				<td colspan='2' style='font-size:5vw;'><%=getTran(request,"web","loadlastspt",sWebLanguage) %></td>
			</tr>
			<tr>
				<td colspan='2' style='font-size:5vw;text-align: center'>
					<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='button' name='yesButton' value='<%=getTran(request,"web","yes",sWebLanguage) %>' onclick='window.location.href="sptcomplaints.jsp?sptaction=loadspt";'/>	
					<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='button' name='noButton' value='<%=getTran(request,"web","no",sWebLanguage) %>' onclick='window.location.href="sptcomplaints.jsp?doreset=reset&doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>";'/>	
				</td>
			</tr>
		</table>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>