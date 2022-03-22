package be.openclinic.mobilemoney;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.system.SH;
import be.openclinic.finance.*;

public class MobileMoney {
	
	public static boolean createPaymentRequest(String transactionid,
											String invoiceuid,
											String patientuid,
											double amount,
											String currency,
											String payerphone,
											String payermessage,
											String payeemessage,
											String userid,
											String operator) {
		try {
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into OC_MOMO(OC_MOMO_TRANSACTIONID,"
														+ "OC_MOMO_CREATEDATETIME,"
														+ "OC_MOMO_INVOICEUID,"
														+ "OC_MOMO_PATIENTUID,"
														+ "OC_MOMO_UPDATEUID,"
														+ "OC_MOMO_AMOUNT,"
														+ "OC_MOMO_CURRENCY,"
														+ "OC_MOMO_PAYERPHONE,"
														+ "OC_MOMO_UPDATETIME,"
														+ "OC_MOMO_STATUS,"
														+ "OC_MOMO_OPERATOR,"
														+ "OC_MOMO_PAYERMESSAGE,"
														+ "OC_MOMO_PAYEEMESSAGE) values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, transactionid);
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(3, invoiceuid);
			ps.setString(4, patientuid);
			ps.setString(5, userid);
			ps.setDouble(6, amount);
			ps.setString(7, currency);
			ps.setString(8, payerphone);
			ps.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(10, "PENDING");
			ps.setString(11, operator);
			ps.setString(12, payermessage);
			ps.setString(13, payeemessage);
			ps.execute();
			ps.close();
			conn.close();
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean createDisbursement(String transactionid,
											String invoiceuid,
											String patientuid,
											double amount,
											String currency,
											String payerphone,
											String payermessage,
											String payeemessage,
											String userid,
											String operator,
											String originTransactionId) {
		try {
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			//Mark the payment transaction as credited
			PreparedStatement ps = conn.prepareStatement("insert into OC_MOMO(OC_MOMO_TRANSACTIONID,"
									+ "OC_MOMO_CREATEDATETIME,"
									+ "OC_MOMO_INVOICEUID,"
									+ "OC_MOMO_PATIENTUID,"
									+ "OC_MOMO_UPDATEUID,"
									+ "OC_MOMO_AMOUNT,"
									+ "OC_MOMO_CURRENCY,"
									+ "OC_MOMO_PAYERPHONE,"
									+ "OC_MOMO_UPDATETIME,"
									+ "OC_MOMO_STATUS,"
									+ "OC_MOMO_OPERATOR,"
									+ "OC_MOMO_PAYERMESSAGE,"
									+ "OC_MOMO_PAYEEMESSAGE,"
									+ "OC_MOMO_ORIGINTRANSACTIONID) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, transactionid);
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(3, invoiceuid);
			ps.setString(4, patientuid);
			ps.setString(5, userid);
			ps.setDouble(6, amount);
			ps.setString(7, currency);
			ps.setString(8, payerphone);
			ps.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(10, "PENDING");
			ps.setString(11, operator);
			ps.setString(12, payermessage);
			ps.setString(13, payeemessage);
			ps.setString(14, originTransactionId);
			ps.execute();
			ps.close();
			conn.close();
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
			
	public static boolean updatePaymentStatus(String transactionid,String status,String financialTransactionId) {
		try {
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("update OC_MOMO SET OC_MOMO_UPDATETIME=?,"
														+ "OC_MOMO_STATUS=?,OC_MOMO_FINANCIALTRANSACTIONID=? where OC_MOMO_TRANSACTIONID=?");
			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(2, status);
			ps.setString(3, financialTransactionId);
			ps.setString(4, transactionid);
			ps.execute();
			ps.close();
			conn.close();
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public static boolean updateDisbursementStatus(String transactionid,String status,String financialTransactionId) {
		try {
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("update OC_MOMO SET OC_MOMO_UPDATETIME=?,"
														+ "OC_MOMO_STATUS=?,OC_MOMO_FINANCIALTRANSACTIONID=? where OC_MOMO_TRANSACTIONID=?");
			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(2, status);
			ps.setString(3, financialTransactionId);
			ps.setString(4, transactionid);
			ps.execute();
			ps.close();
			if(status.equalsIgnoreCase("successful")) {
				ps = conn.prepareStatement("select * from OC_MOMO where OC_MOMO_TRANSACTIONID=?");
				ps.setString(1, transactionid);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					String originTransactionId= rs.getString("OC_MOMO_ORIGINTRANSACTIONID");
					String invoiceid = SH.c(rs.getString("oc_momo_invoiceuid"));
					rs.close();
					ps.close();
					ps = conn.prepareStatement("update OC_MOMO set OC_MOMO_CREDITTRANSACTIONID=? where OC_MOMO_TRANSACTIONID=?");
					ps.setString(1, financialTransactionId);
					ps.setString(2, originTransactionId);
					ps.execute();
					//Revert payment registrations linked to this operation
					ps.close();
					ps = conn.prepareStatement("select * from oc_momo where OC_MOMO_TRANSACTIONID=?");
					ps.setString(1, originTransactionId);
					rs = ps.executeQuery();
					if(rs.next()) {
						String patientCreditUid=SH.c(rs.getString("OC_MOMO_PATIENTCREDITUID"));
						String wicketCreditUid=SH.c(rs.getString("OC_MOMO_WICKETCREDITUID"));
						PatientCredit pc = PatientCredit.get(patientCreditUid);
						if(pc!=null) {
							pc.setAmount(0);
							pc.setComment(pc.getComment()+" #MOMO_REIMBURSED");
							pc.store();
							if(SH.c(pc.getInvoiceUid()).length()>0) {
								PatientInvoice pi = PatientInvoice.get(pc.getInvoiceUid());
								if(pi!=null && pi.getStatus().equalsIgnoreCase("closed")) {
									pi.setStatus("open");
									pi.store();
								}
							}
						}
						WicketCredit wc = WicketCredit.get(wicketCreditUid);
						if(wc!=null) {
							wc.setAmount(0);
							wc.setComment(wc.getComment()+" #MOMO_REIMBURSED");
							wc.store();
							Wicket w = Wicket.get(wc.getWicketUID());
							if(w!=null) {
								w.calculateBalance();
							}
							PatientInvoice pi = (PatientInvoice)wc.getInvoice();
							if(pi!=null && pi.getStatus()!=null && pi.getStatus().equalsIgnoreCase("closed")) {
								pi.setStatus("open");
								pi.store();
							}
						}
					}
				}
				rs.close();
				ps.close();
			}
			conn.close();
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public static void updateCreditOperationIds(String financialtransactionid,String patientcredituid,String wicketcredituid) {
		try {
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("update OC_MOMO SET OC_MOMO_PATIENTCREDITUID=?,OC_MOMO_WICKETCREDITUID=? where OC_MOMO_FINANCIALTRANSACTIONID=?");
			ps.setString(1, patientcredituid);
			ps.setString(2, wicketcredituid);
			ps.setString(3, financialtransactionid);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}
