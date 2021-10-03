package be.openclinic.medical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.OC_Object;
import be.openclinic.system.SH;
import net.admin.AdminPerson;
import net.admin.User;

public class ImagingOrder extends OC_Object {
	private String personId;
	private java.util.Date orderDateTime;
	private java.util.Date executionDateTime;
	private java.util.Date reportDateTime;
	private String requestingUser;
	private ImagingExam imagingExam;
	private String orderComment;
	private boolean orderUrgent;
	private String orderReason;
	private boolean orderModified;
	private String orderModifiedReason;
	private boolean orderExecuted;
	private String orderExecutionComment;
	private boolean orderReported;
	private String orderReport;
	private boolean abnormality;
	private Vector<String> radiologists = new Vector<String>();
	
	public static String setOrderExecuted(String uid,String value) {
		if(value.equalsIgnoreCase("0")) {
			value="medwan.common.no";
		}
		else if(value.equalsIgnoreCase("1")) {
			value="medwan.common.yes";
		}
		else {
			return "orderexecuted value must be 0 or 1";
		}
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(uid.split("\\.")[0]), Integer.parseInt(uid.split("\\.")[1]));
			if(transaction!=null && SH.c(transaction.getTransactionType()).length()>0) {
				PreparedStatement ps = conn.prepareStatement("delete from items where serverid=? and transactionid=? and type=?");
				ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
				ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
				String suffix="";
				if(uid.split("\\.").length>2 && Integer.parseInt(uid.split("\\.")[2])>1) {
					suffix=uid.split("\\.")[2];
				}
				ps.setString(3, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix);
				ps.execute();
				ps.close();
				
				ps = conn.prepareStatement("insert into items(itemid,type,value,date,transactionid,serverid,version,versionserverid,priority,valuehash) values(?,?,?,?,?,?,?,?,?,?)");
				ps.setInt(1, MedwanQuery.getInstance().getOpenclinicCounter("ItemID"));
				ps.setString(2, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix);
				ps.setString(3, value);
				ps.setTimestamp(4, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps.setInt(5,Integer.parseInt(uid.split("\\.")[1]));
				ps.setInt(6, Integer.parseInt(uid.split("\\.")[0]));
				ps.setInt(7, 1);
				ps.setInt(8, Integer.parseInt(uid.split("\\.")[0]));
				ps.setInt(9, 1);
				ps.setInt(10, ("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix+value).hashCode());
				if(ps.executeUpdate()==0) {
					ps.close();
					conn.close();
					return "orderexecuted could not be updated for imagingorderid="+uid;
				}
				ps.close();
				conn.close();
			}
			else {
				return "orderexecuted could not be updated for imagingorderid="+uid;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
			return "orderexecuted could not be updated for imagingorderid="+uid;
		}
		return "";
	}
	
	public static Vector<ImagingOrder> get(String id) {
		Vector<ImagingOrder> orders = new Vector<ImagingOrder>();
		if(id!=null && id.split("\\.").length>=2 && getServerId(id)!=-1 && getObjectId(id)!=-1) {
			TransactionVO transaction = MedwanQuery.getInstance().loadTransactionNoCache(Integer.parseInt(id.split("\\.")[0]),Integer.parseInt(id.split("\\.")[1]));
			for(int n=1;n<10;n++) {
				if(id.split("\\.").length>2 && !(id.split("\\.")[2].equalsIgnoreCase(n+""))) {
					continue;
				}
				String suffix="";
				if(n>1) {
					suffix=n+"";
				}
				if(transaction!=null) {
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0) {
						ImagingOrder order = new ImagingOrder();
						order.setUid(transaction.getUid()+"."+n);
						order.setPersonId(""+MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()));
						order.setOrderDateTime(transaction.getUpdateTime());
						order.setReportDateTime(transaction.getTimestamp());
						order.setRequestingUser(transaction.getUser().userId+"");
						order.setImagingExam(new ImagingExam());
						order.getImagingExam().setIdSystem("be.openclinic.radiology.imagetype");
						order.getImagingExam().setIdValue(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix));
						order.getImagingExam().setDescription(SH.getTranNoLink("mir_type", order.getImagingExam().getIdValue(), "en"));
						order.setOrderComment(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_SPECIFICATION"+suffix));
						order.setOrderUrgent(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_URGENT"+suffix).equalsIgnoreCase("medwan.common.true")?true:false);
						order.setOrderReason(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_EXAMINATIONREASON"+suffix));
						order.setOrderModified(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORIGINAL_MODIFIED"+suffix).equalsIgnoreCase("medwan.common.true")?true:false);
						order.setOrderModifiedReason(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_ORIGINAL_MODIFIED_REASON"+suffix));
						order.setOrderExecuted(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix).equalsIgnoreCase("medwan.common.yes")?true:false);
						order.setOrderExecutionComment(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION_REASON"+suffix));
						order.setOrderReported(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_VALIDATION"+suffix).equalsIgnoreCase("medwan.common.true")?true:false);
						order.setOrderReport(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_PROTOCOL"+suffix));
						order.setAbnormality(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_ABNORMAL"+suffix).equalsIgnoreCase("medwan.common.true")?true:false);
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_RADIOLOGIST"+suffix).length()>0){
							order.addRadiologist(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_RADIOLOGIST"+suffix));
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_RADIOLOGIST2"+suffix).length()>0){
							order.addRadiologist(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_RADIOLOGIST2"+suffix));
						}
						orders.add(order);
					}
				}
			}
		}
		return orders;
		
	}
	
	public String toXml() {
		return toXml(false);
	}
	
	public String toXml(boolean bExtended) {
		String s="<imagingorder id='"+SH.c(getUid())+"'>";
		if(bExtended) {
			s+="<patient personid='"+SH.c(personId)+"'>";
			s+=AdminPerson.get(SH.c(personId)).toXml();
			s+="</patient>";
		}
		else {
			s+="<patient personid='"+SH.c(personId)+"'/>";
		}
		s+="<orderdatetime>"+SH.c(orderDateTime)+"</orderdatetime>";
		s+="<executiondatetime>"+SH.c(executionDateTime)+"</executiondatetime>";
		s+="<reportdatetime>"+SH.c(reportDateTime)+"</reportdatetime>";
		s+="<requestinguser id='"+SH.cx(requestingUser)+"'>";
		if(bExtended) {
			try {
				User user = User.get(Integer.parseInt(requestingUser));
				if(user.person!=null && user.person.isNotEmpty()) {
					s+=user.person.toXml();
				}
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		s+="</requestinguser>";
		s+=imagingExam.toXml();
		s+="<ordercomment>"+SH.cx(orderComment)+"</ordercomment>";
		s+="<orderurgent>"+(orderUrgent?1:0)+"</orderurgent>";
		s+="<orderreason>"+SH.cx(orderReason)+"</orderreason>";
		s+="<ordermodified>"+(orderModified?1:0)+"</ordermodified>";
		s+="<ordermodifiedreason>"+SH.cx(orderModifiedReason)+"</ordermodifiedreason>";
		s+="<orderexecuted>"+(orderExecuted?1:0)+"</orderexecuted>";
		s+="<orderexecutioncomment>"+SH.cx(orderExecutionComment)+"</orderexecutioncomment>";
		s+="<orderreport>"+SH.cx(orderReport)+"</orderreport>";
		s+="<orderabnormality>"+(abnormality?1:0)+"</orderabnormality>";
		s+="<radiologists>";
		for(int n=0;n<radiologists.size();n++) {
			s+="<radiologist id='"+SH.c(radiologists.elementAt(n))+"'>";
			if(bExtended) {
				try {
					User user = User.get(Integer.parseInt(radiologists.elementAt(n)));
					if(user.person!=null && user.person.isNotEmpty()) {
						s+=user.person.toXml();
					}
				}
				catch(Exception e) {
					e.printStackTrace();
				}
			}
			s+="</radiologist>";
		}
		s+="</radiologists>";
		s+="</imagingorder>";
		return s;
	}
	
	public void addRadiologist(String radiologist) {
		radiologists.add(radiologist);
	}
	
	public boolean isOrderReported() {
		return orderReported;
	}

	public void setOrderReported(boolean orderReported) {
		this.orderReported = orderReported;
	}

	public String getPersonId() {
		return personId;
	}
	public void setPersonId(String personId) {
		this.personId = personId;
	}
	public java.util.Date getOrderDateTime() {
		return orderDateTime;
	}
	public void setOrderDateTime(java.util.Date orderDateTime) {
		this.orderDateTime = orderDateTime;
	}
	public java.util.Date getExecutionDateTime() {
		return executionDateTime;
	}
	public void setExecutionDateTime(java.util.Date executionDateTime) {
		this.executionDateTime = executionDateTime;
	}
	public java.util.Date getReportDateTime() {
		return reportDateTime;
	}
	public void setReportDateTime(java.util.Date reportDateTime) {
		this.reportDateTime = reportDateTime;
	}
	public String getRequestingUser() {
		return requestingUser;
	}
	public void setRequestingUser(String requestingUser) {
		this.requestingUser = requestingUser;
	}
	public ImagingExam getImagingExam() {
		return imagingExam;
	}
	public void setImagingExam(ImagingExam imagingExam) {
		this.imagingExam = imagingExam;
	}
	public String getOrderComment() {
		return orderComment;
	}
	public void setOrderComment(String orderComment) {
		this.orderComment = orderComment;
	}
	public boolean isOrderUrgent() {
		return orderUrgent;
	}
	public void setOrderUrgent(boolean orderUrgent) {
		this.orderUrgent = orderUrgent;
	}
	public String getOrderReason() {
		return orderReason;
	}
	public void setOrderReason(String orderReason) {
		this.orderReason = orderReason;
	}
	public boolean isOrderModified() {
		return orderModified;
	}
	public void setOrderModified(boolean orderModified) {
		this.orderModified = orderModified;
	}
	public String getOrderModifiedReason() {
		return orderModifiedReason;
	}
	public void setOrderModifiedReason(String orderModifiedReason) {
		this.orderModifiedReason = orderModifiedReason;
	}
	public boolean isOrderExecuted() {
		return orderExecuted;
	}
	public void setOrderExecuted(boolean orderExecuted) {
		this.orderExecuted = orderExecuted;
	}
	public String getOrderExecutionComment() {
		return orderExecutionComment;
	}
	public void setOrderExecutionComment(String orderExecutionComment) {
		this.orderExecutionComment = orderExecutionComment;
	}
	public String getOrderReport() {
		return orderReport;
	}
	public void setOrderReport(String orderReport) {
		this.orderReport = orderReport;
	}
	public boolean isAbnormality() {
		return abnormality;
	}
	public void setAbnormality(boolean abnormality) {
		this.abnormality = abnormality;
	}
	public Vector getRadiologists() {
		return radiologists;
	}
	public void setRadiologists(Vector radiologists) {
		this.radiologists = radiologists;
	}
	
	
}
