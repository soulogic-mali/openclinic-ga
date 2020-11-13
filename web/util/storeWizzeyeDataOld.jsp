<%@page import="be.openclinic.archiving.ScanDirectoryMonitor"%>
<%@page import="be.mxs.common.model.vo.healthrecord.IConstants"%>
<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.FileOutputStream"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	StringBuffer charReplace(StringBuffer sb,char from,String to){
		int chunksize=1000;
		StringBuffer newBuffer = new StringBuffer();
		for(int n=0;n<sb.length();n=n+chunksize){
			if(sb.length()-n>chunksize){
				newBuffer.append(sb.substring(n, n+chunksize).replaceAll(Character.toString(from),to));
			}
			else{
				newBuffer.append(sb.substring(n, sb.length()).replaceAll(Character.toString(from),to));
			}
		}
		return newBuffer;
	}
%>
<%
	String roomid = SH.c(request.getParameter("roomid"));
	String type = SH.c(request.getParameter("type"));
	String id = SH.c(request.getParameter("id"));
	String user = SH.c(request.getParameter("user"));
	String imagedata = SH.c(request.getParameter("imagedata"));
	//First find the matching patient
	String personid = (String)application.getAttribute("wizzeyeRoomId."+roomid);
	if(personid!=null){
		AdminPerson person = AdminPerson.getAdminPerson(personid);
		if(person.isNotEmpty()){
			//First check if the same image has not been stored before
			Connection conn = SH.getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from arch_documents where ARCH_DOCUMENT_SOURCEID=?");
			ps.setString(1,roomid+"."+id);
			ResultSet rs = ps.executeQuery();
			//If the document already exists, we will not store it a second time
			if(!rs.next()){
				rs.close();
				ps.close();
				
				//Create a new Document UID that must be used for the image
				int doccounter=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				String udi=ArchiveDocument.generateUDI(doccounter);
    			//First create a document transaction
				String sDoctitle="",filepath="";
				if(type.equalsIgnoreCase("snapshot")){
					User activeuser = User.get(Integer.parseInt(user));
					sDoctitle=getTranNoLink("wizzeye","teleconsultation.snaptshot",activeuser.getParameter("userlanguage"));
					filepath = ScanDirectoryMonitor.getFilePathAndName(udi, "png");
				}
				else if(type.equalsIgnoreCase("video")){
					User activeuser = User.get(Integer.parseInt(user));
					sDoctitle=getTranNoLink("wizzeye","teleconsultation.video",activeuser.getParameter("userlanguage"));
					filepath = ScanDirectoryMonitor.getFilePathAndName(udi, "mp4");
				}
    			int tranId = MedwanQuery.getInstance().getOpenclinicCounter("TransactionID");
    			TransactionVO transaction = new TransactionVO(tranId,"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ARCHIVE_DOCUMENT",new java.util.Date(),new java.util.Date(),IConstants.TRANSACTION_STATUS_CLOSED,MedwanQuery.getInstance().getUser(user),new Vector());
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_TITLE",
                        sDoctitle,new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_REFERENCE",
                        roomid+"."+id,new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_SOURCEID",
                        roomid+"."+id,new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_PERSONID",
                        personid,new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_STORAGENAME",
                        filepath,new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UID",
                        SH.cs("serverId","1"),new java.util.Date(),null));
    			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                        ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UDI",
                        doccounter+"",new java.util.Date(),null));
                MedwanQuery.getInstance().updateTransaction(Integer.parseInt(person.personid),transaction);

    			ArchiveDocument archDoc = ArchiveDocument.save(false,transaction,MedwanQuery.getInstance().getUser(user));
				
    			//Write the image to a file
				String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
			    String SCANDIR_TO   = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
		    	File scanDir = new File(SCANDIR_BASE+"/"+SCANDIR_TO);
		    	if(!scanDir.exists()){	
		    		scanDir.mkdir();
		    		Debug.println("INFO : 'scanDirectoryMonitor_dirTo' created");
		    	}
		    	filepath=scanDir+"/"+filepath;

				String rawdata = imagedata.substring(imagedata.indexOf(",")+1);
				rawdata = charReplace(new StringBuffer(rawdata),' ',"+").toString(); //we use charReplace for huge files
				byte[] decodedBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(rawdata);
			    FileUtils.writeByteArrayToFile(new File(filepath), decodedBytes);
			}
			rs.close();
			ps.close();
			conn.close();
		}
	}
	
%>