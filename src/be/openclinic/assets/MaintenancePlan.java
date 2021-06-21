package be.openclinic.assets;

import be.openclinic.common.OC_Object;
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

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;


public class MaintenancePlan extends OC_Object {
    public int serverId;
    public int objectId;    

    public String name; // 255
    public String assetUID; // 50
    public java.util.Date startDate;
    public java.util.Date endDate;
    public String frequency;
    public String operator; // 255
    public String planManager; // 255
    public String instructions; // text
    public String type;
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
    public String nomenclature;
    public int lockedBy;
    
    public String getNomenclature() {
		return nomenclature;
	}

	public void setNomenclature(String nomenclature) {
		this.nomenclature = nomenclature;
	}

	public int getLockedBy() {
		return lockedBy;
	}

	public void setLockedBy(int lockedBy) {
		this.lockedBy = lockedBy;
	}

    public static void updateMaintenanceplan(Element ePlan) throws Exception{
    	int serverid = Integer.parseInt(ePlan.attributeValue("serverid"));
    	int objectid = Integer.parseInt(ePlan.attributeValue("objectid"));
    	java.util.Date updatetime = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(ePlan.element("updatetime").getTextTrim());
    	//First we check if this maintenanceplan record has been changed
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_serverid=? and oc_maintenanceplan_objectid=? and oc_maintenanceplan_updatetime=?");
		ps.setInt(1, serverid);
		ps.setInt(2, objectid);
		ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
		ResultSet rs =ps.executeQuery();
		if(!rs.next()){
			//The record has changed. Let's update it
    		rs.close();
    		ps.close();
			ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_serverid=? and oc_maintenanceplan_objectid=?");
    		ps.setInt(1, serverid);
    		ps.setInt(2, objectid);
    		rs =ps.executeQuery();
    		if(!rs.next()){
    			//The record does not exist yet, create it
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("insert into oc_maintenanceplans(oc_maintenanceplan_serverid,oc_maintenanceplan_objectid) values(?,?)");
        		ps.setInt(1, serverid);
        		ps.setInt(2, objectid);
    			ps.execute();
    		}
			MaintenancePlan plan = new MaintenancePlan();
			plan.setUid(serverid+"."+objectid);
			plan.setServerId(serverid);
			plan.setObjectId(objectid);
			plan.setAssetUID(ePlan.element("assetuid")==null?"":ePlan.element("assetuid").getText());
			plan.setComment1(ePlan.element("comment1")==null?"":ePlan.element("comment1").getText());
			plan.setComment2(ePlan.element("comment2")==null?"":ePlan.element("comment2").getText());
			plan.setComment3(ePlan.element("comment3")==null?"":ePlan.element("comment3").getText());
			plan.setComment4(ePlan.element("comment4")==null?"":ePlan.element("comment4").getText());
			plan.setComment5(ePlan.element("comment5")==null?"":ePlan.element("comment5").getText());
			plan.setComment6(ePlan.element("comment6")==null?"":ePlan.element("comment6").getText());
			plan.setComment7(ePlan.element("comment7")==null?"":ePlan.element("comment7").getText());
			plan.setComment8(ePlan.element("comment8")==null?"":ePlan.element("comment8").getText());
			plan.setComment9(ePlan.element("comment9")==null?"":ePlan.element("comment9").getText());
			plan.setComment10(ePlan.element("comment10")==null?"":ePlan.element("comment10").getText());
			plan.setEndDate(ePlan.element("enddate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(ePlan.element("enddate").getText()));
			plan.setFrequency(ePlan.element("frequency")==null?"":ePlan.element("frequency").getText());
			plan.setInstructions(ePlan.element("instructions")==null?"":ePlan.element("instructions").getText());
			plan.setLockedBy(Integer.parseInt(ePlan.element("lockedby")==null?"0":ePlan.element("lockedby").getText()));
			plan.setName(ePlan.element("name")==null?"":ePlan.element("name").getText());
			plan.setOperator(ePlan.element("operator")==null?"":ePlan.element("operator").getText());
			plan.setPlanManager(ePlan.element("planmanager")==null?"":ePlan.element("planmanager").getText());
			plan.setStartDate(ePlan.element("startdate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(ePlan.element("startdate").getText()));
			plan.setType(ePlan.element("type")==null?"":ePlan.element("type").getText());
			plan.store(ePlan.element("updateid")==null?"":ePlan.element("updateid").getText());
		}
		rs.close();
		ps.close();
		//Add documents from XML
    	Iterator iDocuments = ePlan.element("documents").elementIterator("document");
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
		conn.close();
		Iterator iOperations = ePlan.element("maintenanceoperations").elementIterator("maintenanceoperation");
		while(iOperations.hasNext()){
			Element eOperation = (Element)iOperations.next();
			try{
				MaintenanceOperation.updateMaintenanceoperation(eOperation);
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
    
    public static void addTagString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_maintenanceplan_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			//xml.append("<"+tag+"><![CDATA["+HTMLEntities.htmlentities(s)+"]]></"+tag+">");
			xml.append("<"+tag+">"+HTMLEntities.xmlencode(s)+"</"+tag+">");
		}
    }
    
    public static void addTagBinaryString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_maintenanceplan_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			xml.append("<"+tag+"><![CDATA["+HTMLEntities.xmlencode(s)+"]]></"+tag+">");
		}
    }
    
    public static void addTagDate(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
    	try{
	    	java.util.Date d = rs.getTimestamp("oc_maintenanceplan_"+tag);
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
    		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_serverid=? and oc_maintenanceplan_objectid=? and oc_maintenanceplan_objectid>-1");
    		ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
    		ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			xml.append("<maintenanceplan serverid='"+rs.getInt("oc_maintenanceplan_serverid")+"' objectid='"+rs.getInt("oc_maintenanceplan_objectid")+"'>");
    			addTagBinaryString(xml,"name",rs);
    			addTagString(xml,"assetuid",rs);
    			addTagDate(xml,"startdate",rs);
    			addTagString(xml,"frequency",rs);
    			addTagBinaryString(xml,"operator",rs);
    			addTagBinaryString(xml,"planmanager",rs);
    			addTagBinaryString(xml,"instructions",rs);
    			addTagDate(xml,"updatetime",rs);
    			addTagString(xml,"updateid",rs);
    			addTagBinaryString(xml,"type",rs);
    			addTagDate(xml,"enddate",rs);
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
    			addTagString(xml,"lockedby",rs);
    			//Now add the maintenanceoperations
    			xml.append("<maintenanceoperations>");
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_maintenanceplanuid=? and oc_maintenanceoperation_objectid>-1");
    			ps.setString(1, uid);
    			rs = ps.executeQuery();
    			while(rs.next()){
    				xml.append(MaintenanceOperation.toXml(rs.getString("oc_maintenanceoperation_serverid")+"."+rs.getString("oc_maintenanceoperation_objectid")));
    			}
    			xml.append("</maintenanceoperations>");
    			//Now add the documents
    			xml.append("<documents>");
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("select * from arch_documents where arch_document_objectid>-1 and arch_document_storagename is not null and arch_document_storagename<>'' and arch_document_category='maintenanceplan' and arch_document_reference='maintenanceplan."+uid+"'");
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
    			xml.append("</maintenanceplan>");
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
    
    public boolean isOverdue(){
    	return isOverdue(new java.util.Date());
    }
    
    public boolean isOverdue(java.util.Date date){
    	java.util.Date nd = getNextOperationDate();
    	return nd!=null && nd.before(date);
    }
    
    public java.util.Date getNextOperationDate(){
    	if(isInactive()){
    		return null;
    	}
    	java.util.Date date = null;
    	//First find out the last next operation date specified for this plan
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from OC_MAINTENANCEOPERATIONS where OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID=? order by OC_MAINTENANCEOPERATION_NEXTDATE desc");
    		ps.setString(1, getUid());
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			date = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	if(date==null){
    		//No operations specified yet, take the startdate of thye plan as the next operation date
    		date = getStartDate();
    	}
    	return date;
    }
    
    public String getComment10() {
		return comment10;
	}

	public void setComment10(String comment10) {
		this.comment10 = comment10;
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

	public java.util.Date getEndDate() {
		return endDate;
	}

	public void setEndDate(java.util.Date endDate) {
		this.endDate = endDate;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAssetUID() {
		return assetUID;
	}
	
	public String getAssetNomenclature(){
		String nomenclature="";
		Asset asset = getAsset();
		if(asset!=null){
			nomenclature=asset.getNomenclature();
		}
		return nomenclature;
	}
	
	public String getAssetName(){
		String name="";
		Asset asset = getAsset();
		if(asset!=null){
			name=asset.getDescription();
		}
		return name;
	}
	
	public String getAssetCode(){
		String code="";
		Asset asset = getAsset();
		if(asset!=null){
			code=asset.getCode();
		}
		return code;
	}
	
	public boolean isInactive(){
		return isInactive(new java.util.Date());
	}
	
	public boolean isInactive(java.util.Date date){
		return (getEndDate()!=null && !getEndDate().after(date)) || (getAsset()!=null && getAsset().isInactive(date));
	}
	
	public Asset getAsset(){
		Asset asset = null;
		if(ScreenHelper.checkString(getAssetUID()).length()>0){
			 asset = Asset.get(getAssetUID());
		}
		return asset;
	}

	public void setAssetUID(String assetUID) {
		this.assetUID = assetUID;
	}

	public java.util.Date getStartDate() {
		return startDate;
	}

	public void setStartDate(java.util.Date startDate) {
		this.startDate = startDate;
	}

	public String getFrequency() {
		return frequency;
	}

	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getPlanManager() {
		return planManager;
	}

	public void setPlanManager(String planManager) {
		this.planManager = planManager;
	}

	public String getInstructions() {
		return instructions;
	}

	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}

	//--- CONSTRUCTOR ---
    public MaintenancePlan(){
        serverId = -1;
        objectId = -1;

        name = "";
        assetUID = "";
        startDate = null;
        endDate = null;

        frequency = "";
        operator = "";
        planManager = "";
        instructions = "";
        comment1 = "";
        comment2 = "";
        comment3 = "";
        comment4 = "";
        comment5 = "";
        comment6 = "";
        comment7 = "";
        comment8 = "";
        comment9 = "";
        comment10 = "";
        lockedBy = -1;
    }
    
    //--- GET NAME --------------------------------------------------------------------------------
    public static String getName(String sPlanUID){
    	String sPlanName = "";

        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_MAINTENANCEPLAN_NAME FROM OC_MAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sPlanUID.substring(0,sPlanUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sPlanUID.substring(sPlanUID.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                sPlanName = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
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
        
    	return sPlanName;
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
                // insert new plan
                sSql = "INSERT INTO OC_MAINTENANCEPLANS(OC_MAINTENANCEPLAN_SERVERID,OC_MAINTENANCEPLAN_OBJECTID,"+
                       "  OC_MAINTENANCEPLAN_NAME,OC_MAINTENANCEPLAN_ASSETUID,OC_MAINTENANCEPLAN_STARTDATE,"+
                	   "  OC_MAINTENANCEPLAN_FREQUENCY,OC_MAINTENANCEPLAN_OPERATOR,OC_MAINTENANCEPLAN_PLANMANAGER,"+
                       "  OC_MAINTENANCEPLAN_INSTRUCTIONS,OC_MAINTENANCEPLAN_TYPE,OC_MAINTENANCEPLAN_ENDDATE,OC_MAINTENANCEPLAN_COMMENT1"
                       + ",OC_MAINTENANCEPLAN_COMMENT2,OC_MAINTENANCEPLAN_COMMENT3,OC_MAINTENANCEPLAN_COMMENT4,OC_MAINTENANCEPLAN_COMMENT5"
                       + ",OC_MAINTENANCEPLAN_COMMENT6,OC_MAINTENANCEPLAN_COMMENT7,OC_MAINTENANCEPLAN_COMMENT8,OC_MAINTENANCEPLAN_COMMENT9"
                       + ",OC_MAINTENANCEPLAN_COMMENT10"+
                       "  ,OC_MAINTENANCEPLAN_UPDATETIME,OC_MAINTENANCEPLAN_UPDATEID,OC_MAINTENANCEPLAN_LOCKEDBY)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 11
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEPLANS",-100000);
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                
                ps.setString(psIdx++,name);
                ps.setString(psIdx++,assetUID);

                // purchaseDate date might be unspecified
                if(startDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(startDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                int nFrequency=0;
                try{
                	nFrequency=Integer.parseInt(frequency);
                }
                catch(Exception r){}
                
                ps.setInt(psIdx++,nFrequency);
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,planManager);
                ps.setString(psIdx++,instructions);
                ps.setString(psIdx++,type);

                if(endDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(endDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
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
                
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setInt(psIdx++,lockedBy);
                
                ps.executeUpdate();
            } 
            else{
            	storeHistory();
                // update existing record
                sSql = "UPDATE OC_MAINTENANCEPLANS SET"+
                       "  OC_MAINTENANCEPLAN_NAME = ?, OC_MAINTENANCEPLAN_ASSETUID = ?, OC_MAINTENANCEPLAN_STARTDATE = ?,"+
                	   "  OC_MAINTENANCEPLAN_FREQUENCY = ?, OC_MAINTENANCEPLAN_OPERATOR = ?, OC_MAINTENANCEPLAN_PLANMANAGER = ?,"+
                       "  OC_MAINTENANCEPLAN_INSTRUCTIONS = ?,OC_MAINTENANCEPLAN_TYPE = ?,OC_MAINTENANCEPLAN_ENDDATE = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT1 = ?,OC_MAINTENANCEPLAN_COMMENT2 = ?,OC_MAINTENANCEPLAN_COMMENT3 = ?,OC_MAINTENANCEPLAN_COMMENT4 = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT5 = ?,OC_MAINTENANCEPLAN_COMMENT6 = ?,OC_MAINTENANCEPLAN_COMMENT7 = ?,OC_MAINTENANCEPLAN_COMMENT8 = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT9 = ?,OC_MAINTENANCEPLAN_COMMENT10 = ?"+
                       "  ,OC_MAINTENANCEPLAN_UPDATETIME = ?, OC_MAINTENANCEPLAN_UPDATEID = ?, OC_MAINTENANCEPLAN_LOCKEDBY=?"+ // update-info
                       " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                
                ps.setString(psIdx++,name);
                ps.setString(psIdx++,assetUID);

                // purchaseDate date might be unspecified
                if(startDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(startDate.getTime()));
                }
                else{
                    ps.setObject(psIdx++,null);
                }
                
                ps.setString(psIdx++,frequency);
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,planManager);
                ps.setString(psIdx++,instructions);
                ps.setString(psIdx++,type);
                if(endDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(endDate.getTime()));
                }
                else{
                    ps.setObject(psIdx++,null);
                }
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

                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setInt(psIdx++,lockedBy);
                
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
    public boolean hasHistory(){
        boolean bHistory=false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM oc_maintenanceplanshistory"+
                          " WHERE (OC_maintenanceplan_SERVERID = ? AND OC_maintenanceplan_OBJECTID = ?)";
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
        
    
    public boolean storeHistory(){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            // insert new plan
            sSql = "INSERT INTO OC_MAINTENANCEPLANSHISTORY(OC_MAINTENANCEPLAN_SERVERID,OC_MAINTENANCEPLAN_OBJECTID,"+
                   "  OC_MAINTENANCEPLAN_NAME,OC_MAINTENANCEPLAN_ASSETUID,OC_MAINTENANCEPLAN_STARTDATE,"+
            	   "  OC_MAINTENANCEPLAN_FREQUENCY,OC_MAINTENANCEPLAN_OPERATOR,OC_MAINTENANCEPLAN_PLANMANAGER,"+
                   "  OC_MAINTENANCEPLAN_INSTRUCTIONS,OC_MAINTENANCEPLAN_TYPE,OC_MAINTENANCEPLAN_ENDDATE,OC_MAINTENANCEPLAN_COMMENT1"
                   + ",OC_MAINTENANCEPLAN_COMMENT2,OC_MAINTENANCEPLAN_COMMENT3,OC_MAINTENANCEPLAN_COMMENT4,OC_MAINTENANCEPLAN_COMMENT5"
                   + ",OC_MAINTENANCEPLAN_COMMENT6,OC_MAINTENANCEPLAN_COMMENT7,OC_MAINTENANCEPLAN_COMMENT8,OC_MAINTENANCEPLAN_COMMENT9"
                   + ",OC_MAINTENANCEPLAN_COMMENT10"+
                   "  ,OC_MAINTENANCEPLAN_UPDATETIME,OC_MAINTENANCEPLAN_UPDATEID,OC_MAINTENANCEPLAN_LOCKEDBY,OC_MAINTENANCEPLAN_HISTORYDATE,OC_MAINTENANCEPLAN_HISTORYUSER)"+
                   " select OC_MAINTENANCEPLAN_SERVERID,OC_MAINTENANCEPLAN_OBJECTID,"+
		            "  OC_MAINTENANCEPLAN_NAME,OC_MAINTENANCEPLAN_ASSETUID,OC_MAINTENANCEPLAN_STARTDATE,"+
		     	   "  OC_MAINTENANCEPLAN_FREQUENCY,OC_MAINTENANCEPLAN_OPERATOR,OC_MAINTENANCEPLAN_PLANMANAGER,"+
		            "  OC_MAINTENANCEPLAN_INSTRUCTIONS,OC_MAINTENANCEPLAN_TYPE,OC_MAINTENANCEPLAN_ENDDATE,OC_MAINTENANCEPLAN_COMMENT1"
		            + ",OC_MAINTENANCEPLAN_COMMENT2,OC_MAINTENANCEPLAN_COMMENT3,OC_MAINTENANCEPLAN_COMMENT4,OC_MAINTENANCEPLAN_COMMENT5"
		            + ",OC_MAINTENANCEPLAN_COMMENT6,OC_MAINTENANCEPLAN_COMMENT7,OC_MAINTENANCEPLAN_COMMENT8,OC_MAINTENANCEPLAN_COMMENT9"
		            + ",OC_MAINTENANCEPLAN_COMMENT10"+
		            "  ,OC_MAINTENANCEPLAN_UPDATETIME,OC_MAINTENANCEPLAN_UPDATEID,OC_MAINTENANCEPLAN_LOCKEDBY,?,? from OC_MAINTENANCEPLANS"
		            + " where OC_MAINTENANCEPLAN_SERVERID=? and OC_MAINTENANCEPLAN_OBJECTID=?";
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
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sPlanUID){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM OC_MAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sPlanUID.substring(0,sPlanUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sPlanUID.substring(sPlanUID.indexOf(".")+1)));
            
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
    public static MaintenancePlan get(MaintenancePlan plan){
    	return get(plan.getUid());
    }
       
    public static MaintenancePlan get(String splanUid){
    	MaintenancePlan plan = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        if(splanUid.split("\\.").length==2) {
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        
	        try{
	            String sSql = "SELECT * FROM OC_MAINTENANCEPLANS"+
	                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
	            ps = oc_conn.prepareStatement(sSql);
	            ps.setInt(1,Integer.parseInt(splanUid.substring(0,splanUid.indexOf("."))));
	            ps.setInt(2,Integer.parseInt(splanUid.substring(splanUid.indexOf(".")+1)));
	
	            // execute
	            rs = ps.executeQuery();
	            if(rs.next()){
	                plan = new MaintenancePlan();
	                plan.setUid(rs.getString("OC_MAINTENANCEPLAN_SERVERID")+"."+rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
	                plan.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_SERVERID"));
	                plan.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
	                
	                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
	                plan.assetUID     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_ASSETUID"));
	                plan.startDate    = rs.getDate("OC_MAINTENANCEPLAN_STARTDATE");
	                plan.endDate    = rs.getDate("OC_MAINTENANCEPLAN_ENDDATE");
	                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
	                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
	                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
	                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
	                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
	                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
	                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
	                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
	                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
	                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
	                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
	                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
	                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
	                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
	                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
	                
	                // update-info
	                plan.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEPLAN_UPDATETIME"));
	                plan.setUpdateUser(rs.getString("OC_MAINTENANCEPLAN_UPDATEID"));
	                plan.setLockedBy(rs.getInt("OC_MAINTENANCEPLAN_LOCKEDBY"));
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
        }
        return plan;
    }
        
    public static MaintenancePlan getHistory(String splanUid,java.util.Date timestamp){
    	MaintenancePlan plan = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM OC_MAINTENANCEPLANSHISTORY"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ? and oc_maintenanceplan_historydate=?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(splanUid.substring(0,splanUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(splanUid.substring(splanUid.indexOf(".")+1)));
            ps.setTimestamp(3, new java.sql.Timestamp(timestamp.getTime()));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                plan = new MaintenancePlan();
                plan.setUid(rs.getString("OC_MAINTENANCEPLAN_SERVERID")+"."+rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                plan.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_SERVERID"));
                plan.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                
                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                plan.assetUID     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_ASSETUID"));
                plan.startDate    = rs.getDate("OC_MAINTENANCEPLAN_STARTDATE");
                plan.endDate    = rs.getDate("OC_MAINTENANCEPLAN_ENDDATE");
                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                
                // update-info
                plan.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEPLAN_UPDATETIME"));
                plan.setUpdateUser(rs.getString("OC_MAINTENANCEPLAN_UPDATEID"));
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
        
        return plan;
    }
        
    public static MaintenancePlan getFromDefault(String splanUid){
    	MaintenancePlan plan = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM OC_DEFAULTMAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_UID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setString(1,splanUid);

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                plan = new MaintenancePlan();
                plan.setUid("-1");
                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                plan.nomenclature = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NOMENCLATURE"));
                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
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
        
        return plan;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<MaintenancePlan> getList(){
    	return getList(new MaintenancePlan());     	
    }
    
    public static List<MaintenancePlan> getList(MaintenancePlan findItem){
        List<MaintenancePlan> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	//*** compose query ***************************
            String sSql = "SELECT * FROM OC_MAINTENANCEPLANS,OC_ASSETS WHERE oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') "; // 'where' facilitates further composition of query

            //*** search-criteria *** 
            if(findItem.name.length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_NAME LIKE '%"+findItem.name+"%'";
            }
            if(ScreenHelper.checkString(findItem.assetUID).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_ASSETUID = '"+findItem.assetUID+"'";
            }
            if(ScreenHelper.checkString(findItem.type).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_TYPE = '"+findItem.type+"'";
            }
            if(ScreenHelper.checkString(findItem.getTag()).length() > 0){
                sSql+= " AND OC_ASSET_SERVICE like '"+findItem.getTag()+"%'";
            }
            if(ScreenHelper.checkString(findItem.operator).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_OPERATOR LIKE '%"+findItem.operator+"%'";
            }
            
            sSql+= " ORDER BY OC_MAINTENANCEPLAN_NAME ASC";
            
            ps = oc_conn.prepareStatement(sSql);
            
                        
            //*** execute query ***************************
            rs = ps.executeQuery();
            MaintenancePlan plan;
            
            while(rs.next()){
            	plan = new MaintenancePlan();   
            	plan.setUid(rs.getString("OC_MAINTENANCEPLAN_SERVERID")+"."+rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                plan.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_SERVERID"));
                plan.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));

                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                plan.assetUID     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_ASSETUID"));
                plan.startDate    = rs.getDate("OC_MAINTENANCEPLAN_STARTDATE");
                plan.endDate    = rs.getDate("OC_MAINTENANCEPLAN_ENDDATE");
                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                
                // update-info
                plan.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEPLAN_UPDATETIME"));
                plan.setUpdateUser(rs.getString("OC_MAINTENANCEPLAN_UPDATEID"));
                plan.setLockedBy(rs.getInt("OC_MAINTENANCEPLAN_LOCKEDBY"));
                
                foundObjects.add(plan);
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
    
    public static void deleteDefault(int uid){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	ps=oc_conn.prepareStatement("delete from oc_defaultmaintenanceplans where oc_maintenanceplan_uid=?");
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

    public static void copyFromDefault(String assetUid, String defaultPlanUid, int updateUid){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	ps = oc_conn.prepareStatement("insert into oc_maintenanceplans ("
        			+ " OC_MAINTENANCEPLAN_SERVERID,"
        			+ " OC_MAINTENANCEPLAN_OBJECTID,"
        			+ " OC_MAINTENANCEPLAN_NAME,"
        			+ " OC_MAINTENANCEPLAN_ASSETUID,"
        			+ " OC_MAINTENANCEPLAN_STARTDATE,"
        			+ " OC_MAINTENANCEPLAN_ENDDATE,"
        			+ " OC_MAINTENANCEPLAN_FREQUENCY,"
        			+ " OC_MAINTENANCEPLAN_OPERATOR,"
        			+ " OC_MAINTENANCEPLAN_PLANMANAGER,"
        			+ " OC_MAINTENANCEPLAN_INSTRUCTIONS,"
        			+ " OC_MAINTENANCEPLAN_TYPE,"
        			+ " OC_MAINTENANCEPLAN_UPDATETIME,"
        			+ " OC_MAINTENANCEPLAN_UPDATEUID,"
        			+ " OC_MAINTENANCEPLAN_COMMENT1,"
        			+ " OC_MAINTENANCEPLAN_COMMENT2,"
        			+ " OC_MAINTENANCEPLAN_COMMENT3,"
        			+ " OC_MAINTENANCEPLAN_COMMENT4,"
        			+ " OC_MAINTENANCEPLAN_COMMENT5,"
        			+ " OC_MAINTENANCEPLAN_COMMENT6,"
        			+ " OC_MAINTENANCEPLAN_COMMENT7,"
        			+ " OC_MAINTENANCEPLAN_COMMENT8,"
        			+ " OC_MAINTENANCEPLAN_COMMENT9,"
        			+ " OC_MAINTENANCEPLAN_COMMENT10)"
        			+ " select "
        			+ " ?," //serverid
        			+ " ?," //objectid
        			+ " OC_MAINTENANCEPLAN_NAME,"
        			+ " ?," //assetuid
        			+ " OC_MAINTENANCEPLAN_STARTDATE,"
        			+ " OC_MAINTENANCEPLAN_ENDDATE,"
        			+ " OC_MAINTENANCEPLAN_FREQUENCY,"
        			+ " OC_MAINTENANCEPLAN_OPERATOR,"
        			+ " OC_MAINTENANCEPLAN_PLANMANAGER,"
        			+ " OC_MAINTENANCEPLAN_INSTRUCTIONS,"
        			+ " OC_MAINTENANCEPLAN_TYPE,"
        			+ " ?," //updatetime
        			+ " ?," //updateuid
        			+ " OC_MAINTENANCEPLAN_COMMENT1,"
        			+ " OC_MAINTENANCEPLAN_COMMENT2,"
        			+ " OC_MAINTENANCEPLAN_COMMENT3,"
        			+ " OC_MAINTENANCEPLAN_COMMENT4,"
        			+ " OC_MAINTENANCEPLAN_COMMENT5,"
        			+ " OC_MAINTENANCEPLAN_COMMENT6,"
        			+ " OC_MAINTENANCEPLAN_COMMENT7,"
        			+ " OC_MAINTENANCEPLAN_COMMENT8,"
        			+ " OC_MAINTENANCEPLAN_COMMENT9,"
        			+ " OC_MAINTENANCEPLAN_COMMENT10)"
        			+ " from oc_maintenanceplans where "
        			+ " OC_MAINTENANCEPLAN_UID=?");
        	ps.setInt(1, MedwanQuery.getInstance().getConfigInt("serverId"));
        	ps.setInt(2, MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEPLANS"));
        	ps.setString(3, assetUid);
        	ps.setTimestamp(4, new java.sql.Timestamp(new java.util.Date().getTime()));
        	ps.setInt(5, updateUid);
        	ps.setString(6, defaultPlanUid);
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
    
    public void copyToDefault(String nomenclaturecode){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	ps = oc_conn.prepareStatement("delete from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=? and oc_maintenanceplan_name=? and oc_maintenanceplan_frequency=?");
        	ps.setString(1, nomenclaturecode);
        	ps.setString(2, getName());
        	ps.setString(3, getFrequency());
        	ps.execute();
        	ps.close();
        	ps = oc_conn.prepareStatement("insert into oc_defaultmaintenanceplans ("
        			+ " OC_MAINTENANCEPLAN_NAME,"
        			+ " OC_MAINTENANCEPLAN_UID,"
        			+ " OC_MAINTENANCEPLAN_NOMENCLATURE,"
        			+ " OC_MAINTENANCEPLAN_STARTDATE,"
        			+ " OC_MAINTENANCEPLAN_ENDDATE,"
        			+ " OC_MAINTENANCEPLAN_FREQUENCY,"
        			+ " OC_MAINTENANCEPLAN_OPERATOR,"
        			+ " OC_MAINTENANCEPLAN_PLANMANAGER,"
        			+ " OC_MAINTENANCEPLAN_INSTRUCTIONS,"
        			+ " OC_MAINTENANCEPLAN_TYPE,"
        			+ " OC_MAINTENANCEPLAN_COMMENT1,"
        			+ " OC_MAINTENANCEPLAN_COMMENT2,"
        			+ " OC_MAINTENANCEPLAN_COMMENT3,"
        			+ " OC_MAINTENANCEPLAN_COMMENT4,"
        			+ " OC_MAINTENANCEPLAN_COMMENT5,"
        			+ " OC_MAINTENANCEPLAN_COMMENT6,"
        			+ " OC_MAINTENANCEPLAN_COMMENT7,"
        			+ " OC_MAINTENANCEPLAN_COMMENT8,"
        			+ " OC_MAINTENANCEPLAN_COMMENT9,"
        			+ " OC_MAINTENANCEPLAN_COMMENT10)"
        			+ " values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
        	ps.setString(1, getName());
        	ps.setInt(2, MedwanQuery.getInstance().getOpenclinicCounter("DEFAULTMAINTENANCEPLANUID"));
        	ps.setString(3, nomenclaturecode);
        	ps.setDate(4, getStartDate()==null?null:new java.sql.Date(getStartDate().getTime()));
        	ps.setDate(5, getEndDate()==null?null:new java.sql.Date(getEndDate().getTime()));
        	ps.setString(6, getFrequency());
        	ps.setString(7, getOperator());
        	ps.setString(8, getPlanManager());
        	ps.setString(9, getInstructions());
        	ps.setString(10, getType());
        	ps.setString(11, getComment1());
        	ps.setString(12, getComment2());
        	ps.setString(13, getComment3());
        	ps.setString(14, getComment4());
        	ps.setString(15, getComment5());
        	ps.setString(16, getComment6());
        	ps.setString(17, getComment7());
        	ps.setString(18, getComment8());
        	ps.setString(19, getComment9());
        	ps.setString(20, getComment10());
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

    public void saveDefault(){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        if(getUid()==null || getUid().length()==0) {
        	setUid(MedwanQuery.getInstance().getOpenclinicCounter("DEFAULTMAINTENANCEPLANUID")+"");
        }
        try{
        	ps = oc_conn.prepareStatement("delete from oc_defaultmaintenanceplans where oc_maintenanceplan_uid=?");
        	ps.setString(1, getUid());
        	ps.execute();
        	ps.close();
        	ps = oc_conn.prepareStatement("insert into oc_defaultmaintenanceplans ("
        			+ " OC_MAINTENANCEPLAN_NAME,"
        			+ " OC_MAINTENANCEPLAN_UID,"
        			+ " OC_MAINTENANCEPLAN_NOMENCLATURE,"
        			+ " OC_MAINTENANCEPLAN_STARTDATE,"
        			+ " OC_MAINTENANCEPLAN_ENDDATE,"
        			+ " OC_MAINTENANCEPLAN_FREQUENCY,"
        			+ " OC_MAINTENANCEPLAN_OPERATOR,"
        			+ " OC_MAINTENANCEPLAN_PLANMANAGER,"
        			+ " OC_MAINTENANCEPLAN_INSTRUCTIONS,"
        			+ " OC_MAINTENANCEPLAN_TYPE,"
        			+ " OC_MAINTENANCEPLAN_COMMENT1,"
        			+ " OC_MAINTENANCEPLAN_COMMENT2,"
        			+ " OC_MAINTENANCEPLAN_COMMENT3,"
        			+ " OC_MAINTENANCEPLAN_COMMENT4,"
        			+ " OC_MAINTENANCEPLAN_COMMENT5,"
        			+ " OC_MAINTENANCEPLAN_COMMENT6,"
        			+ " OC_MAINTENANCEPLAN_COMMENT7,"
        			+ " OC_MAINTENANCEPLAN_COMMENT8,"
        			+ " OC_MAINTENANCEPLAN_COMMENT9,"
        			+ " OC_MAINTENANCEPLAN_COMMENT10)"
        			+ " values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
        	ps.setString(1, getName());
        	ps.setInt(2, Integer.parseInt(getUid()));
        	ps.setString(3, getNomenclature());
        	ps.setDate(4, getStartDate()==null?null:new java.sql.Date(getStartDate().getTime()));
        	ps.setDate(5, getEndDate()==null?null:new java.sql.Date(getEndDate().getTime()));
        	ps.setString(6, getFrequency());
        	ps.setString(7, getOperator());
        	ps.setString(8, getPlanManager());
        	ps.setString(9, getInstructions());
        	ps.setString(10, getType());
        	ps.setString(11, getComment1());
        	ps.setString(12, getComment2());
        	ps.setString(13, getComment3());
        	ps.setString(14, getComment4());
        	ps.setString(15, getComment5());
        	ps.setString(16, getComment6());
        	ps.setString(17, getComment7());
        	ps.setString(18, getComment8());
        	ps.setString(19, getComment9());
        	ps.setString(20, getComment10());
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
}