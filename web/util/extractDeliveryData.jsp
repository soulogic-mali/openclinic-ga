<%@page import="org.apache.poi.ss.usermodel.*,org.apache.poi.ss.util.*,org.apache.poi.xssf.usermodel.*"%>
<%@include file="/includes/helper.jsp"%>
<%!
	private void setCellValue(int nCol, Row row, String sValue){
		Cell cell = row.createCell(nCol);
		cell.setCellValue(sValue);
	}
%>
<%
	XSSFWorkbook workbook = new XSSFWorkbook();
	XSSFSheet sheet = workbook.createSheet("DELIVERIES");
	StringBuffer result = new StringBuffer();
	int rownum=0;
	int colnum=0;
	Row row = sheet.createRow(rownum++);
	setCellValue(colnum++,row,"PATIENTID");
	setCellValue(colnum++,row,"DATE");
	setCellValue(colnum++,row,"HIVSTATUS");
	setCellValue(colnum++,row,"ON ART");
	setCellValue(colnum++,row,"BIRTHWEIGHT");
	setCellValue(colnum++,row,"BIRTHHEIGHT");
	setCellValue(colnum++,row,"HEADCIRCUMFERENCE");
	setCellValue(colnum++,row,"GENDER CHILD");
	setCellValue(colnum++,row,"BORNALIVE");
	setCellValue(colnum++,row,"BORNDEAD");
	setCellValue(colnum++,row,"APGAR 1MIN");
	setCellValue(colnum++,row,"MOTHER DECEASED");
	setCellValue(colnum++,row,"WEEKS");
	setCellValue(colnum++,row,"TYPE");

	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from transactions where transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY_MSPLS'");
	ResultSet rs = ps.executeQuery();
	int count=0, hivpos=0,hivneg=0;
	while(rs.next()){
		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(rs.getInt("serverid"), rs.getInt("transactionid"));
		try{
			if(transaction!=null && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR").length()>0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE").length()>0){
				count++;
				row = sheet.createRow(rownum++);
				colnum=0;
				setCellValue(colnum++,row,(transaction.getHealthrecordId()+"").hashCode()+"");
				setCellValue(colnum++,row,ScreenHelper.formatDate(transaction.getUpdateTime()));
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH"));
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_ARV").equalsIgnoreCase("medwan.common.true")?"1":"0");
				int weight =0;
				String sWeight = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDWEIGHT").replace(".","").replace(",","");
				try{
					weight=Integer.parseInt(sWeight);
					if(weight<500 || weight>10000){
						sWeight="";
					}
				}
				catch(Exception o){
					sWeight="";
				}
				setCellValue(colnum++,row,sWeight);
				int height =0;
				String sHeight = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDHEIGHT").replace(".","").replace(",","");
				try{
					height=Integer.parseInt(sHeight);
					if(height<10 || height>100){
						sHeight="";
					}
				}
				catch(Exception o){
					sHeight="";
				}
				setCellValue(colnum++,row,sHeight);
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDCRANIEN"));
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER"));
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE").equalsIgnoreCase("openclinic.common.bornalive")?"1":"0");
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILDALIVE").equalsIgnoreCase("openclinic.common.borndead")?"1":"0");
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_APGAR_TOTAL_1"));
				boolean bDeceased=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DEATH").equalsIgnoreCase("medwan.common.true");
				if(!bDeceased && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID").length()>0){
					Encounter encounter = Encounter.get(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID"));
					if(encounter!=null && ScreenHelper.checkString(encounter.getOutcome()).startsWith("dead")){
						bDeceased=true;
					}
				}
				setCellValue(colnum++,row,bDeceased?"1":"0");
				setCellValue(colnum++,row,transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_DATE_DR").trim().replace(" ",".").replace(",","."));
				if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_EUSTOCIC").equalsIgnoreCase("medwan.common.true")){
					setCellValue(colnum++,row,"E");
				}
				else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_DYSTOCIC").equalsIgnoreCase("medwan.common.true")){
					setCellValue(colnum++,row,"D");
				}
				else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_DYSTOCIC").equalsIgnoreCase("medwan.common.true")){
					setCellValue(colnum++,row,"");
				}
				if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH").equalsIgnoreCase("+")){
					hivpos++;
				}
				if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_PREGNANCY_VIH").equalsIgnoreCase("-")){
					hivneg++;
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	rs.close();
	ps.close();
	conn.close();
	response.setContentType("application/octet-stream; charset=windows-1252");
	response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicReport"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".xlsx\"");
	ServletOutputStream os = response.getOutputStream();
	workbook.write(os);
	os.flush();
	os.close();
%>