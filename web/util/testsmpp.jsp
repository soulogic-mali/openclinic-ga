<%@page import="ie.omk.smpp.*,ie.omk.smpp.message.*,ie.omk.smpp.net.*,ie.omk.smpp.util.*,java.net.*"%>

<%
	try{
		InetAddress smscAddr = InetAddress.getByName("41.222.182.51");
	    TcpLink smscLink = new TcpLink(smscAddr, 10501);
	    smscLink.open();
	    ie.omk.smpp.Connection connection = new ie.omk.smpp.Connection(smscLink);
	    BindResp smppResponse = connection.bind(ie.omk.smpp.Connection.TRANSCEIVER,"tabasamu","tabas@mu","CMT",1,1,"3000");
	    if (smppResponse.getCommandStatus() == 0) {
	        System.out.println("Link established");
	    }
	    else{
	    	System.out.println("Error: "+smppResponse.getCommandStatus()+" / "+smppResponse.getErrorCode());
	    }
	    connection.closeLink();
	}
	catch(Exception e){
		e.printStackTrace();
	}

%>
