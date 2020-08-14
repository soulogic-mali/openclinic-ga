<%@page import="java.util.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	String setBold(String line,int field){
		String s = "";
		String[] fields = line.split("\\|");
		if(fields.length>field){
			for(int n=0;n<field;n++){
				if(s.length()>0){
					s+="|";
				}
				s+=fields[n];
			}
			if(s.length()>0){
				s+="|";
			}
			s+="<b>"+fields[field]+"</b>";
			for(int n=field+1;n<fields.length;n++){
				if(s.length()>0){
					s+="|";
				}
				s+=fields[n];
			}
		}
		else{
			s=line;
		}
		return s;
	}
%>
<font style='font-family: Courier New,Courier,Lucida Sans Typewriter,Lucida Typewriter,monospace; font-size: 10px'>
<%
	String msgid = request.getParameter("msgid");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	String message = be.openclinic.medical.Labo.getHL7ResultMessage(msgid, conn);
	conn.close();
	String[] messageLines = message.split("\r");
	for(int n=0;n<messageLines.length;n++){
		String s =setBold(messageLines[n],0);
		if(messageLines[n].split("\\|")[0].equalsIgnoreCase("PID") || messageLines[n].split("\\|")[0].equalsIgnoreCase("OBX")){
			s=setBold(setBold(s, 3), 5);
		}
		else if(messageLines[n].split("\\|")[0].equalsIgnoreCase("SPM")){
			s=setBold(s, 3);
		}
		else if(messageLines[n].split("\\|")[0].equalsIgnoreCase("MSH")){
			s=setBold(s, 9);
		}
		out.println(s+"<br/>");
	}
%>
</font>