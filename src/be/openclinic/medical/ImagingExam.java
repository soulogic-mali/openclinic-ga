package be.openclinic.medical;

import be.openclinic.system.SH;

public class ImagingExam {
	private String idSystem;
	private String idValue;
	private String description;
	
	
	public String getIdSystem() {
		return idSystem;
	}


	public void setIdSystem(String idSystem) {
		this.idSystem = idSystem;
	}


	public String getIdValue() {
		return idValue;
	}


	public void setIdValue(String idValue) {
		this.idValue = idValue;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public String toXml() {
		String s="<imagingexam>";
		s+="<id>";
		s+="<system>"+SH.c(idSystem)+"</system>";
		s+="<value>"+SH.c(idValue)+"</value>";
		s+="</id>";
		s+="<description>"+SH.cx(description)+"</description>";
		s+="</imagingexam>";
		return s;
	}

}
