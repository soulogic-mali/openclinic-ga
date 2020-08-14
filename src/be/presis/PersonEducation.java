package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class PersonEducation {
	private IdList school = new IdList();
	private IdList level = new IdList();
	private IdList diploma = new IdList();
	private IdList course = new IdList();
	private String department;
	private String specialEducation;
	private IdList agreements = new IdList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<education>");
		sb.append("<school>"+school.toXml()+"</school>");
		sb.append("<level>"+level.toXml()+"</level>");
		sb.append("<diploma>"+diploma.toXml()+"</diploma>");
		sb.append("<course>"+course.toXml()+"</course>");
		sb.append("<department>"+SH.c(department)+"</department>");
		sb.append("<specialeducation>"+SH.c(specialEducation)+"</specialeducation>");
		sb.append("<agreements>"+agreements.toXml()+"</agreements>");
		sb.append("</education>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eEducation = e.addElement("education");
		school.toXml(eEducation);
		level.toXml(eEducation);
		diploma.toXml(eEducation);
		course.toXml(eEducation);
		eEducation.addElement("department").addCDATA(department==null?"":department);
		eEducation.addElement("specialeducation").addCDATA(specialEducation==null?"":specialEducation);
		agreements.toXml(eEducation);
	}
	public static PersonEducation fromXml(Element e) {
		PersonEducation education = new PersonEducation();
		if(e!=null) {
			education.setSchool(IdList.fromXml(e.element("school")));
			education.setLevel(IdList.fromXml(e.element("level")));
			education.setDiploma(IdList.fromXml(e.element("diploma")));
			education.setCourse(IdList.fromXml(e.element("course")));
			education.setAgreements(IdList.fromXml(e.element("agreements")));
			if(e.element("department")!=null) {
				education.setDepartment(SH.c(e.elementText("department")));
			}
			if(e.element("specialeducation")!=null) {
				education.setSpecialEducation(SH.c(e.elementText("specialeducation")));
			}
		}
		return education;
	}
	public IdList getSchool() {
		return school;
	}
	public void setSchool(IdList school) {
		this.school = school;
	}
	public IdList getLevel() {
		return level;
	}
	public void setLevel(IdList level) {
		this.level = level;
	}
	public IdList getDiploma() {
		return diploma;
	}
	public void setDiploma(IdList diploma) {
		this.diploma = diploma;
	}
	public IdList getCourse() {
		return course;
	}
	public void setCourse(IdList course) {
		this.course = course;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getSpecialEducation() {
		return specialEducation;
	}
	public void setSpecialEducation(String specialEducation) {
		this.specialEducation = specialEducation;
	}
	public IdList getAgreements() {
		return agreements;
	}
	public void setAgreements(IdList agreements) {
		this.agreements = agreements;
	}
}
