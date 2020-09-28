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
	
	Vector vSigns= new Vector();
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
	vSigns.add(diseaseprogress);
	if(checkString(request.getParameter("complaint1a")).length()>0){
		vSigns.add(((String)request.getParameter("complaint1a")).split("\\.")[0]);
	}
	if(checkString(request.getParameter("complaint1b")).length()>0){
		vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
	}
	//Ikirezi interface
	//Make Ikirezi call
	HashSet diseases = new HashSet();
	Vector resp = new Vector();
	resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
	if(resp.size()==0 && MedwanQuery.getInstance().getConfigInt("ikireziFallbackOnPrimarySymptom",1)==1 && !vSigns.elementAt(vSigns.size()-1).equals("0")){
		out.println("<script>alert('"+getTranNoLink("web","elementremoved",sWebLanguage)+": "+Ikirezi.getSymptomLabel(Integer.parseInt((String)vSigns.elementAt(vSigns.size()-1)), sWebLanguage).toUpperCase()+"');</script>");
		vSigns.remove(vSigns.size()-1);
		vSigns.add("0");
		resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
	}
	Vector diagnosiscodes = new Vector();
	Vector symptomcodes=new Vector();
	for (int n=0;n<resp.size();n++){
		Vector v = (Vector)resp.elementAt(n);
		if(!diagnosiscodes.contains(v.elementAt(1)+";"+v.elementAt(3))){
			diagnosiscodes.add(v.elementAt(1)+";"+v.elementAt(3));
		}
		if(request.getParameter("selectdisease")!=null && ((String)v.elementAt(1)).equalsIgnoreCase(request.getParameter("selectdisease"))){
			symptomcodes.add(v.elementAt(2)+";"+((String)v.elementAt(4)).replaceAll("%","--pct--").replaceAll("<","--lt--").replaceAll(">","--gt--")+";"+v.elementAt(5)+";"+v.elementAt(6));
		}
	}

%>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='age' value='<%=age %>'/>
			<input type='hidden' name='gender' value='<%=gender %>'/>
			<input type='hidden' name='diseaseProgress' value='<%=diseaseprogress %>'/>
			<input type='hidden' name='complaint1a' value='<%=checkString(request.getParameter("complaint1a")) %>'/>
			<input type='hidden' name='complaint1b' value='<%=checkString(request.getParameter("complaint1b")) %>'/>
			<input type='hidden' name='selectdisease' id='selectdisease' value=''/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="transactionForm.action='ikirezi.jsp';transactionForm.submit();" src='<%=sCONTEXTPATH%>/_img/icons/mobile/ikirezi.png'/>
						<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"ikirezi","panorama",sWebLanguage) %></td>
				</tr>
				<%
					if(checkString(request.getParameter("selectdisease")).length()==0){
						Iterator idc = diagnosiscodes.iterator();
						while(idc.hasNext()){
							String disease = (String)idc.next();
							out.println("<tr><td colspan='2' class='admin2' style='font-size:5vw;font-weight: bolder'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/info.png' onclick='document.getElementById(\"selectdisease\").value=\""+disease.split(";")[0]+"\";transactionForm.submit();'/>&nbsp;"+disease.split(";")[1]+"</td></tr>");
						}
					}
					else{
						%>
						<tr>
							<td colspan='2' class='admin2' style='text-align: center'><img onclick="document.getElementById('selectdisease').value='';transactionForm.submit();" src='<%=sCONTEXTPATH%>/_img/icons/mobile/back.png'/></td>
						</tr>
						<tr class='admin'>
							<td style='font-size:5vw;'><%=getTran(request,"web","sign",sWebLanguage) %></td>
							<td><table width='100%'><tr><td width='50%' style='font-size:6vw;text-align: center'>+</td><td style='font-size:6vw;text-align: center' width='50%'>-</td></tr></table></td>
						</tr>
						<%
						Iterator idc = symptomcodes.iterator();
						while(idc.hasNext()){
							String symptom = (String)idc.next();
							double confirmingPower = Math.log10(Double.parseDouble(symptom.split(";")[2]));
							int confirmingcolor = new Double(255-confirmingPower*255/3).intValue();
							if(confirmingcolor<0){
								confirmingcolor=0;
							}
							double excludingPower = Math.log10(Double.parseDouble(symptom.split(";")[3]));
							int excludingcolor = new Double(255-excludingPower*255/3).intValue();
							if(excludingcolor<0){
								excludingcolor=0;
							}
							out.println("<tr><td class='admin2' style='font-size:5vw;font-weight: bolder'>"+ScreenHelper.capitalize(symptom.split(";")[1])+"</td>");
							out.println("<td class='admin2'><table cellpadding='0' cellspacing='0' width='100%' height='100%'><td width='50%' style='font-size:5vw;font-weight: bolder;background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");color: "+(confirmingcolor<122?"white":"black")+";text-align: center'>"+new Double(confirmingPower*100).intValue()+"</td><td width='50%' class='admin2' style='font-size:5vw;font-weight: bolder;background-color: rgb(255,"+excludingcolor+","+excludingcolor+");color: "+(excludingcolor<122?"white":"black")+";text-align: center'>"+new Double(excludingPower*100).intValue()+"</td></table></td>");
							out.println("</tr>");
						}
					}
				%>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>