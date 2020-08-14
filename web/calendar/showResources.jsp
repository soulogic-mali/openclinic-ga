<%@page import="be.openclinic.util.Nomenclature"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private String resource2JSON(Nomenclature resource,String sWebLanguage, int counter){
		String s="";
		s+="{\"id\":\""+resource.getId()+"\",";
		s+="\"order\":\""+counter+"\",";
		s+="\"title\":\""+ScreenHelper.getTranNoLink("calendarresource",resource.getId(),sWebLanguage).split(";")[0]+"\"";
		Vector<Nomenclature> children = Nomenclature.getChildren("calendarresource", resource.getId());
		if(children.size()>0){
			s+=",\"children\":[";
			for(int n=0;n<children.size();n++){
				if(n>0){
					s+=",";
				}
				s+=resource2JSON(children.elementAt(n),sWebLanguage,counter++);
			}
			s+="]";
		}
		s+="}";
		return s;
	}

	private String location2JSON(Label label, int counter){
		String s="";
		s+="{\"id\":\"LOC."+label.id+"\",";
		s+="\"order\":\""+counter+"\",";
		s+="\"title\":\""+label.value+"\"";
		s+="}";
		return s;
	}
%>
<%
	int counter = 0;
	StringBuffer sb = new StringBuffer();
	sb.append("[");
	sb.append("{\"id\":\"LOC.ALL\",");
	sb.append("\"order\":\""+counter+++"\",");
	sb.append("\"title\":\""+getTranNoLink("web","location",sWebLanguage)+"\",\"children\":[");
	boolean bInitialized=false;
	//First we show the different locations
	Vector locations = Label.getLabels("appointment.location", "", "", sWebLanguage, "OC_LABEL_VALUE");
	for(int n=0;n<locations.size();n++){
		if(bInitialized){
			sb.append(",");
		}
		else{
			bInitialized=true;
		}
		sb.append(location2JSON((Label)locations.elementAt(n),counter++));
	}
	sb.append("]}");
	Vector<Nomenclature> rootresources = Nomenclature.getRootElements("calendarresource");
	for(int n=0;n<rootresources.size();n++){
		if(bInitialized){
			sb.append(",");
		}
		else{
			bInitialized=true;
		}
		sb.append(resource2JSON(rootresources.elementAt(n),sWebLanguage,counter++));
	}
	sb.append("]");
	out.println(sb.toString());
%>
