<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="javazoom.upload.*,java.io.*,org.apache.poi.xssf.usermodel.*,org.apache.poi.ss.usermodel.*,org.apache.poi.hssf.usermodel.*,be.openclinic.assets.*"%>

<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="storemodel" value="<%=UploadBean.MEMORYSTORE %>" />
</jsp:useBean>
<%
	boolean bVerify=false;
	boolean bLoad = false;
	int rownr=0,created=0,updated=0,refused=0;

	StringBuffer sResult = new StringBuffer();
	sResult.append("<table border='1'>");
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
	    // Uses MultipartFormDataRequest to parse the HTTP request.
	    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	    if (mrequest !=null) {
	        Hashtable files = mrequest.getFiles();
	        if ( (files != null) && (!files.isEmpty()) ) {
		       	UploadFile file = (UploadFile)files.get("filename");
		       	if(file!=null && file.getFileName()!=null){
		       		bVerify=mrequest.getParameter("action").equalsIgnoreCase("validate");
		       		bLoad=mrequest.getParameter("action").equalsIgnoreCase("submit");
       				Connection conn = SH.getOpenClinicConnection();
		       		String fullFileName = MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/"+file.getFileName();
					new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")).mkdirs();
	                upBean.setFolderstore(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp"));
	                upBean.setParsertmpdir(application.getRealPath("/")+"/"+MedwanQuery.getInstance().getConfigString("tempdir","/tmp/"));
	                upBean.store(mrequest, "filename");
		       		File excelFile = new File(fullFileName);
		       		FileInputStream fis = new FileInputStream(excelFile); 
		       		XSSFWorkbook wb = new XSSFWorkbook(fis); 
		       		XSSFSheet sheet = wb.getSheetAt(0); 
		       		Iterator<Row> itr = sheet.iterator();  
		       		Hashtable<Integer,String> colHeaders = new Hashtable();
		       		while(itr.hasNext()){
       					if(bVerify){
			       			sResult.append("<tr>");
       					}
       					StringBuffer cellString = new StringBuffer();
		       			Asset asset = new Asset();
		       			asset.setUid("-1");
		       			Row row = itr.next();
		       			Iterator<Cell> cellIterator = row.cellIterator();
	       				if(rownr==0){
	       					int celnr=0;
	       					if(bVerify){
	       						sResult.append("<td class='admin'>UID</td>");
	       					}
			       			while (cellIterator.hasNext()){
			       				String cellValue="";
			       				Cell cell = cellIterator.next();
			       				System.out.println("COL: "+cell.getColumnIndex());
			       				if(cell.getCellType()==Cell.CELL_TYPE_STRING){
					       			cellValue=cell.getStringCellValue();
			       				}
			       				else if(cell.getCellType()==Cell.CELL_TYPE_NUMERIC){
					       			if(HSSFDateUtil.isCellDateFormatted(cell)){
					       				cellValue=SH.formatDate(cell.getDateCellValue());
					       			}
					       			else{
						       			cellValue=cell.getNumericCellValue()+"";
					       			}
			       				}
			       				if(rownr==0){
			       					colHeaders.put(celnr,cellValue);
			       					if(bVerify){
			       						sResult.append("<td class='admin'>"+cellValue+"</td>");
			       					}
			       				}
			       				celnr++;
			       			}
	       				}
	       				else {
	       					for (int celnr=0;celnr<colHeaders.size();celnr++){
		       					String cellValue="";
		       					Cell cell = row.getCell(celnr, Row.CREATE_NULL_AS_BLANK);
			       				if(cell.getCellType()==Cell.CELL_TYPE_STRING){
					       			cellValue=cell.getStringCellValue();
			       				}
			       				else if(cell.getCellType()==Cell.CELL_TYPE_NUMERIC){
					       			if(HSSFDateUtil.isCellDateFormatted(cell)){
					       				cellValue=SH.formatDate(cell.getDateCellValue());
					       			}
					       			else{
						       			cellValue=cell.getNumericCellValue()+"";
					       			}
			       				}
			       				if(cellValue.length()>0){
			       					//Set value for new object
			       					if(colHeaders.get(celnr).equalsIgnoreCase("CODE")){
			       						asset.setCode(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("TYPE")){
			       						asset.setAssetType(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DESCRIPTION")){
			       						asset.setDescription(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("NOMENCLATURE")){
			       						asset.setNomenclature(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("RECEPTIONNE_PAR")){
			       						asset.setReceiptBy(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("NUMERO_SERIE")){
			       						asset.setSerialnumber(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("CODE_SERVICE")){
			       						asset.setServiceuid(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("QUANTITE")){
			       						asset.setQuantity(Double.parseDouble(cellValue));
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("PRIX_ACHAT")){
			       						asset.setPurchasePrice(Double.parseDouble(cellValue));
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DATE_ACHAT")){
			       						asset.setPurchaseDate(SH.parseDate(cellValue));
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("CHARACTERISTIQUES")){
			       						asset.setCharacteristics(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("NORMECE")){
			       						asset.setComment1(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("MARQUE")){
			       						asset.setComment2(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("AUTRENORME")){
			       						asset.setComment3(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("VOLTAGE")){
			       						asset.setComment4(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("INTENSITE")){
			       						asset.setComment5(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("SOURCE_FINANCEMENT")){
			       						asset.setComment6(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("ETAT_FONCTIONNEL")){
			       						asset.setComment7(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DETAIL")){
			       						asset.setComment8(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("ETAT")){
			       						asset.setComment9(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("MODELE")){
			       						asset.setComment10(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DATE_PRODUCTION")){
			       						asset.setComment11(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DATE_LIVRAISON")){
			       						asset.setComment12(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DATE_MISE_EN_SERVICE")){
			       						asset.setComment13(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("DATE_FIN_GARANTIE")){
			       						asset.setComment14(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("UNITE_INTENSITE")){
			       						asset.setComment16(cellValue);
			       					}
			       					else if(colHeaders.get(celnr).equalsIgnoreCase("SURFACE")){
			       						asset.setComment17(cellValue);
			       					}
			       					if(bVerify){
			       						cellString.append("<td nowrap>"+cellValue+"</td>");
			       					}
			       				}
			       				else{
			       					if(bVerify){
			       						cellString.append("<td class='adminred'>&nbsp;</td>");
			       					}
			       				}
			       				System.out.println("Cell value:"+cellValue);
	       					}
		       			}
		       			if(rownr>0){
			       			if(SH.c(asset.getCode()).length()==0){
			       				System.out.println("ERROR! row "+rownr+": asset code missing");
			       				refused++;
			       			}
			       			else if(SH.c(asset.getDescription()).length()==0){
			       				System.out.println("ERROR! row "+rownr+": asset description missing");
			       				refused++;
			       			}
			       			else if(SH.c(asset.getNomenclature()).length()==0){
			       				System.out.println("ERROR! row "+rownr+": asset nomenclature missing");
			       				refused++;
			       			}
			       			else if(SH.c(asset.getServiceuid()).length()==0){
			       				System.out.println("ERROR! row "+rownr+": asset service code missing");
			       				refused++;
			       			}
			       			else{
			       				PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_code=? and oc_asset_service=? and oc_asset_description=?");
			       				ps.setString(1,asset.getCode());
			       				ps.setString(2,asset.getServiceuid());
			       				ps.setString(3,asset.getDescription());
			       				ResultSet rs = ps.executeQuery();
			       				if(rs.next()){
			       					asset.setUid(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"));
			       					if(bVerify){
			       						sResult.append("<td class='adminred'>"+asset.getUid()+"</td>");
			       					}
		       						updated++;
			       				}
			       				else{
			       					if(bVerify){
			       						sResult.append("<td>&nbsp;</td>");
			       					}
		       						created++;
			       				}
			       				rs.close();
			       				ps.close();

		       					if(bVerify){
		       						sResult.append(cellString);
		       					}
		       					else{
				       				asset.store(activeUser.userid);
		       					}
			       			}
		       			}
       					if(bVerify){
			       			sResult.append("</tr>");
       					}
		       			rownr++;
		       		}
		       		fis.close();
		       		excelFile.delete();
			       	conn.close();
		       	}
	        }
	    }
	}
	sResult.append("</table>");
%>
<form name='transactionForm' id='transactionForm' method='post' enctype="multipart/form-data">
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='4'><%=getTran(request,"web","upload.excel.file",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","excelfile",sWebLanguage) %></td>
			<td class='admin2' width='1%' nowrap><input type='file' accept=".xlsx" size='60' name='filename' id='filename' value=''/></td>
			<td class='admin2'>
				<input type='button' name='verifyButton' onclick='doValidate();' value='<%=getTranNoLink("web","verify",sWebLanguage)%>'/>
				<input type='button' name='submitButton' onclick='doSubmit();' value='<%=getTranNoLink("web","send",sWebLanguage)%>'/>	
			</td>
		</tr>
	</table>
</form>
<script>
	function doSubmit(){
		if(document.getElementById("filename").value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
			document.getElementById("filename").focus();
		}
		else{
			document.getElementById("action").value='submit';
			transactionForm.submit();
		}
	}
	function doValidate(){
		if(document.getElementById("filename").value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
			document.getElementById("filename").focus();
		}
		else{
			document.getElementById("action").value='validate';
			transactionForm.submit();
		}
	}
</script>
<%
	if(bVerify || bLoad){
		%>
		<table cellpadding='5'>
			<tr>
				<td class='admin'><%=getTran(request,"web","updates",sWebLanguage) %>:&nbsp;</td><td class='admin2'><%=updated %>&nbsp;</td>
				<td class='admin'><%=getTran(request,"web","creates",sWebLanguage) %>:&nbsp;</td><td class='admin2'><%=created %>&nbsp;</td>
				<td class='admin'><%=getTran(request,"web","refusals",sWebLanguage) %>:&nbsp;</td><td class='admin2'><%=refused %>&nbsp;</td>
			</tr>
		</table>
		<%
	}
	if(bVerify){
		out.println("<hr/>");
		out.println(sResult.toString());
	}
%>