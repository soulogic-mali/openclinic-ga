<%@page import="java.util.*,be.openclinic.finance.*,be.openclinic.pharmacy.*,be.openclinic.knowledge.*,be.openclinic.medical.*,
                be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
                
<%
	Product product=null;
	String diagnosisuid="";
	int quantity=0;
	if(request.getParameter("productUid")!=null){
		product = Product.get(request.getParameter("productUid"));
	}
	else if(request.getParameter("productStockUid")!=null){
		ProductStock productStock = ProductStock.get(request.getParameter("productStockUid"));
		product = productStock.getProduct();
		if(productStock.getLevel()>0){
			quantity=productStock.getLevel();
		}
	}
	if(product!=null && ScreenHelper.checkString(product.getAtccode()).length()>0){
		Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
		if(encounter!=null && encounter.hasValidUid()){
			Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "OC_DIAGNOSIS_GRAVITY DESC");
			for(int n=0;n<diagnoses.size();n++){
				Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
				if(Indication.isATCCodeIndicatedForICD10Code(product.getAtccode(), diagnosis.getCode())){
					diagnosisuid = diagnosis.getUid();
					break;
				}
			}
		}
	}
	String insuranceCoverage="";
	if(MedwanQuery.getInstance().getConfigInt("checkDrugPrescriptionInsuranceCoverage",1)==1){
		if(product!=null && product.getPrestationcode()!=null){
			Prestation prestation = Prestation.get(product.getPrestationcode());
			if(prestation!=null){
				Vector insurances = Insurance.getCurrentInsurances(activePatient.personid);
				if(insurances.size()>0){
					for(int n=0;n<insurances.size();n++){
						Insurance insurance = (Insurance)insurances.elementAt(n);
					}
				}
			}
		}
	}	
%>
{
	"name": "<%=product.getName() %>",
	"timeunitcount": "<%=product.getTimeUnitCount()>0?Math.round(product.getTimeUnitCount()):1 %>",
	"timeunit": "<%=ScreenHelper.checkString(product.getTimeUnit()).length()>0?product.getTimeUnit():"type2day" %>",
	"startdate": "<%=ScreenHelper.formatDate(new java.util.Date()) %>",
	"unitspertimeunit": "<%=product.getUnitsPerTimeUnit()>0?Math.round(product.getUnitsPerTimeUnit()):1 %>",
	"totalunits": "<%=product.getTotalUnits()>0?Math.round(product.getTotalUnits()):1 %>",
	"prescriberuid": "<%=activeUser.userid %>",
	"prescribername": "<%=activeUser.person.getFullName() %>",
	"levels": "<%=product.getAccessibleStockLevels() %>",
	"quantity": "<%=quantity %>",
	"packageunits": "<%=product.getPackageUnits()>0?product.getPackageUnits():1 %>",
	"productunit": "<%=getTran(request,"product.unit",product.getUnit(),sWebLanguage) %>",
	"diagnosis": "<%=diagnosisuid %>",
	"route": "<%=checkString(product.getRoute()) %>",
	"schema": "<%=ProductSchema.getProductSchema(product.getUid()).asString() %>"
}
