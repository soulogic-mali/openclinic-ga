package be.mxs.common.util.pdf.official;

import com.itextpdf.text.Document;
import com.itextpdf.text.ExceptionConverter;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;
import java.net.URL;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.db.MedwanQuery;

public class EndPageCardBloodBank extends PdfPageEventHelper {
	
	String url;
	String contextPath;
	String projectDir;
	int red=-1;
	int green=-1;
	int blue=-1;
	
	public EndPageCardBloodBank(String url,String contextPath,String projectDir){
		this.url=url;
		this.contextPath=contextPath;
		this.projectDir=projectDir;
	}

	public EndPageCardBloodBank(String url,String contextPath,String projectDir,int red, int green,int blue){
		this.url=url;
		this.contextPath=contextPath;
		this.projectDir=projectDir;
		this.red=red;
		this.green=green;
		this.blue=blue;
	}

    //--- ON END PAGE -----------------------------------------------------------------------------
    // add "duplicata" in background of each page of the PDF document.
    //---------------------------------------------------------------------------------------------
    public void onEndPage(PdfWriter writer, Document document) {
        try{
            // load image
            Image watermarkImg =Image.getInstance(new URL(url+contextPath+projectDir+"/_img/cardheader4.png"));
            watermarkImg.scaleToFit(310*200*MedwanQuery.getInstance().getConfigInt("userCardHeaderZoom",100)/25400,310);
            //watermarkImg.setRotationDegrees(30);
            int[] transparencyValues = {100,100};
            //watermarkImg.setTransparency(transparencyValues);
            watermarkImg.setAbsolutePosition(MedwanQuery.getInstance().getConfigInt("userCardHeaderAbsoluteX",0),MedwanQuery.getInstance().getConfigInt("userCardHeaderAbsoluteY",109));

			// these are the canvases we are going to use
            PdfContentByte under = writer.getDirectContentUnder();
            under.addImage(watermarkImg);
            
        }
        catch(Exception e) {
            throw new ExceptionConverter(e);
        }
    }

}
