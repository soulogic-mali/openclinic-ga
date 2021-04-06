package be.openclinic.medical;

import java.util.Vector;

public class BloodProduct {
	private String productType="";
	private String reasonForDestruction="";
	private String transfusionDepartment="";
	private String transfusionReason="";
	private Vector transfusionIncidents=new Vector();
	private int patientAge;
	private String patientGender="";
}
