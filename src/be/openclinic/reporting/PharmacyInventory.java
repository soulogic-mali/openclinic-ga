package be.openclinic.reporting;

import java.awt.Color;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellUtil;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.pharmacy.Batch;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ServiceStock;

public class PharmacyInventory extends PharmacyReport {
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
		
		XSSFSheet sheet = workbook.createSheet(ScreenHelper.getTranNoLink("web", "inventory", language));
		int rownum = 0;
		int colnum = 0;
		//Report Header
		row = sheet.createRow(rownum++);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("web", "date", language));
		CellUtil.setFont(cell, workbook, font);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.formatDate(date));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		colnum=0;
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "inventory", language));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		row = sheet.createRow(rownum++);

		sheet.setColumnWidth(0,1400);
		sheet.setColumnWidth(1,12500);
		sheet.setColumnWidth(2,3000);
		sheet.setColumnWidth(3,2400);
		sheet.setColumnWidth(4,2700);
		sheet.setColumnWidth(5,2700);
		sheet.setColumnWidth(6,2700);
		sheet.setColumnWidth(7,2700);
		sheet.setColumnWidth(8,3350);
		sheet.setColumnWidth(9,3100);
		sheet.setColumnWidth(10,2000);
		sheet.setColumnWidth(11,4200);
		
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
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "batch", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "expirydate", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "theoreticalstock", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "physicalstock", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "gap", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "unitprice", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "gapvalue", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "stockvalue", language));
		cell.setCellStyle(box);
		
		Hashtable productoperations = ProductStock.getProductStockOperations(date, new java.util.Date());
		SortedMap groups = new TreeMap();
		String[] serviceStockUids = getServiceUids().split(";");
		for(int q=0;q<serviceStockUids.length;q++){
			Vector productStocks = ServiceStock.getProductStocks(serviceStockUids[q]);
			for(int n=0;n<productStocks.size();n++){
				ProductStock stock = (ProductStock)productStocks.elementAt(n);
				if(stock==null || (MedwanQuery.getInstance().getConfigInt("pharmacyShowZeroLevelStocks",0)==0 && stock.getCorrectedLevel(date,productoperations)<=0) || stock.getProduct()==null){
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
					int nBatchedQuantity=0;
					double datelevel=stock.getCorrectedLevel(date,productoperations);
					Vector batches = Batch.getAllBatches(stock.getUid());
					for(int b=0;b<batches.size() && (nBatchedQuantity<datelevel);b++){
						Batch batch = (Batch)batches.elementAt(b);
						double level=batch.getLevel(date);
						if(level>0){
							if(datelevel<nBatchedQuantity+level){
								level=level-(nBatchedQuantity+level-datelevel);
							}
							nBatchedQuantity+=level;
							uid=stock.getProduct().getName()+";"+ScreenHelper.checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+";"+batch.getBatchNumber()+";"+ScreenHelper.formatDate(batch.getEnd())+" ;"+ScreenHelper.checkString(stock.getProduct().getUnit())+" ;"+ScreenHelper.checkString(stock.getProduct().getDose())+" ;";
							if(stocks.get(uid)==null){
								stocks.put(uid, new Double(0));
							}
							stocks.put(uid,	(Double)stocks.get(uid)+level);
						}
					}
					if(nBatchedQuantity<datelevel){
						if(stock.getProductUid().equalsIgnoreCase("1.1439")) {
							System.out.println("Out of Batch = "+(datelevel-nBatchedQuantity));
						}
						//Part of the stock has no batch associated 
						uid=stock.getProduct().getName()+";"+ScreenHelper.checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+"; ; ;"+ScreenHelper.checkString(stock.getProduct().getUnit())+" ;"+ScreenHelper.checkString(stock.getProduct().getDose())+" ;";
						if(stocks.get(uid)==null){
							stocks.put(uid, new Double(0));
						}
						stocks.put(uid,	(Double)stocks.get(uid)+datelevel-nBatchedQuantity);
					}
				}
			}
		}
		Hashtable printedSubTitels = new Hashtable();
		Iterator iGroups = groups.keySet().iterator();
		boolean bInitialized = false;
		double sectionTotal=0,generalTotal=0;
		String title="";
		while(iGroups.hasNext()){
			String key = (String)iGroups.next();
			//For each new group, we are going to print a title
			if(bInitialized){
				//First print the totals from the previous title
				row = sheet.createRow(rownum++);
				cell = row.createCell(0);
				cell.setCellValue("");
				cell.setCellStyle(leftbox);
				cell = row.createCell(1);
				cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "subtotal", language));
				cell.setCellStyle(middlebox);
				CellUtil.setFont(cell, workbook, font);
				for(int n=2;n<11;n++) {
					cell = row.createCell(n);
					cell.setCellValue("");
					cell.setCellStyle(middlebox);
				}
				cell = row.createCell(11);
				cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(sectionTotal));
				cell.setCellStyle(rightbox);
				CellUtil.setFont(cell, workbook, font);

				sectionTotal=0;
			}
			bInitialized=true;
			title=key;
			
			CellRangeAddress cellRangeAddress = new CellRangeAddress(rownum,rownum,0,11);
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
				cell.setCellValue(key2.split(";")[3]);
				cell.setCellStyle(middlebox);
				cell = row.createCell(5);
				cell.setCellValue(key2.split(";")[4]);
				//Check if date is in the past
				try {
					if(ScreenHelper.parseDate(key2.split(";")[4]).before(date)) {
						cell.setCellStyle(orangemiddlebox);
					}
					else {
						cell.setCellStyle(middlebox);
					}
				}
				catch(Exception e) {
					cell.setCellStyle(middlebox);
				}
				double level=(Double)stocks.get(key2);
				cell = row.createCell(6);
				cell.setCellValue(level);
				cell.setCellStyle(middlebox);
				cell = row.createCell(7);
				cell.setCellValue(level);
				cell.setCellStyle(middlebox);
				cell = row.createCell(8);
				cell.setCellValue(0);
				cell.setCellStyle(middlebox);
				double pump=0;
				long day=24*3600*1000;
				Product product = Product.get(key2.split(";")[2]);
				if(product!=null){
					pump=product.getLastYearsAveragePrice(new java.util.Date(date.getTime()));
				}
				if(pump>0) {
					cell = row.createCell(9);
					cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(pump));
					cell.setCellStyle(middlebox);
					cell = row.createCell(10);
					cell.setCellValue(0);
					cell.setCellStyle(middlebox);
					cell = row.createCell(11);
					cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(level*pump));
					cell.setCellStyle(rightbox);
				}
				else {
					cell = row.createCell(9);
					cell.setCellValue("-");
					cell.setCellStyle(middlebox);
					cell = row.createCell(10);
					cell.setCellValue("-");
					cell.setCellStyle(middlebox);
					cell = row.createCell(11);
					cell.setCellValue("-");
					cell.setCellStyle(rightbox);
				}
				sectionTotal+=level*pump;
				generalTotal+=level*pump;
			}
		}
		if(bInitialized){
			row = sheet.createRow(rownum++);
			cell = row.createCell(0);
			cell.setCellValue("");
			cell.setCellStyle(leftbox);
			cell = row.createCell(1);
			cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "subtotal", language));
			cell.setCellStyle(middlebox);
			CellUtil.setFont(cell, workbook, font);
			for(int n=2;n<11;n++) {
				cell = row.createCell(n);
				cell.setCellValue("");
				cell.setCellStyle(middlebox);
			}
			cell = row.createCell(11);
			cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(sectionTotal));
			cell.setCellStyle(rightbox);
			CellUtil.setFont(cell, workbook, font);

			row = sheet.createRow(rownum++);
			cell = row.createCell(0);
			cell.setCellValue("");
			cell.setCellStyle(leftbox);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			cell = row.createCell(1);
			cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "totalgeneral", language));
			cell.setCellStyle(middlebox);
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			
			for(int n=2;n<11;n++) {
				cell = row.createCell(n);
				cell.setCellValue("");
				cell.setCellStyle(middlebox);
				CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			}
			cell = row.createCell(11);
			cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(generalTotal));
			cell.setCellStyle(rightbox);
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
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
