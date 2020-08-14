package be.openclinic.reporting;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;

import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Namespace;
import org.dom4j.QName;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;
import pe.gob.susalud.jr.transaccion.susalud.bean.InConAse270;
import pe.gob.susalud.jr.transaccion.susalud.bean.InConNom271;
import pe.gob.susalud.jr.transaccion.susalud.service.ConNom271Service;
import pe.gob.susalud.jr.transaccion.susalud.service.imp.*;

public class SUSALUD {
	 
	public static InConNom271 getAffiliationInformation(int personid, String iafas){
		InConNom271 patientData = new InConNom271();
		//Todo: get patient information from AdminPerson
		AdminPerson person = AdminPerson.getAdminPerson(personid+"");
		ConAse270ServiceImpl impl = new ConAse270ServiceImpl();
		InConAse270 inConAse = new InConAse270();
		inConAse.setNoTransaccion("270_CON_ASE");
		inConAse.setIdRemitente(MedwanQuery.getInstance().getConfigString("susalud.ipressid","00008215")); //IPRESS
		inConAse.setIdReceptor(iafas);
		inConAse.setFeTransaccion(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())); 
		inConAse.setHoTransaccion(new SimpleDateFormat("HHmmss").format(new java.util.Date()));
		inConAse.setIdCorrelativo(MedwanQuery.getInstance().getOpenclinicCounter("270_CON_ASE")+"");
		inConAse.setIdTransaccion("270");
		inConAse.setTiFinalidad("13");
		inConAse.setCaRemitente("2");
		inConAse.setNuRucRemitente(MedwanQuery.getInstance().getConfigString("susalud.ipressruc","20601978572"));
		inConAse.setTxRequest("CC"); //271_CON_COD
		inConAse.setCaReceptor("2");
		inConAse.setCaPaciente("1");
		inConAse.setCoProducto("1");
		//inConAse.setApPaternoPaciente(person.getLastnameFather());
		inConAse.setTiDocumento("1"); //1=DNI
		inConAse.setNuDocumento(person.getID("natreg")); //DNI number
		String x12n = impl.beanToX12N(inConAse);
		try {
			PrintWriter writer = new PrintWriter("c:/aaa/x12n.txt", "UTF-8");
			writer.print(x12n);
			writer.close();
			String soapResponse = sendSOAPMessage(x12n,iafas);
			processSOAPResponse(patientData, soapResponse);
			//TODO: process response in order to see if any errors occurred
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return patientData;
	}
	
	public static void processSOAPResponse(InConNom271 patientData, String soapResponse) throws DocumentException, FileNotFoundException, UnsupportedEncodingException{
		Namespace soapenv = new Namespace("soapenv","http://schemas.xmlsoap.org/soap/envelope/");
		Namespace wsp = new Namespace("wsp","http://www.susalud.gob.pe/acreditacion/WSPasarelaSuSalud/");
		Namespace wsse = new Namespace("wsse","http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd");
		Namespace wsu = new Namespace("wsu","http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd");
		Namespace ns1 = new Namespace("NS1","http://www.susalud.gob.pe/acreditacion/WSPasarelaSuSalud/");
		Document doc = DocumentHelper.parseText(soapResponse);
		PrintWriter writer = new PrintWriter("c:/aaa/error.xml", "UTF-8");
		writer.print(doc.asXML());
		writer.close();
		Element root = doc.getRootElement();
		Element header = root.element(new QName("Header",soapenv));
		Element body = root.element(new QName("Body",soapenv));
		if(body!=null){
			Element response = body.element(new QName("getConsultaAsegCodResponse",ns1));
			if(response!=null){
				Element error=response.element("coError");
				if(error==null || ScreenHelper.checkString(error.getText()).length()==0){
					Element insuranceData = response.element(new QName("txRepuesta",soapenv));
					if(insuranceData!=null){
						ConNom271ServiceImpl impl = new ConNom271ServiceImpl();
						patientData=impl.x12NToBean(insuranceData.getText());
					}
				}
				else{
					patientData.setNuControl("99");
					patientData.setNuControlST(error.getText());
				}
			}
		}
	}
	
