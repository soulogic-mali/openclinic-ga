/**
 * NEG_RegistroFUABatchSOAP11Stub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1;

public class NEG_RegistroFUABatchSOAP11Stub extends org.apache.axis.client.Stub implements pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[4];
        _initOperationDesc1();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("registrarFUA");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "registrarFUARequest"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUARequestType"), pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUARequestType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUAResponseType"));
        oper.setReturnClass(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "registrarFUAResponse"));
        oper.setStyle(org.apache.axis.constants.Style.DOCUMENT);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("registrarFUACompat");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "registrarFUACompatRequest"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "RegistrarFUACompatRequestType"), pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatRequestType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "RegistrarFUACompatResponseType"));
        oper.setReturnClass(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "registrarFUACompatResponse"));
        oper.setStyle(org.apache.axis.constants.Style.DOCUMENT);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getResultadoFUA");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "getResultadoFUARequest"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "GetResultadoFUARequestType"), pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUARequestType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "GetResultadoFUAResponseType"));
        oper.setReturnClass(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "getResultadoFUAResponse"));
        oper.setStyle(org.apache.axis.constants.Style.DOCUMENT);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getResultadoFUACompat");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "getResultadoFUACompatRequest"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "GetResultadoFUACompatRequestType"), pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatRequestType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "GetResultadoFUACompatResponseType"));
        oper.setReturnClass(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "getResultadoFUACompatResponse"));
        oper.setStyle(org.apache.axis.constants.Style.DOCUMENT);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[3] = oper;

    }

    public NEG_RegistroFUABatchSOAP11Stub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public NEG_RegistroFUABatchSOAP11Stub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public NEG_RegistroFUABatchSOAP11Stub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            javax.xml.namespace.QName qName2;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Disa");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Disa.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "DocumentoIdentidad");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.DocumentoIdentidad.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Estado");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Estado.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Login");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Login.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "OperacionWeb");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.OperacionWeb.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "ServicioWeb");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.ServicioWeb.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ConectividadType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ConectividadType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "HeaderRequestType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.HeaderRequestType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "HeaderResponseType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.HeaderResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "OpcionType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.OpcionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ResponseData");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ResponseStatus");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "SisFault");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.SisFault.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ValidacionIndicador");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ValidacionIndicador.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "ArchivoResultadoZipType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.ArchivoResultadoZipType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "GetResultadoFUARequestType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUARequestType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "GetResultadoFUAResponseType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "ArchivoResultadoBase64Type");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "GetResultadoFUACompatRequestType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatRequestType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "GetResultadoFUACompatResponseType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "ArchivoPaqueteZipType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.ArchivoPaqueteZipType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUARequestType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUARequestType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUAResponseType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "ArchivoPaqueteZipCompatType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.ArchivoPaqueteZipCompatType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "RegistrarFUACompatRequestType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatRequestType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "RegistrarFUACompatResponseType");
            cachedSerQNames.add(qName);
            cls = pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    protected org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call _call = super._createCall();
            if (super.maintainSessionSet) {
                _call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                _call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                _call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                _call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                _call.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                _call.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                    _call.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Object x = cachedSerFactories.get(i);
                        if (x instanceof Class) {
                            java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                            java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                        else if (x instanceof javax.xml.rpc.encoding.SerializerFactory) {
                            org.apache.axis.encoding.SerializerFactory sf = (org.apache.axis.encoding.SerializerFactory)
                                 cachedSerFactories.get(i);
                            org.apache.axis.encoding.DeserializerFactory df = (org.apache.axis.encoding.DeserializerFactory)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                    }
                }
            }
            return _call;
        }
        catch (java.lang.Throwable _t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
        }
    }

    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType registrarFUA(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUARequestType registrarFUARequest) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/registrarFUA");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("", "registrarFUA"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {registrarFUARequest});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType) _resp;
            } catch (java.lang.Exception _exception) {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType) org.apache.axis.utils.JavaUtils.convert(_resp, pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType registrarFUACompat(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatRequestType registrarFUACompatRequest) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/registrarFUACompat");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("", "registrarFUACompat"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {registrarFUACompatRequest});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType) _resp;
            } catch (java.lang.Exception _exception) {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType) org.apache.axis.utils.JavaUtils.convert(_resp, pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType getResultadoFUA(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUARequestType getResultadoFUARequest) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/getResultadoFUA");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("", "getResultadoFUA"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getResultadoFUARequest});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType) _resp;
            } catch (java.lang.Exception _exception) {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType) org.apache.axis.utils.JavaUtils.convert(_resp, pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType getResultadoFUACompat(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatRequestType getResultadoFUACompatRequest) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://sis.gob.pe/esb/negocio/NEG_RegistroFUABatch/v1/getResultadoFUACompat");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("", "getResultadoFUACompat"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getResultadoFUACompatRequest});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType) _resp;
            } catch (java.lang.Exception _exception) {
                return (pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType) org.apache.axis.utils.JavaUtils.convert(_resp, pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

}
