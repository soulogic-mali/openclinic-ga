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
import be.openclinic.finance.Prestation;
import be.openclinic.pharmacy.Batch;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ServiceStock;

public class PharmacyExpiration extends PharmacyReport {
	Cell cell;
	Row row;
	
	public void generateReport(java.util.Date begin, java.util.Date end, OutputStream os, String language) throws IOException {
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
		cell.setCellValue(ScreenHelper.getTranNoLink("web", "period", language));
		CellUtil.setFont(cell, workbook, font);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.formatDate(begin)+" - "+ScreenHelper.formatDate(end));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		colnum=0;
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "expiration", language));
		CellUtil.setFont(cell, workbook, font);
		row = sheet.createRow(rownum++);
		row = sheet.createRow(rownum++);

		sheet.setColumnWidth(0,3000); 	//N°
		sheet.setColumnWidth(1,12500);	//Product
		sheet.setColumnWidth(2,4000);	//batch
		sheet.setColumnWidth(3,4000);	//expiry
		sheet.setColumnWidth(4,4000);	//quantity
		sheet.setColumnWidth(5,4000);	//unitprice
		sheet.setColumnWidth(6,4000);	//totalprice
		
		colnum=0;
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "no", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "product", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "batch", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "expiry", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "quantity", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "unitprice", language));
		cell.setCellStyle(box);
		cell = row.createCell(colnum++);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "totalprice", language));
		cell.setCellStyle(box);
		
		Vector batches = Batch.getActiveExpiringBatches(begin, end, getServiceUids());
		boolean bInitialized = false;
		double generalTotal=0;
		int linecount=1;
		for(int n=0;n<batches.size();n++){
			String key = (String)batches.elementAt(n);
			Product product = Product.get(key.split(";")[1]);
			if(product!=null) {
				bInitialized=true;
				//Nu printen we de gegevens van de productstock
				row = sheet.createRow(rownum++);
				cell = row.createCell(0);
				cell.setCellValue(linecount++);
				cell.setCellStyle(leftbox);
				cell = row.createCell(1);
				cell.setCellValue(product.getName());
				cell.setCellStyle(middlebox);
				cell = row.createCell(2);
				cell.setCellValue(key.split(";")[3]); 
				cell.setCellStyle(middlebox);
				cell = row.createCell(3);
				cell.setCellValue(key.split(";")[2]);
				cell.setCellStyle(middlebox);
				cell = row.createCell(4);
				cell.setCellValue(key.split(";")[4]); 
				cell.setCellStyle(middlebox);
				double pump=0;
				if(product!=null){
					long day=ScreenHelper.getTimeDay();
					pump=product.getLastYearsAveragePrice(new java.util.Date(end.getTime()));
				}
				cell = row.createCell(5);
				cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(pump)); 
				cell.setCellStyle(middlebox);
				cell = row.createCell(6);
				cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(Double.parseDouble(key.split(";")[4])*pump)); 
				cell.setCellStyle(middlebox);
				generalTotal+=Double.parseDouble(key.split(";")[4])*pump;
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
			cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "totalgeneral", language));
			cell.setCellStyle(middlebox);
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_TOP, CellStyle.BORDER_MEDIUM);
			CellUtil.setCellStyleProperty(cell, workbook, CellUtil.BORDER_BOTTOM, CellStyle.BORDER_MEDIUM);
			CellRangeAddress cellRangeAddress2 = new CellRangeAddress(rownum,rownum,2,6);
			RegionUtil.setBorderTop(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderRight(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			RegionUtil.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM, cellRangeAddress2, sheet, workbook);
			sheet.addMergedRegion(cellRangeAddress2);
			cell = CellUtil.getCell(CellUtil.getRow(rownum, sheet), 2);
			cell.setCellValue(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00")).format(generalTotal));
			CellUtil.setFont(cell, workbook, font);
			CellUtil.setAlignment(cell, workbook, CellStyle.ALIGN_RIGHT);
			rownum++;
		}
		row = sheet.createRow(rownum++);
		row = sheet.createRow(rownum++);
		cell = row.createCell(0);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "signature1", language));
		CellUtil.setFont(cell, workbook, font);
		cell = row.createCell(4);
		cell.setCellValue(ScreenHelper.getTranNoLink("pharmacyreport", "signature2", language));
		CellUtil.setFont(cell, workbook, font);
		workbook.write(os);
	}

}
