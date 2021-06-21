package be.openclinic.assets;

import be.openclinic.archiving.ArchiveDocument;
import be.openclinic.common.OC_Object;
import be.openclinic.system.SH;
import be.openclinic.util.Nomenclature;
import net.admin.Service;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.ScreenHelper;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.apache.commons.io.FileUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;


public class Asset extends OC_Object {
	public static final int INFRASTRUCTURE=0,EQUIPMENT=1;
    public int serverId;
    public int objectId;    

    public String code;
    public String gmdncode;
    public String parentUid;
    public String description; // OC_LABELS.OC_LABEL_ID
    public String serialnumber;
    public double quantity;
    public String assetType;
    public String supplierUid;
    public java.util.Date purchaseDate;
    public double purchasePrice;
    public String receiptBy;
    public String purchaseDocuments;
    public String writeOffMethod;
    public int writeOffPeriod; // years
    public String annuity;
    public String serviceuid;
    public String characteristics;
    public String accountingCode;
    public String gains; // xml : date, value
    public String losses; // xml : date, value
    public String residualValueHistory; // calculated, not in DB
    
    //*** loan ***
    public java.util.Date loanDate;
    public double loanAmount;
    public String loanInterestRate;
    public String loanReimbursementPlan; // date,capital,interest,totalAmount
    public double loanReimbursementAmount; // calculated, not in DB
    public String loanComment;
    public String loanDocuments;
    public String nomenclature;
    public String comment1;
    public String comment2;
    public String comment3;
    public String comment4;
    public String comment5;
    public String comment6;
    public String comment7;
    public String comment8;
    public String comment9;
    public String comment10;
    public String comment11;
    public String comment12;
    public String comment13;
    public String comment14;
    public String comment15;
    public String comment16;
    public String comment17;
    public String comment18;
    public String comment19;
    public String comment20;
    
    public java.util.Date saleDate;
    public double saleValue;
    public String saleClient;
    public int lockedBy;
    
    public java.util.Date lockeddate;
    
    public java.util.Date getLockeddate() {
		return lockeddate;
	}

	public void setLockeddate(java.util.Date lockeddate) {
		this.lockeddate = lockeddate;
	}

	public int getLockedBy() {
		return lockedBy;
	}

	public void setLockedBy(int lockedBy) {
		this.lockedBy = lockedBy;
	}
	
	public static String convertNegativeIds(String xml){
		String s = "";
        SAXReader reader = new SAXReader(false);
		try {
            Document document = reader.read(new StringReader(xml.toString()));
            Element rootElement = document.getRootElement(); //gmao
            Iterator iElements = rootElement.elementIterator();
            while(iElements.hasNext()){
            	Element eElement = (Element)iElements.next();
            	if(eElement.getName().equalsIgnoreCase("asset")){
            		eElement.addAttribute("newid", MedwanQuery.getInstance().getOpenclinicCounter("OC_ASSETS")+"");
            	}
            	else if(eElement.getName().equalsIgnoreCase("maintenanceplan")){
            		eElement.addAttribute("newid", MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEPLANS")+"");
            	}
            	else if(eElement.getName().equalsIgnoreCase("maintenanceoperation")){
            		eElement.addAttribute("newid", MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEOPERATIONS")+"");
            	}
            	else if(eElement.getName().equalsIgnoreCase("assetcomponent")){
            		eElement.addAttribute("newid", MedwanQuery.getInstance().getOpenclinicCounter("ComponentObjectId")+"");
            	}
            	else if(eElement.getName().equalsIgnoreCase("document")){
            		int newid=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
            		String newudi=ArchiveDocument.generateUDI(newid);
            		eElement.addAttribute("newid", newid+"");
            		eElement.addAttribute("newudi", newudi+"");
            		eElement.addAttribute("newfile", eElement.attributeValue("oldfile").replaceAll(eElement.attributeValue("udi"), newudi));
            	}
            }
            s=document.asXML();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return s;
	}
	
	public static boolean checkOutAssetsForService(String serviceid, int serverid){
		boolean bSuccess=true;
		String allChildren=Service.getChildIdsAsString(serviceid);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	Connection conna = MedwanQuery.getInstance().getAdminConnection();
    	try{
    		PreparedStatement psa = conna.prepareStatement("update services set defaultcontext=? where serviceid in("+allChildren+")");
    		psa.setString(1, serverid+"");
    		psa.execute();
    		psa.close();
    		conna.close();
    		MedwanQuery.getInstance().services.clear();
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+allChildren+")");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			Asset.checkOutAsset(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"),serverid);
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		bSuccess=false;
    		e.printStackTrace();
    	}
    	return bSuccess;
	}
	public static void checkOutAsset(String uid) throws NumberFormatException, SQLException{
		checkOutAsset(uid,MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100));
	}
	public static void checkOutAsset(String uid, int serverid) throws NumberFormatException, SQLException{
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("update oc_assets set oc_asset_lockedby=?,oc_asset_lockeddate=? where oc_asset_serverid=? and oc_asset_objectid=?");
		ps.setInt(1, serverid);
		ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		ps.setInt(3, Integer.parseInt(uid.split("\\.")[0]));
		ps.setInt(4, Integer.parseInt(uid.split("\\.")[1]));
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_lockedby=? where oc_maintenanceplan_assetuid=?");
		ps.setInt(1, serverid);
		ps.setString(2, uid);
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("update oc_maintenanceoperations,oc_maintenanceplans set oc_maintenanceoperation_lockedby=oc_maintenanceplan_lockedby"
				+ " where oc_maintenanceplan_objectid=replace(oc_maintenanceoperation_maintenanceplanuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"
				+ " oc_maintenanceplan_assetuid=?");
		ps.setString(1, uid);
		ps.execute();
		ps.close();
		conn.close();
	}
	
	public static void checkInAssetsForService(String serviceid, int serverid){
		String allChildren=Service.getChildIdsAsString(serviceid);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+allChildren+")");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			Asset.checkInAsset(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"),serverid);
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
	}
	public static void checkInAssetsForServerId(int serverid){
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	Connection conna = MedwanQuery.getInstance().getAdminConnection();
    	try{
    		PreparedStatement psa = conna.prepareStatement("update services set defaultcontext='' where defaultcontext=?");
    		psa.setString(1, serverid+"");
    		psa.execute();
    		psa.close();
    		conna.close();
    		MedwanQuery.getInstance().services.clear();
    		PreparedStatement ps = conn.prepareStatement("select distinct oc_asset_serverid,oc_asset_objectid from oc_assets where oc_asset_lockedby=? or "
    				+ " exists (select * from oc_maintenanceplans where oc_maintenanceplan_lockedby=? and oc_maintenanceplan_assetuid=oc_asset_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_asset_objectid) or"
    				+ " exists (select * from oc_maintenanceoperations,oc_maintenanceplans  where oc_maintenanceoperation_maintenanceplanuid=oc_maintenanceplan_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_maintenanceplan_objectid and oc_maintenanceoperation_lockedby=? and oc_maintenanceplan_assetuid=oc_asset_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_asset_objectid)");
    		ps.setInt(1, serverid);
    		ps.setInt(2, serverid);
    		ps.setInt(3, serverid);
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			Asset.checkInAsset(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"),serverid);
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
	}
	public static void checkInAsset(String uid){
		checkInAsset(uid,MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100));
	}
	public static void checkInAsset(String uid, int serverid){
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("update oc_assets set oc_asset_lockedby=-1,oc_asset_lockeddate=null where oc_asset_serverid=? and oc_asset_objectid=?");
    		ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
    		ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
    		ps.execute();
    		ps.close();
    		ps = conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_lockedby=-1 where oc_maintenanceplan_assetuid=?");
    		ps.setString(1, uid);
    		ps.execute();
    		ps.close();
    		ps = conn.prepareStatement("update oc_maintenanceoperations,oc_maintenanceplans set oc_maintenanceoperation_lockedby=-1"
    				+ " where oc_maintenanceplan_objectid=replace(oc_maintenanceoperation_maintenanceplanuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"
    				+ " oc_maintenanceplan_assetuid=?");
    		ps.setString(1, uid);
    		ps.execute();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
	}
	
	public static StringBuffer toXmlForService(String serviceid){
		StringBuffer xml = new StringBuffer();
		xml.append("<gmao>");
		String allChildren=Service.getChildIdsAsString(serviceid);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+allChildren+")");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			xml.append(Asset.toXml(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid")));
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
		xml.append("</gmao>");
		return xml;
	}
	
	public static StringBuffer toXmlForServiceUnlocked(String serviceid){
		StringBuffer xml = new StringBuffer();
		xml.append("<gmao serviceid='"+serviceid+"'>");
		String allChildren=Service.getChildIdsAsString(serviceid);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+allChildren+") and (oc_asset_lockedby is null or oc_asset_lockedby<0)");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			xml.append(Asset.toXml(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid")));
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
		xml.append("</gmao>");
		return xml;
	}
	
	public static void checkOutForService(String serviceid){
		String allChildren=Service.getChildIdsAsString(serviceid);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+allChildren+")");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			Asset.checkOutAsset(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"));
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
	}
	
	public static Vector getCheckedOutAssetUids(){
		Vector uids = new Vector();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select distinct oc_asset_serverid,oc_asset_objectid from oc_assets where oc_asset_lockedby=? or "
    				+ " exists (select * from oc_maintenanceplans where oc_maintenanceplan_lockedby=? and oc_maintenanceplan_assetuid=oc_asset_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_asset_objectid) or"
    				+ " exists (select * from oc_maintenanceoperations,oc_maintenanceplans  where oc_maintenanceoperation_maintenanceplanuid=oc_maintenanceplan_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_maintenanceplan_objectid and oc_maintenanceoperation_lockedby=? and oc_maintenanceplan_assetuid=oc_asset_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_asset_objectid)");
    		ps.setInt(1, MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100));
    		ps.setInt(2, MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100));
    		ps.setInt(3, MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100));
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()){
    			uids.add(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"));
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
		return uids;
	}
	
	public static boolean hasNegativeIds(){
		boolean bHasNegativeIds = false;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select (select count(*) from oc_assets where oc_asset_objectid<0)+"
    				+ "(select count(*) from arch_documents where arch_document_category in ('asset','maintenanceplan') and arch_document_objectid<0 and arch_document_storagename is not null and arch_document_storagename<>'')+"
    				+ "(select count(*) from oc_maintenanceplans where oc_maintenanceplan_objectid<0)+"
    				+ "(select count(*) from oc_maintenanceoperations where oc_maintenanceoperation_objectid<0)+"
    				+ "(select count(*) from oc_assetcomponents where oc_component_objectid<0) total");
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			bHasNegativeIds=rs.getInt("total")>0;
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
		return bHasNegativeIds;
	}
	
	public static boolean updateNegativeIds(String xml){
		boolean bSuccess=true;
        SAXReader reader = new SAXReader(false);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
            Document document = reader.read(new StringReader(xml.toString()));
            Element rootElement = document.getRootElement(); //gmao
            Iterator iElements = rootElement.elementIterator();
            while(iElements.hasNext()){
            	Element eElement = (Element)iElements.next();
            	if(eElement.getName().equalsIgnoreCase("asset")){
            		PreparedStatement ps = conn.prepareStatement("update oc_assets set oc_asset_objectid=? where oc_asset_objectid=?");
            		ps.setInt(1, Integer.parseInt(eElement.attributeValue("newid")));
            		ps.setInt(2, Integer.parseInt(eElement.attributeValue("objectid")));
            		ps.execute();
            		ps.close();
            		ps = conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_assetuid=? where oc_maintenanceplan_assetuid=?");
            		ps.setString(1, "1."+eElement.attributeValue("newid"));
            		ps.setString(2, "1."+eElement.attributeValue("objectid"));
            		ps.execute();
            		ps.close();
            		ps = conn.prepareStatement("update oc_assetcomponents set oc_component_assetuid=? where oc_component_assetuid=?");
            		ps.setString(1, "1."+eElement.attributeValue("newid"));
            		ps.setString(2, "1."+eElement.attributeValue("objectid"));
            		ps.execute();
            		ps.close();
            		ps = conn.prepareStatement("update arch_documents set arch_document_reference=replace(arch_document_reference,?,?) where arch_document_reference = 'asset.1."+eElement.attributeValue("objectid")+"'");
            		ps.setString(1, "1."+eElement.attributeValue("objectid"));
            		ps.setString(2, "1."+eElement.attributeValue("newid"));
            		ps.execute();
            		ps.close();
            	}
            	else if(eElement.getName().equalsIgnoreCase("maintenanceplan")){
            		PreparedStatement ps = conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_objectid=? where oc_maintenanceplan_objectid=?");
            		ps.setInt(1, Integer.parseInt(eElement.attributeValue("newid")));
            		ps.setInt(2, Integer.parseInt(eElement.attributeValue("objectid")));
            		ps.execute();
            		ps.close();
            		ps = conn.prepareStatement("update oc_maintenanceoperations set oc_maintenanceoperation_maintenanceplanuid=? where oc_maintenanceoperation_maintenanceplanuid=?");
            		ps.setString(1, "1."+eElement.attributeValue("newid"));
            		ps.setString(2, "1."+eElement.attributeValue("objectid"));
            		ps.execute();
            		ps.close();
            		ps = conn.prepareStatement("update arch_documents set arch_document_reference=replace(arch_document_reference,?,?) where arch_document_reference = 'maintenanceplan.1."+eElement.attributeValue("objectid")+"'");
            		ps.setString(1, "1."+eElement.attributeValue("objectid"));
            		ps.setString(2, "1."+eElement.attributeValue("newid"));
            		ps.execute();
            		ps.close();
            	}
            	else if(eElement.getName().equalsIgnoreCase("maintenanceoperation")){
            		PreparedStatement ps = conn.prepareStatement("update oc_maintenanceoperations set oc_maintenanceoperation_objectid=? where oc_maintenanceoperation_objectid=?");
            		ps.setInt(1, Integer.parseInt(eElement.attributeValue("newid")));
            		ps.setInt(2, Integer.parseInt(eElement.attributeValue("objectid")));
            		ps.execute();
            		ps.close();
            	}
            	else if(eElement.getName().equalsIgnoreCase("assetcomponent")){
            		PreparedStatement ps = conn.prepareStatement("update oc_assetcomponents set oc_component_objectid=? where oc_component_objectid=?");
            		ps.setInt(1, Integer.parseInt(eElement.attributeValue("newid")));
            		ps.setInt(2, Integer.parseInt(eElement.attributeValue("objectid")));
            		ps.execute();
            		ps.close();
            	}
            	else if(eElement.getName().equalsIgnoreCase("document")){
            		PreparedStatement ps = conn.prepareStatement("update arch_documents set arch_document_udi=?,arch_document_storagename=replace(arch_document_storagename,?,?),arch_document_objectid=? where arch_document_objectid=?");
            		ps.setString(1, eElement.attributeValue("newudi"));
            		ps.setString(2, eElement.attributeValue("udi"));
            		ps.setString(3, eElement.attributeValue("newudi"));
            		ps.setInt(4, Integer.parseInt(eElement.attributeValue("newid")));
            		ps.setInt(5, Integer.parseInt(eElement.attributeValue("objectid")));
            		ps.execute();
            		ps.close();
            		//We must also update the physical filename on disk
    				String sFileStore=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo")+"/";
    				Debug.println("Moving file from "+sFileStore+eElement.attributeValue("oldfile")+" to "+sFileStore+eElement.attributeValue("newfile"));
    				try{
    					FileUtils.moveFile(new File(sFileStore+eElement.attributeValue("oldfile")), new File(sFileStore+eElement.attributeValue("newfile")));
    				}
    				catch(Exception e){
    					e.printStackTrace();
    				}
    				if(new File(sFileStore+eElement.attributeValue("newfile")).exists()){
    					Debug.println("Move successful");
    				}
    				else{
    					Debug.println("ERROR moving file");
    				}
            	}
            }
            conn.close();
		} catch (Exception e) {
			bSuccess=false;
			e.printStackTrace();
		}
		return bSuccess;
	}
	
