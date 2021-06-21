package be.mxs.common.util.io;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.dcm4che2.data.Tag;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.dpms.medwan.common.model.vo.authentication.UserVO;
import be.mxs.common.model.vo.IdentifierFactory;
import be.mxs.common.model.vo.healthrecord.ItemContextVO;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.archiving.ArchiveDocument;
import be.openclinic.archiving.ScanDirectoryMonitor;
import be.openclinic.archiving.ScannableFileFilter;
import be.openclinic.system.SH;
import uk.org.primrose.GeneralException;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class PaxmlReader {

	public static void main(String[] args) throws GeneralException, IOException {
		PrimroseLoader.load(args[0], true);
		ScanDirectoryMonitor.loadConfig();
		Collection<File> files = FileUtils.listFiles(new File(args[1]), new WildcardFileFilter("*.paxml"), null);
		Iterator<File> iFiles = files.iterator();
		while(iFiles.hasNext()) {
			File file = iFiles.next();
			try {
				BasicFileAttributes attr = Files.readAttributes(file.toPath(), BasicFileAttributes.class);
				if(attr.lastModifiedTime().toMillis()<new java.util.Date().getTime()-24*3600*1000) {
					file.delete();
				}
				else {
					SAXReader reader = new SAXReader(false);
					Document document = reader.read(file);
					Element root = document.getRootElement();
					String personid = SH.c(root.attributeValue("personid")).trim();
					String filename = SH.c(root.attributeValue("file")).trim();
					String orderid = SH.c(root.elementText("orderid")).trim();
					String documentname = SH.c(root.elementText("name")).trim();
					String documentdate = SH.c(root.elementText("date")).trim();
					String status = SH.c(root.elementText("status")).trim();
					String summary = SH.c(root.elementText("summary")).trim();
					String absolutefilename=file.getParentFile().getAbsolutePath()+"/"+filename;
					System.out.println("Check "+absolutefilename);
					File docfile=new File(absolutefilename);
					if(docfile.exists()) {
						//We've got the matching PDF file, store it in the patient record
						//First create an external document transaction
		    			TransactionVO transaction = new TransactionFactoryGeneral().createTransactionVO(MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4")),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ARCHIVE_DOCUMENT",false); 
		    			transaction.setCreationDate(new java.util.Date());
		    			transaction.setStatus(1);
		    			transaction.setTransactionId(MedwanQuery.getInstance().getOpenclinicCounter("TransactionID"));
		    			transaction.setServerId(MedwanQuery.getInstance().getConfigInt("serverId",1));
		    			transaction.setTransactionType("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ARCHIVE_DOCUMENT");
		    			try {
		    				transaction.setUpdateTime(new SimpleDateFormat("yyyyMMddHHmmss").parse(documentdate));
		    			}
		    			catch(Exception i) {
		    				i.printStackTrace();
		    				transaction.setUpdateTime(new java.util.Date());
		    			}
		    			UserVO user = MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4"));
		    			if(user==null){
		    				MedwanQuery.getInstance().getUser("4");
		    			}
		    			transaction.setUser(user);
		    			transaction.setVersion(1);
		    			transaction.setItems(new Vector());
		    			ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_TITLE",documentname,new Date(),itemContextVO));
		    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_PERSONID",personid,new Date(),itemContextVO));
		    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_REFERENCE",orderid,new Date(),itemContextVO));
		    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_CATEGORY","medical",new Date(),itemContextVO));
		    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_DESCRIPTION",summary,new Date(),itemContextVO));
		    			itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			    		ArchiveDocument archiveDocument = ArchiveDocument.save(true, transaction, user);
		    			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
		    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_UDI",archiveDocument.udi,new Date(),itemContextVO));
	    				MedwanQuery.getInstance().updateTransaction(Integer.parseInt(personid),transaction);
	    				System.out.println("UDI="+archiveDocument.udi);
	    				ScanDirectoryMonitor.acceptIncomingFile(archiveDocument.udi, docfile);
	    				file.delete();
					}
				}
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		System.exit(0);
	}

}
