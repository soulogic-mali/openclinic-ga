<%@page import="be.openclinic.assets.Asset"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="be.openclinic.system.FormFile"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	String getSampleValue(String header, String firstline, String fieldname, String sWebLanguage){
		String[] headerfields = header.replaceAll("\\\r","").split(";");
		String[] firstlinefields = firstline.replaceAll("\\\r","").split(";");
		for(int n=0;n<headerfields.length;n++){
			if(headerfields[n].equalsIgnoreCase(fieldname)){
				return "<b>"+getTranNoLink("web","yes",sWebLanguage)+"</b></td><td><i>["+(firstlinefields.length>n?firstlinefields[n]:"")+"]</i>";
			}
		}
		return "<b>"+getTranNoLink("web","no",sWebLanguage)+"</b>";
	}

	String getValue(String header, String line, String fieldname){
		String[] headerfields = header.replaceAll("\\\r","").split(";");
		String[] linefields = line.replaceAll("\\\r","").split(";");
		for(int n=0;n<headerfields.length;n++){
			if(headerfields[n].equalsIgnoreCase(fieldname)){
				return linefields.length>n?linefields[n]:"";
			}
		}
		return "";
	}
%>
<%
	Hashtable params = SH.getMultipartFormParameters(request);
%>
<form name='transactionForm' method='post' enctype="multipart/form-data">
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","importassetinventory",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","inventoryfile",sWebLanguage) %></td>
			<td class='admin'>
				<input class='button' type='file' name='inventoryfile' size='30'/>
				<input class='button' type='submit' name='analyzeButton' value='<%=getTranNoLink("web","analyze",sWebLanguage)%>'/>
				<input class='button' type='submit' name='importButton' value='<%=getTranNoLink("web","import",sWebLanguage)%>'/>
			</td>
		</tr>
	</table>
<%
	if(params.get("analyzeButton")!=null){
		FormFile file = (FormFile)params.get("inventoryfile");
		if(file!=null && file.getDocument()!=null && file.getDocument().length>0){
			out.println("<p/><table>");
			out.println("<tr><td>"+getTran(request,"web","filename",sWebLanguage)+":</td><td><b>"+file.getFilename()+"</b></td></tr>");
			out.println("<tr><td>"+getTran(request,"web","size",sWebLanguage)+":</td><td><b>"+file.getDocument().length+"</b></td></tr>");
			out.println("<tr><td>"+getTran(request,"web","lines",sWebLanguage)+":</td><td><b>"+StringUtils.countMatches(new String(file.getDocument()),"\n")+"</b></td></tr>");
			out.println("</table>");
			out.println("<h1><u>"+getTran(request,"web","headeranalysis",sWebLanguage)+"</u></h1>");
			out.println("<p/><table>");
			String[] lines = new String(file.getDocument()).split("\\\n");
			String firstline="";
			if(lines.length>0){
				firstline= lines[1];
			}
			out.println("<tr><td><b>UID </b>( -> OC_ASSET_COMMENT20):</td><td>"+getSampleValue(lines[0],firstline,"UID",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>DESCRIPTION </b>( -> OC_ASSET_DESCRIPTION):</td><td>"+getSampleValue(lines[0],firstline,"DESCRIPTION",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>LOCATION </b>( -> OC_ASSET_SERVICE):</td><td>"+getSampleValue(lines[0],firstline,"LOCATION",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>NOMENCLATURE </b>( -> OC_ASSET_NOMENCLATURE):</td><td>"+getSampleValue(lines[0],firstline,"NOMENCLATURE",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>BRAND </b>( -> OC_ASSET_COMMENT2):</td><td>"+getSampleValue(lines[0],firstline,"BRAND",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>MODEL </b>( -> OC_ASSET_COMMENT10):</td><td>"+getSampleValue(lines[0],firstline,"MODEL",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>SERIALNUMBER </b>( -> OC_ASSET_SERIAL):</td><td>"+getSampleValue(lines[0],firstline,"SERIALNUMBER",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>STATUS </b>( -> OC_ASSET_COMMENT7):<li>1 = Functional and in use<li>2 = Functional and not in use<li>3 = Not functional<li>4 = Maintenance required</td><td>"+getSampleValue(lines[0],firstline,"STATUS",sWebLanguage)+"</td></tr>");
			out.println("<tr><td><b>DETAILS </b>( -> OC_ASSET_COMMENT8):</td><td>"+getSampleValue(lines[0],firstline,"DETAILS",sWebLanguage)+"</td></tr>");
			out.println("</table>");
		}
		else{
			out.println("<p/><h1>"+getTran(request,"web","nofileselected",sWebLanguage)+"</h1>");
		}
	}
	else if(params.get("importButton")!=null){
		FormFile file = (FormFile)params.get("inventoryfile");
		if(file!=null && file.getDocument()!=null && file.getDocument().length>0){
			String[] lines = new String(file.getDocument()).split("\\\n");
			int created=0,updated=0,failure=0;
			for(int n=1;n<lines.length;n++){
				try{
					boolean bCreated=false;
					Asset asset =null;
					//First find out if the asset already exists
					String uid = getValue(lines[0],lines[n],"UID");
					if(uid.length()==0){
						uid=(n+lines[n]).hashCode()+"."+n;
					}
					if(uid.length()>0){
						//Try to find the asset based on the UID
						asset = Asset.getAssetByFieldValue("oc_asset_comment20", uid);
					}
					if(asset==null){
						asset=new Asset();
						asset.setUid("-1");
						bCreated=true;
					}
					//Then fill the asset fields
					asset.setDescription(getValue(lines[0],lines[n],"DESCRIPTION"));
					asset.setServiceuid(getValue(lines[0],lines[n],"LOCATION"));
					asset.setNomenclature(getValue(lines[0],lines[n],"NOMENCLATURE"));
					asset.setComment2(getValue(lines[0],lines[n],"BRAND"));
					asset.setComment10(getValue(lines[0],lines[n],"MODEL"));
					asset.setSerialnumber(getValue(lines[0],lines[n],"SERIALNUMBER"));
					asset.setComment7(getValue(lines[0],lines[n],"STATUS"));
					asset.setComment8(getValue(lines[0],lines[n],"DETAILS"));
					asset.setComment20(uid);
					asset.store(activeUser.userid);
					if(bCreated){
						created++;
					}
					else{
						updated++;
					}
				}
				catch(Exception e){
					failure++;
				}
			}
			out.println("<p/><h1>"+created+" "+getTran(request,"web","recordscreated",sWebLanguage)+", "+updated+" "+getTran(request,"web","recordsupdated",sWebLanguage)+", "+failure+" "+getTran(request,"web","failed",sWebLanguage)+"</h1>");
		}
		else{
			out.println("<p/><h1>"+getTran(request,"web","nofileselected",sWebLanguage)+"</h1>");
		}
	}
%>
</form>
