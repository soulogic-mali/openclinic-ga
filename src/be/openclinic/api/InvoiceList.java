package be.openclinic.api;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.finance.PatientInvoice;
import be.openclinic.medical.ImagingOrder;
import be.openclinic.system.SH;

public class InvoiceList extends API {
	
	public InvoiceList(HttpServletRequest request) {
		super(request);
	}

	@Override
	public String get() {
		String s ="<invoicelist>";
		if(exists("patientinvoiceid")) {
			PatientInvoice invoice = PatientInvoice.get(value("patientinvoiceid").split("\\.")[0]+"."+value("patientinvoiceid").split("\\.")[1]);
			if(invoice!=null) {
				s+=invoice.toXml(value("detail","extended").equalsIgnoreCase("extended"));
			}
		}
		else if(exists("personid")) {
			Vector<PatientInvoice> invoices = PatientInvoice.getPatientInvoices(value("personid"));
			for(int n=0;n<invoices.size();n++) {
				PatientInvoice invoice = PatientInvoice.get(invoices.elementAt(n).getUid());
				if(exists("begindate") && invoice.getDate().before(SH.parseDate(value("begindate"),new SimpleDateFormat("yyyyMMddHHmmssSSS")))) {
					continue;
				}
				if(exists("enddate") && invoice.getDate().after(SH.parseDate(value("enddate"),new SimpleDateFormat("yyyyMMddHHmmssSSS")))) {
					continue;
				}
				if(exists("status") && !invoice.getStatus().equalsIgnoreCase(value("status"))) {
					continue;
				}
				if(exists("class") && !invoice.hasPrestationClass(value("class"))) {
					continue;
				}
				if(exists("family") && !invoice.hasPrestationFamily(value("family"))) {
					continue;
				}
				if(exists("invoicegroup") && !invoice.hasPrestationInvoiceGroup(value("invoicegroup"))) {
					continue;
				}
				if(exists("type") && !invoice.hasPrestationType(value("type"))) {
					continue;
				}
				if(exists("costcenter") && !invoice.hasPrestationCostCenter(value("costcenter"))) {
					continue;
				}
				s+=invoice.toXml(value("detail","extended").equalsIgnoreCase("extended"));
			}
		}
		s+="</invoicelist>";
		return format(s);
	}

	@Override
	public String set() {
		String s= "<response error='0'>set operation not implemented</response>";
		return format(s);
	}
}
