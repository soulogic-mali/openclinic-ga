package be.openclinic.reporting;

import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellUtil;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ServiceStock;

public class PharmacySynthesis extends PharmacyReport {
	Cell cell;
	Row row;
	
	public void generateReport(java.util.Date date, OutputStream os, String language) throws IOException {
		XSSFWorkbook workbook = new XSSFWorkbook();
		
		XSSFCellStyle box=workbook.createCellStyle();
		box.setBorderBottom(BorderStyle.MEDIUM);
		box.setBorderTop(BorderStyle.MEDIUM);
		box.setBorderRight(BorderStyle.MEDIUM);
		box.setBorderLeft(BorderStyle.MEDIUM);
		XSSFFont font=workbook.createFont();
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		box.setFont(font);
		box.setAlignment(HorizontalAlignment.CENTER);
		box.setVerticalAlignment(VerticalAlignment.TOP);
		box.setWrapText(true);
		
		XSSFCellStyle leftbox=workbook.createCellStyle();
		leftbox.setBorderRight(BorderStyle.THIN);
		leftbox.setBorderLeft(BorderStyle.MEDIUM);
		leftbox.setBorderBottom(BorderStyle.HAIR);
		XSSFFont lightfont=workbook.createFont();
		lightfont.setBoldweight(XSSFFont.BOLDWEIGHT_NORMAL);
		leftbox.setFont(lightfont);
		leftbox.setAlignment(HorizontalAlignment.LEFT);
		leftbox.setVerticalAlignment(VerticalAlignment.TOP);
		leftbox.setWrapText(true);
		
		XSSFCellStyle middlebox=workbook.createCellStyle();
		middlebox.setBorderRight(BorderStyle.THIN);
		middlebox.setBorderLeft(BorderStyle.THIN);
		middlebox.setBorderBottom(BorderStyle.HAIR);
		middlebox.setFont(lightfont);
		middlebox.setAlignment(HorizontalAlignment.LEFT);
		middlebox.setVerticalAlignment(VerticalAlignment.TOP);
		middlebox.setWrapText(true);

		XSSFCellStyle orangemiddlebox=workbook.createCellStyle();
		orangemiddlebox.setBorderRight(BorderStyle.THIN);
		orangemiddlebox.setBorderLeft(BorderStyle.THIN);
		orangemiddlebox.setBorderBottom(BorderStyle.HAIR);
		orangemiddlebox.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
		orangemiddlebox.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		orangemiddlebox.setFont(lightfont);
		orangemiddlebox.setAlignment(HorizontalAlignment.LEFT);
		orangemiddlebox.setVerticalAlignment(VerticalAlignment.TOP);
		orangemiddlebox.setWrapText(true);

		XSSFCellStyle rightbox=workbook.createCellStyle();
		rightbox.setBorderRight(BorderStyle.MEDIUM);
		rightbox.setBorderLeft(BorderStyle.THIN);
		rightbox.setBorderBottom(BorderStyle.HAIR);
		rightbox.setFont(lightfont);
		rightbox.setAlignment(HorizontalAlignment.LEFT);
		rightbox.setVerticalAlignment(VerticalAlignment.TOP);
		rightbox.setWrapText(true);
		
		XSSFSheet sheet = workbook.createSheet(ScreenHelper.getTranNoLink("web", "synthesis", language));
		int rownum = 0;
		int colnum = 0;
		//Report Header
		row = sheet.createRow(rownum++);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("web", "month", language));
		CellUtil.setFont(cell, workbook, font);
		cell = row.createCell(colnum++);
		cell.setCellValue(new SimpleDateFormat("MM/yyyy").format(date));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		colnum=0;
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "synthesis", language));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		row = sheet.createRow(rownum++);

		sheet.setColumnWidth(0,1400); 	//N°
		sheet.setColumnWidth(1,12500);	//Product
		sheet.setColumnWidth(2,3000);	//Form
		sheet.setColumnWidth(3,2400);	//Dose
		sheet.setColumnWidth(4,2700);	//Average monthly consumption (CMM)
		sheet.setColumnWidth(5,2700);	//Remaining stock
		sheet.setColumnWidth(6,2700);	//Remaining months
		sheet.setColumnWidth(7,3500);	//Quantity consumed past month
		sheet.setColumnWidth(8,2700);	//Quantity lost past month
		sheet.setColumnWidth(9,2700);	//Number of stock-out days
		sheet.setColumnWidth(10,4000);	//Comments
		
		colnum=0;
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "no", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "product", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "form", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "dosage", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "cmm", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "remainingstock", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "remainingmonths", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "quantityconsumedpastmonth", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "quantitylostpastmonth", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "stockoutdays", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "comments", language));
		cell.setCellStyle(box);
		
		//Calculate first and last day of the month
		java.util.Date begin = ScreenHelper.parseDate("01/"+new SimpleDateFormat("MM/yyyy").format(date));
		long month = 32*ScreenHelper.getTimeDay();
		java.util.Date end = ScreenHelper.parseDate("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date(begin.getTime()+month)));
		
		Hashtable averageconsumptions = Product.getLastYearsAverageMonthlyConsumptions(end,getServiceUids());
		Hashtable consumptions = Product.getConsumptions(begin, end, getServiceUids());
		Hashtable quantitieslost = Product.getQuantitiesLost(begin, end, getServiceUids());
		Hashtable productoperations = Product.getProductOperations(begin, new java.util.Date());
		Hashtable productoperations2 = ProductStock.getProductStockOperations(end, new java.util.Date());
		SortedMap groups = new TreeMap();
		String[] serviceStockUids = getServiceUids().split(";");
		for(int q=0;q<serviceStockUids.length;q++){
			Vector productStocks = ServiceStock.getProductStocks(serviceStockUids[q]);
			for(int n=0;n<productStocks.size();n++){
				ProductStock stock = (ProductStock)productStocks.elementAt(n);
				if(stock==null || (stock.getEnd()!=null && stock.getEnd().before(begin)) || stock.getProduct()==null){
					continue;
				}
				String uid="";
				//We first figure out in which group this stock should go
				//First find the product subcategory
				uid=(ScreenHelper.checkString(stock.getProduct().getFullProductSubGroupName(language))).length()==0?"?":stock.getProduct().getFullProductSubGroupName(language);
				if(groups.get(uid)==null){
					groups.put(uid, new TreeMap());
				}
				if(uid.length()>0){
					SortedMap stocks = (TreeMap)groups.get(uid);
					//Now we add an entry for each combination productUid+BatchNumber
					//Look up all batches for this product
					int datelevel=new Double(stock.getCorrectedLevel(end,productoperations2)).intValue();
					if(datelevel<0) {
						datelevel=0;
					}
					uid=stock.getProduct().getName()+";"+ScreenHelper.checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+"; ; ;"+ScreenHelper.checkString(stock.getProduct().getUnit())+" ;"+ScreenHelper.checkString(stock.getProduct().getDose())+" ;";
					if(stocks.get(uid)==null){
						stocks.put(uid, 0);
					}
					stocks.put(uid,	(Integer)stocks.get(uid)+datelevel);
				}
			}
		}
		Hashtable printedSubTitels = new Hashtable();
		Iterator iGroups = groups.keySet().iterator();
		boolean bInitialized = false;
		double consumptionTotal=0,generalTotal=0;
		String title="";
		while(iGroups.hasNext()){
			String key = (String)iGroups.next();
			//For each new group, we are going to print a title
			bInitialized=true;
			title=key;
			
			CellRangeAddress cellRangeAddress = new CellRangeAddress(rownum,rownum,0,10);
			RegionUtil.setBorderTop(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderRight(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			sheet.addMergedRegion(cellRangeAddress);
			cell = CellUtil.getCell(CellUtil.getRow(rownum, sheet), 0);
			cell.setCellValue(title);
			CellUtil.setAlignment(cell, workbook, CellStyle.ALIGN_CENTER);
			CellUtil.setFont(cell, workbook, font);
		    cell.getCellStyle().setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		    cell.getCellStyle().setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			rownum++;
			
			int linecount=1;
			SortedMap stocks = (SortedMap)groups.get(key);
			//Now we print a line for each element in the stocks for this group
			Iterator iStocks = stocks.keySet().iterator();
			while(iStocks.hasNext()){
				String key2 = (String)iStocks.next();
				Product product = Product.get(key2.split(";")[2]);
				if(product!=null){
					//Nu printen we de gegevens van de productstock
					row = sheet.createRow(rownum++);
					cell = row.createCell(0);
					cell.setCellValue(linecount++);
					cell.setCellStyle(leftbox);
					cell = row.createCell(1);
					cell.setCellValue(key2.split(";")[0]);
					cell.setCellStyle(middlebox);
					cell = row.createCell(2);
					cell.setCellValue(ScreenHelper.getTranNoLink("product.unit",key2.split(";")[5].trim(),language));
					cell.setCellStyle(middlebox);
					cell = row.createCell(3);
					cell.setCellValue(key2.split(";")[6].trim());
					cell.setCellStyle(middlebox);
					cell = row.createCell(4);
					double averageconsumption=averageconsumptions.get(key2.split(";")[2])==null?0:((Double)averageconsumptions.get(key2.split(";")[2])).intValue();
					cell.setCellValue(new DecimalFormat("#0").format(averageconsumption));
					cell.setCellStyle(middlebox);
					cell = row.createCell(5);
					double pump=0;
					long day=24*3600*1000;
					pump=product.getLastYearsAveragePrice(new java.util.Date(end.getTime()));
					int level=(Integer)stocks.get(key2);
					cell.setCellValue(level);
					cell.setCellStyle(middlebox);
					cell = row.createCell(6);
					cell.setCellValue(averageconsumption<=0?"-":new DecimalFormat("#0.0").format(new Double(level)/averageconsumption)); 
					cell.setCellStyle(middlebox);
					cell = row.createCell(7);
					int consumption=consumptions.get(key2.split(";")[2])==null?0:((Double)consumptions.get(key2.split(";")[2])).intValue();
					cell.setCellValue(consumption); 
					cell.setCellStyle(middlebox);
					cell = row.createCell(8);
					int lost=quantitieslost.get(key2.split(";")[2])==null?0:((Double)quantitieslost.get(key2.split(";")[2])).intValue();
					cell.setCellValue(lost); 
					cell.setCellStyle(middlebox);
					cell = row.createCell(9);
					cell.setCellValue(product.getDaysOutOfStock(begin, end, productoperations));
					cell.setCellStyle(middlebox);
					cell = row.createCell(10);
					cell.setCellValue("");
					cell.setCellStyle(middlebox);
					consumptionTotal+=consumption*pump;
					generalTotal+=level*pump;
				}
			}
		}
		if(bInitialized){
			row = sheet.createRow(rownum);
			cell = row.createCell(0);
			cell.setCellValue("");
			cell.setCellStyle(leftbox);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_LEFT, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_TOP, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			cell = row.createCell(1);
			cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "turnover", language));
			cell.setCellStyle(middlebox);
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_TOP, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			CellRangeAddress cellRangeAddress = new CellRangeAddress(rownum,rownum,2,10);
			RegionUtil.setBorderTop(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderRight(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			RegionUtil.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress, sheet, workbook);
			sheet.addMergedRegion(cellRangeAddress);
			cell = CellUtil.getCell(CellUtil.getRow(rownum, sheet), 2);
			cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(consumptionTotal));
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setAlignment(cell, workbook, CellStyle.ALIGN_LEFT);
			rownum++;

			row = sheet.createRow(rownum);
			cell = row.createCell(0);
			cell.setCellValue("");
			cell.setCellStyle(leftbox);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_LEFT, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_TOP, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			cell = row.createCell(1);
			cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "stockvalue", language));
			cell.setCellStyle(middlebox);
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_TOP, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			CellRangeAddress cellRangeAddress2 = new CellRangeAddress(rownum,rownum,2,10);
			RegionUtil.setBorderTop(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderRight(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			sheet.addMergedRegion(cellRangeAddress2);
			cell = CellUtil.getCell(CellUtil.getRow(rownum, sheet), 2);
			cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(generalTotal));
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setAlignment(cell, workbook, CellStyle.ALIGN_LEFT);
			rownum++;
		}
		row = sheet.createRow(rownum++);
		row = sheet.createRow(rownum++);
		cell = row.createCell(0);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "signature1", language));
		CellUtil.setFont(cell, workbook, font);
		cell = row.createCell(6);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "signature2", language));
		CellUtil.setFont(cell, workbook, font);
		workbook.write(os);
	}

}
