<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String listuid = checkString(request.getParameter("listuid"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n******************* pharmacy/deleteDrugsOutBarcode.jsp *****************");
		Debug.println("listuid : "+listuid+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////

	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = null;
	
	// aflevering verwijderen uit oc_drugsoutlist
	ps=conn.prepareStatement("insert into OC_DRUGSOUTLISTHISTORY(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME)"+
							 " select OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME"+
							 " from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
	ps.setInt(1,Integer.parseInt(listuid.split("\\.")[0]));
	ps.setInt(2,Integer.parseInt(listuid.split("\\.")[1]));
	ps.execute();
	ps.close();

	ps = conn.prepareStatement("delete from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
	ps.setInt(1,Integer.parseInt(listuid.split("\\.")[0]));
	ps.setInt(2,Integer.parseInt(listuid.split("\\.")[1]));
	ps.execute();
	ps.close();

	// lijst maken van oc_drugsoutlist producten in wacht voor patiënt
	String drugs = "<table width='100%' class='list' cellpadding='0' cellspacing='1'>";
	
	ps=conn.prepareStatement("select * from OC_DRUGSOUTLIST where OC_LIST_PATIENTUID=?"+
	                         " order by OC_LIST_PRODUCTSTOCKUID");
	ps.setString(1,activePatient.personid);
	ResultSet rs = ps.executeQuery();
	int count = 0;
	
	while(rs.next()){
		ProductStock stock = ProductStock.get(rs.getString("OC_LIST_PRODUCTSTOCKUID"));
		if(stock!=null){
			int level = stock.getLevel();
			
			Batch batch = Batch.get(rs.getString("OC_LIST_BATCHUID"));
			String sBatch = "?";
			String sExpires = "";
			if(batch!=null){
				sBatch = batch.getBatchNumber();
				level = batch.getLevel();
				sExpires = ScreenHelper.formatDate(batch.getEnd());
			}
			
			// header
			if(count==0){
				drugs+= "<tr class='admin'>"+
			             "<td/>"+
						 "<td>ID</td>"+
			             "<td>"+getTran(request,"web","code",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","product",sWebLanguage)+"</td>"+
						 "<td>"+getTran(request,"web","quantity",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","batch",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","level",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","expires",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","comment",sWebLanguage)+"</td>"+
			             "<td>"+getTran(request,"web","encounter",sWebLanguage)+"</td>"+
						"</tr>";
			}
			
			String stocklabel="";
			drugs+= "<tr>"+
			         "<td class='admin2'>"+
			          "<a href='javascript:doDelete(\\\""+rs.getInt("OC_LIST_SERVERID")+"."+rs.getInt("OC_LIST_OBJECTID")+"\\\");'>"+
			           "<img src='_img/icons/icon_delete.png' class='link' title='"+getTranNoLink("web","delete",sWebLanguage)+"'/></a>"+
			         "</td>"+
			         "<td class='admin2'>"+stock.getUid()+"</td>"+
			         "<td class='admin2'><b>"+stock.getProduct().getCode()+"</b></td>"+
			         "<td class='admin2'><b>"+stock.getProduct().getName()+"</b>"+stocklabel+"</td>"+
			         "<td class='admin2'><b>"+rs.getInt("OC_LIST_QUANTITY")+"</b></td>"+
			         "<td class='admin2'>"+sBatch+"</td>"+
			         "<td class='admin2'>"+level+"</td>"+
			         "<td class='admin2'>"+sExpires+"</td>"+
			         "<td class='admin2'><b>"+checkString(rs.getString("OC_LIST_COMMENT"))+"</b></td>"+
			         "<td class='admin2'>"+checkString(rs.getString("OC_LIST_ENCOUNTERUID"))+"</td>"+
			        "</tr>";

			count++;
		}
	}
	rs.close();
	ps.close();
	conn.close();
	
	drugs+= "</table>";
	
	out.print("{\"drugs\":\""+drugs+"\"}");
%>