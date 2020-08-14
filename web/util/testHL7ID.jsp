<%@page import="ca.uhn.hl7v2.model.v251.message.OUL_R22"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="be.openclinic.hl7.*,ca.uhn.hl7v2.*,ca.uhn.hl7v2.app.*,ca.uhn.hl7v2.model.*,ca.uhn.hl7v2.model.v251.*,ca.uhn.hl7v2.model.v251.group.*,ca.uhn.hl7v2.model.v251.segment.*,ca.uhn.hl7v2.parser.*" %>
<%
	java.sql.Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_hl7in");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String message = rs.getString("oc_hl7in_message");
		HapiContext context = new DefaultHapiContext();
        CanonicalModelClassFactory mcf = new CanonicalModelClassFactory("2.5.1");
        context.setModelClassFactory(mcf);		
		Parser p = context.getPipeParser();
		OUL_R22 msg = (OUL_R22)p.parse(message);
		List specimens = msg.getSPECIMENAll();
		Iterator iSpecimens = specimens.iterator();
		while(iSpecimens.hasNext()){
			OUL_R22_SPECIMEN specimen = (OUL_R22_SPECIMEN)iSpecimens.next();
			String id =specimen.getSPM().getSpecimenID().getEip1_PlacerAssignedIdentifier().getEntityIdentifier().getValue();
			if(id.contains("998937")){
				System.out.println(rs.getString("oc_hl7in_id")+": "+id);
			}
		}
	}
	rs.close();
	ps.close();
	conn.close();

%>