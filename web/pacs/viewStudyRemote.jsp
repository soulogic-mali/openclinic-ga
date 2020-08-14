<%@page import="be.openclinic.common.OC_Object"%>
<%@ page import="org.dom4j.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %>
<%@include file="/includes/helper.jsp"%>
<%
	String docuid=com.itextpdf.xmp.impl.Base64.decode(request.getParameter("docuid"));
	Map<String,String> pars = new TreeMap<String,String>();
	for(int n=0;n<docuid.split("\\&").length;n++){
		pars.put(docuid.split("\\&")[n].split("=")[0], docuid.split("\\&")[n].split("=")[1]);
	}
	String key = ScreenHelper.checkString(pars.get("key"));
	String documentuid = ScreenHelper.checkString(pars.get("documentuid"));
	MedwanQuery.getInstance().setSession(session, User.get(4));
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		org.dom4j.Document document = DocumentHelper.createDocument();
		document.addElement("error").setText("InvalidKey");
		out.println(document.asXML());
	}
	else{
		out.println(sJSPROTOTYPE);
		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(documentuid);
		Vector<TransactionVO> pacstrans = MedwanQuery.getInstance().getTransactionsByType(MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
		String studies="",series="";
		for(int n=0;n<pacstrans.size();n++){
			TransactionVO tran = pacstrans.elementAt(n);
			String orderuid = tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID");
			if(orderuid.equalsIgnoreCase(documentuid)){
				if(n>0){
					studies+="_";
					series+="_";
				}
				studies+=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID");
				series+=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
			}
		}
	    String server=(request.isSecure()?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
		long sid=new java.util.Date().getTime();
		long oid=new java.util.Random().nextInt();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from oc_config where oc_key like 'wadouid.%' and updatetime<?");
		ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime()-120000));
		ps.execute();
		ps.close();
		conn.close();
		MedwanQuery.getInstance().reloadConfigValues();
		String wadoid="wadouid."+sid+"."+oid;
		MedwanQuery.getInstance().setConfigString(wadoid, studies+"@"+series+"@"+session.getId());
		System.out.println("wadoid "+wadoid+" = "+studies+"@"+series+"@"+session.getId());
	%>
	<IFRAME style="display:none" name="hidden-form" id='hf'></IFRAME>
	<script>
		var url='weasis://'+encodeURI('$dicom:get -w <%=server %><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/pacs/wadoQuery.jsp?wadouid=<%=wadoid %>');
		document.getElementById('hf').src=url;
	</script>
<%
	}
%>
