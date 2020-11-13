<%@page import="javax.mail.*,javax.mail.internet.*,javax.activation.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	System.out.println("Gmail sender");
	String username = SH.c(request.getParameter("user"));
	String password = SH.c(request.getParameter("password"));
	//final String username = MedwanQuery.getInstance(false).getConfigString("mailbot.user","openclinic.mailrobot@ict4d.be");
	//final String password = MedwanQuery.getInstance(false).getConfigString("mailbot.password","Bigo4ever");

	String sFrom = SH.c(request.getParameter("from"));
	String sFromName = SH.c(request.getParameter("fromName"));
	String sTo = SH.c(request.getParameter("to"));
	String sReplyTo = SH.c(request.getParameter("replyto"));
	String sSubject = SH.c(request.getParameter("subject"));
	String sMessage = SH.c(request.getParameter("message"));
	String sImage = SH.c(request.getParameter("logo"));
	
    boolean bSuccess = false;    
	try{

		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", MedwanQuery.getInstance(false).getConfigString("mailbot.server","smtp.gmail.com"));
		props.put("mail.smtp.port", MedwanQuery.getInstance(false).getConfigString("mailbot.port","587"));
        props.put("mail.smtp.user", username);
        props.put("mail.smtp.password", password);

        Session mailSession = Session.getInstance(props);
        mailSession.setDebug(MedwanQuery.getInstance(false).getConfigString("Debug").equalsIgnoreCase("On"));
        Transport transport = mailSession.getTransport("smtp");

        MimeMessage message = new MimeMessage(mailSession);
        message.setSubject(sSubject);
        message.setFrom(new InternetAddress(sFrom,sFromName));	  
        message.setReplyTo(new InternetAddress[] {new InternetAddress(sReplyTo)});
        message.setSentDate(new java.util.Date());
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sTo,false));

        // This HTML mail have to 2 part, the BODY and the embedded image       
        MimeMultipart multipart = new MimeMultipart("related");

        // first part  (the html)
        BodyPart messageBodyPart = new MimeBodyPart();		
        String htmlText = sMessage;	    
        message.setHeader("content-type", "text/html; charset=ISO-8859-1"); 
        messageBodyPart.setContent(htmlText, "text/html");

        // add it
        multipart.addBodyPart(messageBodyPart);
        
        if(sImage.length()>0 && new java.io.File(sImage).exists()){
	        // second part (the image)
	        messageBodyPart = new MimeBodyPart();
	        DataSource fds = new FileDataSource(sImage);
	        messageBodyPart.setDataHandler(new DataHandler(fds));
	        messageBodyPart.setHeader("Content-ID","<image_logo>");
	
	        // add it
	        multipart.addBodyPart(messageBodyPart);
        }

        // put everything together
        message.setContent(multipart);
        System.out.println("Yes: sending message");
        transport.connect(MedwanQuery.getInstance(false).getConfigString("mailbot.server","smtp.gmail.com"),username,password);
        transport.sendMessage(message,message.getRecipients(Message.RecipientType.TO));
        transport.close();
        bSuccess=true;
    }
    catch(Exception e){
    	Debug.print(e.getMessage());
    }
	
%>
