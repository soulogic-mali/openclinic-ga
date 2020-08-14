<%@page import="be.openclinic.system.Encryption"%>
<%
	Encryption encryption = new Encryption();
	encryption.createKeys();
	String msg = "Dit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjfDit is een tekst ef aef f iefzefrgezgfaieufgaieufhaufhauefhapufehapoufehapzoehf	ajf	aifziefj	zpijf	zpjfez	pjfezpjf";
	out.println(msg+"<br/><br/><hr/>");
	String password=Encryption.getToken(16);
	String encmsg = encryption.encryptTextSymmetric(msg, password);
	out.println(encmsg+"<br/><br/><hr/>");
	msg=encryption.decryptTextSymmetric(encmsg, password);
	out.println(msg+"<br/>");
%>