package be.openclinic.system;

import java.io.IOException;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.PostMethod;

public class Gmail {

	public static boolean sendMessage(String user, String password,String from, String fromName, String to,String replyto,String subject, String message, String logo) {
		System.out.println("GMail Call");
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(SH.cs("mpi.gmailURL","http://openclinic.chuk.hnrw.org/openclinic/util/sendGmailMessage.jsp"));
		NameValuePair[] nvp = new NameValuePair[9];
		nvp[0]= new NameValuePair("user",user);
		nvp[1]= new NameValuePair("password",password);
		nvp[2]= new NameValuePair("from",from);
		nvp[3]= new NameValuePair("fromName",fromName);
		nvp[4]= new NameValuePair("to",to);
		nvp[5]= new NameValuePair("replyto",replyto);
		nvp[6]= new NameValuePair("subject",subject);
		nvp[7]= new NameValuePair("message",message);
		nvp[8]= new NameValuePair("logo",logo);
		method.setQueryString(nvp);
		try {
			System.out.println("Sending message to "+SH.cs("mpi.gmailURL","http://openclinic.chuk.hnrw.org/openclinic/util/sendGmailMessage.jsp"));
			int statusCode = client.executeMethod(method);
			return true;
		} catch (HttpException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return false;
	}
}
