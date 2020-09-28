<%@page import="be.openclinic.knowledge.*"%>
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
<title><%=getTran(request,"web","ikirezi",sWebLanguage) %></title>
<%
	String gender=checkString(request.getParameter("gender"));	
	if(gender.length()==0){
		gender="m";
	}
	int age=240;
	try{
		age=Integer.parseInt(checkString(request.getParameter("age")));
	}
	catch(Exception e){}
	String diseaseprogress=checkString(request.getParameter("diseaseProgress"));
	if(diseaseprogress.length()==0){
		diseaseprogress="542";
	}
%>
<html>
	<body>
		<form name='transactionForm' method='post' action='panorama.jsp'>
			<table width='100%'>
				<tr>
					<td style='font-size:8vw;text-align: left'></td>
					<td style='font-size:8vw;text-align: right'>
						<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","ikirezi",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='mobileadmin' style='font-size:6vw;' colspan='2'>
						<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/ikirezi.png' onclick='transactionForm.submit();'/>
					</td>
				</tr>
				<tr>
					<td class='admin' style='font-size:5vw;'><%= getTran(request,"web","age",sWebLanguage)%></td>
					<td class='admin2' style='font-size:5vw;'>
						<select style='font-size:5vw;' name='age'>
							<option style='font-size:5vw;' value='1' <%=age==1?"selected":""%>><12m</option>
							<option style='font-size:5vw;' value='24' <%=age==24?"selected":""%>>12m-60m</option>
							<option style='font-size:5vw;' value='120' <%=age==120?"selected":""%>>5-15y</option>
							<option style='font-size:5vw;' value='240' <%=age==240?"selected":""%>>>15y</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='admin' style='font-size:5vw;'><%= getTran(request,"web","gender",sWebLanguage)%></td>
					<td class='admin2' style='font-size:5vw;'>
						<select style='font-size:5vw;' name='gender'>
							<option style='font-size:5vw;' value='m' <%=gender.equals("m")?"selected":""%>>M</option>
							<option style='font-size:5vw;' value='f' <%=gender.equals("f")?"selected":""%>>F</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='admin' style='font-size:5vw;'><%= getTran(request,"ikirezi","disease.progress",sWebLanguage)%></td>
					<td class='admin2' style='font-size:5vw;'>
						<select style='font-size:5vw;width: 200px;' name='diseaseProgress' id='diseaseProgress'>
							<%=ScreenHelper.writeSelect(request, "disease.progress", diseaseprogress, sWebLanguage) %>
						</select>
					</td>
				</tr>
				<tr>
					<td class='admin' style='font-size:5vw;'><%= getTran(request,"ikirezi","firstcomplaint",sWebLanguage)%></td>
					<td class='admin2'>
						<select  style='font-size:5vw;width: 200px;' name='complaint1a' id='complaint1a' onchange='validateselects();'>
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
								if(age<12){
									vSigns.add("110");
								}
								else if(age<180){
									vSigns.add("98");
								}
								else if(gender.toLowerCase().equalsIgnoreCase("m")){
									vSigns.add("136");
								}
								else{
									vSigns.add("81");
								}
								//2. Get type of encounter 
								vSigns.add(diseaseprogress);
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
	
								//Load all selected startup signs that are available in Ikirezi
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
									out.println("<option "+(finding.split(";")[1].equalsIgnoreCase(checkString(request.getParameter("complaint1a")))?"selected":"")+" style='font-style:italic;font-size: 5vw;' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"'>"+finding.split(";")[0]+"</option>");
								}
							
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='admin' style='font-size:5vw;'><%= getTran(request,"ikirezi","secondcomplaint",sWebLanguage)%></td>
					<td class='admin2'>
						<select  style='font-size:5vw;width: 200px;' name='complaint1b' id='complaint1b' onchange='validateselects();'>
							<option/>
							<%
								//Load all selected startup signs that are available in Ikirezi
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
									out.println("<option "+(finding.split(";")[1].equalsIgnoreCase(checkString(request.getParameter("complaint1b")))?"selected":"")+" style='font-style:italic;font-size: 5vw;' value='"+finding.split(";")[1]+"."+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"'>"+finding.split(";")[0]+"</option>");
								}
							
							%>
						</select>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>