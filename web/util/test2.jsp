<%@page import="com.africastalking.*,com.africastalking.sms.*,java.util.*"%>
<%
		String USERNAME = "frank_verbeke";
		String API_KEY = "deb5579a3cb70a60d6e2d83210291a25ad2255a233fe5fb002c82c4e9c236aa3";
		AfricasTalking.initialize(USERNAME, API_KEY);
		SmsService sms = AfricasTalking.getService(AfricasTalking.SERVICE_SMS);
		String[] recipients = new String[] {
			"+250785298381"
		};
		String message = "OpenClinic GA\nTest message\n> > >\nGateway = AfricasTalking";
		try {
			List<Recipient> resp = sms.send(message,"OpenClinic", recipients, true);
			for (Recipient recipient : resp) {
				System.out.print(recipient.number);
				System.out.print(" : ");
				System.out.println(recipient.status);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		}
%>