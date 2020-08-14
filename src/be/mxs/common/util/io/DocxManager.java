package be.mxs.common.util.io;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Vector;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;

public class DocxManager{
    private Vector rs=new Vector();
    XWPFDocument doc;
    
    public DocxManager(InputStream in) throws IOException {
        super();
        doc = new XWPFDocument(in);
    }
    
    public void replaceText(String textToReplace,String replacementText){
        for (XWPFParagraph p : doc.getParagraphs()) {
            //Forget about the previous runs
            rs=new Vector();
            List<XWPFRun> runs = p.getRuns();
            if (runs != null) {
                for (XWPFRun r : runs) {
                    replaceTextInRun(r,textToReplace,replacementText);
                }
            }
        }
        for (XWPFTable tbl : doc.getTables()) {
           for (XWPFTableRow row : tbl.getRows()) {
              for (XWPFTableCell cell : row.getTableCells()) {
                 for (XWPFParagraph p : cell.getParagraphs()) {
                    //Forget about the previous runs
                    rs=new Vector();
                    for (XWPFRun r : p.getRuns()) {
                        replaceTextInRun(r,textToReplace,replacementText);
                    }
                 }
                 replaceTextInCell(textToReplace, replacementText, cell);
              }
           }
        }
    }
    
    public void replaceTextInCell(String textToReplace,String replacementText,XWPFTableCell rootcell){
        for (XWPFTable tbl : rootcell.getTables()) {
            for (XWPFTableRow row : tbl.getRows()) {
               for (XWPFTableCell cell : row.getTableCells()) {
                  for (XWPFParagraph p : cell.getParagraphs()) {
                     //Forget about the previous runs
                     rs=new Vector();
                     for (XWPFRun r : p.getRuns()) {
                         replaceTextInRun(r,textToReplace,replacementText);
                     }
                  }
                  replaceTextInCell(textToReplace, replacementText, cell);
               }
            }
         }
    }
    
    public void writeDocument(OutputStream out) throws IOException{
        doc.write(out);
    }
    
    private String getRunText(){
        String s ="";
        for(int n=0;n<rs.size();n++){
            XWPFRun run = (XWPFRun)rs.elementAt(n);
            if(n==0){
                String text = run.getText(0);
                s=text.split(" ")[text.split(" ").length-1];
            }
            else{
                s+=run.getText(0);
            }
        }
        return s;
    }
    
    private void replaceRunText(String replacementText){
        for(int n=0;n<rs.size();n++){
            XWPFRun run = (XWPFRun)rs.elementAt(n);
            String newtext="";
            if(n==0){
                //This is the first run, only the last text segment must be replaced
                String text = run.getText(0);
                String[] segments = text.split(" ");
                for(int i=0;i<segments.length;i++){
                    if(i==segments.length-1){
                        //This is the last segment of the first run, replace it with the replacementText
                        newtext+=replacementText;
                    }
                    else{
                        //We keep previous segments as they are
                        newtext+=segments[i]+" ";
                    }
                }
            }
            else{
                //This is a later run, replace it completely with blank
                newtext="";
            }
            run.setText(newtext,0);
        }       
    }
    
    private void replaceTextInRun(XWPFRun r,String textToReplace,String replacementText){
        String text = r.getText(0);
        if (text != null && text.contains(textToReplace)) {
            text = text.replace(textToReplace, replacementText);
            r.setText(text,0);
            //Forget about the previous runs
            rs=new Vector();
        }
        else{
            String runtext=getRunText();
            if(runtext.length()>0){
                //We allready stored text fragments from previous run(s)
                //Let's see if there's a match when we concatenate
                if((runtext+text).contains(textToReplace)){
                    //After concatenation, we have a math
                    //Now we replace the first textfragment with the new text en replace the other segments with blanks
                    replaceRunText(replacementText);
                    //The first fragment of the last run must also be replaced with blank
                    if(text.split(" ").length==1){
                        text="";
                    }
                    else{
                        text = text.substring(text.split(" ")[0].length());
                    }
                    r.setText(text,0);
                    rs=new Vector();
                }
            }
            if((runtext+text).contains(" ")){
                //Forget about the previous runs
                rs=new Vector();
            }
            if(text!=null && text.length()>0){
                int segments = text.split(" ").length;
                if(segments>0 && textToReplace.startsWith(runtext+text.split(" ")[segments-1])){
                    rs.add(r);
                }
            }
        }
    }

}
