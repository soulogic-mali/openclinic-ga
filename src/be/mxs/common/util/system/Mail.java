package be.mxs.common.util.system;

import be.mxs.common.util.db.MedwanQuery;

import javax.mail.*;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.AddressException;
import javax.activation.FileDataSource;
import javax.activation.DataHandler;
import java.io.PrintStream;
import java.util.Properties;
import java.util.Vector;

public class Mail {
    static public void sendMail(String smtpServer, String sFrom, String sTo, String sSubject, String sMessage, String sAttachment, String sFileName)
            throws AddressException, MessagingException {

            Properties props = System.getProperties();
            props.put("mail.smtp.localhost", "127.0.0.1"); 
            props.put("mail.smtp.host", smtpServer);
            Session session = Session.getDefaultInstance(props, null);
            Message msg = new MimeMessage(session);

            msg.setFrom(new InternetAddress(sFrom));
            msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(sTo.replaceAll(";", " ").replaceAll(",", " "), false)); // false : simple email addresses separated by spaces are also allowed
            msg.setSentDate(new java.util.Date());
            msg.setSubject(sSubject);

            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(sMessage);
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            if(sAttachment!=null){
    	        messageBodyPart = new MimeBodyPart();
    	        javax.activation.DataSource source = new FileDataSource(sAttachment);
    	        messageBodyPart.setDataHandler(new DataHandler(source));
    	        messageBodyPart.setFileName(sFileName);
    	        multipart.addBodyPart(messageBodyPart);
            }

            msg.setContent(multipart);

            Transport.send(msg);

            if(Debug.enabled){
                Debug.println("*** Mail sent ***");
                Debug.println("From   : "+sFrom);
                Debug.println("To     : "+sTo);
                Debug.println("Server : "+smtpServer);
                Debug.println("*****************");
            }
        }
    static public void sendMail(String smtpServer, String sFrom, String sTo, String sSubject, String sMessage, Vector attachedFiles)
            throws AddressException, MessagingException {

            Properties props = System.getProperties();
            props.put("mail.smtp.localhost", "127.0.0.1"); 
            props.put("mail.smtp.host", smtpServer);
            Session session = Session.getDefaultInstance(props, null);
            Message msg = new MimeMessage(session);

            msg.setFrom(new InternetAddress(sFrom));
            msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(sTo.replaceAll(";", " ").replaceAll(",", " "), false)); // false : simple email addresses separated by spaces are also allowed
            msg.setSentDate(new java.util.Date());
            msg.setSubject(sSubject);

            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(sMessage);
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            for(int n=0;n<attachedFiles.size();n++){
            	String sAttachment = (String)attachedFiles.elementAt(n);
	            if(sAttachment!=null){
	    	        messageBodyPart = new MimeBodyPart();
	    	        javax.activation.DataSource source = new FileDataSource(sAttachment);
	    	        messageBodyPart.setDataHandler(new DataHandler(source));
	    	        messageBodyPart.setFileName(sAttachment);
	    	        multipart.addBodyPart(messageBodyPart);
	            }
            }

            msg.setContent(multipart);

            Transport.send(msg);

            if(Debug.enabled){
                Debug.println("*** Mail sent ***");
                Debug.println("From   : "+sFrom);
                Debug.println("To     : "+sTo);
                Debug.println("Server : "+smtpServer);
                Debug.println("*****************");
            }
        }
}
