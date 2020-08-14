<%@page import="ocspring2.OC"%>
<%@page import="be.openclinic.medical.*"%>
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
<body onresize="checkZoomFactor();">
<script>
	var zoom = 1;
	if(window.devicePixelRatio){
		zoom=window.devicePixelRatio;
	}
	zoom =zoom/1.1;
	var bChanged=false;
	
	function checkZoomFactor(){
		var newzoom = 1;
		if(window.devicePixelRatio){
			newzoom=window.devicePixelRatio;
		}
		newzoom=newzoom/1.1;
		if(Math.abs(zoom-newzoom)>0.01){
			if(reloadForm) reloadForm.submit();
		}
	}
</script>
<%
Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
try{
	Hashtable ikireziSymptoms = new Hashtable();
	if(request.getParameter("encounteruid")!=null){
		encounter = Encounter.get((String)request.getParameter("encounteruid"));
	}
	if(encounter !=null){
		if(checkString(request.getParameter("init")).length()>0){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into oc_ikireziactions(oc_action_id, oc_action_encounteruid, oc_action_data, oc_action_uid, oc_action_updatetime) values(?,?,?,?,?)");
			ps.setInt(1,MedwanQuery.getInstance().getOpenclinicCounter("IKIREZI_ACTION"));
			ps.setString(2,encounter.getUid());
			ps.setString(3,"init."+request.getParameter("init"));
			ps.setInt(4,Integer.parseInt(activeUser.userid));
			ps.setTimestamp(5, new Timestamp(new java.util.Date().getTime()));
			ps.execute();
			ps.close();
			conn.close();
		}
		ikireziSymptoms = encounter.getIkireziSymptoms();
	}

	if(activePatient==null || (checkString(request.getParameter("panorama")).length()==0 && checkString(request.getParameter("hints")).length()==0)){
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<center><br><font style='font-size: 14px; font-weight: bolder; color: red'><%=getTran(request,"ikirezi","disclaimer",sWebLanguage) %></font><br>&nbsp;</center>
			</tr>
			<tr class='admin'><td colspan='2'><%=getTran(request,"ikirezi","panorama",sWebLanguage) %></td></tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","disease.progress",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='diseaseProgress' id='diseaseProgress'>
						<%=ScreenHelper.writeSelect(request, "disease.progress", "", sWebLanguage) %>
					</select>
				</td>
			</tr>
			<!-- Make a list of all valid complaints from the patient record and their onset dates -->
			<tr class='admin'><td colspan='2'><%=getTran(request,"ikirezi","principal.complaints",sWebLanguage) %></td></tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","firstcomplaint",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='complaint1a' id='complaint1a' onchange='validateselects();'>
						<option/>
						<%
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
							//Load all symptoms from ikirezi
							Vector vSigns= new Vector();
							//1. First get person reference
							int age = activePatient.getAgeInMonths();
							if(age<12){
								vSigns.add("110");
							}
							else if(age<180){
								vSigns.add("98");
							}
							else if(activePatient.gender.toLowerCase().equalsIgnoreCase("m")){
								vSigns.add("136");
							}
							else{
								vSigns.add("81");
							}
							//2. Get type of encounter 
							vSigns.add(request.getParameter("diseaseProgress"));
							Hashtable hIkirezi = new Hashtable();
							Connection iconn = MedwanQuery.getInstance().getIkireziConnection();
							PreparedStatement ps = iconn.prepareStatement("select * from sym_lang");
							ResultSet rs = ps.executeQuery();
							while(rs.next()){
								hIkirezi.put(rs.getString("nrs"),rs.getString("symp"+sWebLanguage.substring(0,1)));
							}
							rs.close();
							ps.close();
							iconn.close();
							Hashtable findings = Ikirezi.getRemainingStartupSigns(vSigns,sWebLanguage);
							//Then find all existing reasons for encounter with ICPC code
							HashSet activecodes = new HashSet();
							Vector rfes = new Vector();
							boolean bSelected=false;
							String firstcode="";
							if(encounter!=null){
								rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounter.getUid());
								for(int n=0;n<rfes.size();n++){
									ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
									if(rfe.getCodeType().equalsIgnoreCase("icpc") && hICPCMappings.get(rfe.getCode())!=null && !activecodes.contains(hICPCMappings.get(rfe.getCode())) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+hICPCMappings.get(rfe.getCode())+"*")<0){
										activecodes.add(hICPCMappings.get(rfe.getCode()));
										String date = "";
										try{
											date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
										}
										catch(Exception e){}
										out.println("<option style='FONT-WEIGHT:bold' value='"+hICPCMappings.get(rfe.getCode())+"."+date+"' "+(!bSelected?"selected":"")+">"+((String)hIkirezi.get(hICPCMappings.get(rfe.getCode()))).toUpperCase()+"</option>");
										if(!bSelected){
											firstcode=hICPCMappings.get(rfe.getCode())+"";
											bSelected=true;
										}
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
										out.println("<option style='FONT-WEIGHT:bold' value='"+hICDMappings.get(rfe.getCode())+"."+date+"' "+(!bSelected?"selected":"")+">"+((String)hIkirezi.get(hICDMappings.get(rfe.getCode()))).toUpperCase()+"</option>");
										if(!bSelected){
											firstcode=hICPCMappings.get(rfe.getCode())+"";
											bSelected=true;
										}
									}
								}
								Hashtable encounterSymptoms = Ikirezi.getEncounterSymptoms(encounter.getUid());
								//Load all selected startup signs that are available in Ikirezi
								out.println("<option disabled>------------------</option>");
								SortedSet sortedFindings = new TreeSet();
								Enumeration eFindings = findings.keys();
								while(eFindings.hasMoreElements()){
									String nrs = (String)eFindings.nextElement();
									if(!activecodes.contains(nrs) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+nrs+"*")<0){
										sortedFindings.add(ScreenHelper.removeAccents(((String)findings.get(nrs)).toUpperCase())+";"+nrs);
									}
								}
								Iterator iFindings = sortedFindings.iterator();
								while(iFindings.hasNext()){
									String finding=(String)iFindings.next();
									if(findings.get(finding.split(";")[1])!=null && encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))!=null && (Integer)encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))==1){
										out.println("<option style='FONT-WEIGHT:bold' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' "+(!bSelected?"selected":"")+">"+finding.split(";")[0].toUpperCase()+"</option>");
										if(!bSelected){
											firstcode=finding.split(";")[1];
											bSelected=true;
										}
									}
								}
								//Load all unselected startup signs that are available in Ikirezi
								out.println("<option disabled>------------------</option>");
								eFindings = findings.keys();
								while(eFindings.hasMoreElements()){
									String nrs = (String)eFindings.nextElement();
									if(!activecodes.contains(nrs) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+nrs+"*")<0){
										sortedFindings.add(ScreenHelper.removeAccents(((String)findings.get(nrs)).toUpperCase())+";"+nrs);
									}
								}
								iFindings = sortedFindings.iterator();
								while(iFindings.hasNext()){
									String finding=(String)iFindings.next();
									if(findings.get(finding.split(";")[1])==null || encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))==null || (Integer)encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))!=1){
										out.println("<option style='font-style:italic' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"'>"+finding.split(";")[0]+"</option>");
									}
								}
							}
						
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","secondcomplaint",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='complaint1b' id='complaint1b' onchange='validateselects();'>
						<option/>
						<%
							activecodes = new HashSet();
							bSelected=false;
							if(encounter!=null){
								for(int n=0;n<rfes.size();n++){
									ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
									if(rfe.getCodeType().equalsIgnoreCase("icpc") && hICPCMappings.get(rfe.getCode())!=null && !activecodes.contains(hICPCMappings.get(rfe.getCode())) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+hICPCMappings.get(rfe.getCode())+"*")<0){
										activecodes.add(hICPCMappings.get(rfe.getCode()));
										String date = "";
										try{
											date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
										}
										catch(Exception e){}
										out.println("<option style='FONT-WEIGHT:bolder' value='"+hICPCMappings.get(rfe.getCode())+"."+date+"' "+(!bSelected && !(hICPCMappings.get(rfe.getCode())+"").equalsIgnoreCase(firstcode)?"selected":"")+">"+((String)hIkirezi.get(hICPCMappings.get(rfe.getCode()))).toUpperCase()+"</option>");
										if(!bSelected  && !(hICPCMappings.get(rfe.getCode())+"").equalsIgnoreCase(firstcode)){
											bSelected=true;
										}
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
										out.println("<option style='FONT-WEIGHT:bolder' value='"+hICDMappings.get(rfe.getCode())+"."+date+"' "+(!bSelected && !(hICPCMappings.get(rfe.getCode())+"").equalsIgnoreCase(firstcode)?"selected":"")+">"+((String)hIkirezi.get(hICDMappings.get(rfe.getCode()))).toUpperCase()+"</option>");
										if(!bSelected && !(hICPCMappings.get(rfe.getCode())+"").equalsIgnoreCase(firstcode)){
											bSelected=true;
										}
									}
								}
								Hashtable encounterSymptoms = Ikirezi.getEncounterSymptoms(encounter.getUid());
								//Load all selected startup signs that are available in Ikirezi
								out.println("<option disabled>------------------</option>");
								SortedSet sortedFindings = new TreeSet();
								Enumeration eFindings = findings.keys();
								while(eFindings.hasMoreElements()){
									String nrs = (String)eFindings.nextElement();
									if(!activecodes.contains(nrs) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+nrs+"*")<0){
										sortedFindings.add(ScreenHelper.removeAccents(((String)findings.get(nrs)).toUpperCase())+";"+nrs);
									}
								}
								Iterator iFindings = sortedFindings.iterator();
								while(iFindings.hasNext()){
									String finding=(String)iFindings.next();
									if(findings.get(finding.split(";")[1])!=null && encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))!=null && (Integer)encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))==1){
										out.println("<option style='FONT-WEIGHT:bold' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' "+(!bSelected?"selected":"")+">"+finding.split(";")[0].toUpperCase()+"</option>");
										bSelected=true;
									}
								}
								//Load all unselected startup signs that are available in Ikirezi
								out.println("<option disabled>------------------</option>");
								eFindings = findings.keys();
								while(eFindings.hasMoreElements()){
									String nrs = (String)eFindings.nextElement();
									if(!activecodes.contains(nrs) && MedwanQuery.getInstance().getConfigString("unselectableIkireziSigns","*8*81*98*101*104*110*111*112*136*153*154*155*156*158*159*160*163*165*170*171*172*208*213*221*356*395*396*402*411*412*429*430*436*437*445*474*517*540*542*3000*").indexOf("*"+nrs+"*")<0){
										sortedFindings.add(ScreenHelper.removeAccents(((String)findings.get(nrs)).toUpperCase())+";"+nrs);
									}
								}
								iFindings = sortedFindings.iterator();
								while(iFindings.hasNext()){
									String finding=(String)iFindings.next();
									if(findings.get(finding.split(";")[1])==null || encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))==null || (Integer)encounterSymptoms.get(Integer.parseInt(finding.split(";")[1]))!=1){
										out.println("<option style='font-style:italic' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"'>"+finding.split(";")[0]+"</option>");
									}
								}
							}
						%>
					</select>
				</td>
			</tr>
		</table>
		<input class='button' type='submit' name='panorama' id='panorama' value='<%=getTranNoLink("web","viewpanorama",sWebLanguage) %>'/>
		<input class='button' type='submit' name='hints' id='hints' value='<%=getTranNoLink("web","showhints",sWebLanguage) %>'/>
	</form>
	
	<script>
		function validateselects(){
			var c1 = document.getElementById("complaint1a").value;
			if(c1==document.getElementById("complaint1b").value){
				document.getElementById("complaint1b").options[0].selected=true;
			}
			for(n=0;n<document.getElementById("complaint1b").options.length;n++){
				if(c1.length>0 && c1==document.getElementById("complaint1b").options[n].value){
					document.getElementById("complaint1b").options[n].selected=false;
					document.getElementById("complaint1b").options[n].disabled=true;
				}
				else{
					document.getElementById("complaint1b").options[n].disabled=false;
				}
			}
		}
        window.setTimeout('validateselects();',500);
	</script>
	
