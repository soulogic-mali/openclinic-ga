<%@page import="be.mxs.common.util.system.Pointer"%>
<%@page import="org.dom4j.*"%>
<%@page import="be.openclinic.system.*" %>
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
	String begin = SH.p(request, "begin");
	String end = SH.p(request, "end");
%>
<head>
  	<%=sCSSNORMAL%>
</head>

<table width='100%'>
	<tr class='admin'>
		<td colspan='8'><%=getTran(request,"web","sptstatistics",sWebLanguage) %></td>
	</tr>
	<tr>
		<form name="transactionForm" id="transactionForm" method="post">
			<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
			<td class='admin2'><%=SH.writeDateField("begin", "transactionForm", begin, true, false, sWebLanguage, sCONTEXTPATH)%></td>
			<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
			<td class='admin2'><%=SH.writeDateField("end", "transactionForm", end, true, false, sWebLanguage, sCONTEXTPATH)%></td>
			<td class='admin2'><input type='submit' name='submitButton' value='<%=getTran(request,"web","execute",sWebLanguage) %>'/></td>
		</form>
		<form name="uploadForm" id="uploadForm" method="post" enctype="multipart/form-data">
			<td class='admin'><%=getTran(request,"web","uploadsptdata",sWebLanguage) %></td>
			<td class='admin2'><input type='file' name='sptdata'/><input type='submit' name='uploadButton' value='<%=getTran(request,"web","upload",sWebLanguage) %>'/></td>
		</form>
	</tr>
