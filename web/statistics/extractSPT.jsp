<%@page import="be.openclinic.knowledge.SPT"%>
<%@page import="org.dom4j.DocumentHelper"%>
<%@page import="be.mxs.common.util.system.Pointer"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	class Demographics{
		int infants,children,adults,male,female;
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
	java.util.Date start = SH.parseDate(request.getParameter("start"));
	java.util.Date end = SH.parseDate(request.getParameter("end"));
	long day = 24*3600*1000;
	end=new java.util.Date(end.getTime()+day);
	Hashtable<String,String> concepts = new Hashtable();

	if(SH.c(request.getParameter("download")).equalsIgnoreCase("1")){		
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"SPT_"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".xml\"");
	   
	    ServletOutputStream os = response.getOutputStream();

		byte[] b = SPT.extractSigns(start,end).asXML().getBytes();
	    for(int n=0; n<b.length; n++){
	        os.write(b[n]);
	    }
	    
	    os.flush();
	    os.close();
	}
	else{
		String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "/"+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml");
		SAXReader reader = new SAXReader(false);
		Document document = reader.read(new URL(sDoc));
		Element root = document.getRootElement();
		if(root.element("concepts")!=null){
			Iterator iConcepts = root.element("concepts").elementIterator("concept");
			while(iConcepts.hasNext()){
				Element concept = (Element)iConcepts.next();
				concepts.put(concept.attributeValue("id"),getLabel(concept,sWebLanguage));
			}
		}
		HashSet patients = new HashSet();
		Hashtable<String,HashSet> patientstrategies = new Hashtable<String,HashSet>();
		SortedMap<String,Demographics> strategies = new TreeMap<String,Demographics>();
		Demographics totalDemographics = new Demographics();
		Connection conn = SH.getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_UPDATETIME>=? and SPT_SIGN_UPDATETIME<? order by SPT_SIGN_PATIENTUID,SPT_SIGN_UPDATETIME");
		ps.setDate(1,new java.sql.Date(start.getTime()));
		ps.setDate(2,new java.sql.Date(end.getTime()));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String patientuid=rs.getString("SPT_SIGN_PATIENTUID");
			String[] signs = SH.c(rs.getString("SPT_SIGN_SIGNS")).split(";");
			for(int n=0;n<signs.length;n++){
				if(signs[n].split("\\.").length==2 && signs[n].endsWith(".1=yes")){
					String strategy=signs[n].split("=")[0];
					if(strategies.get(strategy)==null){
						strategies.put(strategy,new Demographics());
					}
					if(patientstrategies.get(strategy)==null){
						patientstrategies.put(strategy,new HashSet<String>());
					}
					if(!patientstrategies.get(strategy).contains(patientuid)){
						Demographics demographics = strategies.get(strategy);
						//Find patient info
						String personid = Pointer.getPointer("sptreverseidentifier."+patientuid);
						AdminPerson patient = AdminPerson.get(personid);
						if(patient!=null && patient.isNotEmpty()){
							if(patient.gender.equalsIgnoreCase("m")){
								demographics.male++;
								if(!patients.contains(patientuid)){
									totalDemographics.male++;
								}
							}
							else{
								demographics.female++;
								if(!patients.contains(patientuid)){
									totalDemographics.female++;
								}
							}
							if(patient.getAgeInMonths()<6){
								demographics.infants++;
								if(!patients.contains(patientuid)){
									totalDemographics.infants++;
								}
							}
							else if(patient.getAgeInMonths()<144){
								demographics.children++;
								if(!patients.contains(patientuid)){
									totalDemographics.children++;
								}
							}
							else{
								demographics.adults++;
								if(!patients.contains(patientuid)){
									totalDemographics.adults++;
								}
							}
							if(!patients.contains(patientuid)){
								patients.add(patientuid);
							}
							patientstrategies.get(strategy).add(patientuid);
						}
					}
				}
			}
		}
		rs.close();
		ps.close();
		conn.close();
%>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='8'><%=getTran(request,"web","statistics.extractspt",sWebLanguage)+ " [v"+root.attributeValue("version")+"]" %></td>
		</tr>
		<tr class='admin'>
			<td colspan='2'><%=request.getParameter("start")+" - "+request.getParameter("end") %></td>
			<td><%=getTran(request,"web","total",sWebLanguage) %></td>
			<td><%=getTran(request,"web","male",sWebLanguage) %></td>
			<td><%=getTran(request,"web","female",sWebLanguage) %></td>
			<td><%=getTran(request,"web","infants",sWebLanguage) %></td>
			<td><%=getTran(request,"web","children",sWebLanguage) %></td>
			<td><%=getTran(request,"web","adults",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' colspan='2'><%=getTran(request,"web","totalpatients",sWebLanguage) %></td>
			<td class='admin2'><%=patients.size() %></td>
			<td class='admin2'><%=totalDemographics.male %></td>
			<td class='admin2'><%=totalDemographics.female %></td>
			<td class='admin2'><%=totalDemographics.infants %></td>
			<td class='admin2'><%=totalDemographics.children %></td>
			<td class='admin2'><%=totalDemographics.adults %></td>
		</tr>
		<%
			Iterator<String> iStrategies = strategies.keySet().iterator();
			while(iStrategies.hasNext()){
				String strategy = iStrategies.next();
				Demographics demographics = strategies.get(strategy);
				%>
				<tr>
					<td class='admin'><%=strategy.replaceAll("\\.1","").toUpperCase()%></td>
					<td class='admin'><%=SH.c(concepts.get(strategy)) %></td>
					<td class='admin2'><%=patientstrategies.get(strategy).size() %></td>
					<td class='admin2'><%=strategies.get(strategy).male %></td>
					<td class='admin2'><%=strategies.get(strategy).female %></td>
					<td class='admin2'><%=strategies.get(strategy).infants %></td>
					<td class='admin2'><%=strategies.get(strategy).children %></td>
					<td class='admin2'><%=strategies.get(strategy).adults %></td>
				</tr>
				<%
			}
		%>
	</table>
	<a target ='downloadFile' href='statistics/extractSPT.jsp?download=1&start=<%=request.getParameter("start")%>&end=<%=request.getParameter("end")%>'><%=getTran(request,"web","download",sWebLanguage) %></a>
	<iframe id='downloadFile' name='downloadFile' style='display: none'/>
<%
	}
%>