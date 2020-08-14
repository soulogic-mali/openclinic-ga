package be.openclinic.surveillance;

import java.util.Date;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.system.SH;

public class Covid {
	
	static String[] signs = {
		"ITEM_TYPE_COVID_ABDOMINALPAIN","ITEM_TYPE_COVID_ABNORMALXRAY","ITEM_TYPE_COVID_ARDS",
		"ITEM_TYPE_COVID_CHESTPAIN","ITEM_TYPE_COVID_CHILLS","ITEM_TYPE_COVID_CONJUNCTIVALINJECTION",
		"ITEM_TYPE_COVID_COUGH","ITEM_TYPE_COVID_DIARRHEA","ITEM_TYPE_COVID_DYSPNEA",
		"ITEM_TYPE_COVID_FATIGUE","ITEM_TYPE_COVID_FEVER","ITEM_TYPE_COVID_LUNGFLUID",
		"ITEM_TYPE_COVID_xrayfluid","ITEM_TYPE_COVID_HEADACHE","ITEM_TYPE_COVID_ARTHRITIS",
		"ITEM_TYPE_COVID_MALAISE","ITEM_TYPE_COVID_MUSCLEPAIN","ITEM_TYPE_COVID_NAUSEA",
		"ITEM_TYPE_COVID_IRRITABILITY","ITEM_TYPE_COVID_PHARYNGEALEXUDATE","ITEM_TYPE_COVID_PNEUMONIA",
		"ITEM_TYPE_COVID_RAPIDBREATHING","ITEM_TYPE_COVID_RUNNINGNOSE","ITEM_TYPE_COVID_PHARYNGITIS",
		"ITEM_TYPE_COVID_VOMITING","ITEM_TYPE_COVID_COMA"
	};
	
	public static long symptomFreeHours(int personid, Date date){
		Date d = null;
		TransactionVO transaction = null;
		TransactionVO transaction1 = null;
		TransactionVO transaction2 = null;
		Vector<TransactionVO> transactions = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_COVID19_FOLLOWUP");
		for(int n=0;n<transactions.size();n++) {
			TransactionVO t = transactions.elementAt(n);
			if(t.getUpdateTime().before(date)) {
				if(isSymptomFree(t)) {
					transaction1=t;
				}
				else {
					break;
				}
			}
		}
		transactions = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_COVID19_ASSESSMENT");
		for(int n=0;n<transactions.size();n++) {
			TransactionVO t = transactions.elementAt(n);
			if(t.getUpdateTime().before(date)) {
				if(isSymptomFree(t)) {
					transaction2=t;
				}
				else {
					break;
				}
			}
		}
		if(transaction1==null && transaction2!=null) {
			transaction=transaction2;
		}
		else if(transaction2==null && transaction1!=null) {
			transaction = transaction1;
		}
		else if(transaction1!=null && transaction2!=null) {
			if(transaction1.getUpdateTime().before(transaction2.getUpdateTime())) {
				transaction=transaction2;
			}
			else {
				transaction=transaction1;
			}
		}
		if(transaction!=null) {
			d=transaction.getUpdateTime();
		}
		if(transaction==null) {
			return 0;
		}
		else {
			return (new Date().getTime()-d.getTime())/SH.getTimeHour();
		}
	}
	
	public static boolean isSymptomFree(TransactionVO transaction) {
		for(int n=0;n<signs.length;n++) {
			if(!transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants."+signs[n]).equalsIgnoreCase("2")) {
				return false;
			}
		}
		return true;
	}

}