	public static String sendSOAPMessage(String x12n, String iafas) throws ClientProtocolException, IOException{
		Namespace soapenv = new Namespace("soapenv","http://schemas.xmlsoap.org/soap/envelope/");
		Namespace sch = new Namespace("sch","http://www.susalud.gob.pe/ws/siteds/schemas");
		Namespace wsse = new Namespace("wsse","http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd");
		Namespace wsu = new Namespace("wsu","http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd");
		Document doc = DocumentHelper.createDocument();
		Element root = DocumentHelper.createElement("soapenv:Envelope");
		doc.setRootElement(root);
		root.addAttribute("xmlns:soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
		root.addAttribute("xmlns:sch", "http://www.susalud.gob.pe/ws/siteds/schemas");
		
		//Create SOAP header
		Element header = root.addElement(new QName("Header",soapenv));
		Element security = header.addElement(new QName("Security",wsu));
		security.addAttribute(new QName("mustUnderstand",soapenv), "1");
		security.addAttribute("xmlns:wsse", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd");
		security.addAttribute("xmlns:wsu", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd");
		Element user = security.addElement(new QName("UsernameToken",wsse));
		user.addAttribute(new QName("Id",wsu), MedwanQuery.getInstance().getConfigString("susalud.usernametoken","UsernameToken-0E7A7BE10245323DE31478700786050125"));
		Element username = user.addElement(new QName("Username",wsse));
		username.setText(MedwanQuery.getInstance().getConfigString("susalud.username","hosp_emer_pedi"));
		Element userpassword = user.addElement(new QName("Password",wsse));
		userpassword.addAttribute("Type", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText");
		userpassword.setText(MedwanQuery.getInstance().getConfigString("susalud.password","m/ewc1tk2EJlticYxOz+rP4sTeiruvfMQIuz8RAVtNepMbGMIxfB4nGhpejXnRDUrGxJlbbA34m01ADtU3904vvkTiWo3rFuO33xuoObWbJT98dv24DJEhTjq0i9vb4h9Q0eI+yy2NT7dFNasYGz10+gMx57K3r7bF7AMxb3EAs=|ss33s1l8083a948s910ul7su3l313u0l99224ulls121533s8u321s73s2ss1909|q6pghGZ1cyqhXcNTH6NbzA=="));
		Element usernonce = user.addElement(new QName("Nonce",wsse));
		usernonce.addAttribute("EncodingType", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary");
		//Generate a random text and Base64 encode it
		String random = org.apache.commons.codec.binary.Base64.encodeBase64String((""+new java.util.Date().getTime()).getBytes());
		usernonce.setText(random);
		Element usercreated = user.addElement(new QName("Created",wsu));
		usercreated.setText(new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())+"T"+new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+"Z");

		//Create SOAP body
		Element body = root.addElement(new QName("Body",soapenv));
		Element req = body.addElement(new QName("getConsultaAsegCodRequest",sch));
		Element name = req.addElement(new QName("txNombre",sch));
		name.setText("270_CON_ASE");
		Element insurer = req.addElement(new QName("coIafa",sch));
		insurer.setText(iafas);  
		Element payload = req.addElement(new QName("txPeticion",sch));
		payload.setText(x12n);
		Element exception = req.addElement(new QName("coExcepcion",sch));
		exception.setText("0000");
		
		//Send SOAP message to SUSALUD server
		String url=MedwanQuery.getInstance().getConfigString("susalud.webserviceurl","http://200.48.4.27:7805/siteds_ws/SitedsService?wsdl");
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost(url);
		PrintWriter writer = new PrintWriter("c:/aaa/x12n.xml", "UTF-8");
		writer.print(doc.asXML());
		writer.close();
	    StringEntity stringEntity = new StringEntity(doc.asXML(), "UTF-8");
	    stringEntity.setChunked(true);
	    httpPost.setEntity(stringEntity);
	    httpPost.addHeader("Accept", "text/xml");

	    CloseableHttpResponse resp = client.execute(httpPost);
	    HttpEntity entity = resp.getEntity();
	    if(entity!=null){
	    	return EntityUtils.toString(entity);
	    }
	    else{
	    	return null;
	    }
	}
}
