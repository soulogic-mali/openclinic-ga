package be.mxs.common.util.pdf.general.oc.examinations;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.pdf.general.PDFGeneralBasic;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.system.TransactionItem;

import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.tool.xml.ElementList;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Element;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.html.simpleparser.HTMLWorker;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Font;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.awt.*;

public class PDFGenericTransaction extends PDFGeneralBasic {

    //--- ADD CONTENT ------------------------------------------------------------------------------
    protected void addContent(){    	
        try{
            contentTable = new PdfPTable(1);
            table = new PdfPTable(5);
            SortedMap sorteditems = new TreeMap();
            Iterator iterator = transactionVO.getItems().iterator();
            ItemVO item;
            while(iterator.hasNext()){
                item = (ItemVO)iterator.next();
                if(	item.getType().toLowerCase().startsWith(IConstants_PREFIX.toLowerCase()) &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_CONTEXT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_DEPARTMENT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_ENCOUNTERUID") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_PRIVATETRANSACTION") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_TRANSACTION_RESULT") &&
                    	!item.getType().equalsIgnoreCase(IConstants_PREFIX+"ITEM_TYPE_RECRUITMENT_CONVOCATION_ID")){
                	TransactionItem ti = TransactionItem.selectTransactionItem(transactionVO.getTransactionType(), item.getType());
                	sorteditems.put(ScreenHelper.checkString(ti.getPrintChapter())+";"+String.format("%010d", ti.getPriority())+";"+item.getType()+";"+ti.getResultLabelType(),item);
                }
            }
            
            String activekey="";

            iterator = sorteditems.keySet().iterator();
            while(iterator.hasNext()){
            	String key = (String)iterator.next();
            	if(!activekey.equalsIgnoreCase(key.split(";")[0])){
            		//Print title
            		if(key.split(";")[0].length()>0 || activekey.length()>0){
	                    cell = new PdfPCell(new Phrase(getTran(transactionVO.getTransactionType(),key.split(";")[0]).toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)MedwanQuery.getInstance().getConfigInt("transactionTitleFontSize",9)*fontSizePercentage/100.0),Font.BOLD)));
	                    cell.setColspan(5);
	                    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	                    cell.setBorder(PdfPCell.BOX);
	                    cell.setBorderColor(BaseColor.LIGHT_GRAY);
	                    table.addCell(cell);
	            		activekey=key.split(";")[0];
            		}
            	}
            	item = (ItemVO)sorteditems.get(key);
                // itemType
                cell = new PdfPCell(new Phrase(getTran("web.occup",item.getType()).toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)MedwanQuery.getInstance().getConfigInt("transactionTextFontSize",7)*fontSizePercentage/100.0),Font.NORMAL)));
                cell.setColspan(2);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setBorder(PdfPCell.BOX);
                cell.setBorderColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);

                // itemValue
                if(!item.getType().contains(MedwanQuery.getInstance().getConfigString("htmlItems","_JOURNAL"))){
                	//Now check if this is a keyword item
                	if(key.split(";").length>3 && key.split(";")[3].length()>0 && key.split(";")[3].equalsIgnoreCase("keywords")){
                		String values = "";
                		for(int n=0;n<item.getValue().split(";").length;n++) {
                			if(item.getValue().split(";")[n].split("\\$").length>1) {
                				if(values.length()>0) {
                					values+=", ";
                				}
                				values+=getTran(item.getValue().split(";")[n].split("\\$")[0],item.getValue().split(";")[n].split("\\$")[1]);
                			}
                		}
                		cell = new PdfPCell(new Phrase(values,FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)MedwanQuery.getInstance().getConfigInt("transactionTextFontSize",7)*fontSizePercentage/100.0),Font.NORMAL)));
                	}
                	//Now check if the label must be translated
                	else if(key.split(";").length>3 && key.split(";")[3].length()>0){
                		cell = new PdfPCell(new Phrase(getTran(key.split(";")[3],item.getValue()),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)MedwanQuery.getInstance().getConfigInt("transactionTextFontSize",7)*fontSizePercentage/100.0),Font.NORMAL)));
                	}
                	else{
                		cell = new PdfPCell(new Phrase(getTran("web.occup",item.getValue()),FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)MedwanQuery.getInstance().getConfigInt("transactionTextFontSize",7)*fontSizePercentage/100.0),Font.NORMAL)));
                	}
                }
                else{
                    ElementList list = XMLWorkerHelper.parseToElementList(item.getValue(), null);
                    for (Element element : list) {
                        cell.addElement(element);
                    }
                }
                cell.setColspan(3);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setBorder(PdfPCell.BOX);
                cell.setBorderColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);
            }

            // add table
            if(table.size() >= 1){
                contentTable.addCell(createCell(new PdfPCell(table),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER));
                tranTable.addCell(createContentCell(contentTable));
            }
            addDiagnosisEncoding();

            // add transaction to doc
            addTransactionToDoc();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

}
