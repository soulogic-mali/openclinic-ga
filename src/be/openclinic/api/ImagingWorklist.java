package be.openclinic.api;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.medical.ImagingOrder;
import be.openclinic.system.SH;

public class ImagingWorklist extends API {
	
	public ImagingWorklist(HttpServletRequest request) {
		super(request);
	}

	@Override
	public String get() {
		String s ="<worklist>";
		if(exists("orderid")) {
			Vector<ImagingOrder> orders = ImagingOrder.get(value("orderid").split("\\.")[0]+"."+value("orderid").split("\\.")[1]);
			for(int n=0;n<orders.size();n++) {
				ImagingOrder order = orders.elementAt(n);
				if(value("orderid").split("\\.").length>2) {
					if(value("orderid").equalsIgnoreCase(order.getUid())) {
						s+=order.toXml();
					}
				}
				else {
					order.toXml();
				}
			}
		}
		else if(exists("personid")) {
			Vector<TransactionVO> transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(value("personid")),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2");
			for(int n=0;n<transactions.size();n++) {
				TransactionVO transaction = transactions.elementAt(n);
				if(exists("begindate") && transaction.getUpdateTime().before(SH.parseDate(value("begindate"),new SimpleDateFormat("yyyyMMddHHmmssSSS")))) {
					continue;
				}
				else if(exists("enddate") && transaction.getUpdateTime().after(SH.parseDate(value("enddate"),new SimpleDateFormat("yyyyMMddHHmmssSSS")))) {
					continue;
				}
				else if(value("status","").equalsIgnoreCase("notexecuted")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix).length()==0) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else if(value("status","").equalsIgnoreCase("waiting")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix).length()==0) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else if(value("status","").equalsIgnoreCase("notreported")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && !transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_VALIDATION").equalsIgnoreCase("medwan.common.true")) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else {
					s+=toXml(ImagingOrder.get(transaction.getUid()));
				}
			}
		}
		else if(exists("begindate")) {
			if(!exists("enddate")) {
				instructions.put("enddate", SH.formatDate(new java.util.Date(), new SimpleDateFormat("yyyyMMddHHmmssSSS")));
			}
			Vector<TransactionVO> transactions = MedwanQuery.getInstance().getTransactionsByTypeBetween("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2", SH.parseDate(value("begindate"),new SimpleDateFormat("yyyyMMddHHmmssSSS")), SH.parseDate(value("enddate"), new SimpleDateFormat("yyyyMMddHHmmssSSS")));
			for(int n=0;n<transactions.size();n++) {
				TransactionVO transaction = transactions.elementAt(n);
				if(value("status","").equalsIgnoreCase("notexecuted")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix).equalsIgnoreCase("medwan.common.no")) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else if(value("status","").equalsIgnoreCase("waiting")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_PRESTATION"+suffix).length()==0) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else if(value("status","").equalsIgnoreCase("notreported")) {
					for(int i=1;i<10;i++) {
						String suffix="";
						if(i>1) {
							suffix=i+"";
						}
						if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+suffix).length()>0 && !transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_VALIDATION").equalsIgnoreCase("medwan.common.true")) {
							s+=toXml(ImagingOrder.get(transaction.getUid()+"."+i));
						}
					}
				}
				else {
					s+=toXml(ImagingOrder.get(transaction.getUid()));
				}
			}
		}
		else if(exists("enddate")) {
			s+="<error>begindate is mandatory when enddate is provided</error>";
		}
		else if(exists("status")) {
			s+="<error>begindate is mandatory when only status is provided</error>";
		}
		s+="</worklist>";
		return format(s);
	}

	@Override
	public String set() {
		String s= "<response error='0'>successful operation</response>";
		if(!exists("imagingorderid")) {
			s= "<response error='AS-1'>imagingorderid is mandatory</response>";
		}
		else {
			if(exists("orderexecuted")) {
				String s2 =ImagingOrder.setOrderExecuted(value("imagingorderid"),value("orderexecuted"));
				if(s2.length()>0) {
					s= "<response error='AS-2'>"+s2+"</response>";
				}
			}
			else {
				s= "<response error='AS-3'>at least one of the following parameters is mandatory: orderexecuted</response>";
			}
		}
		return format(s);
	}

	public String toXml(Vector<ImagingOrder> orders) {
		String s="";
		for(int n=0;n<orders.size();n++) {
			ImagingOrder order = orders.elementAt(n);
			s+=order.toXml(value("detail","extended").equalsIgnoreCase("extended"));
		}
		return s;
	}

}
