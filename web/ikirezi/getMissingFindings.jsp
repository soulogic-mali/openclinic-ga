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
	String nrz = checkString(request.getParameter("nrz"));
	String diseasetitle = Ikirezi.getDiagnosisLabel(nrz, sWebLanguage).toUpperCase();
	if(nrz.equals("-1")){
		diseasetitle=getTran(request,"web","alldiagnoses",sWebLanguage);
	}
	else{
		diseasetitle=diseasetitle.toUpperCase();
		
		String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "/sdt.xml";
		SAXReader reader = new SAXReader(false);
		Document document = reader.read(new URL(sDoc));
		Element root = document.getRootElement();
		Iterator sdts = root.elementIterator("treatment");
		while(sdts.hasNext()){
			Element sdt = (Element)sdts.next();
			if(sdt.attributeValue("id").equalsIgnoreCase(nrz)){
				diseasetitle+="&nbsp;&nbsp;&nbsp;<a href='javascript:showSDT("+nrz+")'><img src='"+sCONTEXTPATH+"/_img/shortcutIcons/icon_pill1.png'/></a>";
				break;
			}
		}
	}
%>

<table width='100%'>
	<tr>
		<td colspan='4'><center><font style='font-size: 12px; color: red'><%=getTran(request,"ikirezi","missingfindingswarning",sWebLanguage) %></font></center></td>
	</tr>
	<tr class='admin'>
		<td colspan='4'><center><%=diseasetitle %></center></td>
	</tr>
	<tr>
		<th class='admin'><%=getTran(request,"web","finding",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"ikirezi","present",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"ikirezi","absent",sWebLanguage) %></th>
	</tr>
<%
	Vector ikireziSymptoms = new Vector();
	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	if(encounter !=null){
		if(nrz.equals("-1")){
			ikireziSymptoms = ocspring2.OCProb.getListData(session.getId(), sWebLanguage);
		}
		else{
			ikireziSymptoms = ocspring2.OCProb.getListData(session.getId(), sWebLanguage,nrz);
		}
	}
	for(int n=0;n<ikireziSymptoms.size();n++){
		Vector sign = (Vector)ikireziSymptoms.elementAt(n);
		String signid = (String)sign.elementAt(4);
		String signName=(String)sign.elementAt(5);
		double confirmingPower = Math.log10(Double.parseDouble((String)sign.elementAt(7)));
		int confirmingcolor = new Double(255-confirmingPower*255/3).intValue();
		if(confirmingcolor<0){
			confirmingcolor=0;
		}
		double excludingPower = Math.log10(Double.parseDouble((String)sign.elementAt(8)));
		int excludingcolor = new Double(255-excludingPower*255/3).intValue();
		if(excludingcolor<0){
			excludingcolor=0;
		}
		out.println("<tr>");
		out.println("<td class='admin'>"+ScreenHelper.uppercaseFirstLetter(signName.replaceAll("--pct--","%").replaceAll("--lt--","<").replaceAll("--gt--",">"))+"</td>");
		out.println("<td nowrap style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><center><input type='radio' value='1' name='r_"+signid+"' ondblclick='this.checked=false;registersymptom("+signid+",0)'' onclick='registersymptom("+signid+",1)'/></center></td>");
		out.println("<td nowrap style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><center><input type='radio' value='-1' name='r_"+signid+"' ondblclick='this.checked=false;registersymptom("+signid+",0)'' onclick='registersymptom("+signid+",-1)'/></center></td>");
		out.println("</tr>");
	}
%>
</table>


