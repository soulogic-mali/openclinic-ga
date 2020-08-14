package be.mxs.common.util.pdf.general;

import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.medical.LabRequest;
import be.openclinic.reporting.Register;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import net.admin.User;
import net.admin.AdminPerson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.dom4j.io.SAXReader;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.Hashtable;
import java.util.Iterator;

public class PDFRegisterGenerator extends PDFOfficialBasic {

    // declarations
    private final int pageWidth = 100;
    private String type;
    PdfWriter docWriter=null;
    public void addHeader(){
    }
    public void addContent(){
    }



    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFRegisterGenerator(User user, String sProject){
        this.user = user;
        this.sProject = sProject;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String registerid, String begindate,String enddate,String sLanguage) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;
        sPrintLanguage=sLanguage;

        String sURL = req.getRequestURL().toString();
        if(sURL.indexOf("openclinic",10) > 0){
            sURL = sURL.substring(0,sURL.indexOf("openclinic", 10));
        }

        String sContextPath = req.getContextPath()+"/";
        HttpSession session = req.getSession();
        String sProjectDir = (String)session.getAttribute("activeProjectDir");

        this.url = sURL;
        this.contextPath = sContextPath;
        this.projectDir = sProjectDir;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
            Rectangle rectangle=new Rectangle(0,0,new Float(MedwanQuery.getInstance().getConfigInt("imageLabelWidth",360)*72/254).floatValue(),new Float(MedwanQuery.getInstance().getConfigInt("imageLabelHeight",890)*72/254).floatValue());
            String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + MedwanQuery.getInstance().getConfigString("registersfile","registers.xml");
            SAXReader reader = new SAXReader(false);
            org.dom4j.Document document = reader.read(new URL(sDoc));
            Iterator registers = document.getRootElement().elementIterator("register");
            while(registers.hasNext()){
            	org.dom4j.Element register = (org.dom4j.Element)registers.next();
            	if(checkString(register.attributeValue("id")).equalsIgnoreCase(registerid)){
            		if(register.attributeValue("pagesize").equalsIgnoreCase("A4")){
            			doc.setPageSize(PageSize.A4.rotate());
            		}
            		if(register.attributeValue("pagesize").equalsIgnoreCase("A3")){
            			doc.setPageSize(PageSize.A3.rotate());
            		}
                    doc.setMargins(10,10,10,10);
                    doc.setJavaScript_onLoad("print();\r");
                    doc.open();
            		//First we determine the total width of the table
            		int tablewidth=0;
            		Iterator columns = register.element("columns").elementIterator("column");
        			while(columns.hasNext()){
        				org.dom4j.Element column = (org.dom4j.Element)columns.next();
        				tablewidth+=Integer.parseInt(column.attributeValue("colspan"));
        			}
        			table = new PdfPTable(tablewidth);
        			table.setWidthPercentage(100);
        			cell = createValueCell(ScreenHelper.getTranNoLink("web.occup",register.attributeValue("transactiontype"),sLanguage)+"\n\n",Font.BOLD,10, tablewidth,false);
        			cell.setBorder(PdfPCell.NO_BORDER);
        			table.addCell(cell);
            		columns = register.element("columns").elementIterator("column");
        			while(columns.hasNext()){
        				org.dom4j.Element column = (org.dom4j.Element)columns.next();
        				Font font = FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLD);
        				font.setColor(BaseColor.WHITE);
        				cell = new PdfPCell(new Paragraph(ScreenHelper.getTranNoLink(column.attributeValue("labelid").split(";")[0],column.attributeValue("labelid").split(";")[1],sPrintLanguage),font));
        				cell.setColspan(Integer.parseInt(column.attributeValue("colspan")));
        				cell.setBackgroundColor(BaseColor.BLACK);
        				cell.setBorderColor(BaseColor.WHITE);
        				table.addCell(cell);
        			}
        			//Now we set the column headers
            		//This is the register that is needed
            		String transactiontype = register.attributeValue("transactiontype");
            		//We first construct the register query
            		String sSql="select h.personid, t.* from healthrecord h, transactions t where"+
            					" h.healthrecordid=t.healthrecordid and"+
            					" t.transactiontype=? and"+
            					" t.updatetime>=? and"+
            					" t.updatetime<=? and"+
            					" t.serverid=?"+
            					" order by t.updatetime,t.transactionid";
            		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
            		PreparedStatement ps = conn.prepareStatement(sSql);
            		ps.setString(1,transactiontype);
            		ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(begindate).getTime()));
            		ps.setDate(3,new java.sql.Date(ScreenHelper.parseDate(enddate).getTime()));
            		ps.setInt(4,MedwanQuery.getInstance().getConfigInt("serverId"));
            		ResultSet rs = ps.executeQuery();
            		int counter=0;
            		while(rs.next()){
            			//Each result is a row in the registry
            			//Now we will browse through the columns in order to compose the register line
            			Register reg = new Register(MedwanQuery.getInstance().getConfigInt("serverId"), rs.getInt("transactionid"),rs.getInt("personid"),sPrintLanguage);
            			reg.setCounter(counter);
            			counter++;
            			columns = register.element("columns").elementIterator("column");
            			while(columns.hasNext()){
            				org.dom4j.Element column = (org.dom4j.Element)columns.next();
                			String concatval="";
            				String val="";
            				for(int i=0;i<column.attributeValue("source").split(";").length;i++){
        	    				val=reg.getValue(column.attributeValue("source").split(";",-1)[i], column.attributeValue("name").split(";",-1)[i], checkString(column.attributeValue("translateresult")).split(";",-1)[i]);
        	    				if(checkString(column.attributeValue("contains")).split(";",-1).length>i && checkString(column.attributeValue("contains")).split(";",-1)[i].length()>0){
        	    					boolean bContains=false;
        	    					for(int n=0;n<val.split(",").length;n++){
        	    						if(val.split(",")[n].equals(column.attributeValue("contains").split(";",-1)[i])){
        	    							bContains=true;
        	    							break;
        	    						}
        	    					}
        	    					if(!bContains){
        	    						val="";
        	    					}
        	    				}
        	    				if(val.length()>0 && checkString(column.attributeValue("concatenate")).equals("1")){
        	    					if(concatval.length()>0){
        	    						concatval+="\n";
        	    					}
        	    					concatval+=val;
        	    				}
        	    				else if(val.length()==0 && !checkString(column.attributeValue("concatenate")).equals("1")){
        	    					break;
        	    				}
            				}
            				if(concatval.length()>0){
            					val=concatval;
            				}
            				if(val.length()>0 && checkString(column.attributeValue("outputsource")).length()>0 && checkString(column.attributeValue("outputname")).length()>0){
            					val=reg.getValue(column.attributeValue("outputsource"), column.attributeValue("outputname"), checkString(column.attributeValue("outputtranslateresult")));
            				}
            				if(val.length()>0 && checkString(column.attributeValue("output")).length()>0){
            					val=column.attributeValue("output");
            				}
            				cell = createValueCell(val.replaceAll("\\{sep\\}", "\n"),Font.NORMAL,6,Integer.parseInt(column.attributeValue("colspan")),true);
            				table.addCell(cell);
            			}
            		}
            		rs.close();
            		ps.close();
            		conn.close();
            		doc.add(table);
            	}
            }
        }
		catch(Exception e){
			baosPDF.reset();
			e.printStackTrace();
		}
		finally{
			if(doc!=null) doc.close();
            if(docWriter!=null) docWriter.close();
		}

		if(baosPDF.size() < 1){
			throw new DocumentException("document has no bytes");
		}

		return baosPDF;
	}

    //---- ADD PAGE HEADER ------------------------------------------------------------------------
    private void addPageHeader() throws Exception {
    }

    protected void printImageLabel(String imageid, String trandate, String examination,AdminPerson activePatient){
        try {
            Image image = PdfBarcode.getBarcode(imageid, docWriter);            
            image.scaleAbsoluteHeight((doc.getPageSize().getHeight()-doc.topMargin()-doc.bottomMargin())*2/3);
            image.scaleAbsoluteWidth((doc.getPageSize().getWidth()-doc.leftMargin()-doc.rightMargin())*2/3);
            table = new PdfPTable(3);
            table.setWidthPercentage(100);
            cell=new PdfPCell(image);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(3);
            cell.setPadding(0);
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(activePatient.personid+ " "+activePatient.lastname+" "+activePatient.firstname+" "+activePatient.gender+" °"+activePatient.dateOfBirth,FontFactory.getFont(FontFactory.COURIER,8,Font.NORMAL)));
            cell.setColspan(3);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setPadding(0);
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(trandate+": "+examination,FontFactory.getFont(FontFactory.COURIER,8,Font.NORMAL)));
            cell.setColspan(3);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setPadding(0);
            table.addCell(cell);

            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //################################### UTILITY FUNCTIONS #######################################

    //--- CREATE UNDERLINED CELL ------------------------------------------------------------------
    protected PdfPCell createUnderlinedCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.UNDERLINE))); // underlined
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    //--- PRINT VECTOR ----------------------------------------------------------------------------
    protected String printVector(Vector vector){
        StringBuffer buf = new StringBuffer();
        for(int i=0; i<vector.size(); i++){
            buf.append(vector.get(i)).append(", ");
        }

        // remove last comma
        if(buf.length() > 0) buf.deleteCharAt(buf.length()-2);

        return buf.toString();
    }

    //--- CREATE TITLE ----------------------------------------------------------------------------
    protected PdfPCell createTitle(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,10,Font.UNDERLINE)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);

        return cell;
    }

    //--- CREATE TITLE ----------------------------------------------------------------------------
    protected PdfPCell createLabel(String msg, int fontsize, int colspan,int style){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,fontsize,style)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);

        return cell;
    }

    //--- CREATE BORDERLESS CELL ------------------------------------------------------------------
    protected PdfPCell createBorderlessCell(String value, int height, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setPaddingTop(height); //
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    protected PdfPCell createBorderlessCell(String value, int colspan){
        return createBorderlessCell(value,3,colspan);
    }

    protected PdfPCell createBorderlessCell(int colspan){
        cell = new PdfPCell();
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);

        return cell;
    }

    //--- CREATE ITEMNAME CELL --------------------------------------------------------------------
    protected PdfPCell createItemNameCell(String itemName, int colspan){
        cell = new PdfPCell(new Paragraph(itemName,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL))); // no uppercase
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    //--- CREATE PADDED VALUE CELL ----------------------------------------------------------------
    protected PdfPCell createPaddedValueCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
        cell.setPaddingRight(5); // difference

        return cell;
    }

    //--- CREATE NUMBER VALUE CELL ----------------------------------------------------------------
    protected PdfPCell createNumberCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);

        return cell;
    }

}
