package pe.gob.sis;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URL;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;
import java.util.zip.ZipOutputStream;

import javax.activation.DataHandler;
import javax.xml.soap.*;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Namespace;
import org.dom4j.QName;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import com.chilkatsoft.CkHttp;
import com.chilkatsoft.CkHttpRequest;
import com.chilkatsoft.CkHttpResponse;
import com.chilkatsoft.CkXml;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

public class FUAGenerator {
	
	/* 
	 * Writes the data of a list of FUA to a set of text files and compresses these text files in a zip
	 * Different modules
	 * 1. Make a list of FUA that have not been sent yet and that are complete (do not contain errors
	 * 		or missing information
	 * 2. Append the data of each FUA to the different text files
	 * 3. Compress the resulting files in a ZIP file
	 * 4. Send the zip file to SIS
	*/
	
	private Vector fuas = new Vector();
	private StringBuffer sbAtencion,sbDiagnosticos,sbMedicamentos,sbSMI,sbInsumos,sbProcedimientos,sbReciennacido,sbServiciosadicionales;
	private Element config = null; 
	
	public String generateFUAs(int year, int month){
		sbAtencion = new StringBuffer();
		sbDiagnosticos = new StringBuffer();
		sbMedicamentos = new StringBuffer();
		sbSMI = new StringBuffer();
		sbInsumos = new StringBuffer();
		sbProcedimientos = new StringBuffer();
		sbServiciosadicionales = new StringBuffer();
        String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "fuaformat.xml";
        SAXReader reader = new SAXReader(false);
        try{
            Document fuaConfig = reader.read(new URL(sDoc));
            config=fuaConfig.getRootElement();
            loadFUAs(year,month);
    		for(int n=0;n<fuas.size(); n++){
    			FUA fua = (FUA)fuas.elementAt(n);
    			exportFUA(fua);
    		}
    		Debug.println(sbAtencion);
    		Debug.println(sbDiagnosticos);
    		Debug.println(sbMedicamentos);
    		Debug.println(sbSMI);
    		Debug.println(sbInsumos);
    		Debug.println(sbProcedimientos);
    		Debug.println(sbServiciosadicionales);
    		//All FUA have been exported, now create files
    		String batch = StringUtils.leftPad(MedwanQuery.getInstance().getOpenclinicCounter("FUATRANSFER"+"."+year+"."+month)+"",2,"0");
    		String zipname = MedwanQuery.getInstance().getConfigString("fua.ipress.renaes","01471570")+year+StringUtils.leftPad(month+"",2,"0")+batch+".zip";
    		writeFile(sbAtencion,"ATENCION.TXT");
    		writeFile(sbDiagnosticos,"ATENCIONDIA.TXT");
    		writeFile(sbInsumos,"ATENCIONINS.TXT");
    		writeFile(sbMedicamentos,"ATENCIONMED.TXT");
    		writeFile(sbProcedimientos,"ATENCIONPRO.TXT");
    		writeFile(sbSMI,"ATENCIONSMI.TXT");
    		writeFile(sbServiciosadicionales,"ATENCIONSER.TXT");
    		writeFile(new StringBuffer(),"ATENCIONRN.TXT");
    		writeFile(getResumen(year,month,zipname,batch),"RESUMEN.TXT");
    		//Now create zipfile
    		String filePath=MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+zipname;
            ZipParameters zipParameters = new ZipParameters();
            zipParameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
            zipParameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_ULTRA);
            zipParameters.setEncryptFiles(true);
            zipParameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_STANDARD);
            zipParameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
            zipParameters.setPassword(MedwanQuery.getInstance().getConfigString("fua.password","PilotoFUAE123"));
            ZipFile zipFile = new ZipFile(filePath);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCION.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONDIA.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONINS.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONMED.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONPRO.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONSMI.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONSER.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"ATENCIONRN.TXT"), zipParameters);
            zipFile.addFile(new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+"RESUMEN.TXT"), zipParameters);
    		for(int n=0;n<fuas.size(); n++){
    			FUA fua = (FUA)fuas.elementAt(n);
    			/** Code to be activated when tests have been performed
    			 * sentDateTime is the date when the FUA was exported to a zip file
    			 * Regardless the fact if the zip file has been sent to SIS or not
    				fua.setSentDateTime(new java.util.Date());
    				fua.store();
    			 **/
    		}
            return filePath;
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        return "";
	}
	
	public void sendSOAPFUAZipChilkat(String fuazip,String zippath){
	    try {
	        System.load("C:/Users/Frank/Downloads/chilkat-9.5.0-jdk8-x64/chilkat-9.5.0-jdk8-x64/chilkat.dll");
	        System.out.println("Chilkat successfully loaded");
	    } catch (UnsatisfiedLinkError e) {
	      e.printStackTrace();
	    }
	    boolean success;
	    CkHttp http = new CkHttp();
	    http.put_AllowGzip(true);
	    http.put_UserAgent("Apache-HttpClient/4.1.1 (java 1.5)");
	    //  Any string unlocks the component for the 1st 30-days.
	    success = http.UnlockComponent("Anything for 30-day trial");
	    if (success != true) {
	        System.out.println(http.lastErrorText());
	        return;
	    }

	    CkXml soapXml = new CkXml();

	    soapXml.put_Tag("soap-env:Envelope");
	    soapXml.AddAttribute("xmlns:soap-env","http://schemas.xmlsoap.org/soap/envelope/");

	    CkXml header = soapXml.NewChild("soap-env:Header","");

	    CkXml headerRequestType = header.NewChild("v1:HeaderRequestType","");
	    headerRequestType.AddAttribute("xmlns:v1","http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/");
	    headerRequestType.NewChild2("canal","HOEMPE");
	    headerRequestType.NewChild2("usuario","HOEMPESOA");
	    headerRequestType.NewChild2("autorizacion","123456");

	    CkXml body = soapXml.NewChild("soap-env:Body","");
	    CkXml registrarFUARequest = body.NewChild("v11:registrarFUARequest","");
	    registrarFUARequest.AddAttribute("xmlns:v11","http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/");
	    CkXml paquete = registrarFUARequest.NewChild("v11:paquete","");
	    paquete.NewChild2("v11:nombreZip",fuazip);
	    paquete.NewChild2("v11:dataZip","cid:"+fuazip);
	    soapXml.GetRoot2();
	    soapXml.put_EmitXmlDecl(false);
	    String xmlBody = soapXml.getXml();
	    System.out.println(xmlBody);

	    CkHttpRequest req = new CkHttpRequest();
	    req.put_HttpVerb("POST");
	    req.AddHeader("Accept-Encoding","gzip,deflate");
	    req.AddHeader("User-Agent","Apache-HttpClient/4.1.1 (java 1.5)");
	    req.AddHeader("MIME-Version","1.0");
	    req.AddHeader("Connection","Keep-Alive");
	    req.put_Path("/cxf/esb/negocio/registroFUABatch/v1?wsdl");

	    req.put_ContentType("multipart/related; start=\"<rootpart@soapui.org>\"; start-info=\"text/xml\"; type=\"application/xop+xml\"");
	    req.AddHeader("SOAPAction","\"http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/registrarFUA\"");
	    
	    success = req.AddStringForUpload2("","",xmlBody,"utf-8","application/xop+xml; type=\"text/xml\"; charset=utf-8");
	    success = req.AddSubHeader(0,"Content-Transfer-Encoding","8bit");
	    success = req.AddSubHeader(0,"Content-ID","<rootpart@soapui.org>");

	    success = req.AddFileForUpload2("",zippath,"application/zip; name="+fuazip);
	    success = req.AddSubHeader(1,"Content-ID","<"+fuazip+">");
	    success = req.AddSubHeader(1,"Content-Transfer-Encoding","binary");
	    success = req.AddSubHeader(1,"Content-Disposition","attachment; name="+fuazip+"; filename="+fuazip);


	    http.put_FollowRedirects(true);

	    //  For debugging, set the SessionLogFilename property
	    //  to see the exact HTTP request and response in a log file.
	    //  (Given that the request contains binary data, you'll need an editor
	    //  that can gracefully view text + binary data.  I use EmEditor for most simple editing tasks..)
	    http.put_VerboseLogging(true);
	    //http.put_ProxyPort(8888);
	    //http.put_ProxyDomain("127.0.0.1");

	    CkHttpResponse resp;
	    boolean useTls = true;
	    resp = http.SynchronousRequest("pruebaws01.sis.gob.pe",443,useTls,req);
	    if (resp == null ) {
	        System.out.println(http.lastErrorText());
	        }
	    else {
	        CkXml xmlResponse = new CkXml();
	        success = xmlResponse.LoadXml(resp.bodyStr());
	        System.out.println(xmlResponse.getXml());

	    }
	}
	public SOAPMessage sendSOAPFUAZip(String fuazip,String zippath) {
		try{
			MessageFactory mf = MessageFactory.newInstance(SOAPConstants.SOAP_1_1_PROTOCOL);
			
			SOAPMessage soapm = mf.createMessage();
			SOAPPart soapp = soapm.getSOAPPart();
			SOAPEnvelope soape = soapp.getEnvelope();
			SOAPHeader soaph = soape.getHeader();
			SOAPElement soapel = soaph.addHeaderElement(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/","HeaderRequestType","v1"));
			soapel.addChildElement("canal").addTextNode("HOEMPESOA");
			soapel.addChildElement("usuario").addTextNode("HOEMPESOA");
			soapel.addChildElement("autorizacion").addTextNode("123456");
			SOAPBody soapb = soape.getBody();
			soapel = soapb.addBodyElement(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/","registrarFUARequest","v11"));
			soapel = soapel.addChildElement(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/","paquete","v11"));
			soapel.addChildElement(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/","nombreZip","v11")).addTextNode(fuazip);
			soapel.addChildElement(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/","dataZip","v11")).addTextNode("cid:"+fuazip);
	
	        final StringWriter sw = new StringWriter();
	        try {
	            TransformerFactory.newInstance().newTransformer().transform(
	                new DOMSource(soapm.getSOAPPart()),
	                new StreamResult(sw));
	        } catch (TransformerException e) {
	            throw new RuntimeException(e);
	        }
			PrintWriter writer = new PrintWriter(new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/soap.xml"));
			writer.print(sw.toString());
			writer.flush();
			writer.close();
			
			//Adding attachment
			//DataHandler dataHandler = new DataHandler(new URL("file:///"+zippath));
			AttachmentPart attachment = soapm.createAttachmentPart(Files.readAllBytes(new File(zippath).toPath()), "application/zip");
			attachment.setContentId(fuazip);
			soapm.addAttachmentPart(attachment);
			
			//Send SOAP request to SIS server
			SOAPConnectionFactory soapcf = SOAPConnectionFactory.newInstance();
			SOAPConnection soapc = soapcf.createConnection();
			//System.setProperty("http.proxyHost", "127.0.0.1");
			//System.setProperty("http.proxyPort", "8888");
			String url=MedwanQuery.getInstance().getConfigString("url_soasis","https://pruebaws01.sis.gob.pe/cxf/esb/negocio/registroFUABatch/v1?wsdl");
			SOAPMessage response = soapc.call(soapm, url);
			soapc.close();
	        return response;
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public String getPrettyPrint(SOAPMessage mresponse) throws Exception {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		mresponse.writeTo(os);
		byte[] bos = os.toByteArray();
		String r = new String(bos);
		Document document = DocumentHelper.parseText(r);
		OutputFormat format = OutputFormat.createPrettyPrint();
		StringWriter sw = new StringWriter();
	    XMLWriter writer = new XMLWriter(sw, format);
	    writer.write(document);
		return sw.toString();
	}
	
	private void exportFUA(FUA fua){
		exportAtencion(fua);
		exportDiagnosticos(fua);
		exportMedicamentos(fua);
		exportSMI(fua);
		exportInsumos(fua);
		exportProcedimientos(fua);
		exportServiciosAdicionales(fua);
	}
	
	private StringBuffer getResumen(int year, int month, String zipname,String batch){
		StringBuffer resumen = new StringBuffer();
		resumen.append(year+"\n");
		resumen.append(StringUtils.leftPad(month+"",2,"0")+"\n");
		resumen.append(batch+"\n");
		resumen.append(zipname+"\n");
		resumen.append(MedwanQuery.getInstance().getConfigString("FUAversion","0200")+"\n");
		resumen.append(StringUtils.countMatches(sbAtencion.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbSMI.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbDiagnosticos.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbMedicamentos.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbInsumos.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbProcedimientos.toString(),"\n")+"\n");
		resumen.append(StringUtils.countMatches(sbServiciosadicionales.toString(),"\n")+"\n");
		resumen.append("0\n");
		resumen.append("OPENCLINIC\n");
		resumen.append(MedwanQuery.getInstance().getConfigString("updateVersion")+"\n");
		resumen.append("1\n");
		resumen.append("1\n");
		resumen.append(MedwanQuery.getInstance().getConfigString("FUAResponsibleForTransmission","12345678")+"\n");
		return resumen;
	}
	
	private void writeFile(StringBuffer sb,String filename){
		File file = new File(MedwanQuery.getInstance().getConfigString("FUAFolder","/temp/fua")+"/"+filename);
		file.getParentFile().mkdirs();
		if(file.exists()){
			file.delete();
		}
		try {
			PrintWriter writer = new PrintWriter(file);
			writer.print(sb);
			writer.flush();
			writer.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	private void exportServiciosAdicionales(FUA fua){
		Vector serviciosadicionales = fua.serviciosAdicionales;
		for(int i=0;i<serviciosadicionales.size();i++){
			ServiciosAdicionales m = (ServiciosAdicionales)serviciosadicionales.elementAt(i);
			for(int n=1;n<3;n++){
				if(n>1){
					sbServiciosadicionales.append("|");
				}
				sbServiciosadicionales.append(exportValidate(n,"serviciosadicionales",m, fua));
			}
			sbServiciosadicionales.append("\n");
		}
	}
	
	private void exportProcedimientos(FUA fua){
		Vector procedimientos = fua.procedimientos;
		for(int i=0;i<procedimientos.size();i++){
			Procedimientos m = (Procedimientos)procedimientos.elementAt(i);
			for(int n=1;n<12;n++){
				if(n==6){
					continue;
				}
				if(n>1){
					sbProcedimientos.append("|");
				}
				sbProcedimientos.append(exportValidate(n,"procedimientos",m, fua));
			}
			sbProcedimientos.append("\n");
		}
	}
	
	private void exportInsumos(FUA fua){
		Vector insumos = fua.insumos;
		for(int i=0;i<insumos.size();i++){
			Insumos m = (Insumos)insumos.elementAt(i);
			for(int n=1;n<8;n++){
				if(n>1){
					sbInsumos.append("|");
				}
				sbInsumos.append(exportValidate(n,"insumos",m, fua));
			}
			sbInsumos.append("\n");
		}
	}
	
	private void exportSMI(FUA fua){
		Vector smi = fua.smi;
		for(int i=0;i<smi.size();i++){
			SMI m = (SMI)smi.elementAt(i);
			for(int n=1;n<4;n++){
				if(n>1){
					sbSMI.append("|");
				}
				sbSMI.append(exportValidate(n,"smi",m, fua));
			}
			sbSMI.append("\n");
		}
	}
	
	private void exportMedicamentos(FUA fua){
		Vector medicamentos = fua.medicamentos;
		for(int i=0;i<medicamentos.size();i++){
			Medicamentos m = (Medicamentos)medicamentos.elementAt(i);
			for(int n=1;n<8;n++){
				if(n>1){
					sbMedicamentos.append("|");
				}
				sbMedicamentos.append(exportValidate(n,"medicamentos",m, fua));
			}
			sbMedicamentos.append("\n");
		}
	}
	
	private void exportDiagnosticos(FUA fua){
		Vector diagnosticos = fua.diagnosticos;
		for(int i=0;i<diagnosticos.size();i++){
			Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
			for(int n=1;n<6;n++){
				if(n>1){
					sbDiagnosticos.append("|");
				}
				sbDiagnosticos.append(exportValidate(n,"diagnosticos",d, fua));
			}
			sbDiagnosticos.append("\n");
		}
	}
	
	private void exportAtencion(FUA fua){
		Atencion atencion = fua.atencion;
		for(int n=1;n<86;n++){
			if(n>1){
				sbAtencion.append("|");
			}
			sbAtencion.append(exportValidate(n,"atencion",fua.atencion, fua));
		}
		sbAtencion.append("\n");
	}
	
	private String exportValidate(int n,String table, SIS_Object sisObject, FUA fua){
		Element eTable = config.element(table);
		Element eExport = eTable.element("e"+n);
		String s = sisObject.getValueString(n).trim();
		if(intVal(eExport,"maxsize")>-1){
			if(s.length()>intVal(eExport,"maxsize")){
				System.out.println("ERROR: Field length "+table+"("+n+")> "+intVal(eExport,"maxsize"));
				return s.substring(0, intVal(eExport,"maxsize"));
			}
			else{
				return s;
			}
			
		}
		if(intVal(eExport,"size")>-1){
			if(s.length()<intVal(eExport,"size")){
				if(stringVal(eExport,"padleft").length()>0){
					s=StringUtils.leftPad(s, intVal(eExport,"size"),stringVal(eExport,"padleft"));
				}
				else if(stringVal(eExport,"padright").length()>0){
					s=StringUtils.rightPad(s, intVal(eExport,"size"),stringVal(eExport,"padright"));
				}
			}
			else if(s.length()>intVal(eExport,"size")){
				s=s.substring(0,intVal(eExport,"size"));
			}
			return s;
		}
		return s;
	}
	
	private int intVal(Element element,String attribute){
		if(ScreenHelper.checkString(element.attributeValue(attribute)).length()==0){
			return -1;
		}
		return Integer.parseInt(element.attributeValue(attribute));
	}
	
	private String stringVal(Element element, String attribute){
		return ScreenHelper.checkString(element.attributeValue(attribute));
	}
	
	public void loadFUAs(int year, int month) throws ParseException{
		fuas = new Vector();
		long day = 24*3600*1000;
		Date begin = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+month+"/"+year);
		Date end = new Date(begin.getTime()+32*day);
		end=new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/YYYY").format(end));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			ps = conn.prepareStatement("select * from sis_fua where sis_fua_date>=? and sis_fua_date<? and sis_fua_status = 'closed' and sis_fua_sentdatetime is null order by sis_fua_date");
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			rs = ps.executeQuery();
			while(rs.next()){
				FUA fua = FUA.get(rs.getString("sis_fua_serverid")+"."+rs.getString("sis_fua_objectid"));
				if(fua.getErrors().length()==0){
					fuas.add(fua);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();;
		}
		finally{
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}

	public void loadErrorFUAs(int year, int month) throws ParseException{
		fuas = new Vector();
		long day = 24*3600*1000;
		Date begin = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+month+"/"+year);
		Date end = new Date(begin.getTime()+32*day);
		end=new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/YYYY").format(end));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			ps = conn.prepareStatement("select * from sis_fua where sis_fua_date>=? and sis_fua_date<? and sis_fua_status = 'closed' and sis_fua_sentdatetime is null order by sis_fua_date");
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			rs = ps.executeQuery();
			while(rs.next()){
				FUA fua = FUA.get(rs.getString("sis_fua_serverid")+"."+rs.getString("sis_fua_objectid"));
				if(fua.getErrors().length()>0){
					fuas.add(fua);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();;
		}
		finally{
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}

	public Vector getFuas() {
		return fuas;
	}

	public void setFuas(Vector fuas) {
		this.fuas = fuas;
	}

}
