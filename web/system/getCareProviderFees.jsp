<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
    String userid = checkString(request.getParameter("userid"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n******************** system/getCareProviderFees.jsp ********************");
		Debug.println("userid : "+userid+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////

    if(userid.length() > 0){
        %><br><%
        
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from OC_CAREPROVIDERFEES"+
		                                             " where OC_CAREPROVIDERFEE_USERID = ?"+
		                                             "  ORDER by OC_CAREPROVIDERFEE_TYPE");
		ps.setString(1,userid);
		ResultSet rs = ps.executeQuery();
		String type, id, amount, sClass = "1";
		Float famount;
		boolean nodata = true;
		StringBuffer html = new StringBuffer();
		
		while(rs.next()){
			// header
			if(nodata){
				html.append("<tr class='admin'>"+
			               "<td width='25'>&nbsp;</td>"+
			               "<td width='120'>"+getTran(request,"web","type",sWebLanguage)+"</td>"+
			               "<td width='200'>&nbsp;</td>"+
			               "<td width='*'>"+getTran(request,"web","amount",sWebLanguage)+"</td>"+
						  "</tr>");
			}
			
			type = rs.getString("OC_CAREPROVIDERFEE_TYPE");
			id = rs.getString("OC_CAREPROVIDERFEE_ID");
			famount = rs.getFloat("OC_CAREPROVIDERFEE_AMOUNT");
			
			// alternate row-style
			if(sClass.length()==0) sClass = "1";
			else                   sClass = "";
			
			// 1 - prestation
			if(type.equalsIgnoreCase("prestation")){
				Prestation prestation = Prestation.get(rs.getString("OC_CAREPROVIDERFEE_ID"));
				if(prestation!=null){
					String aHref = "<a href='javascript:editline(\"prestation\",\""+prestation.getUid()+"\",\""+prestation.getDescription()+"\",\""+famount+"\");'>"+getTran(request,"web","prestation",sWebLanguage)+"<a>";
					html.append("<tr class='list"+sClass+"'>"+
					             "<td><img src='_img/icons/icon_delete.png' class='link' onclick='deleteline(\"prestation\",\""+prestation.getUid()+"\",\""+userid+"\");'/></td>"+
					             "<td>"+aHref+"</td>"+
					             "<td>"+prestation.getDescription()+"</td>"+
					             "<td>"+new java.text.DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(famount)+" "+MedwanQuery.getInstance().getConfigString("currency","")+"</td>"+
					            "</tr>");
					nodata = false;
				}
			}
			// 2 - prestationtype
			else if(type.equalsIgnoreCase("prestationtype")){
				String aHref = "<a href='javascript:editline(\"prestationtype\",\""+id+"\",\"\",\""+famount+"\");'>"+getTran(request,"web","type",sWebLanguage)+"<a>";
				html.append("<tr class='list"+sClass+"'>"+
				             "<td><img src='_img/icons/icon_delete.png' class='link' onclick='deleteline(\"prestationtype\",\""+id+"\",\""+userid+"\");'/></td>"+
				             "<td>"+aHref+"</td>"+
				             "<td>"+getTran(request,"prestation.type",id,sWebLanguage)+"</td>"+
				             "<td>"+rs.getFloat("OC_CAREPROVIDERFEE_AMOUNT")+"%</td>"+
				            "</tr>");
				nodata = false;
			}
			// 3 - invoicegroup
			else if(type.equalsIgnoreCase("invoicegroup")){
				String aHref = "<a href='javascript:editline(\"invoicegroup\",\""+id+"\",\"\",\""+famount+"\");'>"+getTran(request,"web","invoicegroup",sWebLanguage)+"<a>";
				html.append("<tr class='list"+sClass+"'>"+
				             "<td><img src='_img/icons/icon_delete.png' class='link' onclick='deleteline(\"invoicegroup\",\""+id+"\",\""+userid+"\");'/></td>"+
				             "<td>"+aHref+"</td>"+
				             "<td>"+id+"</td>"+
				             "<td>"+famount+"%</td>"+
				            "</tr>");
				nodata = false;
			}
			// 4 - default
			else if(type.equalsIgnoreCase("default")){
				String aHref = "<a href='javascript:editline(\"default\",\"\",\"\",\""+famount+"\");'>"+getTran(request,"web","default",sWebLanguage)+"<a>";
				html.append("<tr class='list"+sClass+"'>"+
				             "<td><img src='_img/icons/icon_delete.png' onclick='deleteline(\"default\",\""+id+"\",\""+userid+"\");'/></td>"+
				             "<td colspan='2'>"+aHref+"</td>"+
				             "<td>"+famount+"%</td>"+
				            "</tr>");
				nodata = false;
			}
		}
		rs.close();
		ps.close();
		conn.close();
		
		if(nodata){
			out.write(getTran(request,"web","noRecordsFound",sWebLanguage));
		}
		else{
			out.write("<table width='100%' class='list' cellpadding='0' cellspacing='1'>");			
			 out.write(html.toString());
			out.write("</table>");
		}
    }
%>