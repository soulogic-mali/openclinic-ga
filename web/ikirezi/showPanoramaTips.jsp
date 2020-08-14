<%@page import="org.jfree.ui.LengthAdjustmentType"%>
<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<script>
	bChanged=false;
</script>
<%
	String id = checkString(request.getParameter("id"));
	String disease = checkString(request.getParameter("disease"));
	String encounteruid = checkString(request.getParameter("encounteruid"));
	String diseasetitle=disease.toUpperCase();
	
	String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "/sdt.xml";
	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new URL(sDoc));
	Element root = document.getRootElement();
	Iterator sdts = root.elementIterator("treatment");
	while(sdts.hasNext()){
		Element sdt = (Element)sdts.next();
		if(sdt.attributeValue("id").equalsIgnoreCase(id)){
			diseasetitle+="&nbsp;&nbsp;&nbsp;<a href='javascript:showSDT("+id+")'><img src='"+sCONTEXTPATH+"/_img/shortcutIcons/icon_pill1.png'/></a>";
			break;
		}
	}

%>

<table width='100%'>
	<tr class='admin'>
		<td colspan='4'><center><%=diseasetitle %></center></td>
	</tr>
	<tr>
		<th class='admin' colspan='2'><%=getTran(request,"web","finding",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"ikirezi","present",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"ikirezi","absent",sWebLanguage) %></th>
	</tr>
<%
	Hashtable ikireziSymptoms = new Hashtable();
	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	if(encounteruid.length()>0){
		encounter=Encounter.get(encounteruid);
	}
	if(encounter !=null){
		ikireziSymptoms = encounter.getIkireziSymptoms();
	}
	String[] signs = checkString(request.getParameter("signs")).split("\\$");
	for(int n=0;n<signs.length;n++){
		String[] fields = signs[n].split(";");
		double confirmingPower = Math.log10(Double.parseDouble(fields[2]));
		int confirmingcolor = new Double(255-confirmingPower*255/3).intValue();
		if(confirmingcolor<0){
			confirmingcolor=0;
		}
		double excludingPower = Math.log10(Double.parseDouble(fields[3]));
		int excludingcolor = new Double(255-excludingPower*255/3).intValue();
		if(excludingcolor<0){
			excludingcolor=0;
		}
		out.println("<tr>");
		out.println("<td class='admin' width='1px' id='check_"+fields[4]+"'>"+(ikireziSymptoms.get(fields[4])!=null?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_check.gif'/>":"")+"</td>");
		out.println("<td class='admin'>"+ScreenHelper.uppercaseFirstLetter(fields[1].replaceAll("--pct--","%").replaceAll("--lt--","<").replaceAll("--gt--",">"))+"</td>");
		//out.println("<td nowrap style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><input type='radio' value='1' "+(ikireziSymptoms.get(fields[4])!=null && (Integer)ikireziSymptoms.get(fields[4])==1?"checked":"")+" name='r_"+fields[4]+"' ondblclick='this.checked=false;registersymptom("+fields[4]+",0)'' onclick='registersymptom("+fields[4]+",1)'/> <b>"+new DecimalFormat("#0.0").format(confirmingPower)+"</b></td>");
		//out.println("<td nowrap style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><input type='radio' value='-1' "+(ikireziSymptoms.get(fields[4])!=null && (Integer)ikireziSymptoms.get(fields[4])==-1?"checked":"")+" name='r_"+fields[4]+"' ondblclick='this.checked=false;registersymptom("+fields[4]+",0)'' onclick='registersymptom("+fields[4]+",-1)'/> <b>"+new DecimalFormat("#0.0").format(excludingPower)+"</b></td>");
		out.println("<td nowrap style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><center><input type='radio' value='1' "+(ikireziSymptoms.get(fields[4])!=null && (Integer)ikireziSymptoms.get(fields[4])==1?"checked":"")+" name='r_"+fields[4]+"' ondblclick='this.checked=false;registersymptom("+fields[4]+",0)'' onclick='registersymptom("+fields[4]+",1)'/></center></td>");
		out.println("<td nowrap style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><center><input type='radio' value='-1' "+(ikireziSymptoms.get(fields[4])!=null && (Integer)ikireziSymptoms.get(fields[4])==-1?"checked":"")+" name='r_"+fields[4]+"' ondblclick='this.checked=false;registersymptom("+fields[4]+",0)'' onclick='registersymptom("+fields[4]+",-1)'/></center></td>");
		out.println("</tr>");
	}
%>
</table>

