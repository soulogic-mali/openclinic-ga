<%@page import="be.openclinic.system.Encryption"%>
<%@page import="ca.uhn.fhir.context.*,ca.uhn.fhir.rest.api.*,ca.uhn.fhir.rest.client.api.*,ca.uhn.fhir.rest.client.interceptor.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String token = Encryption.getToken(16);
	out.println("Token = "+token+"<BR/>");
	String encstring = "dS5Vf1KTNLHXYgfmQLaqsi+DSxbiZnSUlP6wXOr46CS5Sl1LEi9zHZIyY4cTBZqCJD42zeqaTWJMjIik8F+mfOHnvIyBofSuQ9Pnr8qCNKsoHLgOl9MWZc9kgl+tvP19Vi4/VpLCP47Mdox3yGB/F/gKYPL9YvMVuEvFhJUxlyE=";
	out.println("EncToken = "+encstring+"<BR/>");
	String dectoken = Encryption.decryptTextWithPrivateKey(encstring, "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOtVtZp1rBpy6AkOXGTjxsjK+4+uhPd+DFBLPT1fCfvZFIqXbppXte9ZVq8jPE4qZTZCnvFiZ8N2Uw7yyFaVYr1RKdxvgIoyJkcjVDudALSUS18yQIXs7A7YRvqpHcrcjotfBM1qa9iEBsxFLGS+7IPJsjw9oJQjdRWhUawYWdGzAgMBAAECgYEAwRsujpU6aOWbEztOg5cImeE99VO+Vht/XS+wC7j9x0QFAAhswIdyifmkEMh4BqfxL0oRhH88J/7i/uQnkiy4vI9s4faMJCZymVNBC1WkBKoylnscIZxiA/r2MlWzwLYCSujVa8yNVLp1p3gaIYW4aFY9GjSzwtbzQr3qIxf75aECQQD8suriJaBX1h1kCDP7yliwLkyeorgOlYmNeVjUyjQ3EWYlL7itgrBWXi5rkk+7ElY+pLCzbod3M1MVaPitRGvRAkEA7mi470fjOm+ycVzcGiYLKcarB6S7XMVtPiY2VdZoM0qm+Yls/IEbiSWeyfmzhdSeE3Dm6qfXz11Fkie7txB6QwJAXnmt4zraBbzhZCLE/KAcJFJLBwwi8CDsOl5h3bxzZRs2KzT6QLSZpNC1XjZnZLNoVydPgOYT83bW2yxRvMXV4QJADXLo486pWdWNOmnjnLICtTOY2FCJpT0Z4YSkUglLTYFrk+4VsNTTqdPudjRY1TbeR/h5fklDmlYHo6wMIdKTIwJAaNwKDbZHuW+tCZsEgd7W5kCeldq/TXLYXsPP2sTSXg/lYxtEGtzw8vIVplzSjvC/y8hct5WFA9zGQZtXmm/xyg==");
	out.println("dectoken = "+dectoken+"<br/>");
%>