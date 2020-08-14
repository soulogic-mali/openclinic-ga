/**
 * NEG_RegistroFUABatch_v1Locator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1;

public class NEG_RegistroFUABatch_v1Locator extends org.apache.axis.client.Service implements pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch_v1 {

    public NEG_RegistroFUABatch_v1Locator() {
    }


    public NEG_RegistroFUABatch_v1Locator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public NEG_RegistroFUABatch_v1Locator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for NEG_RegistroFUABatchSOAP11Binding
    private java.lang.String NEG_RegistroFUABatchSOAP11Binding_address = "https://pruebaws01.sis.gob.pe/cxf/esb/negocio/registroFUABatch/v1/";

    public java.lang.String getNEG_RegistroFUABatchSOAP11BindingAddress() {
        return NEG_RegistroFUABatchSOAP11Binding_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String NEG_RegistroFUABatchSOAP11BindingWSDDServiceName = "NEG_RegistroFUABatchSOAP11Binding";

    public java.lang.String getNEG_RegistroFUABatchSOAP11BindingWSDDServiceName() {
        return NEG_RegistroFUABatchSOAP11BindingWSDDServiceName;
    }

    public void setNEG_RegistroFUABatchSOAP11BindingWSDDServiceName(java.lang.String name) {
        NEG_RegistroFUABatchSOAP11BindingWSDDServiceName = name;
    }

    public pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch getNEG_RegistroFUABatchSOAP11Binding() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(NEG_RegistroFUABatchSOAP11Binding_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getNEG_RegistroFUABatchSOAP11Binding(endpoint);
    }

    public pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch getNEG_RegistroFUABatchSOAP11Binding(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatchSOAP11Stub _stub = new pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatchSOAP11Stub(portAddress, this);
            _stub.setPortName(getNEG_RegistroFUABatchSOAP11BindingWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setNEG_RegistroFUABatchSOAP11BindingEndpointAddress(java.lang.String address) {
        NEG_RegistroFUABatchSOAP11Binding_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch.class.isAssignableFrom(serviceEndpointInterface)) {
                pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatchSOAP11Stub _stub = new pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatchSOAP11Stub(new java.net.URL(NEG_RegistroFUABatchSOAP11Binding_address), this);
                _stub.setPortName(getNEG_RegistroFUABatchSOAP11BindingWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("NEG_RegistroFUABatchSOAP11Binding".equals(inputPortName)) {
            return getNEG_RegistroFUABatchSOAP11Binding();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/", "NEG_RegistroFUABatch_v1");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/", "NEG_RegistroFUABatchSOAP11Binding"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("NEG_RegistroFUABatchSOAP11Binding".equals(portName)) {
            setNEG_RegistroFUABatchSOAP11BindingEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
