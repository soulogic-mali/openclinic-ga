<script src="https://www.java.com/js/deployJava.js"></script>
<script>
 var attributes = {
 	code :'be.fedict.eid.applet.Applet.class',
 	archive :'eid-applet-package-1.2.6.jar',
 	width :1000,
 	height :500
 };
 var parameters = {
 	TargetPage :'identity-result.jsp',
 	AppletService : '/openclinic/applet-service;jsessionid=<%=session.getId()%>',
 	BackgroundColor : '#ffffff'
 };
 var version = '1.6';
 deployJava.runApplet(attributes, parameters, version);
</script>