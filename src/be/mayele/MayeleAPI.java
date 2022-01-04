package be.mayele;

import java.io.IOException;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.json.XML;

import be.openclinic.system.SH;

/** 
Paramètres interface simplifiée
key:        code d'accès. L'accès pourra être limité aux clients disposant d'adresses ip spécifiques
format      = xml (default), json
module:     module à utiliser               - bi.hf    = formations sanitaires
                                            - bi.hrh   = ressources humaines
                                            - bi.nom   = nomenclatures
                                            - bi.insc  = registre des plans de couverture santé
                                            - bi.ins   = registre des assurés
                                            - bi.dhis  = entrepot de données
                                            - bi.sec   = sécurité
records:	100 par défaut

Une liste de critères de recherche spécifique pour chaque module


bi.sec      - key           = security key (access profile)
            - hrh           = contact person hrh uid
            - type          = ACC (access rights = default), LOG (accesses registered)      
            - from          = YYYYMMDDhhmmss
            - to            = YYYYMMDDhhmmss                                        
    
**/

public class MayeleAPI{
    public static final String version="0.1";
    
    public static StringBuffer getHeader() {
    	StringBuffer sb = new StringBuffer();
		try {
			sb = new StringBuffer(FileUtils.readFileToString(new java.io.File(SH.cs("localProjectPath","/mayele")+"/mayele/mayeleheader.html"),"utf8"));
		} catch (IOException e) {
			e.printStackTrace();
		}
    	return sb;
    }
    
    public static StringBuffer process(HttpServletRequest request) {
        Document document = DocumentHelper.createDocument();
        Element root = document.addElement("mayele");
        root.addAttribute("version",version);
        root.addAttribute("module", SH.p(request, "module"));
        if(!isValidKey(SH.p(request, "key"),SH.p(request, "module"))) {
        	if(SH.p(request, "key").length()==0) {
            	error(root, "E003", "No key specified for this request");
        	}
        	else if(SH.p(request, "module").length()==0) {
            	error(root, "E004", "No module specified for this request");
        	}
        	else {
        		error(root, "E005", "Invalid key for module "+SH.p(request, "module")+": "+SH.p(request,"key"));
        	}
        	StringWriter sw = new StringWriter();  
        	OutputFormat format = OutputFormat.createPrettyPrint();  
        	XMLWriter xw = new XMLWriter(sw, format);  
        	try {
				xw.write(document);
			} catch (IOException e) {
		        error(root,"A003","XML formatting error");
				e.printStackTrace();
			}  
        	if(SH.p(request,"format").startsWith("html")) {
        		return new StringBuffer(getHeader().toString()+XML2HTML(sw.toString()));
        	}
        	else {
        		return new StringBuffer(sw.toString());
        	}
        }
        if(SH.p(request,"format").length()>0 && "*xml*json*htmlxml*htmljson*".indexOf(SH.p(request,"format"))<0) {
        	error(root, "E002", "Unknown format: "+SH.p(request,"format"));
        }
        else {
	        try {
				Module module = (Module)(Class.forName("be.mayele."+SH.p(request, "module")).newInstance());
				module.process(request, root);
			} catch (InstantiationException e) {
		        error(root,"A002","General error");
				e.printStackTrace();
			} catch (IllegalAccessException e) {
		        error(root,"A001","Illegal access");
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
		        error(root,"E001","Unknown module: "+SH.p(request, "module"));
				e.printStackTrace();
			}
        }
        StringBuffer sb = new StringBuffer();
        if(SH.p(request,"format").equalsIgnoreCase("json")) {
        	try {
        		sb.append(XML.toJSONObject(document.asXML()).toString(4));
        	}
        	catch(Exception e) {
		        error(root,"A004","JSON formatting error");
        		e.printStackTrace();
        	}
        }
        else if(SH.p(request,"format").equalsIgnoreCase("htmljson")){
        	try {
        		sb.append(XML2HTML(XML.toJSONObject(document.asXML()).toString(4)));
        	}
        	catch(Exception e) {
		        error(root,"A004","JSON formatting error");
        		e.printStackTrace();
        	}
        }
        else if(SH.p(request,"format").equalsIgnoreCase("htmlxml")){
        	StringWriter sw = new StringWriter();  
        	OutputFormat format = OutputFormat.createPrettyPrint();  
        	XMLWriter xw = new XMLWriter(sw, format);  
        	try {
				xw.write(document);
			} catch (IOException e) {
		        error(root,"A003","XML formatting error");
				e.printStackTrace();
			}  
        	sb.append(XML2HTML(sw.toString()));
        }
        else {
        	StringWriter sw = new StringWriter();  
        	OutputFormat format = OutputFormat.createPrettyPrint();  
        	XMLWriter xw = new XMLWriter(sw, format);  
        	try {
				xw.write(document);
			} catch (IOException e) {
		        error(root,"A003","XML formatting error");
				e.printStackTrace();
			}  
        	sb.append(sw.toString());
        }
        return sb;
    }
    
    public static void error(Element root,String id,String message) {
        Element error = root.addElement("error");
        error.addAttribute("id",id);
        error.setText(message);
    }
    
    public static boolean isValidKey(String key, String module) {
    	boolean bValid=false;
    	Connection conn = SH.getOpenClinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from mayele_sec_acc where accesskey=?");
    		ps.setString(1, key);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			String[] accessrights = SH.c(rs.getString("accessrights")).split(";");
    			for(int n=0;n<accessrights.length;n++) {
    				if(accessrights[n].equalsIgnoreCase(module)) {
    					bValid=true;
    					break;
    				}
    			}
    		}
    		rs.close();
    		ps.close();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return bValid;
    }
    
    public static String XML2HTML(String s) {
    	return "<div style='font-family: monospace'>"+s.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br/>").replaceAll(" ","&nbsp;").replaceAll("\t","&nbsp;&nbsp;")+"</div>";
    }
}
