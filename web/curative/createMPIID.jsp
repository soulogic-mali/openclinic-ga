<%@page import="be.mxs.common.util.db.*,net.admin.*,ca.uhn.fhir.rest.client.interceptor.*,ca.uhn.fhir.rest.gclient.*,java.util.*,be.hapi.*"%>
<%@page import="ca.uhn.fhir.context.*,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.Identifier.*,org.hl7.fhir.r4.model.Bundle.*,org.hl7.fhir.instance.model.api.*,ca.uhn.fhir.rest.client.api.*,ca.uhn.fhir.rest.api.*"%>
<%@include file="/includes/validateUser.jsp"%>
{
	"result" : "<%=activePatient.createMPI()%>"
}