</table>
<table width='100%'>
<%
	Hashtable parameters = SH.getMultipartFormParameters(request);
	if(parameters.get("uploadButton")!=null){
		Connection conn = SH.getStatsConnection();
		Enumeration<String> eParameters = parameters.keys();
		while(eParameters.hasMoreElements()){
			String parName=eParameters.nextElement();
			if(parName.equalsIgnoreCase("sptdata")){
				int counter=0,updates=0;
				FormFile formFile = (FormFile)parameters.get(parName);
				org.dom4j.Document document = DocumentHelper.parseText(new String(formFile.getDocument()));
				Element root = document.getRootElement();
				int serverid = Integer.parseInt(root.attributeValue("server"));
				String version = root.attributeValue("version");
				//We do not accept sptdata from an unidentified server
				if(serverid>1){
					Iterator<Element> patients = root.elementIterator("patient");
					while(patients.hasNext()){
						try{
							Element patient = patients.next();
							long patientid = Long.parseLong(patient.attributeValue("id"));
							int patientage = Integer.parseInt(patient.attributeValue("ageinmonths"));
							String patientgender = patient.attributeValue("gender");
							try{
								Iterator<Element> statuses = patient.elementIterator("status");
								while(statuses.hasNext()){
									counter++;
									Element status = statuses.next();
									java.util.Date datetime = new SimpleDateFormat("yyyyMMddHHmmss").parse(status.attributeValue("datetime"));
									int userid = Integer.parseInt(status.attributeValue("user"));
									String treatment = status.attributeValue("treatment");
									String signs = status.getText();
									//Store the data only if it doesn't exist yet
									PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_SERVERID=? AND SPT_SIGN_PATIENTUID=? AND SPT_SIGN_UPDATETIME=?");
									ps.setInt(1,serverid);
									ps.setLong(2,patientid);
									ps.setTimestamp(3, new java.sql.Timestamp(datetime.getTime()));
									ResultSet rs = ps.executeQuery();
									if(!rs.next()){
										rs.close();
										ps.close();
										ps = conn.prepareStatement("insert into SPT_SIGNS(SPT_SIGN_SERVERID,SPT_SIGN_PATIENTUID,SPT_SIGN_PATIENTAGE,SPT_SIGN_PATIENTGENDER,SPT_SIGN_SIGNS,SPT_SIGN_TREATMENT,SPT_SIGN_UPDATETIME,SPT_SIGN_UPDATEUID) values(?,?,?,?,?,?,?,?)");
										ps.setInt(1,serverid);
										ps.setLong(2,patientid);
										ps.setInt(3,patientage);
										ps.setString(4, patientgender);
										ps.setString(5,signs);
										ps.setString(6,treatment);
										ps.setTimestamp(7,SH.ts(datetime));
										ps.setInt(8,userid);
										ps.execute();
										updates++;
									}
									else{
										rs.close();
									}
									ps.close();
								}
							}
							catch(Exception i){
								i.printStackTrace();
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					%>
					<tr><td colspan='8'><%=getTran(request,"web","successfullyreceived",sWebLanguage)+" <b>"+counter+"</b> "+getTran(request,"web","recordingsforserverid",sWebLanguage)+" <b>"+serverid+"</b>" %></td></tr>
					<tr><td colspan='8'><%=getTran(request,"web","updateof",sWebLanguage)+" <b>"+updates+"</b> "+getTran(request,"web","recordings",sWebLanguage) %></td></tr>
					<%
				}
				else {
					%>
					<tr><td colspan='8'><%= getTran(request,"web","undefinedserverid",sWebLanguage)+": <b>"+serverid+"</b>" %></td></tr>
					<%
				}
			}
		}
		conn.close();
	}
	else if(request.getParameter("submitButton")!=null && begin.length()>0 && end.length()>0){
		java.util.Date dbegin = SH.parseDate(begin);
		java.util.Date dend = SH.parseDate(end);
		long day = 24*3600*1000;
		dend=new java.util.Date(dend.getTime()+day);
		Hashtable<String,String> concepts = new Hashtable();
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
		Vector servers = new Vector();
		Connection conn = SH.getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("select distinct SPT_SIGN_SERVERID from SPT_SIGNS where SPT_SIGN_UPDATETIME>=? and SPT_SIGN_UPDATETIME<?");
		ps.setDate(1,new java.sql.Date(dbegin.getTime()));
		ps.setDate(2,new java.sql.Date(dend.getTime()));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			servers.add(rs.getInt("SPT_SIGN_SERVERID"));
		}
		rs.close();
		ps.close();
		for(int svr=0; svr<servers.size();svr++){
			HashSet patients = new HashSet();
			Hashtable<String,HashSet> patientstrategies = new Hashtable<String,HashSet>();
			SortedMap<String,Demographics> strategies = new TreeMap<String,Demographics>();
			Demographics totalDemographics = new Demographics();
			Hashtable treatments = new Hashtable();
			int serverid = (Integer)servers.elementAt(svr);
			conn.close();
			conn = SH.getStatsConnection();
			ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_UPDATETIME>=? and SPT_SIGN_UPDATETIME<? and SPT_SIGN_SERVERID=? order by SPT_SIGN_PATIENTUID,SPT_SIGN_UPDATETIME");
			ps.setDate(1,new java.sql.Date(dbegin.getTime()));
			ps.setDate(2,new java.sql.Date(dend.getTime()));
			ps.setInt(3,serverid);
			rs = ps.executeQuery();
			while(rs.next()){
				String personid=rs.getString("SPT_SIGN_PATIENTUID");
				String[] signs = SH.c(rs.getString("SPT_SIGN_SIGNS")).split(";");
				String treatment = SH.c(rs.getString("SPT_SIGN_TREATMENT"));
				for(int n=0;n<signs.length;n++){
					if(signs[n].split("\\.").length==2 && signs[n].endsWith(".1=yes")){
						String strategy=signs[n].split("=")[0];
						if(treatment.length()>0){
							if(treatments.get(strategy)==null){
								treatments.put(strategy,new TreeMap());
							}
						 	SortedMap outcomes = (SortedMap)treatments.get(strategy);
						 	if(outcomes.get(treatment)==null){
							 	outcomes.put(treatment,1);
						 	}
						 	else{
								outcomes.put(treatment,1+(Integer)outcomes.get(treatment));
						 	}
						}
						if(strategies.get(strategy)==null){
							strategies.put(strategy,new Demographics());
						}
						if(patientstrategies.get(strategy)==null){
							patientstrategies.put(strategy,new HashSet<String>());
						}
						if(!patientstrategies.get(strategy).contains(personid)){
							Demographics demographics = strategies.get(strategy);
							//Find patient info
							if(rs.getString("SPT_SIGN_PATIENTGENDER").equalsIgnoreCase("m")){
								demographics.male++;
								if(!patients.contains(personid)){
									totalDemographics.male++;
								}
							}
							else{
								demographics.female++;
								if(!patients.contains(personid)){
									totalDemographics.female++;
								}
							}
							int age=rs.getInt("SPT_SIGN_PATIENTAGE");
							if(age<6){
								demographics.infants++;
								if(!patients.contains(personid)){
									totalDemographics.infants++;
								}
							}
							else if(age<144){
								demographics.children++;
								if(!patients.contains(personid)){
									totalDemographics.children++;
								}
							}
							else{
								demographics.adults++;
								if(!patients.contains(personid)){
									totalDemographics.adults++;
								}
							}
							if(!patients.contains(personid)){
								patients.add(personid);
							}
							patientstrategies.get(strategy).add(personid);
						}
					}
				}
			}
			rs.close();
			ps.close();
			conn.close();
			String servername="?";
			conn=SH.getOpenclinicConnection();
			ps=conn.prepareStatement("select * from servers where serverid=?");
			ps.setInt(1, serverid);
			rs=ps.executeQuery();
			if(rs.next()){
				servername=rs.getString("serverName");
			}
			rs.close();
			ps.close();
			conn.close();
			%>
			<tr class='admin'>
				<td colspan='2'><%=serverid+" - "+servername %></td>
				<td><%=getTran(request,"web","total",sWebLanguage) %></td>
				<td><%=getTran(request,"web","male",sWebLanguage) %></td>
				<td><%=getTran(request,"web","female",sWebLanguage) %></td>
				<td><%=getTran(request,"web","infants",sWebLanguage) %></td>
				<td><%=getTran(request,"web","children",sWebLanguage) %></td>
				<td><%=getTran(request,"web","adults",sWebLanguage) %></td>
			</tr>
			<tr>
				<td class='admin' colspan='2'><%=getTran(request,"web","totalpatients",sWebLanguage) %> <img onclick='if(document.getElementById("detail.<%=serverid%>").style.display=="none"){document.getElementById("detail.<%=serverid%>").style.display="";}else{document.getElementById("detail.<%=serverid%>").style.display="none";}' src='<%=sCONTEXTPATH%>/_img/icons/icon_info.gif'/></td>
				<td class='admin2'><%=patients.size() %></td>
				<td class='admin2'><%=totalDemographics.male %></td>
				<td class='admin2'><%=totalDemographics.female %></td>
				<td class='admin2'><%=totalDemographics.infants %></td>
				<td class='admin2'><%=totalDemographics.children %></td>
				<td class='admin2'><%=totalDemographics.adults %></td>
			</tr>
			<tr style='display: none' id='detail.<%=serverid%>'>
				<td colspan='8'><table width='100%'>
			<%
				Iterator<String> iStrategies = strategies.keySet().iterator();
				while(iStrategies.hasNext()){
					String strategy = iStrategies.next();
					Demographics demographics = strategies.get(strategy);
					%>
					<tr>
						<td class='admin'><%=strategy.replaceAll("\\.1","").toUpperCase()%></td>
						<td class='admin'><%=SH.c(concepts.get(strategy)) %>
						<%
							String res = "";
							SortedMap outcomes = (SortedMap)treatments.get(strategy);
							if(outcomes!=null){
								Iterator iOutcomes = outcomes.keySet().iterator();
								while(iOutcomes.hasNext()){
									String outcome=(String)iOutcomes.next();
									if(res.length()>0){
										res+=", ";
									}
									res+=outcome.toUpperCase()+"="+outcomes.get(outcome);
								}
							}
							if(res.length()>0){
								out.print(" (<i><font style='color: red'>"+res+"</font></i>)");
							}
						%>
						</td>
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
				</table></td></tr>
			<%
		}
	}
%>
</table>