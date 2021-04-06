package be.mxs.common.util.pdf.official;

import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPageEventHelper;

import java.sql.Connection;
import java.sql.SQLException;

import com.itextpdf.text.*;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.pdf.general.PDFFooter;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.medical.LabRequest;
import net.admin.AdminPerson;

public class EndPageLabResults extends PdfPageEventHelper {
		String sId = "";
		
		public String getsId() {
			return sId;
		}
		public void setsId(String sId) {
			this.sId = sId;
		}
		public EndPageLabResults(String sId) {
			this.sId=sId;
		}
        public void onEndPage(PdfWriter writer, Document document) {
        try{
            int serverid=Integer.parseInt(sId.split("\\.")[0]);
            int transactionid=Integer.parseInt(sId.split("\\.")[1]);
            LabRequest labRequest=new LabRequest(serverid,transactionid);
        	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
            AdminPerson adminPerson=AdminPerson.getAdminPerson(ad_conn,labRequest.getPersonid()+"");
            try {
    			ad_conn.close();
    		} 
            catch (SQLException e) {
    			e.printStackTrace();
    		}
            String sFooter=adminPerson.lastname.toUpperCase()+", "+adminPerson.firstname.toUpperCase()+" - "+sId+" - ";
            String sFooter2=ScreenHelper.getTran(null,"labresult", "footer", adminPerson.language);
            Font font = FontFactory.getFont(FontFactory.HELVETICA,7);

        	Rectangle page = document.getPageSize();
            PdfPTable foot = new PdfPTable(1);
            PdfPCell cell= new PdfPCell(new Phrase(sFooter+sFooter2,FontFactory.getFont(FontFactory.HELVETICA,6)));
            cell.setColspan(1);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            foot.addCell(cell);
            foot.setTotalWidth(page.getWidth() - document.leftMargin() - document.rightMargin());
            foot.writeSelectedRows(0, -1, document.leftMargin(), document.bottomMargin(),writer.getDirectContent());
        }
        catch(Exception e) {
            throw new ExceptionConverter(e);
        }
    }
}