	public static boolean sendDocumentsToServer(){
		boolean bSuccess = true;
        SAXReader reader = new SAXReader(false);
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		CloseableHttpClient client = HttpClients.createDefault();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from arch_documents where arch_document_storagename is not null and arch_document_storagename<>'' and arch_document_tran_serverid=-1 and arch_document_objectid>-1");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
        		String sStorageName=rs.getString("arch_document_storagename");
        		String sFilename=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo")+"/"+sStorageName;
        		File file = new File(sFilename);
        		if(file.exists()){
            		HttpPost post = new HttpPost(MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/storeDocument.jsp");
            		MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            		builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
            		builder.addBinaryBody("filename", file, ContentType.DEFAULT_BINARY, sFilename);
            		String sFolder = "";
            		if(sStorageName.contains("/")){
            			sFolder=sStorageName.substring(0,sStorageName.lastIndexOf("/"))+"/";
            		}
            		builder.addTextBody("folder", sFolder, ContentType.DEFAULT_BINARY);
            		HttpEntity entity = builder.build();
            		post.setEntity(entity);
            		HttpResponse r = client.execute(post);
            	    String xmlIn=new BasicResponseHandler().handleResponse(r);
            	    if(xmlIn.contains("<OK>")){
            	    	Debug.println("File successuflly sent");
            	    	PreparedStatement ps2 = conn.prepareStatement("update arch_documents set arch_document_tran_serverid=null where arch_document_objectid=?");
            	    	ps2.setInt(1, rs.getInt("arch_document_objectid"));
            	    	ps2.execute();
            	    	ps2.close();
            	    }
        		}
        		else{
            		Debug.println("File does not exist on local machine!!");
        	    	PreparedStatement ps2 = conn.prepareStatement("update arch_documents set arch_document_tran_serverid=null where arch_document_objectid=?");
        	    	ps2.setInt(1, rs.getInt("arch_document_objectid"));
        	    	ps2.execute();
        	    	ps2.close();
        		}
            }
			rs.close();
			ps.close();
            conn.close();
		} catch (Exception e) {
			bSuccess=false;
			e.printStackTrace();
		}
		return bSuccess;
	}
	
	public static StringBuffer getNegativeIds(){
		StringBuffer xml = new StringBuffer();
		xml.append("<gmao>");
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_objectid<0");
    		ResultSet rs =ps.executeQuery();
    		while(rs.next()){
    			xml.append("<asset objectid='"+rs.getInt("oc_asset_objectid")+"'/>");
    		}
    		rs.close();
    		ps.close();
    		ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_objectid<0");
    		rs =ps.executeQuery();
    		while(rs.next()){
    			xml.append("<maintenanceplan objectid='"+rs.getInt("oc_maintenanceplan_objectid")+"'/>");
    		}
    		rs.close();
    		ps.close();
    		ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_objectid<0");
    		rs =ps.executeQuery();
    		while(rs.next()){
    			xml.append("<maintenanceoperation objectid='"+rs.getInt("oc_maintenanceoperation_objectid")+"'/>");
    		}
    		rs.close();
    		ps.close();
    		ps = conn.prepareStatement("select * from oc_assetcomponents where oc_component_objectid<0");
    		rs =ps.executeQuery();
    		while(rs.next()){
    			xml.append("<assetcomponent objectid='"+rs.getInt("oc_component_objectid")+"'/>");
    		}
    		rs.close();
    		ps.close();
    		ps = conn.prepareStatement("select * from arch_documents where arch_document_category in ('asset','maintenanceplan') and arch_document_objectid<0 and arch_document_storagename is not null and arch_document_storagename<>''");
    		rs =ps.executeQuery();
    		while(rs.next()){
    			xml.append("<document oldfile='"+rs.getString("arch_document_storagename")+"' udi='"+rs.getString("arch_document_udi")+"' objectid='"+rs.getString("arch_document_objectid")+"'/>");
    		}
    		rs.close();
    		ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		xml.append("</gmao>");
		return xml;
	}

	// search-criteria
    public java.util.Date purchasePeriodBegin, purchasePeriodEnd;
    
    public static void updateAsset(Element eAsset) throws Exception{
    	int serverid = Integer.parseInt(eAsset.attributeValue("serverid"));
    	int objectid = Integer.parseInt(eAsset.attributeValue("objectid"));
    	java.util.Date updatetime = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(eAsset.element("updatetime").getTextTrim());
    	//First we check if this asset record has been changed
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_serverid=? and oc_asset_objectid=? and oc_asset_updatetime=?");
		ps.setInt(1, serverid);
		ps.setInt(2, objectid);
		ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
		ResultSet rs =ps.executeQuery();
		if(!rs.next()){
			//The record has changed. Let's update it
    		rs.close();
    		ps.close();
			ps = conn.prepareStatement("select * from oc_assets where oc_asset_serverid=? and oc_asset_objectid=?");
    		ps.setInt(1, serverid);
    		ps.setInt(2, objectid);
    		rs =ps.executeQuery();
    		if(!rs.next()){
    			//The record does not exist yet, create it
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("insert into oc_assets(oc_asset_serverid,oc_asset_objectid) values(?,?)");
        		ps.setInt(1, serverid);
        		ps.setInt(2, objectid);
    			ps.execute();
    		}
			Asset asset = new Asset();
			asset.setUid(serverid+"."+objectid);
			asset.setServerId(serverid);
			asset.setObjectId(objectid);
			asset.setAccountingCode(eAsset.element("accountingcode")==null?"":eAsset.element("accountingcode").getText());
			asset.setAnnuity(eAsset.element("annuity")==null?"":eAsset.element("annuity").getText());
			asset.setAssetType(eAsset.element("type")==null?"":eAsset.element("type").getText());
			asset.setCharacteristics(eAsset.element("characteristics")==null?"":eAsset.element("characteristics").getText());
			asset.setCode(eAsset.element("code")==null?"":eAsset.element("code").getText());
			asset.setComment1(eAsset.element("comment1")==null?"":eAsset.element("comment1").getText());
			asset.setComment2(eAsset.element("comment2")==null?"":eAsset.element("comment2").getText());
			asset.setComment3(eAsset.element("comment3")==null?"":eAsset.element("comment3").getText());
			asset.setComment4(eAsset.element("comment4")==null?"":eAsset.element("comment4").getText());
			asset.setComment5(eAsset.element("comment5")==null?"":eAsset.element("comment5").getText());
			asset.setComment6(eAsset.element("comment6")==null?"":eAsset.element("comment6").getText());
			asset.setComment7(eAsset.element("comment7")==null?"":eAsset.element("comment7").getText());
			asset.setComment8(eAsset.element("comment8")==null?"":eAsset.element("comment8").getText());
			asset.setComment9(eAsset.element("comment9")==null?"":eAsset.element("comment9").getText());
			asset.setComment10(eAsset.element("comment10")==null?"":eAsset.element("comment10").getText());
			asset.setComment11(eAsset.element("comment11")==null?"":eAsset.element("comment11").getText());
			asset.setComment12(eAsset.element("comment12")==null?"":eAsset.element("comment12").getText());
			asset.setComment13(eAsset.element("comment13")==null?"":eAsset.element("comment13").getText());
			asset.setComment14(eAsset.element("comment14")==null?"":eAsset.element("comment14").getText());
			asset.setComment15(eAsset.element("comment15")==null?"":eAsset.element("comment15").getText());
			asset.setComment16(eAsset.element("comment16")==null?"":eAsset.element("comment16").getText());
			asset.setComment17(eAsset.element("comment17")==null?"":eAsset.element("comment17").getText());
			asset.setComment18(eAsset.element("comment18")==null?"":eAsset.element("comment18").getText());
			asset.setComment19(eAsset.element("comment19")==null?"":eAsset.element("comment19").getText());
			asset.setComment20(eAsset.element("comment20")==null?"":eAsset.element("comment20").getText());
			asset.setDescription(eAsset.element("description")==null?"":eAsset.element("description").getText());
			asset.setGains(eAsset.element("gains")==null?"":eAsset.element("gains").getText());
			asset.setGmdncode(eAsset.element("gmdncode")==null?"":eAsset.element("gmdncode").getText());
			asset.setLoanAmount(Double.parseDouble(eAsset.element("loanamount")==null?"0":eAsset.element("loanamount").getText()));
			asset.setLoanComment(eAsset.element("loancomment")==null?"":eAsset.element("loancomment").getText());
			asset.setLoanDate(eAsset.element("loandate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eAsset.element("loandate").getText()));
			asset.setLoanDocuments(eAsset.element("loandocuments")==null?"":eAsset.element("loandocuments").getText());
			asset.setLoanInterestRate(eAsset.element("loaninterestrate")==null?"":eAsset.element("loaninterestrate").getText());
			asset.setLoanReimbursementPlan(eAsset.element("loanreimbursementplan")==null?"":eAsset.element("loanreimbursementplan").getText());
			asset.setLockedBy(Integer.parseInt(eAsset.element("lockedby")==null?"0":eAsset.element("lockedby").getText()));
			asset.setLockeddate(eAsset.element("lockeddate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eAsset.element("lockeddate").getText()));
			asset.setLosses(eAsset.element("losses")==null?"":eAsset.element("losses").getText());
			asset.setNomenclature(eAsset.element("nomenclature")==null?"":eAsset.element("nomenclature").getText());
			asset.setParentUid(eAsset.element("parentuid")==null?"":eAsset.element("parentuid").getText());
			asset.setPurchaseDate(eAsset.element("purchasedate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eAsset.element("purchasedate").getText()));
			asset.setPurchaseDocuments(eAsset.element("purchasedocuments")==null?"":eAsset.element("purchasedocuments").getText());
			asset.setPurchasePrice(Double.parseDouble(eAsset.element("purchaseprice")==null?"0":eAsset.element("purchaseprice").getText()));
			asset.setQuantity(Integer.parseInt(eAsset.element("quantity")==null?"0":eAsset.element("quantity").getText()));
			asset.setReceiptBy(eAsset.element("purchasereceiptby")==null?"":eAsset.element("purchasereceiptby").getText());
			asset.setSaleClient(eAsset.element("saleclient")==null?"":eAsset.element("saleclient").getText());
			asset.setSaleValue(Double.parseDouble(eAsset.element("salevalue")==null?"0":eAsset.element("salevalue").getText()));
			asset.setServiceuid(eAsset.element("service")==null?"":eAsset.element("service").getText());
			asset.setSerialnumber(eAsset.element("serial")==null?"":eAsset.element("serial").getText());
			asset.setSupplierUid(eAsset.element("supplieruid")==null?"":eAsset.element("supplieruid").getText());
			asset.setUpdateDateTime(updatetime);
			asset.setWriteOffMethod(eAsset.element("writeoffmethod")==null?"":eAsset.element("writeoffmethod").getText());
			asset.setWriteOffPeriod(Integer.parseInt(eAsset.element("writeoffperiod")==null?"0":eAsset.element("writeoffperiod").getText()));
			asset.store(eAsset.element("updateid")==null?"":eAsset.element("updateid").getText());
			//Remove existing components
			rs.close();
			ps.close();
			ps = conn.prepareStatement("delete from oc_assetcomponents where oc_component_assetuid=?");
			ps.setString(1, asset.getUid());
			ps.execute();
			//Add components from XML
	    	Iterator iComponents = eAsset.element("components").elementIterator("component");
	    	while(iComponents.hasNext()){
	    		Element eComponent = (Element)iComponents.next();
				ps.close();
				ps = conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid) values (?,?,?,?,?,?)");
				ps.setString(1, asset.getUid());
				ps.setString(2, eComponent.element("nomenclature")==null?"":eComponent.element("nomenclature").getText());
				ps.setString(3, eComponent.element("type")==null?"":eComponent.element("type").getText());
				ps.setString(4, eComponent.element("characteristics")==null?"":eComponent.element("characteristics").getText());
				ps.setString(5, eComponent.element("status")==null?"":eComponent.element("status").getText());
				ps.setString(6, eComponent.element("objectid")==null?"":eComponent.element("objectid").getText());
				ps.execute();
	    	}
			//Add documents from XML
	    	Iterator iDocuments = eAsset.element("documents").elementIterator("document");
	    	while(iDocuments.hasNext()){
	    		Element eDocument = (Element)iDocuments.next();
	    		//First we check if the document already exists
	    		Debug.println("Received document UDI="+eDocument.elementText("udi"));
	    		rs.close();
	    		ps.close();
	    		ps=conn.prepareStatement("select * from arch_documents where arch_document_udi=?");
	    		ps.setString(1, eDocument.elementText("udi"));
	    		rs=ps.executeQuery();
	    		if(!rs.next()){
	    			//Insert the file record in arch_documents
    	    		Debug.println("Insert in arch_documents document UDI="+eDocument.elementText("udi"));
	    			rs.close();
    				ps.close();
    				ps = conn.prepareStatement("insert into arch_documents(arch_document_serverid,"
    						+ "arch_document_objectid,"
    						+ "arch_document_udi,"
    						+ "arch_document_title,"
    						+ "arch_document_description,"
    						+ "arch_document_category,"
    						+ "arch_document_author,"
    						+ "arch_document_date,"
    						+ "arch_document_destination,"
    						+ "arch_document_reference,"
    						+ "arch_document_personid,"
    						+ "arch_document_storagename,"
    						+ "arch_document_tran_serverid,"
    						+ "arch_document_tran_transactionid,"
    						+ "arch_document_deletedate,"
    						+ "arch_document_updatetime,"
    						+ "arch_document_updateid) "
    						+ "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    				ps.setString(1, eDocument.element("serverid")==null?"":eDocument.element("serverid").getText());
    				ps.setString(2, eDocument.element("objectid")==null?"":eDocument.element("objectid").getText());
    				ps.setString(3, eDocument.element("udi")==null?"":eDocument.element("udi").getText());
    				ps.setString(4, eDocument.element("title")==null?"":eDocument.element("title").getText());
    				ps.setString(5, eDocument.element("description")==null?"":eDocument.element("description").getText());
    				ps.setString(6, eDocument.element("category")==null?"":eDocument.element("category").getText());
    				ps.setString(7, eDocument.element("author")==null?"":eDocument.element("author").getText());
        			ps.setTimestamp(8, eDocument.element("date")==null?null:new java.sql.Timestamp(new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eDocument.element("date").getText()).getTime()));
    				ps.setString(9, eDocument.element("destination")==null?"":eDocument.element("destination").getText());
    				ps.setString(10, eDocument.element("reference")==null?"":eDocument.element("reference").getText());
    				ps.setString(11, eDocument.element("personid")==null?"":eDocument.element("personid").getText());
    				ps.setString(12, eDocument.element("storagename")==null?"":eDocument.element("storagename").getText());
    				ps.setString(13, eDocument.element("tran_serverid")==null?"":eDocument.element("tran_serverid").getText());
    				ps.setString(14, eDocument.element("tran_transactionid")==null?"":eDocument.element("tran_transactionid").getText());
        			ps.setTimestamp(15, eDocument.element("deletedate")==null?null:new java.sql.Timestamp(new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eDocument.element("deletedate").getText()).getTime()));
        			ps.setTimestamp(16, eDocument.element("updatetime")==null?null:new java.sql.Timestamp(new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eDocument.element("updatetime").getText()).getTime()));
    				ps.setString(17, eDocument.element("updateid")==null?"":eDocument.element("updateid").getText());
    				ps.execute();
	    		}
	    		//If this is a remote machine, then try to download the document from the server
	    		//If this is the server, document must be separately uploaded by the remote machine
	    		if(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)>0){
    				String sFilename=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo")+"/"+eDocument.elementText("storagename");
    				Debug.println("Checking existence of file "+sFilename);
    	    		File file = new File(sFilename);
    	    		if(!file.exists()){
        	    		Debug.println("File does not exist, downloading... ");
        				//Now get the file from the server and store it locally
        				String sServerDocumentStore=MedwanQuery.getInstance().getConfigString("GMAOCentralServerDocumentStore","http://localhost/openclinic/scan/to");
        				saveUrl(sFilename, sServerDocumentStore+"/"+eDocument.elementText("storagename"));
        	    		Debug.println("Checking existence after download of file "+sFilename);
	    	    		if(!file.exists()){
	        	    		Debug.println("File exists");
	    	    		}
	    	    		else{
	        	    		Debug.println("File still does not exist!!!");
	    	    		}
    	    		}
	    		}
	    	}
		}
		rs.close();
		ps.close();
		conn.close();
		Iterator iPlans = eAsset.element("maintenanceplans").elementIterator("maintenanceplan");
    	while(iPlans.hasNext()){
    		Element ePlan = (Element)iPlans.next();
    		try{
    			MaintenancePlan.updateMaintenanceplan(ePlan);
        	}
        	catch(Exception a){
        		a.printStackTrace();
        	}
    	}
    }
    
    public static void saveUrl(final String filename, final String urlString)
            throws MalformedURLException, IOException {
        BufferedInputStream in = null;
        FileOutputStream fout = null;
        String folder = filename.replaceAll("\\\\","/").substring(0,filename.lastIndexOf("/"));
        if(!new File(folder).exists()){
        	new File(folder).mkdirs();
        }
        try {
            in = new BufferedInputStream(new URL(urlString).openStream());
            fout = new FileOutputStream(filename);

            final byte data[] = new byte[1024];
            int count;
            while ((count = in.read(data, 0, 1024)) != -1) {
                fout.write(data, 0, count);
            }
        } finally {
            if (in != null) {
                in.close();
            }
            if (fout != null) {
                fout.close();
            }
        }
    }
    
    public static boolean storeXml(StringBuffer xml) throws DocumentException{
    	boolean bSuccess = true;
    	//For each od thes assets, maintenanceplans and maintenanceoperations, 
    	//store only if the updatetime has changed (if the record has been modified)
        SAXReader reader = new SAXReader(false);
        Document document = reader.read(new StringReader(xml.toString()));
        Element rootElement = document.getRootElement(); //gmao
        Iterator iAssets = rootElement.elementIterator("asset");
        while(iAssets.hasNext()){
        	Element eAsset = (Element)iAssets.next();
        	try{
        		updateAsset(eAsset);
        	}
        	catch(Exception a){
        		a.printStackTrace();
        	}
        }
		return bSuccess;
    }
    
    //--- CONSTRUCTOR ---
    public Asset(){
        serverId = -1;
        objectId = -1;

        code = "";
        gmdncode ="";
        parentUid = "";
        description = "";
        serialnumber = "";
        quantity = 1; // default
        assetType = "";
        supplierUid = "";
        purchaseDate = null;
        purchasePrice = 0;
        receiptBy = "";
        purchaseDocuments = "";
        writeOffMethod = "";
        writeOffPeriod = 0;
        annuity = "";
        characteristics = "";
        accountingCode = "";
        gains = "";
        losses = "";
        serviceuid="";
        residualValueHistory = "";
        
        //*** loan ***
        loanDate = null;
        loanAmount = 0;
        loanInterestRate = ""; // text !
        loanReimbursementPlan = "";
        loanReimbursementAmount = 0;
        loanComment = "";
        loanDocuments = "";
        
        saleDate = null;
        saleValue = 0;
        saleClient = "";       
        nomenclature ="";
        comment1="";
        comment2="";
        comment3="";
        comment4="";
        comment5="";
        comment6="";
        comment7="";
        comment8="";
        comment9="";
        comment10="";
        comment11="";
        comment12="";
        comment13="";
        comment14="";
        comment15="";
        comment16="";
        comment17="";
        comment18="";
        comment19="";
        comment20="";
        
        lockedBy=-1;
        lockeddate=null;
    }
    
    public static void addTagString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_asset_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			//xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addTagBinaryString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_asset_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			xml.append("<"+tag+"><![CDATA["+HTMLEntities.xmlencode(s)+"]]></"+tag+">");
		}
    }
    
    public static void addTagDate(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
    	try{
	    	java.util.Date d = rs.getTimestamp("oc_asset_"+tag);
	    	if(d!=null){
	    		xml.append("<"+tag+">"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(d)+"</"+tag+">");
	    	}
    	}
    	catch(Exception e){}
    }
    
    public static void addComponentTagString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_component_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			//xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addComponentTagBinaryString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_component_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			//xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addComponentTagDate(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
    	try{
    		java.util.Date d = rs.getTimestamp("oc_component_"+tag);
	    	if(d!=null){
	    		xml.append("<"+tag+">"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(d)+"</"+tag+">");
	    	}
		}
		catch(Exception e){}
    }
    
    public static void addDocumentTagString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("arch_document_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			//xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addDocumentTagBinaryString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("arch_document_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			//xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addDocumentTagDate(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
    	try{
    		java.util.Date d = rs.getTimestamp("arch_document_"+tag);
	    	if(d!=null){
	    		xml.append("<"+tag+">"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(d)+"</"+tag+">");
	    	}
    	}
    	catch(Exception e){}
    }
    
    public static StringBuffer toXml(String uid){
    	StringBuffer xml = new StringBuffer();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_serverid=? and oc_asset_objectid=? and oc_asset_objectid>-1");
    		ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
    		ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			xml.append("<asset serverid='"+rs.getInt("oc_asset_serverid")+"' objectid='"+rs.getInt("oc_asset_objectid")+"'>");
    			addTagBinaryString(xml,"code",rs);
    			addTagString(xml,"parentuid",rs);
    			addTagBinaryString(xml,"description",rs);
    			addTagBinaryString(xml,"serial",rs);
    			addTagString(xml,"quantity",rs);
    			addTagBinaryString(xml,"type",rs);
    			addTagString(xml,"supplieruid",rs);
    			addTagDate(xml,"purchasedate",rs);
    			addTagString(xml,"purchaseprice",rs);
    			addTagString(xml,"purchasereceiptby",rs);
    			addTagString(xml,"purchasedocs",rs);
    			addTagString(xml,"writeoffmethod",rs);
    			addTagString(xml,"writeoffperiod",rs);
    			addTagString(xml,"annuity",rs);
    			addTagBinaryString(xml,"characteristics",rs);
    			addTagBinaryString(xml,"accountingcode",rs);
    			addTagString(xml,"gains",rs);
    			addTagString(xml,"losses",rs);
    			addTagDate(xml,"loandate",rs);
    			addTagString(xml,"loanamount",rs);
    			addTagString(xml,"loaninterestrate",rs);
    			addTagString(xml,"loanreimbursementplan",rs);
    			addTagBinaryString(xml,"loancomment",rs);
    			addTagString(xml,"loandocs",rs);
    			addTagDate(xml,"saledate",rs);
    			addTagString(xml,"salevalue",rs);
    			addTagString(xml,"saleclient",rs);
    			addTagDate(xml,"updatetime",rs);
    			addTagString(xml,"updateid",rs);
    			addTagString(xml,"gmdncode",rs);
    			addTagBinaryString(xml,"service",rs);
    			addTagBinaryString(xml,"nomenclature",rs);
    			addTagBinaryString(xml,"comment1",rs);
    			addTagBinaryString(xml,"comment2",rs);
    			addTagBinaryString(xml,"comment3",rs);
    			addTagBinaryString(xml,"comment4",rs);
    			addTagBinaryString(xml,"comment5",rs);
    			addTagBinaryString(xml,"comment6",rs);
    			addTagBinaryString(xml,"comment7",rs);
    			addTagBinaryString(xml,"comment8",rs);
    			addTagBinaryString(xml,"comment9",rs);
    			addTagBinaryString(xml,"comment10",rs);
    			addTagBinaryString(xml,"comment11",rs);
    			addTagBinaryString(xml,"comment12",rs);
    			addTagBinaryString(xml,"comment13",rs);
    			addTagBinaryString(xml,"comment14",rs);
    			addTagBinaryString(xml,"comment15",rs);
    			addTagBinaryString(xml,"comment16",rs);
    			addTagBinaryString(xml,"comment17",rs);
    			addTagBinaryString(xml,"comment18",rs);
    			addTagBinaryString(xml,"comment19",rs);
    			addTagBinaryString(xml,"comment20",rs);
    			addTagString(xml,"lockedby",rs);
    			addTagDate(xml,"lockeddate",rs);
    			//Now add the components
    			xml.append("<components>");
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("select * from oc_assetcomponents where oc_component_assetuid=? and oc_component_objectid>-1");
    			ps.setString(1, uid);
    			rs = ps.executeQuery();
    			while(rs.next()){
    				xml.append("<component>");
    				addComponentTagString(xml, "assetuid", rs);
    				addComponentTagBinaryString(xml, "nomenclature", rs);
    				addComponentTagBinaryString(xml, "type", rs);
    				addComponentTagBinaryString(xml, "characteristics", rs);
    				addComponentTagString(xml, "status", rs);
    				addComponentTagString(xml, "objectid", rs);
    				xml.append("</component>");
    			}
    			xml.append("</components>");
    			//Now add the documents
    			xml.append("<documents>");
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("select * from arch_documents where arch_document_objectid>-1 and arch_document_storagename is not null and arch_document_storagename<>'' and arch_document_category='asset' and arch_document_reference='asset."+uid+"'");
    			rs = ps.executeQuery();
    			while(rs.next()){
    				xml.append("<document>");
    				addDocumentTagString(xml, "serverid", rs);
    				addDocumentTagString(xml, "objectid", rs);
    				addDocumentTagString(xml, "udi", rs);
    				addDocumentTagBinaryString(xml, "title", rs);
    				addDocumentTagBinaryString(xml, "description", rs);
    				addDocumentTagBinaryString(xml, "category", rs);
    				addDocumentTagBinaryString(xml, "author", rs);
    				addDocumentTagDate(xml, "date", rs);
    				addDocumentTagBinaryString(xml, "destination", rs);
    				addDocumentTagBinaryString(xml, "reference", rs);
    				addDocumentTagString(xml, "personid", rs);
    				addDocumentTagBinaryString(xml, "storagename", rs);
    				addDocumentTagString(xml, "tran_serverid", rs);
    				addDocumentTagString(xml, "tran_transactionid", rs);
    				addDocumentTagDate(xml, "deletedate", rs);
    				addDocumentTagDate(xml, "updatetime", rs);
    				addDocumentTagString(xml, "updateid", rs);
    				xml.append("</document>");
    			}
    			xml.append("</documents>");
    			//Now add the maintenanceplans
    			xml.append("<maintenanceplans>");
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_assetuid=? and oc_maintenanceplan_objectid>-1");
    			ps.setString(1, uid);
    			rs = ps.executeQuery();
    			while(rs.next()){
    				xml.append(MaintenancePlan.toXml(rs.getString("oc_maintenanceplan_serverid")+"."+rs.getString("oc_maintenanceplan_objectid")));
    			}
    			xml.append("</maintenanceplans>");
    			xml.append("</asset>");
    		}
    		rs.close();
    		ps.close();
        	conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	return xml;
    }
    
    public String getComponentsString(String sWebLanguage){
	    String[] sComponents = ScreenHelper.checkString(getComment15()).split(";");
	    String sReturn="";
		for(int n=0;n<sComponents.length;n++){
			Nomenclature nomenclature = Nomenclature.get("assetcomponent", sComponents[n]);
			if(nomenclature!=null){
				sReturn+=nomenclature.getFullyQualifiedName(sWebLanguage)+"\n";
			}
		}
		return sReturn;
    }
    
    public boolean isAuthorizedUser(String userid){
    	Service service = getService();
    	return service==null || service.isAuthorizedUser(userid);
    }
    
    public String getServiceuid() {
		return serviceuid;
	}
    
    public Service getService(){
    	return Service.getService(getServiceuid());
    }
    
	public void setServiceuid(String serviceuid) {
		this.serviceuid = serviceuid;
	}

	public String getComment16() {
		return comment16;
	}

	public void setComment16(String comment16) {
		this.comment16 = comment16;
	}

	public String getComment17() {
		return comment17;
	}

	public void setComment17(String comment17) {
		this.comment17 = comment17;
	}

	public String getComment18() {
		return comment18;
	}

	public void setComment18(String comment18) {
		this.comment18 = comment18;
	}

	public String getComment19() {
		return comment19;
	}

	public void setComment19(String comment19) {
		this.comment19 = comment19;
	}

	public String getComment20() {
		return comment20;
	}

	public void setComment20(String comment20) {
		this.comment20 = comment20;
	}

	public int getServerId() {
		return serverId;
	}

	public void setServerId(int serverId) {
		this.serverId = serverId;
	}

	public int getObjectId() {
		return objectId;
	}

	public void setObjectId(int objectId) {
		this.objectId = objectId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getGmdncode() {
		return gmdncode;
	}

	public void setGmdncode(String gmdncode) {
		this.gmdncode = gmdncode;
	}

	public String getParentUid() {
		return parentUid;
	}

	public void setParentUid(String parentUid) {
		this.parentUid = parentUid;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getSerialnumber() {
		return serialnumber;
	}

	public void setSerialnumber(String serialnumber) {
		this.serialnumber = serialnumber;
	}

	public double getQuantity() {
		return quantity;
	}

	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public String getSupplierUid() {
		return supplierUid;
	}

	public void setSupplierUid(String supplierUid) {
		this.supplierUid = supplierUid;
	}

	public java.util.Date getPurchaseDate() {
		return purchaseDate;
	}

	public void setPurchaseDate(java.util.Date purchaseDate) {
		this.purchaseDate = purchaseDate;
	}

	public double getPurchasePrice() {
		return purchasePrice;
	}

	public void setPurchasePrice(double purchasePrice) {
		this.purchasePrice = purchasePrice;
	}

	public String getReceiptBy() {
		return receiptBy;
	}

	public void setReceiptBy(String receiptBy) {
		this.receiptBy = receiptBy;
	}

	public String getPurchaseDocuments() {
		return purchaseDocuments;
	}

	public void setPurchaseDocuments(String purchaseDocuments) {
		this.purchaseDocuments = purchaseDocuments;
	}

	public String getWriteOffMethod() {
		return writeOffMethod;
	}

	public void setWriteOffMethod(String writeOffMethod) {
		this.writeOffMethod = writeOffMethod;
	}

	public int getWriteOffPeriod() {
		return writeOffPeriod;
	}

	public void setWriteOffPeriod(int writeOffPeriod) {
		this.writeOffPeriod = writeOffPeriod;
	}

	public String getAnnuity() {
		return annuity;
	}

	public void setAnnuity(String annuity) {
		this.annuity = annuity;
	}

	public String getCharacteristics() {
		return characteristics;
	}

	public void setCharacteristics(String characteristics) {
		this.characteristics = characteristics;
	}

	public String getAccountingCode() {
		return accountingCode;
	}

	public void setAccountingCode(String accountingCode) {
		this.accountingCode = accountingCode;
	}

	public String getGains() {
		return gains;
	}

	public void setGains(String gains) {
		this.gains = gains;
	}

	public String getLosses() {
		return losses;
	}

	public void setLosses(String losses) {
		this.losses = losses;
	}

	public String getResidualValueHistory() {
		return residualValueHistory;
	}

	public void setResidualValueHistory(String residualValueHistory) {
		this.residualValueHistory = residualValueHistory;
	}

	public java.util.Date getLoanDate() {
		return loanDate;
	}

	public void setLoanDate(java.util.Date loanDate) {
		this.loanDate = loanDate;
	}

	public double getLoanAmount() {
		return loanAmount;
	}

	public void setLoanAmount(double loanAmount) {
		this.loanAmount = loanAmount;
	}

	public String getLoanInterestRate() {
		return loanInterestRate;
	}

	public void setLoanInterestRate(String loanInterestRate) {
		this.loanInterestRate = loanInterestRate;
	}

	public String getLoanReimbursementPlan() {
		return loanReimbursementPlan;
	}

	public void setLoanReimbursementPlan(String loanReimbursementPlan) {
		this.loanReimbursementPlan = loanReimbursementPlan;
	}

	public double getLoanReimbursementAmount() {
		return loanReimbursementAmount;
	}

	public void setLoanReimbursementAmount(double loanReimbursementAmount) {
		this.loanReimbursementAmount = loanReimbursementAmount;
	}

	public String getLoanComment() {
		return loanComment;
	}

	public void setLoanComment(String loanComment) {
		this.loanComment = loanComment;
	}

	public String getLoanDocuments() {
		return loanDocuments;
	}

	public void setLoanDocuments(String loanDocuments) {
		this.loanDocuments = loanDocuments;
	}

	public String getNomenclature() {
		return nomenclature;
	}

	public void setNomenclature(String nomenclature) {
		this.nomenclature = nomenclature;
	}

	public String getComment1() {
		return comment1;
	}

	public void setComment1(String comment1) {
		this.comment1 = comment1;
	}

	public String getComment2() {
		return comment2;
	}

	public void setComment2(String comment2) {
		this.comment2 = comment2;
	}

	public String getComment3() {
		return comment3;
	}

	public void setComment3(String comment3) {
		this.comment3 = comment3;
	}

	public String getComment4() {
		return comment4;
	}

	public void setComment4(String comment4) {
		this.comment4 = comment4;
	}

	public String getComment5() {
		return comment5;
	}

	public void setComment5(String comment5) {
		this.comment5 = comment5;
	}

	public String getComment6() {
		return comment6;
	}

	public void setComment6(String comment6) {
		this.comment6 = comment6;
	}

	public String getComment7() {
		return comment7;
	}

	public void setComment7(String comment7) {
		this.comment7 = comment7;
	}

	public String getComment8() {
		return comment8;
	}

	public void setComment8(String comment8) {
		this.comment8 = comment8;
	}

	public String getComment9() {
		return comment9;
	}

	public void setComment9(String comment9) {
		this.comment9 = comment9;
	}

	public String getComment10() {
		return comment10;
	}

	public void setComment10(String comment10) {
		this.comment10 = comment10;
	}

	public String getComment11() {
		return comment11;
	}

	public void setComment11(String comment11) {
		this.comment11 = comment11;
	}

	public String getComment12() {
		return comment12;
	}

	public void setComment12(String comment12) {
		this.comment12 = comment12;
	}

	public String getComment13() {
		return comment13;
	}

	public void setComment13(String comment13) {
		this.comment13 = comment13;
	}

	public String getComment14() {
		return comment14;
	}

	public void setComment14(String comment14) {
		this.comment14 = comment14;
	}

	public String getComment15() {
		return comment15;
	}

	public void setComment15(String comment15) {
		this.comment15 = comment15;
	}

	public boolean isInactive(){
		return isInactive(new java.util.Date());
	}
	
	public boolean isInactive(java.util.Date date){
		return getSaleDate()!=null && !getSaleDate().after(date);
	}
	
	public java.util.Date getSaleDate() {
		return saleDate;
	}

	public void setSaleDate(java.util.Date saleDate) {
		this.saleDate = saleDate;
	}

	public double getSaleValue() {
		return saleValue;
	}

	public void setSaleValue(double saleValue) {
		this.saleValue = saleValue;
	}

	public String getSaleClient() {
		return saleClient;
	}

	public void setSaleClient(String saleClient) {
		this.saleClient = saleClient;
	}

	public java.util.Date getPurchasePeriodBegin() {
		return purchasePeriodBegin;
	}

	public void setPurchasePeriodBegin(java.util.Date purchasePeriodBegin) {
		this.purchasePeriodBegin = purchasePeriodBegin;
	}

	public java.util.Date getPurchasePeriodEnd() {
		return purchasePeriodEnd;
	}

	public void setPurchasePeriodEnd(java.util.Date purchasePeriodEnd) {
		this.purchasePeriodEnd = purchasePeriodEnd;
	}

	//--- GET CODE --------------------------------------------------------------------------------
    public static String getCode(String sAssetUID){
    	String sAssetCode = "";

        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_ASSET_CODE FROM OC_ASSETS"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUID.substring(0,sAssetUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUID.substring(sAssetUID.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
            	sAssetCode = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
    	return sAssetCode;
    }
    
    public double getRemainingValue() {
    	//default Write-off method is linear
    	String method="linear";
    	if(SH.c(this.getWriteOffMethod()).length()>0) {
    		method=this.getWriteOffMethod();
    	}
    	//default annuity is complete
    	String annuity="complete";
    	if(SH.c(this.getAnnuity()).length()>0) {
    		annuity=this.getAnnuity();
    	}
    	java.util.Date begin = this.getPurchaseDate();
    	if(begin==null) {
    		begin=SH.parseDate(this.comment12);
    	}
    	if(this.getPurchasePrice()>0 && this.getWriteOffPeriod()>0 && begin!=null) {
    		if(annuity.equalsIgnoreCase("complete")) {
    			//Each year part accounts for a complete write-off year
    			int years = new java.util.Date().getYear()-begin.getYear()+1;
    			if(years<this.getWriteOffPeriod()) {
    				return this.getPurchasePrice()*(this.getWriteOffPeriod()-years)/this.getWriteOffPeriod();
    			}
    			else {
    				return 0;
    			}
    		}
    		else if(annuity.equalsIgnoreCase("prorata")) {
    			//Each year part accounts for a proportional part of a write-off year
    			double day = 24*3600*1000;
    			double year = 365*day;
    			double years = new Double(new java.util.Date().getTime()-begin.getTime())/year;
    			if(years<this.getWriteOffPeriod()) {
    				return this.getPurchasePrice()*(new Double(this.getWriteOffPeriod())-years)/new Double(this.getWriteOffPeriod());
    			}
    			else {
    				return 0;
    			}
    		}
    	}
    	return -1;
    }
    
    public double getRemainingValue(java.util.Date date) {
    	//default Write-off method is linear
    	String method="linear";
    	if(SH.c(this.getWriteOffMethod()).length()>0) {
    		method=this.getWriteOffMethod();
    	}
    	//default annuity is complete
    	String annuity="complete";
    	if(SH.c(this.getAnnuity()).length()>0) {
    		annuity=this.getAnnuity();
    	}
    	java.util.Date begin = this.getPurchaseDate();
    	if(begin==null) {
    		begin=SH.parseDate(this.comment12);
    	}
    	if(this.getPurchasePrice()>0 && this.getWriteOffPeriod()>0 && begin!=null) {
    		if(annuity.equalsIgnoreCase("complete")) {
    			//Each year part accounts for a complete write-off year
    			int years = date.getYear()-begin.getYear()+1;
    			if(years<this.getWriteOffPeriod()) {
    				return this.getPurchasePrice()*(this.getWriteOffPeriod()-years)/this.getWriteOffPeriod();
    			}
    			else {
    				return 0;
    			}
    		}
    		else if(annuity.equalsIgnoreCase("prorata")) {
    			//Each year part accounts for a proportional part of a write-off year
    			double day = 24*3600*1000;
    			double year = 365*day;
    			double years = new Double(date.getTime()-begin.getTime())/year;
    			if(years<this.getWriteOffPeriod()) {
    				return this.getPurchasePrice()*(new Double(this.getWriteOffPeriod())-years)/new Double(this.getWriteOffPeriod());
    			}
    			else {
    				return 0;
    			}
    		}
    	}
    	return -1;
    }
    
    public boolean existDefaultMaintenancePlans(){
    	boolean bExist =false;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps=null;
    	ResultSet rs=null;
    	try{
            if(ScreenHelper.checkString(getNomenclature()).length()>0){
            	ps=conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
            	ps.setString(1, getNomenclature());
            	rs=ps.executeQuery();
            	if(rs.next()){
            		bExist=true;
            	}
            }
    	}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
    	return bExist;
    }
    
    public static void deleteDefault(int uid){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	ps=oc_conn.prepareStatement("delete from oc_defaultassets where oc_asset_uid=?");
        	ps.setInt(1, uid);
        	ps.execute();
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
    }

    public static Vector getDefaultAssets(String sNomenclatureCode) {
    	Vector assets = new Vector();
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("select * from oc_defaultassets where oc_asset_nomenclature like ? order by oc_asset_description");
        	ps.setString(1, sNomenclatureCode+"%");
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()) {
                Asset asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_UID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                try {
					asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                assets.add(asset);
        	}
        	rs.close();
        	ps.close();
        	oc_conn.close();
        }
        catch(Exception e) {
        	e.printStackTrace();
        }
        return assets;
    }
    
    public static Asset getDefaultAsset(String uid) {
    	Asset asset=null;
    	PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("select * from oc_defaultassets where oc_asset_uid=?");
        	ps.setString(1, uid);
        	ResultSet rs = ps.executeQuery();
        	if(rs.next()) {
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_UID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                try {
					asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
        	}
        	rs.close();
        	ps.close();
        	oc_conn.close();
        }
        catch(Exception e) {
        	e.printStackTrace();
        }
        return asset;
    }
    
    public void copyToDefault(String nomenclaturecode){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	ps = oc_conn.prepareStatement("delete from oc_defaultassets where oc_asset_nomenclature=? and oc_asset_description=?");
        	ps.setString(1, nomenclaturecode);
        	ps.setString(2, getDescription());
        	ps.execute();
        	ps.close();
        	ps = oc_conn.prepareStatement("insert into oc_defaultassets ("
        			+ " OC_ASSET_CODE,"
        			+ " OC_ASSET_UID,"
        			+ " OC_ASSET_DESCRIPTION,"
        			+ " OC_ASSET_QUANTITY,"
        			+ " OC_ASSET_TYPE,"
        			+ " OC_ASSET_SUPPLIERUID,"
        			+ " OC_ASSET_CHARACTERISTICS,"
        			+ " OC_ASSET_NOMENCLATURE,"
        			+ " OC_ASSET_COMMENT1,"
        			+ " OC_ASSET_COMMENT2,"
        			+ " OC_ASSET_COMMENT3,"
        			+ " OC_ASSET_COMMENT4,"
        			+ " OC_ASSET_COMMENT5,"
        			+ " OC_ASSET_COMMENT7,"
        			+ " OC_ASSET_COMMENT8,"
        			+ " OC_ASSET_COMMENT9,"
        			+ " OC_ASSET_COMMENT10,"
        			+ " OC_ASSET_COMMENT15,"
        			+ " OC_ASSET_COMMENT16,"
        			+ " OC_ASSET_COMMENT17)"
        			+ " values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
        	ps.setString(1, getCode());
        	ps.setInt(2, MedwanQuery.getInstance().getOpenclinicCounter("DEFAULTASSETUID"));
        	ps.setString(3, getDescription());
        	ps.setDouble(4, getQuantity());
        	ps.setString(5, getAssetType());
        	ps.setString(6, getSupplierUid());
        	ps.setString(7, getCharacteristics());
        	ps.setString(8, getNomenclature());
        	ps.setString(9, getComment1());
        	ps.setString(10, getComment2());
        	ps.setString(11, getComment3());
        	ps.setString(12, getComment4());
        	ps.setString(13, getComment5());
        	ps.setString(14, getComment7());
        	ps.setString(15, getComment8());
        	ps.setString(16, getComment9());
        	ps.setString(17, getComment10());
        	ps.setString(18, getComment15());
        	ps.setString(19, getComment16());
        	ps.setString(20, getComment17());
        	ps.execute();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
    }

    public void setDefaultMaintenancePlans(){
    	if(!existDefaultMaintenancePlans()){
    		return;
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps=null;
    	ResultSet rs=null;
    	try{
            if(ScreenHelper.checkString(getNomenclature()).length()>0){
                //Add the default maintenance plans to this new asset
                ps=conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_enddate=? where oc_maintenanceplan_assetuid=? and oc_maintenanceplan_enddate is null");
                ps.setDate(1, new java.sql.Date(new java.util.Date().getTime()));
                ps.setString(2, getUid());
                ps.execute();
                ps.close();
                ps=conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
                ps.setString(1, getNomenclature());
                rs=ps.executeQuery();
                while(rs.next()){
                	MaintenancePlan plan = new MaintenancePlan();
                	plan.setUid("-1");
                	plan.setAssetUID(getUid());
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                	plan.setComment1(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                	plan.setCreateDateTime(new java.util.Date());
                	plan.setFrequency(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                	plan.setInstructions(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                	plan.setName(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                	plan.setOperator(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                	plan.setPlanManager(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                	plan.setStartDate(new java.util.Date());
                	plan.setType(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                	plan.setVersion(1);
                	plan.store(getUpdateUser());
                }
            }
    	}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
    }
    
    public boolean saveDefault() {
    	boolean bSuccess=true;
        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = null;
        try {
        	if(getUid()==null || getUid().length()==0) {
        		setUid(MedwanQuery.getInstance().getOpenclinicCounter("DEFAULTASSETUID")+"");
        	}
        	deleteDefault(getUid());
        	String sql = "insert into oc_defaultassets(oc_asset_uid,oc_asset_code,oc_asset_description,oc_asset_type,"
        			+ "oc_asset_supplieruid,oc_asset_characteristics,oc_asset_nomenclature,oc_asset_quantity,oc_asset_comment1,oc_asset_comment2,oc_asset_comment3"
        			+ ",oc_asset_comment4,oc_asset_comment5,oc_asset_comment7,oc_asset_comment8,oc_asset_comment9,oc_asset_comment10,oc_asset_comment15"
        			+ ",oc_asset_comment16,oc_asset_comment17) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        	ps=conn.prepareStatement(sql);
        	ps.setString(1,getUid());
        	ps.setString(2,getCode());
        	ps.setString(3, getDescription());
        	ps.setString(4, getAssetType());
        	ps.setString(5, getSupplierUid());
        	ps.setString(6, getCharacteristics());
        	ps.setString(7, getNomenclature());
        	ps.setDouble(8, getQuantity());
        	ps.setString(9, getComment1());
        	ps.setString(10, getComment2());
        	ps.setString(11, getComment3());
        	ps.setString(12, getComment4());
        	ps.setString(13, getComment5());
        	ps.setString(14, getComment7());
        	ps.setString(15, getComment8());
        	ps.setString(16, getComment9());
        	ps.setString(17, getComment10());
        	ps.setString(18, getComment15());
        	ps.setString(19, getComment16());
        	ps.setString(20, getComment17());
        	ps.execute();
        	ps.close();
        	conn.close();
        }
        catch(Exception e) {
        	bSuccess=false;
        	e.printStackTrace();
        }
    	return bSuccess;
    }
    
    public static void deleteDefault(String uid) {
        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = null;
        try {
        	ps=conn.prepareStatement("delete from oc_defaultassets where oc_asset_uid=?");
        	ps.setString(1, uid);
        	ps.execute();
        	ps.close();
        	conn.close();
        }
        catch(Exception e) {
        	e.printStackTrace();
        }
    }
    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(String userUid){
        boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            if(getUid().equals("-1")){                  
                // insert new asset
                sSql = "INSERT INTO oc_assets(OC_ASSET_SERVERID,OC_ASSET_OBJECTID,OC_ASSET_CODE,"+
                       " OC_ASSET_PARENTUID,OC_ASSET_DESCRIPTION,OC_ASSET_SERIAL,OC_ASSET_QUANTITY,OC_ASSET_TYPE,"+
                       " OC_ASSET_SUPPLIERUID,OC_ASSET_PURCHASEDATE,OC_ASSET_PURCHASEPRICE,OC_ASSET_PURCHASERECEIPTBY,"+
                       " OC_ASSET_PURCHASEDOCS,OC_ASSET_WRITEOFFMETHOD,OC_ASSET_WRITEOFFPERIOD,OC_ASSET_ANNUITY,OC_ASSET_CHARACTERISTICS,"+
                       " OC_ASSET_ACCOUNTINGCODE,OC_ASSET_GAINS,OC_ASSET_LOSSES,OC_ASSET_LOANDATE,OC_ASSET_LOANAMOUNT,"+
                       " OC_ASSET_LOANINTERESTRATE,OC_ASSET_LOANREIMBURSEMENTPLAN,OC_ASSET_LOANCOMMENT,OC_ASSET_LOANDOCS,"+
                       " OC_ASSET_SALEDATE,OC_ASSET_SALEVALUE,OC_ASSET_SALECLIENT,OC_ASSET_UPDATETIME,OC_ASSET_UPDATEID,OC_ASSET_GMDNCODE,"
                       + "OC_ASSET_NOMENCLATURE,OC_ASSET_COMMENT1,OC_ASSET_COMMENT2,OC_ASSET_COMMENT3,OC_ASSET_COMMENT4,OC_ASSET_COMMENT5"
                       + ",OC_ASSET_COMMENT6,OC_ASSET_COMMENT7,OC_ASSET_COMMENT8,OC_ASSET_COMMENT9,OC_ASSET_COMMENT10,OC_ASSET_COMMENT11"
                       + ",OC_ASSET_COMMENT12,OC_ASSET_COMMENT13,OC_ASSET_COMMENT14,OC_ASSET_COMMENT15,OC_ASSET_COMMENT16,OC_ASSET_COMMENT17"
                       + ",OC_ASSET_COMMENT18,OC_ASSET_COMMENT19,OC_ASSET_COMMENT20,OC_ASSET_SERVICE,OC_ASSET_LOCKEDBY,OC_ASSET_LOCKEDDATE)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 31
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_ASSETS",-100000);
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                ps.setString(psIdx++,code);
                ps.setString(psIdx++,parentUid);
                ps.setString(psIdx++,description);
                ps.setString(psIdx++,serialnumber);
                ps.setDouble(psIdx++,quantity);
                ps.setString(psIdx++,assetType);
                ps.setString(psIdx++,supplierUid);

                // purchaseDate date might be unspecified
                if(purchaseDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(purchaseDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,purchasePrice);
                ps.setString(psIdx++,receiptBy);
                ps.setString(psIdx++,purchaseDocuments);
                ps.setString(psIdx++,writeOffMethod);
                ps.setInt(psIdx++,writeOffPeriod);
                ps.setString(psIdx++,annuity);
                ps.setString(psIdx++,characteristics);
                ps.setString(psIdx++,accountingCode);
                ps.setString(psIdx++,gains);
                ps.setString(psIdx++,losses);
                
                //*** loan ***
                // loanDate date might be unspecified
                if(loanDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(loanDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,loanAmount);
                ps.setString(psIdx++,loanInterestRate);
                ps.setString(psIdx++,loanReimbursementPlan);
                //ps.setDouble(psIdx++,loanReimbursementAmount); // calculated
                ps.setString(psIdx++,loanComment);
                ps.setString(psIdx++,loanDocuments);
                                
                // saleDate date might be unspecified
                if(saleDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(saleDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setDouble(psIdx++,saleValue);
                ps.setString(psIdx++,saleClient);
                     
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,gmdncode);
                ps.setString(psIdx++,nomenclature);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);
                ps.setString(psIdx++,comment11);
                ps.setString(psIdx++,comment12);
                ps.setString(psIdx++,comment13);
                ps.setString(psIdx++,comment14);
                ps.setString(psIdx++,comment15);
                ps.setString(psIdx++,comment16);
                ps.setString(psIdx++,comment17);
                ps.setString(psIdx++,comment18);
                ps.setString(psIdx++,comment19);
                ps.setString(psIdx++,comment20);
                ps.setString(psIdx++,serviceuid);
                ps.setInt(psIdx++,lockedBy);
                ps.setTimestamp(psIdx++,lockeddate==null?null:new Timestamp(lockeddate.getTime()));

                ps.executeUpdate();
            } 
            else{
                // update existing record
            	storeHistory();
                sSql = "UPDATE oc_assets SET"+
                       "  OC_ASSET_CODE = ?, OC_ASSET_PARENTUID = ?, OC_ASSET_DESCRIPTION = ?, OC_ASSET_SERIAL = ?,"+
                       "  OC_ASSET_QUANTITY = ?, OC_ASSET_TYPE = ?, OC_ASSET_SUPPLIERUID = ?, OC_ASSET_PURCHASEDATE = ?,"+
                       "  OC_ASSET_PURCHASEPRICE = ?, OC_ASSET_PURCHASERECEIPTBY = ?, OC_ASSET_PURCHASEDOCS = ?,"+
                       "  OC_ASSET_WRITEOFFMETHOD = ?, OC_ASSET_WRITEOFFPERIOD = ?, OC_ASSET_ANNUITY = ?, OC_ASSET_CHARACTERISTICS = ?,"+
                       "  OC_ASSET_ACCOUNTINGCODE = ?, OC_ASSET_GAINS = ?, OC_ASSET_LOSSES = ?, OC_ASSET_LOANDATE = ?,"+
                       "  OC_ASSET_LOANAMOUNT = ?, OC_ASSET_LOANINTERESTRATE = ?, OC_ASSET_LOANREIMBURSEMENTPLAN = ?,"+
                       "  OC_ASSET_LOANCOMMENT = ?, OC_ASSET_LOANDOCS = ?, OC_ASSET_SALEDATE = ?, OC_ASSET_SALEVALUE = ?,"+
                       "  OC_ASSET_SALECLIENT = ?, OC_ASSET_UPDATETIME = ?, OC_ASSET_UPDATEID = ?, OC_ASSET_GMDNCODE=?"+ 
                       "  , OC_ASSET_NOMENCLATURE = ?, OC_ASSET_COMMENT1=?, OC_ASSET_COMMENT2=?, OC_ASSET_COMMENT3=?, OC_ASSET_COMMENT4=?"+
                       "  , OC_ASSET_COMMENT5=?, OC_ASSET_COMMENT6=?, OC_ASSET_COMMENT7=?, OC_ASSET_COMMENT8=?, OC_ASSET_COMMENT9=?"+
                       "  , OC_ASSET_COMMENT10=?, OC_ASSET_COMMENT11=?, OC_ASSET_COMMENT12=?, OC_ASSET_COMMENT13=?, OC_ASSET_COMMENT14=?"+
                       "  , OC_ASSET_COMMENT15=?, OC_ASSET_COMMENT16=?, OC_ASSET_COMMENT17=?, OC_ASSET_COMMENT18=?, OC_ASSET_COMMENT19=?"+
                       "  , OC_ASSET_COMMENT20=?, OC_ASSET_SERVICE=?, OC_ASSET_LOCKEDBY=?, OC_ASSET_LOCKEDDATE=?"+// update-info
                       " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                ps.setString(psIdx++,code);
                ps.setString(psIdx++,parentUid);
                ps.setString(psIdx++,description);
                ps.setString(psIdx++,serialnumber);
                ps.setDouble(psIdx++,quantity);
                ps.setString(psIdx++,assetType);
                ps.setString(psIdx++,supplierUid);

                // purchaseDate date might be unspecified
                if(purchaseDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(purchaseDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,purchasePrice);
                ps.setString(psIdx++,receiptBy);
                ps.setString(psIdx++,purchaseDocuments);
                ps.setString(psIdx++,writeOffMethod);
                ps.setInt(psIdx++,writeOffPeriod);
                ps.setString(psIdx++,annuity);
                ps.setString(psIdx++,characteristics);
                ps.setString(psIdx++,accountingCode);
                ps.setString(psIdx++,gains);
                ps.setString(psIdx++,losses);

                //*** loan ***
                // loanDate date might be unspecified
                if(loanDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(loanDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setDouble(psIdx++,loanAmount);
                ps.setString(psIdx++,loanInterestRate);
                ps.setString(psIdx++,loanReimbursementPlan);
                //ps.setDouble(psIdx++,loanReimbursementAmount); // calculated
                ps.setString(psIdx++,loanComment);
                ps.setString(psIdx++,loanDocuments);

                // saleDate date might be unspecified
                if(saleDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(saleDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setDouble(psIdx++,saleValue);
                ps.setString(psIdx++,saleClient);

                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,gmdncode);
                ps.setString(psIdx++,nomenclature);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);
                ps.setString(psIdx++,comment11);
                ps.setString(psIdx++,comment12);
                ps.setString(psIdx++,comment13);
                ps.setString(psIdx++,comment14);
                ps.setString(psIdx++,comment15);
                ps.setString(psIdx++,comment16);
                ps.setString(psIdx++,comment17);
                ps.setString(psIdx++,comment18);
                ps.setString(psIdx++,comment19);
                ps.setString(psIdx++,comment20);
                ps.setString(psIdx++,serviceuid);
                ps.setInt(psIdx++,lockedBy);
                ps.setTimestamp(psIdx++,lockeddate==null?null:new Timestamp(lockeddate.getTime()));
                
                // where
                ps.setInt(psIdx++,Integer.parseInt(getUid().substring(0,getUid().indexOf("."))));
                ps.setInt(psIdx,Integer.parseInt(getUid().substring(getUid().indexOf(".")+1)));
                
                ps.executeUpdate();
            }           
        }
        catch(Exception e){
            errorOccurred = true;
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
        
        return errorOccurred;
    }
    
    public boolean storeHistory(){
        boolean errorOccurred = false;
        PreparedStatement ps = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            // insert new asset
            sSql = "INSERT INTO oc_assetshistory(OC_ASSET_SERVERID,OC_ASSET_OBJECTID,OC_ASSET_CODE,"+
                   " OC_ASSET_PARENTUID,OC_ASSET_DESCRIPTION,OC_ASSET_SERIAL,OC_ASSET_QUANTITY,OC_ASSET_TYPE,"+
                   " OC_ASSET_SUPPLIERUID,OC_ASSET_PURCHASEDATE,OC_ASSET_PURCHASEPRICE,OC_ASSET_PURCHASERECEIPTBY,"+
                   " OC_ASSET_PURCHASEDOCS,OC_ASSET_WRITEOFFMETHOD,OC_ASSET_WRITEOFFPERIOD,OC_ASSET_ANNUITY,OC_ASSET_CHARACTERISTICS,"+
                   " OC_ASSET_ACCOUNTINGCODE,OC_ASSET_GAINS,OC_ASSET_LOSSES,OC_ASSET_LOANDATE,OC_ASSET_LOANAMOUNT,"+
                   " OC_ASSET_LOANINTERESTRATE,OC_ASSET_LOANREIMBURSEMENTPLAN,OC_ASSET_LOANCOMMENT,OC_ASSET_LOANDOCS,"+
                   " OC_ASSET_SALEDATE,OC_ASSET_SALEVALUE,OC_ASSET_SALECLIENT,OC_ASSET_UPDATETIME,OC_ASSET_UPDATEID,OC_ASSET_GMDNCODE,"
                   + "OC_ASSET_NOMENCLATURE,OC_ASSET_COMMENT1,OC_ASSET_COMMENT2,OC_ASSET_COMMENT3,OC_ASSET_COMMENT4,OC_ASSET_COMMENT5"
                   + ",OC_ASSET_COMMENT6,OC_ASSET_COMMENT7,OC_ASSET_COMMENT8,OC_ASSET_COMMENT9,OC_ASSET_COMMENT10,OC_ASSET_COMMENT11"
                   + ",OC_ASSET_COMMENT12,OC_ASSET_COMMENT13,OC_ASSET_COMMENT14,OC_ASSET_COMMENT15,OC_ASSET_COMMENT16,OC_ASSET_COMMENT17"
                   + ",OC_ASSET_COMMENT18,OC_ASSET_COMMENT19,OC_ASSET_COMMENT20,OC_ASSET_SERVICE,OC_ASSET_LOCKEDBY,OC_ASSET_LOCKEDDATE,OC_ASSET_HISTORYDATE,OC_ASSET_HISTORYUSER)"+
                   " select OC_ASSET_SERVERID,OC_ASSET_OBJECTID,OC_ASSET_CODE,"+
		            " OC_ASSET_PARENTUID,OC_ASSET_DESCRIPTION,OC_ASSET_SERIAL,OC_ASSET_QUANTITY,OC_ASSET_TYPE,"+
		            " OC_ASSET_SUPPLIERUID,OC_ASSET_PURCHASEDATE,OC_ASSET_PURCHASEPRICE,OC_ASSET_PURCHASERECEIPTBY,"+
		            " OC_ASSET_PURCHASEDOCS,OC_ASSET_WRITEOFFMETHOD,OC_ASSET_WRITEOFFPERIOD,OC_ASSET_ANNUITY,OC_ASSET_CHARACTERISTICS,"+
		            " OC_ASSET_ACCOUNTINGCODE,OC_ASSET_GAINS,OC_ASSET_LOSSES,OC_ASSET_LOANDATE,OC_ASSET_LOANAMOUNT,"+
		            " OC_ASSET_LOANINTERESTRATE,OC_ASSET_LOANREIMBURSEMENTPLAN,OC_ASSET_LOANCOMMENT,OC_ASSET_LOANDOCS,"+
		            " OC_ASSET_SALEDATE,OC_ASSET_SALEVALUE,OC_ASSET_SALECLIENT,OC_ASSET_UPDATETIME,OC_ASSET_UPDATEID,OC_ASSET_GMDNCODE,"
		            + "OC_ASSET_NOMENCLATURE,OC_ASSET_COMMENT1,OC_ASSET_COMMENT2,OC_ASSET_COMMENT3,OC_ASSET_COMMENT4,OC_ASSET_COMMENT5"
		            + ",OC_ASSET_COMMENT6,OC_ASSET_COMMENT7,OC_ASSET_COMMENT8,OC_ASSET_COMMENT9,OC_ASSET_COMMENT10,OC_ASSET_COMMENT11"
		            + ",OC_ASSET_COMMENT12,OC_ASSET_COMMENT13,OC_ASSET_COMMENT14,OC_ASSET_COMMENT15,OC_ASSET_COMMENT16,OC_ASSET_COMMENT17"
		            + ",OC_ASSET_COMMENT18,OC_ASSET_COMMENT19,OC_ASSET_COMMENT20,OC_ASSET_SERVICE,OC_ASSET_LOCKEDBY,OC_ASSET_LOCKEDDATE,?,?"
		            +" from oc_assets where OC_ASSET_SERVERID=? and OC_ASSET_OBJECTID=?";
		            ps = oc_conn.prepareStatement(sSql);
            
            int serverId = Integer.parseInt(getUid().split("\\.")[0]),
                objectId = Integer.parseInt(getUid().split("\\.")[1]);
            ps.setTimestamp(1,new Timestamp(new java.util.Date().getTime()));
            ps.setString(2, getUpdateUser());
            ps.setInt(3, serverId);
            ps.setInt(4, objectId);
            ps.executeUpdate();
        }
        catch(Exception e){
            errorOccurred = true;
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
            	se.printStackTrace();
            }
        }
        
        return errorOccurred;
    }
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sAssetUid){
        boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM oc_assets"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));
            
            ps.executeUpdate();
        }
        catch(Exception e){
            errorOccurred = true;
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    //--- GET -------------------------------------------------------------------------------------
    public static Asset get(Asset asset){
        return get(asset.getUid());
    }
       
    public static Asset get(String sAssetUid){
        Asset asset = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM oc_assets"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_SERVERID")+"."+rs.getString("OC_ASSET_OBJECTID"));
                asset.serverId = Integer.parseInt(rs.getString("OC_ASSET_SERVERID"));
                asset.objectId = Integer.parseInt(rs.getString("OC_ASSET_OBJECTID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.gmdncode          = ScreenHelper.checkString(rs.getString("OC_ASSET_GMDNCODE"));
                asset.parentUid         = ScreenHelper.checkString(rs.getString("OC_ASSET_PARENTUID"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.serialnumber      = ScreenHelper.checkString(rs.getString("OC_ASSET_SERIAL"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                try {
					asset.purchaseDate      = rs.getDate("OC_ASSET_PURCHASEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.purchasePrice     = rs.getDouble("OC_ASSET_PURCHASEPRICE");                
                asset.receiptBy         = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASERECEIPTBY"));
                asset.purchaseDocuments = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASEDOCS"));
                asset.writeOffMethod    = ScreenHelper.checkString(rs.getString("OC_ASSET_WRITEOFFMETHOD"));
                asset.writeOffPeriod    = rs.getInt("OC_ASSET_WRITEOFFPERIOD");
                asset.annuity           = ScreenHelper.checkString(rs.getString("OC_ASSET_ANNUITY"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                asset.accountingCode    = ScreenHelper.checkString(rs.getString("OC_ASSET_ACCOUNTINGCODE"));
                asset.gains             = ScreenHelper.checkString(rs.getString("OC_ASSET_GAINS"));
                asset.losses            = ScreenHelper.checkString(rs.getString("OC_ASSET_LOSSES"));
                //asset.residualValueHistory = calculateResidualValueHistory();
                
                //*** loan ***
                try {
					asset.loanDate              = rs.getDate("OC_ASSET_LOANDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.loanAmount            = rs.getDouble("OC_ASSET_LOANAMOUNT");
                asset.loanInterestRate      = rs.getString("OC_ASSET_LOANINTERESTRATE");
                asset.loanReimbursementPlan = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANREIMBURSEMENTPLAN"));
                //asset.loanReimbursementAmount = calculateReimbursementAmount();
                asset.loanComment           = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANCOMMENT"));
                asset.loanDocuments         = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANDOCS"));
                
                try {
					asset.saleDate   = rs.getDate("OC_ASSET_SALEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.saleValue  = rs.getDouble("OC_ASSET_SALEVALUE");
                asset.saleClient = ScreenHelper.checkString(rs.getString("OC_ASSET_SALECLIENT")); 
                
                // update-info
                try {
					asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                asset.setServiceuid(rs.getString("OC_ASSET_SERVICE"));
                asset.setLockedBy(rs.getInt("OC_ASSET_LOCKEDBY"));
                try {
					asset.setLockeddate(rs.getTimestamp("OC_ASSET_LOCKEDDATE"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return asset;
    }
        
    public static Asset getHistory(String sAssetUid,java.util.Date timestamp){
        Asset asset = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM oc_assetshistory"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ? and OC_ASSET_HISTORYDATE = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));
            ps.setTimestamp(3, new java.sql.Timestamp(timestamp.getTime()));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_SERVERID")+"."+rs.getString("OC_ASSET_OBJECTID"));
                asset.serverId = Integer.parseInt(rs.getString("OC_ASSET_SERVERID"));
                asset.objectId = Integer.parseInt(rs.getString("OC_ASSET_OBJECTID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.gmdncode          = ScreenHelper.checkString(rs.getString("OC_ASSET_GMDNCODE"));
                asset.parentUid         = ScreenHelper.checkString(rs.getString("OC_ASSET_PARENTUID"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.serialnumber      = ScreenHelper.checkString(rs.getString("OC_ASSET_SERIAL"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                try {
					asset.purchaseDate      = rs.getDate("OC_ASSET_PURCHASEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.purchasePrice     = rs.getDouble("OC_ASSET_PURCHASEPRICE");                
                asset.receiptBy         = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASERECEIPTBY"));
                asset.purchaseDocuments = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASEDOCS"));
                asset.writeOffMethod    = ScreenHelper.checkString(rs.getString("OC_ASSET_WRITEOFFMETHOD"));
                asset.writeOffPeriod    = rs.getInt("OC_ASSET_WRITEOFFPERIOD");
                asset.annuity           = ScreenHelper.checkString(rs.getString("OC_ASSET_ANNUITY"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                asset.accountingCode    = ScreenHelper.checkString(rs.getString("OC_ASSET_ACCOUNTINGCODE"));
                asset.gains             = ScreenHelper.checkString(rs.getString("OC_ASSET_GAINS"));
                asset.losses            = ScreenHelper.checkString(rs.getString("OC_ASSET_LOSSES"));
                //asset.residualValueHistory = calculateResidualValueHistory();
                
                //*** loan ***
                try {
					asset.loanDate              = rs.getDate("OC_ASSET_LOANDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.loanAmount            = rs.getDouble("OC_ASSET_LOANAMOUNT");
                asset.loanInterestRate      = rs.getString("OC_ASSET_LOANINTERESTRATE");
                asset.loanReimbursementPlan = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANREIMBURSEMENTPLAN"));
                //asset.loanReimbursementAmount = calculateReimbursementAmount();
                asset.loanComment           = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANCOMMENT"));
                asset.loanDocuments         = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANDOCS"));
                
                try {
					asset.saleDate   = rs.getDate("OC_ASSET_SALEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.saleValue  = rs.getDouble("OC_ASSET_SALEVALUE");
                asset.saleClient = ScreenHelper.checkString(rs.getString("OC_ASSET_SALECLIENT")); 
                
                // update-info
                try {
					asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                asset.setServiceuid(rs.getString("OC_ASSET_SERVICE"));
                asset.setLockedBy(rs.getInt("OC_ASSET_LOCKEDBY"));
                try {
					asset.setLockeddate(rs.getTimestamp("OC_ASSET_LOCKEDDATE"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return asset;
    }
        
    public boolean hasHistory(){
        boolean bHistory=false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM oc_assetshistory"+
                          " WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(getUid().substring(0,getUid().indexOf("."))));
            ps.setInt(2,Integer.parseInt(getUid().substring(getUid().indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            bHistory=rs.next();
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return bHistory;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<Asset> getList(){
        return getList(new Asset());         
    }
    
    public static List<Asset> getList(Asset findItem){
        List<Asset> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyyMMdd");
        
        try{
            //*** compose query ***************************
            String sSql = "SELECT * FROM oc_assets WHERE 1=1"; // 'where' facilitates further composition of query

            // search-criteria 
            if(findItem.code.length() > 0){
                sSql+= " AND (OC_ASSET_CODE = '"+findItem.code+"' or OC_ASSET_SERVERID||'.'||OC_ASSET_OBJECTID = '"+findItem.code+"')";
            }
            if(ScreenHelper.checkString(findItem.description).length() > 0){
                sSql+= " AND OC_ASSET_DESCRIPTION LIKE '%"+findItem.description+"%'";
            }
            if(ScreenHelper.checkString(findItem.serviceuid).length() > 0){
                sSql+= " AND OC_ASSET_SERVICE LIKE '"+findItem.serviceuid+"%'";
            }
            if(ScreenHelper.checkString(findItem.serialnumber).length() > 0){
                sSql+= " AND OC_ASSET_SERIAL LIKE '%"+findItem.serialnumber+"%'";
            }
            if(ScreenHelper.checkString(findItem.assetType).length() > 0){
                sSql+= " AND OC_ASSET_TYPE = '"+findItem.assetType+"'";
            }
            if(ScreenHelper.checkString(findItem.comment9).length() > 0){
                sSql+= " AND OC_ASSET_COMMENT9 = '"+findItem.comment9+"'";
            }
            if(ScreenHelper.checkString(findItem.nomenclature).length() > 0){
                sSql+= " AND OC_ASSET_NOMENCLATURE LIKE '"+findItem.nomenclature+"%'";
            }
            if(ScreenHelper.checkString(findItem.nomenclature).length() > 0){
                sSql+= " AND OC_ASSET_NOMENCLATURE LIKE '"+findItem.nomenclature+"%'";
            }
            if(ScreenHelper.checkString(findItem.comment15).length() > 0){
                sSql+= " AND OC_ASSET_COMMENT15 LIKE '%"+findItem.comment15+";%'";
            }
            if(ScreenHelper.checkString(findItem.comment16).length() > 0){
                sSql+= " AND EXISTS (select * from OC_ASSETCOMPONENTS where OC_COMPONENT_ASSETUID=OC_ASSET_SERVERID||'.'||OC_ASSET_OBJECTID and OC_COMPONENT_NOMENCLATURE like '"+(ScreenHelper.checkString(findItem.comment15).length()==0?"%":findItem.comment15)+"' and OC_COMPONENT_STATUS='"+findItem.comment16+"')";
            }
            if(ScreenHelper.checkString(findItem.supplierUid).length() > 0){
                sSql+= " AND OC_ASSET_SUPPLIERUID like '%"+findItem.supplierUid+"%'";
            }

            // purchase date
            if(findItem.purchasePeriodBegin!=null && findItem.purchasePeriodEnd!=null){
                sSql+= " AND ("+
                       "  OC_ASSET_PURCHASEDATE BETWEEN '"+sqlDateFormat.format(findItem.purchasePeriodBegin)+"' AND"+
                       "                                '"+sqlDateFormat.format(findItem.purchasePeriodEnd)+"'"+
                       " )";
            }
            else if(findItem.purchasePeriodBegin!=null){
                sSql+= " AND (OC_ASSET_PURCHASEDATE >= '"+sqlDateFormat.format(findItem.purchasePeriodBegin)+"')";
            }
            else if(findItem.purchasePeriodEnd!=null){
                sSql+= " AND (OC_ASSET_PURCHASEDATE < '"+sqlDateFormat.format(findItem.purchasePeriodEnd)+"')";
            }
            
            Debug.println("\n"+sSql+"\n");
            sSql+= " ORDER BY OC_ASSET_CODE ASC";
            
            ps = oc_conn.prepareStatement(sSql);
            
            //*** execute query ***************************
            rs = ps.executeQuery();
            Asset asset;
            
            while(rs.next()){
                asset = new Asset();
                asset.setUid(rs.getString("OC_ASSET_SERVERID")+"."+rs.getString("OC_ASSET_OBJECTID"));
                asset.serverId = Integer.parseInt(rs.getString("OC_ASSET_SERVERID"));
                asset.objectId = Integer.parseInt(rs.getString("OC_ASSET_OBJECTID"));

                asset.code              = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
                asset.gmdncode          = ScreenHelper.checkString(rs.getString("OC_ASSET_GMDNCODE"));
                asset.parentUid         = ScreenHelper.checkString(rs.getString("OC_ASSET_PARENTUID"));
                asset.description       = ScreenHelper.checkString(rs.getString("OC_ASSET_DESCRIPTION"));
                asset.serialnumber      = ScreenHelper.checkString(rs.getString("OC_ASSET_SERIAL"));
                asset.quantity          = rs.getDouble("OC_ASSET_QUANTITY");
                asset.assetType         = ScreenHelper.checkString(rs.getString("OC_ASSET_TYPE"));
                asset.supplierUid       = ScreenHelper.checkString(rs.getString("OC_ASSET_SUPPLIERUID"));
                try {
					asset.purchaseDate      = rs.getDate("OC_ASSET_PURCHASEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.purchasePrice     = rs.getDouble("OC_ASSET_PURCHASEPRICE");                
                asset.receiptBy         = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASERECEIPTBY"));
                asset.purchaseDocuments = ScreenHelper.checkString(rs.getString("OC_ASSET_PURCHASEDOCS"));
                asset.writeOffMethod    = ScreenHelper.checkString(rs.getString("OC_ASSET_WRITEOFFMETHOD"));
                asset.writeOffPeriod    = rs.getInt("OC_ASSET_WRITEOFFPERIOD");
                asset.annuity           = ScreenHelper.checkString(rs.getString("OC_ASSET_ANNUITY"));
                asset.characteristics   = ScreenHelper.checkString(rs.getString("OC_ASSET_CHARACTERISTICS"));
                asset.accountingCode    = ScreenHelper.checkString(rs.getString("OC_ASSET_ACCOUNTINGCODE"));
                asset.gains             = ScreenHelper.checkString(rs.getString("OC_ASSET_GAINS"));
                asset.losses            = ScreenHelper.checkString(rs.getString("OC_ASSET_LOSSES"));
                //asset.residualValueHistory = calculateResidualValueHistory();
                
                //*** loan ***
                try {
					asset.loanDate              = rs.getDate("OC_ASSET_LOANDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.loanAmount            = rs.getDouble("OC_ASSET_LOANAMOUNT");
                asset.loanInterestRate      = rs.getString("OC_ASSET_LOANINTERESTRATE");
                asset.loanReimbursementPlan = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANREIMBURSEMENTPLAN"));
                //asset.loanReimbursementAmount = calculateReimbursementAmount();
                asset.loanComment           = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANCOMMENT"));
                asset.loanDocuments         = ScreenHelper.checkString(rs.getString("OC_ASSET_LOANDOCS"));
                
                try {
					asset.saleDate   = rs.getDate("OC_ASSET_SALEDATE");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.saleValue  = rs.getDouble("OC_ASSET_SALEVALUE");
                asset.saleClient = ScreenHelper.checkString(rs.getString("OC_ASSET_SALECLIENT")); 
                
                // update-info
                try {
					asset.setUpdateDateTime(rs.getTimestamp("OC_ASSET_UPDATETIME"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                asset.setUpdateUser(rs.getString("OC_ASSET_UPDATEID"));
                
                asset.setNomenclature(rs.getString("OC_ASSET_NOMENCLATURE"));
                asset.setComment1(rs.getString("OC_ASSET_COMMENT1"));
                asset.setComment2(rs.getString("OC_ASSET_COMMENT2"));
                asset.setComment3(rs.getString("OC_ASSET_COMMENT3"));
                asset.setComment4(rs.getString("OC_ASSET_COMMENT4"));
                asset.setComment5(rs.getString("OC_ASSET_COMMENT5"));
                asset.setComment6(rs.getString("OC_ASSET_COMMENT6"));
                asset.setComment7(rs.getString("OC_ASSET_COMMENT7"));
                asset.setComment8(rs.getString("OC_ASSET_COMMENT8"));
                asset.setComment9(rs.getString("OC_ASSET_COMMENT9"));
                asset.setComment10(rs.getString("OC_ASSET_COMMENT10"));
                asset.setComment11(rs.getString("OC_ASSET_COMMENT11"));
                asset.setComment12(rs.getString("OC_ASSET_COMMENT12"));
                asset.setComment13(rs.getString("OC_ASSET_COMMENT13"));
                asset.setComment14(rs.getString("OC_ASSET_COMMENT14"));
                asset.setComment15(rs.getString("OC_ASSET_COMMENT15"));
                asset.setComment16(rs.getString("OC_ASSET_COMMENT16"));
                asset.setComment17(rs.getString("OC_ASSET_COMMENT17"));
                asset.setComment18(rs.getString("OC_ASSET_COMMENT18"));
                asset.setComment19(rs.getString("OC_ASSET_COMMENT19"));
                asset.setComment20(rs.getString("OC_ASSET_COMMENT20"));
                asset.setServiceuid(rs.getString("OC_ASSET_SERVICE"));
                asset.setLockedBy(rs.getInt("OC_ASSET_LOCKEDBY"));
                try {
					asset.setLockeddate(rs.getTimestamp("OC_ASSET_LOCKEDDATE"));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                
                foundObjects.add(asset);
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return foundObjects;
    }
    
    //--- CALCULATE RESIDUAL VALUE HISTORY --------------------------------------------------------
    // todo : OPTIMIZE ALGORITHM ?????????!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public String calculateResidualValueHistory(String sWebLanguage){
        String sHistory = "";
        
        if(this.purchaseDate!=null && this.purchasePrice > 0 && this.writeOffPeriod > 0){
            double writeOffAmount = this.purchasePrice / this.writeOffPeriod;
            DecimalFormat deci = new DecimalFormat("0.00");
            		
            sHistory = "<table cellpadding='1' cellspacing='1' border='0' style='background:#fff;'>";
            
            // 1st day of every fiscal year until value=0
            double value = this.purchasePrice;
            int startYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(this.purchaseDate));
            int year = startYear;
            
            int colCount = 0;
            int maxColCount = MedwanQuery.getInstance().getConfigInt("assets.residualvaluehistory.maxcolcount",4);
            while(value >= writeOffAmount && colCount <= this.writeOffPeriod){
                value-= writeOffAmount;
                year++;

                if(colCount%maxColCount==0){
                	colCount = 0;
                	sHistory+= "<tr>"; // new row when 4 columns have been drawn
                }
                colCount++;

	            sHistory+= "<td style='background:#ccc'>&nbsp;"+year+"&nbsp;:&nbsp;</td>"+
	                       "<td style='background:#C3D9FF;text-align:right;width:90px'>"+ScreenHelper.padLeft(deci.format(value)," ",8)+" "+MedwanQuery.getInstance().getConfigParam("currency","")+"</td>";

	            // add empty 'cols'
	            if(writeOffAmount > value){
		            for(int i=0; i<(maxColCount-colCount); i++){
		                sHistory+= "<td style='background:#C3D9FF;'>&nbsp;</td>";
		            }
	            }
	            
                if(colCount%maxColCount==0){
                	sHistory+= "</tr>";
                }
            }

            // fill last row, if needed
            if(colCount > 0){
	            for(int i=0; i<(maxColCount-colCount); i++){
	                sHistory+= "<td style='background:#C3D9FF;'>&nbsp;</td>";
	            }
            }
            
            sHistory+= "</table>";
        }
        
        return sHistory;
    }
    
    
    public java.util.Date getNextMaintenance(){
    	java.util.Date date = null;
    	try {
    		Connection conn = SH.getOpenClinicConnection();
    		String sql= "select min(oc_maintenanceoperation_nextdate) nextdate from oc_maintenanceoperations o, oc_maintenanceplans p"+
    					" where"+
    					" oc_maintenanceoperation_maintenanceplanuid=oc_maintenanceplan_serverid||'.'||oc_maintenanceplan_objectid and"+
    					" oc_maintenanceplan_assetuid=? and"+
    					" oc_maintenanceoperation_nextdate>?";
    		PreparedStatement ps = conn.prepareStatement(sql);
    		ps.setString(1, this.getUid());
    		ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
    		ResultSet rs = ps.executeQuery();
    		if(rs.next() && rs.getDate("nextdate")!=null) {
    			date = rs.getDate("nextdate");
    		}
    		else {
    			rs.close();
    			ps.close();
        		sql= "select max(oc_maintenanceoperation_nextdate) nextdate from oc_maintenanceoperations o, oc_maintenanceplans p"+
    					" where"+
    					" oc_maintenanceoperation_maintenanceplanuid=oc_maintenanceplan_serverid||'.'||oc_maintenanceplan_objectid and"+
    					" oc_maintenanceplan_assetuid=?";
        		ps = conn.prepareStatement(sql);
        		ps.setString(1, this.getUid());
        		rs = ps.executeQuery();
        		if(rs.next()) {
        			date = rs.getDate("nextdate");
        		}
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return date;
    }
    
    //--- CALCULATE REIMBURSEMENT TOTALS ----------------------------------------------------------
    public double[] calculateReimbursementTotals(){
        double capitalTotal = -1, interestTotal = -1, totalAmount = -1;
        
        if(this.loanReimbursementPlan.length() > 0){
        	// init
        	capitalTotal = 0;
        	interestTotal = 0;
        	totalAmount = 0;
            
            // sum the total amount of each part of the reimbursement plan
            Vector plans = parseLoanReimbursementPlans(this.loanReimbursementPlan);
 
            String sCapital, sInterest;
            double capital, interest, planAmount;
            Element planElem;
            
            for(int i=0; i<plans.size(); i++){
                planElem = (Element)plans.get(i);
    
                sCapital  = ScreenHelper.checkString(planElem.elementText("Capital"));
                sInterest = ScreenHelper.checkString(planElem.elementText("Interest"));
                
                // single plan
                capital = Double.parseDouble(sCapital);
                interest = Double.parseDouble(sInterest);                
                planAmount = (capital+interest);
                
                // all plans
                capitalTotal+= Double.parseDouble(sCapital);
                interestTotal+= Double.parseDouble(sInterest);
                totalAmount+= planAmount;
            }
        }
        
        return new double[]{capitalTotal,interestTotal,totalAmount};
    }
    
    //--- PARSE LOAN REIMBURSEMENT PLANS ----------------------------------------------------------
    /*
        <ReimbursementPlans>
            <Plan>
                <Date>01/05/2013</Date>
                <Capital>20000</Capital>
                <Interest>3.25</Interest>
            </Plan>
        </ReimbursementPlans>
    */    
    private Vector parseLoanReimbursementPlans(String sLoanReimbursementPlans){
        Vector plans = new Vector();

        if(sLoanReimbursementPlans.length() > 0){
            try{
                // parse plans from xml           
                SAXReader reader = new SAXReader(false);
                Document document = reader.read(new StringReader(sLoanReimbursementPlans));
                Element plansElem = document.getRootElement();
         
                if(plansElem!=null){  
                    Iterator plansIter = plansElem.elementIterator("Plan");
        
                    String sTmpDate, sTmpCapital, sTmpInterest;
                    Element planElem;
                    String[] plan;
                    
                    while(plansIter.hasNext()){
                        planElem = (Element)plansIter.next();
                                                
                        //sTmpDate     = ScreenHelper.checkString(planElem.elementText("Date"));
                        //sTmpCapital  = ScreenHelper.checkString(planElem.elementText("Capital"));
                        //sTmpInterest = ScreenHelper.checkString(planElem.elementText("Interest"));
                        
                        //plan = new String[]{sTmpDate,sTmpCapital,sTmpInterest};
                        //plans.add(plan);
                        
                        plans.add(planElem);
                    }
                }
            }
            catch(Exception e){
                if(Debug.enabled) e.printStackTrace();
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }
                
        return plans;
    }

    public String getSupplierName(){
    	return getSupplierName(getSupplierUid());
    }
    
    //--- GET SUPPLIER NAME -----------------------------------------------------------------------
    public String getSupplierName(String sSupplierUid){
        if(ScreenHelper.checkString(sSupplierUid).length()==0){
        	return "";
        }
        String sSupplierName = ""; 
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_SUPPLIER_NAME"+
                          " FROM oc_suppliers"+
                          "  WHERE (OC_SUPPLIER_SERVERID = ? AND OC_SUPPLIER_OBJECTID = ?)";            
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sSupplierUid.substring(0,sSupplierUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sSupplierUid.substring(sSupplierUid.indexOf(".")+1)));
            
            rs = ps.executeQuery();            
            if(rs.next()){
                sSupplierName = ScreenHelper.checkString(rs.getString("OC_SUPPLIER_NAME"));
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return sSupplierName;
    }
    
    //--- GET PARENT CODE -------------------------------------------------------------------------
    public String getParentCode(String sAssetUid){
        String sParentCode = ""; 
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_ASSET_CODE"+
                          " FROM oc_assets"+
                          "  WHERE (OC_ASSET_SERVERID = ? AND OC_ASSET_OBJECTID = ?)";            
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sAssetUid.substring(0,sAssetUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sAssetUid.substring(sAssetUid.indexOf(".")+1)));
            
            rs = ps.executeQuery();            
            if(rs.next()){
                sParentCode = ScreenHelper.checkString(rs.getString("OC_ASSET_CODE"));
            }
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return sParentCode;
    }
    
}
