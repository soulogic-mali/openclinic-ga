<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="be.openclinic.medical.*,be.openclinic.hl7.*,ca.uhn.hl7v2.*,ca.uhn.hl7v2.parser.*,ca.uhn.hl7v2.util.*,ca.uhn.hl7v2.model.*,ca.uhn.hl7v2.model.v251.message.*,ca.uhn.hl7v2.model.v251.group.*" %>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_hl7in");
	ResultSet rs = ps.executeQuery();
    HapiContext context = new DefaultHapiContext();
    CanonicalModelClassFactory mcf = new CanonicalModelClassFactory("2.5.1");
    context.setModelClassFactory(mcf);			
	while(rs.next()){
		Message message = context.getPipeParser().parse(rs.getString("OC_HL7IN_MESSAGE"));
        Terser terser = new Terser(message);
		OUL_R22 labresults = (OUL_R22)message;
		List specimens = labresults.getSPECIMENAll();
		Iterator iSpecimens = specimens.iterator();
    	while(iSpecimens.hasNext()) {
    		OUL_R22_SPECIMEN specimen = (OUL_R22_SPECIMEN)iSpecimens.next();
    		String barcodeid = HL7Server.checkString(specimen.getSPM().getSpecimenID().getPlacerAssignedIdentifier().getEi1_EntityIdentifier().getValue());
    		String specimenid="";
       		specimenid = Labo.getLabSpecimenId(barcodeid,conn);
    		if(specimenid==null) {
    			System.out.println("OUL^R22 Error: invalid specimenid: "+barcodeid);
    			continue;
    		}
    		else {
    			System.out.println("Valid specimen ID: "+barcodeid+" (Lab order ID = "+specimenid.split("\\.")[0]+"."+specimenid.split("\\.")[1]+")");
    		}
    		String serverid = specimenid.split("\\.")[0];
    		String transactionid = specimenid.split("\\.")[1];
    		try {
                String id=terser.get("/.MSH-10");
    			System.out.println("Setting transactionId = "+transactionid+" for message "+id+" in OC_HL7IN");
        		PreparedStatement ps2 = conn.prepareStatement("update OC_HL7IN set OC_HL7IN_TRANSACTIONID=? where OC_HL7IN_ID=?");
        		ps2.setInt(1, Integer.parseInt(transactionid));
    			ps2.setString(2, id);
    	    	ps2.execute();
    	    	ps2.close();
    		}
    		catch(Exception e) {
    			e.printStackTrace();
    		}
    	}
	}
	rs.close();
	ps.close();
	conn.close();
%>