<%
	}
	else if (checkString(request.getParameter("hints")).length()>0 ){
	%>
		<form name='reloadForm' method='post'>
			<input type='hidden' name='hints' value='<%=checkString(request.getParameter("hints"))%>'/>
			<input type='hidden' name='panorama' value='<%=checkString(request.getParameter("panorama"))%>'/>
			<input type='hidden' name='complaint1a' value='<%=checkString(request.getParameter("complaint1a"))%>'/>
			<input type='hidden' name='complaint1b' value='<%=checkString(request.getParameter("complaint1b"))%>'/>
			<input type='hidden' name='diseaseProgress' value='<%=checkString(request.getParameter("diseaseProgress"))%>'/>
		</form>
	<%
		//Get base data from medical record
		Vector vSigns= new Vector();
		//1. First get person reference
		int age = activePatient.getAgeInMonths();
		if(age<12){
			vSigns.add("110");
		}
		else if(age<180){
			vSigns.add("98");
		}
		else if(activePatient.gender.toLowerCase().equalsIgnoreCase("m")){
			vSigns.add("136");
		}
		else{
			vSigns.add("81");
		}
		//2. Get type of encounter 
		vSigns.add(request.getParameter("diseaseProgress"));
		Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), request.getParameter("diseaseProgress"), "1",Integer.parseInt(activeUser.userid));

		//3. Get main complaint
		if(checkString(request.getParameter("complaint1a")).length()>0){
			vSigns.add(((String)request.getParameter("complaint1a")).split("\\.")[0]);
			Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), ((String)request.getParameter("complaint1a")).split("\\.")[0], "1",Integer.parseInt(activeUser.userid));
		}
		
		//4. Get secondary complaint
		if(checkString(request.getParameter("complaint1b")).length()>0){
			vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
			Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), ((String)request.getParameter("complaint1b")).split("\\.")[0], "1",Integer.parseInt(activeUser.userid));
		}
		else{
			vSigns.add("0");
		}
		Hashtable possibleSigns = Ikirezi.getRemainingSigns(vSigns, sWebLanguage);
		HashMap signs = new HashMap();
		HashMap signpowers = new HashMap();
		//Ikirezi interface
		//Make Ikirezi call
		HashSet diseases = new HashSet();
		Vector resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
		for (int n=0;n<resp.size();n++){
			Vector v = (Vector)resp.elementAt(n);
			if(possibleSigns.get(v.elementAt(2))==null){
				Debug.println("excluded: "+v.elementAt(2));
				continue;
			}
			double power=-(Double.parseDouble((String)v.elementAt(5))+Double.parseDouble((String)v.elementAt(6)))/2;
			if(signpowers.get(v.elementAt(2))==null){
				signpowers.put(v.elementAt(2),power);
				signs.put(v.elementAt(2),((String)v.elementAt(4)).replaceAll("%","--pct--").replaceAll("<","--lt--").replaceAll(">","--gt--")+";"+v.elementAt(5)+";"+v.elementAt(6)+";"+v.elementAt(2));
			}
			else{
				if(power<(Double)signpowers.get(v.elementAt(2))){
					signpowers.put(v.elementAt(2),power);
					signs.put(v.elementAt(2),((String)v.elementAt(4)).replaceAll("%","--pct--").replaceAll("<","--lt--").replaceAll(">","--gt--")+";"+v.elementAt(5)+";"+v.elementAt(6)+";"+v.elementAt(2));
				}
			}
		}

		SortedMap sortedsignpowers = new TreeMap();
		Iterator i = signpowers.keySet().iterator();
		while(i.hasNext()){
			String key = (String)i.next();
			sortedsignpowers.put(signpowers.get(key),key);
		}
		out.println("<input type='button' class='button' name='back' value='"+getTranNoLink("web","back",sWebLanguage)+"' style='position: absolute;top: 1%;left: 46%' onclick='window.history.back();'/>");
		out.println("<table width='100%'>");
		out.println("<tr class='admin'>");
		out.println("<th colspan='2'>"+getTran(request,"web","investigation",sWebLanguage)+"</th>");
		out.println("<th>"+getTran(request,"ikirezi","present",sWebLanguage)+"</th>");
		out.println("<th>"+getTran(request,"ikirezi","absent",sWebLanguage)+"</th>");
		out.println("</tr>");
		i = sortedsignpowers.keySet().iterator();
		while(i.hasNext()){
			Double key=(Double)i.next();
			String sign=((String)signs.get(sortedsignpowers.get(key)));
			double c = Double.parseDouble(sign.split(";")[1]);
			double confirmingPower = 0;
			if(c>0){
				confirmingPower=Math.log10(c);
			}
			int confirmingcolor = new Double(255-confirmingPower*255/3).intValue();
			if(confirmingcolor<0){
				confirmingcolor=0;
			}
			else if(confirmingcolor>255){
				confirmingcolor=255;
			}
			double e = Double.parseDouble(sign.split(";")[2]);
			double excludingPower = 0;
			if(e>0){
				excludingPower=Math.log10(Double.parseDouble(sign.split(";")[2]));
			}
			int excludingcolor = new Double(255-excludingPower*255/3).intValue();
			if(excludingcolor<0){
				excludingcolor=0;
			}
			else if(excludingcolor>255){
				excludingcolor=255;
			}
			out.println("<tr>");
			out.println("<td class='admin' width='1px' id='check_"+sign.split(";")[3]+"'>"+(ikireziSymptoms.get(sign.split(";")[3])!=null?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_check.gif'/>":"")+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.uppercaseFirstLetter(sign.split(";")[0])+"</td>");
			out.println("<td nowrap style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><center><input type='radio' value='1' "+(ikireziSymptoms.get(sign.split(";")[3])!=null && (Integer)ikireziSymptoms.get(sign.split(";")[3])==1?"checked":"")+" name='r_"+sign.split(";")[3]+"' ondblclick='this.checked=false;registersymptom("+sign.split(";")[3]+",0)'' onclick='registersymptom("+sign.split(";")[3]+",1)'/></center></td>");
			out.println("<td nowrap style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><center><input type='radio' value='1' "+(ikireziSymptoms.get(sign.split(";")[3])!=null && (Integer)ikireziSymptoms.get(sign.split(";")[3])==-1?"checked":"")+" name='r_"+sign.split(";")[3]+"' ondblclick='this.checked=false;registersymptom("+sign.split(";")[3]+",0)'' onclick='registersymptom("+sign.split(";")[3]+",-1)'/></center></td>");
			out.println("</tr>");
		}
		out.println("</table>");

	}
	else if (checkString(request.getParameter("panorama")).length()>0){
		%>
		<form name='reloadForm' method='post'>
			<input type='hidden' name='hints' value='<%=checkString(request.getParameter("hints"))%>'/>
			<input type='hidden' name='panorama' value='<%=checkString(request.getParameter("panorama"))%>'/>
			<input type='hidden' name='complaint1a' value='<%=checkString(request.getParameter("complaint1a"))%>'/>
			<input type='hidden' name='complaint1b' value='<%=checkString(request.getParameter("complaint1b"))%>'/>
			<input type='hidden' name='diseaseProgress' value='<%=checkString(request.getParameter("diseaseProgress"))%>'/>
		</form>
	<%

		//Get base data from medical record
		Vector vSigns= new Vector();
		//1. First get person reference
		int age = activePatient.getAgeInMonths();
		if(age<12){
			vSigns.add("110");
		}
		else if(age<180){
			vSigns.add("98");
		}
		else if(activePatient.gender.toLowerCase().equalsIgnoreCase("m")){
			vSigns.add("136");
		}
		else{
			vSigns.add("81");
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"1");
		//2. Get type of encounter 
		vSigns.add(request.getParameter("diseaseProgress"));
		Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), request.getParameter("diseaseProgress"), "1",Integer.parseInt(activeUser.userid));
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"2");
		
		//3. Get main complaint
		if(checkString(request.getParameter("complaint1a")).length()>0){
			vSigns.add(((String)request.getParameter("complaint1a")).split("\\.")[0]);
			Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), ((String)request.getParameter("complaint1a")).split("\\.")[0], "1",Integer.parseInt(activeUser.userid));
		}
		else if(checkString(request.getParameter("complaint1b")).length()>0){
			vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
			Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), ((String)request.getParameter("complaint1b")).split("\\.")[0], "1",Integer.parseInt(activeUser.userid));
		}
		else{
			vSigns.add("0");
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"3");

		//4. Get secondary complaint
		if(checkString(request.getParameter("complaint1a")).length()==0){
			vSigns.add("0");
		}
		else if(checkString(request.getParameter("complaint1b")).length()==0){
			vSigns.add("0");
		}
		else{
			vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
			Ikirezi.storeSymptom(encounter==null?"":encounter.getUid(), ((String)request.getParameter("complaint1b")).split("\\.")[0], "1",Integer.parseInt(activeUser.userid));
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"4");

		String sAllSigns = "";
		for(int n=0;n<vSigns.size();n++){
			sAllSigns+=vSigns.elementAt(n)+";";
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"5");

		//Ikirezi interface
		//Make Ikirezi call
		SortedSet diseases = new TreeSet();
		Vector resp = new Vector();
		resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"5.0");
		if(resp.size()==0 && MedwanQuery.getInstance().getConfigInt("ikireziFallbackOnPrimarySymptom",1)==1 && !vSigns.elementAt(vSigns.size()-1).equals("0")){
			out.println("<script>alert('"+getTranNoLink("web","elementremoved",sWebLanguage)+": "+Ikirezi.getSymptomLabel(Integer.parseInt((String)vSigns.elementAt(vSigns.size()-1)), sWebLanguage).toUpperCase()+"');</script>");
			vSigns.remove(vSigns.size()-1);
			vSigns.add("0");
			resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"5.1");
		out.print("<script>");
		out.println(" var signs=[");
		for (int n=0;n<resp.size();n++){
			Vector v = (Vector)resp.elementAt(n);
			if(n>0){
				out.println(",");
			}
			out.print("'"+(v.elementAt(1)+";"+((String)v.elementAt(4)).replaceAll("%","--pct--").replaceAll("<","--lt--").replaceAll(">","--gt--")+";"+v.elementAt(5)+";"+v.elementAt(6)+";"+v.elementAt(2)).replaceAll("'","´")+"'");
			diseases.add((v.elementAt(1)+";"+v.elementAt(3)).replaceAll("'","´")+";"+be.openclinic.medical.Diagnosis.getGravity("icd10",(String)v.elementAt(8),100));
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"6");
		out.println("];");
		out.println(" var disease=[");
		Iterator i = diseases.iterator();
		int n=0;
		while(i.hasNext()){
			String d = (String)i.next();
			//Calculate diagnostic completeness
			double nConfirm=0,nExclude=0,nConfirmed=0,nExcluded=0,nTotal=0;
			for(int q=0;q<resp.size();q++){
				Vector v = (Vector)resp.elementAt(q);
				if(v.elementAt(1).equals(d.split(";")[0])){
					if(ikireziSymptoms.get(v.elementAt(2))!=null && (Integer)ikireziSymptoms.get(v.elementAt(2))==1){
						nConfirm+=Double.parseDouble((String)v.elementAt(5));
						nTotal+=Double.parseDouble((String)v.elementAt(5));
						nConfirmed+=Double.parseDouble((String)v.elementAt(5));
					}
					else if(ikireziSymptoms.get(v.elementAt(2))!=null && (Integer)ikireziSymptoms.get(v.elementAt(2))==-1){
						nExcluded+=Double.parseDouble((String)v.elementAt(6));
						nExclude+=Double.parseDouble((String)v.elementAt(6));
						nTotal+=Double.parseDouble((String)v.elementAt(6));
					}
					else{
						nConfirm+=Double.parseDouble((String)v.elementAt(5));
						nExclude+=Double.parseDouble((String)v.elementAt(6));
						nTotal+=(Double.parseDouble((String)v.elementAt(5))+Double.parseDouble((String)v.elementAt(6)))/2;
					}
				}
			}
			if(n>0){
				out.println(",");
			}
			out.print("'"+d+";"+Math.round(nConfirmed)+" / "+Math.round(nExcluded)+"<br>"+Math.round((nConfirmed+nExcluded)*100/(nTotal))+"% "+getTranNoLink("web","complete",sWebLanguage)+"'");
			n++;
		}
		out.println("];");
		out.println("</script>");
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"8");
	%>
	<input type='button' class='button' name='back' value='<%=getTranNoLink("web","back",sWebLanguage) %>' style='position: absolute;top: 1%;left: 42%' onclick='reloadForm.panorama.value="";reloadForm.submit();'/>
	<input type='button' class='button' name='refresh' value='<%=getTranNoLink("web","reload",sWebLanguage) %>' style='position: absolute;top: 1%;left: 50%' onclick='window.location.reload();'/>
	<canvas class='ikirezi' id="ikirezi" width="800" height="600"></canvas>
	<script>
		document.getElementById("ikirezi").height=window.innerHeight-20;
		document.getElementById("ikirezi").width=window.innerWidth-20;
		var POINTS = <%=diseases.size()%>;
		if(POINTS><%=MedwanQuery.getInstance().getConfigInt("maximumIkireziPanoramaDiagnoses",20)%>){
			POINTS=<%=MedwanQuery.getInstance().getConfigInt("maximumIkireziPanoramaDiagnoses",20)%>;
		}
		var radius = 200;
		var boxWidth=80/zoom;
		var boxHeight=80/zoom;
		var extraWidth=50*10/(POINTS);
		if(extraWidth>170){
			extraWidth=170;
		}
		var extraHeight=25*10/(POINTS);
		if(extraHeight>70){
			extraHeight=70;
		}
		var basewidth=document.getElementById('ikirezi').width;
		var baseheight=document.getElementById('ikirezi').height;
	    c = navigator.userAgent.search("Chrome");
	    f = navigator.userAgent.search("Firefox");
	    m8 = navigator.userAgent.search("MSIE 8.0");
	    m9 = navigator.userAgent.search("MSIE 9.0");
	    if(f>-1){
	    	//basewidth=document.getElementById('ikirezi').width*zoom;
	    }
	    else{
			//document.getElementById('ikirezi').width=document.getElementById('ikirezi').width/zoom;
	    }
		var _CENTERY=(baseheight)/2;
		var _CENTERX=(basewidth)/2+25*screen.width/1280;
		radius=_CENTERY-80*screen.height/720;
	
		function draw(){
			var canvas = document.getElementById('ikirezi');
			canvas.addEventListener('mousemove', function(event) {
				var canvas=document.getElementById('ikirezi');
				var ctx=canvas.getContext('2d');
		       	var bSelected=false;
			    for (i = 0; i < POINTS; i++) {
	  	    	   	var rectangle = new Path2D();
			       	var centerX=(_CENTERX -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS)*8/6);
			       	var centerY=_CENTERY -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       	if(centerX-(boxWidth+extraWidth)/2<20){
			    		centerX=(boxWidth+extraWidth)/2+20;
			       	}
			       	rectangle.rect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
		       		//First clear the rectangle
			       	ctx.strokeStyle='white';
			    	ctx.setLineDash([]);
			       	ctx.stroke(rectangle);
			       	if(ctx.isPointInPath(rectangle,event.clientX,event.clientY)){
			       		ctx.strokeStyle='red';
				    	ctx.setLineDash([2,3]);
				    	bSelected=true;
					}
			       	else{
			       		ctx.strokeStyle='black';
				    	ctx.setLineDash([]);
			       	}
			       	if(bSelected){
				    	canvas.style.cursor="hand";
			       	}
			       	else{
				    	canvas.style.cursor="default";
			       	}
		       		ctx.stroke(rectangle);
			    }
			});
			canvas.addEventListener('click', function(event) {
				var canvas=document.getElementById('ikirezi');
				var ctx=canvas.getContext('2d');
			    for (i = 0; i < POINTS; i++) {
	  	    	   	var rectangle = new Path2D();
			       	var centerX=(_CENTERX -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS)*8/6);
			       	var centerY=_CENTERY -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       	if(centerX-(boxWidth+extraWidth)/2<20){
			    		centerX=(boxWidth+extraWidth)/2+20;
			       	}
			       	rectangle.rect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
			       	if(ctx.isPointInPath(rectangle,event.clientX,event.clientY)){
			       		showPanoramaTips(disease[i].split(";")[0],disease[i].split(";")[1]);
					}
			    }
			});
			if (canvas.getContext) {
			    var ctx = canvas.getContext('2d');
				//1. We berekenen de verschillende punten die er moeten verbonden worden
			    // Add points to the polygon list
			    for (i = 0; i < POINTS; i++) {
			       var centerX=(_CENTERX -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS)*8/6);
			       var centerY=_CENTERY -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       if(centerX-(boxWidth+extraWidth)/2<20){
			    	   centerX=(boxWidth+extraWidth)/2+20;
			       }
			       //Fill rectangle with color corresponding to disease weight
			       var MAXWEIGHT=3
				   //var weight=disease[i].split(";")[2]*1;	
			       //var pro=disease[i].split(";")[3].split(" / ")[0]*1;
			       //if(pro>0){
			       //	   pro=Math.log10(pro);
			       //}
			       //var contra=disease[i].split(";")[3].split(" / ")[1].split("<br>")[0]*1;
			       //if(contra>0){
			       //	   contra=Math.log10(contra);
			       //}
			       //var weight=0.5+pro-contra;
			       //if(weight>MAXWEIGHT){
			       //	   weight=MAXWEIGHT;
			       //}
			       //else if(weight<0){
			       //	   weight=0;
			       //}
			       var weight=(disease[i].split(";")[3].split("<br>")[1].split(" ")[0].replace("%",""))*3/100;
			       ctx.fillStyle='rgb('+Math.floor(255-weight*255/3)+',255,'+Math.floor(255-weight*255/3)+')';
			       ctx.fillRect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
			       ctx.strokeRect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
		    	   ctx.fillStyle='black';
			       ctx.font='15px arial';
			       ctx.textBaseline='middle';
			       ctx.textAlign='center';
			       //ctx.boxedFillText(centerX,centerY+20,boxWidth+extraWidth-10,boxHeight+extraHeight,disease[i].split(";")[1]+"\n"+disease[i].split(";")[3].replace("<br>","\n")+"",true);
			       ctx.boxedFillText(centerX,centerY+20,boxWidth+extraWidth-10,boxHeight+extraHeight,disease[i].split(";")[1]+"\n"+disease[i].split(";")[3].split("<br>")[1]+"",true);
			    }
					
			}
		}

	    CanvasRenderingContext2D.prototype.textLines = function(x, y, w, h, text,
	            hard_wrap) {
	          var ctx = this;
	          var lines = Array();
	          var hard_lines = text.trim().split("\n");
	          hard_lines.forEach(function(hard_line) {
	            if(ctx.measureText(hard_line).width > w) {
	              var line = "";
	              var words = hard_line.split(" ");
	              words.forEach(function(word) {
	                var nline = line + word + " ";
	                if(ctx.measureText(nline).width > w) {
	                  lines.push(line);
	                  if(ctx.measureText(word).width > w && hard_wrap) {
	                    line = "";
	                    var chars = word.split("");
	                    chars.forEach(function(char) {
	                      var nline = line + char;
	                      if(ctx.measureText(nline).width > w) {
	                        lines.push(line);
	                        line = char;
	                      } else {
	                        line = nline;
	                      }
	                    });
	                    line += " ";
	                  } else {
	                    line = word + " ";
	                  }
	                } else {
	                  line = nline;
	                }
	              });
	              lines.push(line);
	            } else {
	              lines.push(hard_line);
	            }
	          });
	          return lines;
	        };
	        CanvasRenderingContext2D.prototype.boxedFillText = function(x, y, w, h, text,
	            hard_wrap) {
	          var ctx = this;
	          var lines = ctx.textLines(x, y, w, h, text, hard_wrap);
	          var lineHeight = parseInt(ctx.font.split("px")[0]) * 1.2;
	          var min_y = y;
	          var max_y = y + h;
	          var ll = lines.length - 1;
	          switch(ctx.textBaseline.toLowerCase()) {
	            case "bottom":
	              min_y = y - h + lineHeight;
	              max_y = y;
	              y -= ll * lineHeight;
	              if(y < min_y)
	                y = min_y;
	              break;
	            case "middle":
	              min_y = y - h / 2 + lineHeight / 2;
	              max_y = y + h / 2 - lineHeight / 2;
	              y -= (ll / 2) * lineHeight;
	              if(y < min_y)
	                y = min_y;
	              break;
	            default:
	              break;
	          }
	          console.log(ctx.textBaseline);
	          lines.forEach(function(line) {
	            if(y <= max_y) {
	              ctx.fillText(line, x, y);
	            }
	            y += lineHeight;
	          });
	        };
	
	        function showPanoramaTips(diseaseid,diseasename){
	        	//Concatenate the signs to show so they can be passed to the Modal box
	        	var s = "";
	        	for(n=0;n<signs.length;n++){
	        		if(signs[n].split(";")[0]==diseaseid){
	        			s=s+signs[n]+"$";
	        		}
	        	}
	    	    var url = "<c:url value="/ikirezi/showPanoramaTips.jsp"/>?encounteruid=<%=encounter==null?"":encounter.getUid()%>&signs="+encodeURI(s)+"&id="+diseaseid+"&disease="+diseasename+"&ts="+new Date().getTime();
	    	    Modalbox.show(url,{title:'<%=getTranNoLink("ikirezi","panorama",sWebLanguage)%>',width:400, height:500, beforeHide:function(){if(bChanged){window.location.reload()}}});
	   	  	}
	
	        window.setTimeout('draw();',500);
	</script>
<%
Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"10");
	}
		}
		catch(Exception e){
			e.printStackTrace();
		}
%>
<script>
	function showSDT(id){
		window.open("<c:url value='/popup.jsp?Page=ikirezi/showSDT.jsp'/>&id="+id+"&ts=<%=getTs()%>","SDT","toolbar=no,status=yes,scrollbars=yes,resizable=no,width=600,height=200,menubar=no").moveTo((screen.width - 500) / 2, (screen.height - 200) / 2);
	}
	
	function registersymptom(symptom,value){
	    var url = "<c:url value='/ikirezi/storeSymptom.jsp'/>";
	    var sParams=	"symptom="+symptom+
	    				"&value="+value+
	    				"&encounteruid=<%=encounter==null?"":encounter.getUid()%>";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: sParams,
	      onSuccess: function(resp){
	    	  bChanged=true;
	    	  if(value=='0'){
	    		  document.getElementById("check_"+symptom).innerHTML="";
	    	  }
	    	  else{
	    		  document.getElementById("check_"+symptom).innerHTML="<img src='<%=sCONTEXTPATH%>/_img/icons/icon_check.gif'/>";
	    	  }
	      },
	    });
	}
	
	document.getElementById('ikirezi').focus();
</script>
</body>