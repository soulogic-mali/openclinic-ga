<%@page import="be.openclinic.finance.Prestation"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sPrestationGroupUID = checkString(request.getParameter("PrestationGroupUID"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n****************** financial/getGroupPrestations.jsp ******************");
		Debug.println("sPrestationGroupUID  : "+sPrestationGroupUID); // no newline here
	}
	///////////////////////////////////////////////////////////////////////////////////////////////

    String prestationcontent = "";
	int recCount = 0;
	
	if(sPrestationGroupUID.length() > 0){
	    try{
	    	// header
	        prestationcontent = "<table class='list' cellpadding='0' cellspacing='1' width='100%'>"+
	                             "<tr class='admin'>"+
	          	                  "<td width='25'>&nbsp;</td>"+
	          	     	          "<td width='80'>"+getTran(request,"web","code",sWebLanguage)+"</td>"+
		                          "<td width='*'>"+getTran(request,"web","description",sWebLanguage)+"</td>"+
	                             "</tr>";
	        
	    	String sSql = "select oc_prestationgroup_prestationuid from oc_prestationgroups_prestations"+
	                      " where oc_prestationgroup_groupuid = ?";
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    	PreparedStatement ps = oc_conn.prepareStatement(sSql);
	    	ps.setString(1,sPrestationGroupUID);
	    	ResultSet rs = ps.executeQuery();
	    	
	    	String sPrestationUid, sClass = "1";
	    	while(rs.next()){
	    		sPrestationUid = rs.getString("oc_prestationgroup_prestationuid");
	    		
	    		Prestation prestation = Prestation.get(sPrestationUid);
	    		if(prestation!=null){
	    			recCount++;
	    			
	    			// alternate row-style
	    			if(sClass.length()==0) sClass = "1";
	    			else                   sClass = "";
	    			
	    	        prestationcontent+= "<tr class='list"+sClass+"'>"+ 
	    		                         "<td><img class='link' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onClick='deletePrestation(\\\""+prestation.getUid()+"\\\");'/></a></td>"+
	    		                      	 "<td>"+prestation.getCode()+"</td>"+
	    	        		             "<td><b>"+prestation.getDescription()+"</b></td>"+
	    	        		            "</tr>";
	   	        }
	    	}
	        rs.close();
	        ps.close();
	        oc_conn.close();
	        
	        Debug.println("--> recCount : "+recCount);
		    
		    prestationcontent+= "</table>";	
		    prestationcontent+= recCount+" "+getTran(request,"web","recordsFound",sWebLanguage);		
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>

{
  "PrestationContent":"<%=prestationcontent%>"
}