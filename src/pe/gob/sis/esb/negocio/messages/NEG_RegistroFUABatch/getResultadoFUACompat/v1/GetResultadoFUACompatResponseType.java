/**
 * GetResultadoFUACompatResponseType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1;

public class GetResultadoFUACompatResponseType  implements java.io.Serializable {
    private pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus;

    private java.lang.String respuestaString;

    private java.lang.String identificadorPaquete;

    private pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUAS;

    private pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUASNSNC;

    public GetResultadoFUACompatResponseType() {
    }

    public GetResultadoFUACompatResponseType(
           pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus,
           java.lang.String respuestaString,
           java.lang.String identificadorPaquete,
           pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUAS,
           pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUASNSNC) {
           this.responseStatus = responseStatus;
           this.respuestaString = respuestaString;
           this.identificadorPaquete = identificadorPaquete;
           this.retFUAS = retFUAS;
           this.retFUASNSNC = retFUASNSNC;
    }


    /**
     * Gets the responseStatus value for this GetResultadoFUACompatResponseType.
     * 
     * @return responseStatus
     */
    public pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus getResponseStatus() {
        return responseStatus;
    }


    /**
     * Sets the responseStatus value for this GetResultadoFUACompatResponseType.
     * 
     * @param responseStatus
     */
    public void setResponseStatus(pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus) {
        this.responseStatus = responseStatus;
    }


    /**
     * Gets the respuestaString value for this GetResultadoFUACompatResponseType.
     * 
     * @return respuestaString
     */
    public java.lang.String getRespuestaString() {
        return respuestaString;
    }


    /**
     * Sets the respuestaString value for this GetResultadoFUACompatResponseType.
     * 
     * @param respuestaString
     */
    public void setRespuestaString(java.lang.String respuestaString) {
        this.respuestaString = respuestaString;
    }


    /**
     * Gets the identificadorPaquete value for this GetResultadoFUACompatResponseType.
     * 
     * @return identificadorPaquete
     */
    public java.lang.String getIdentificadorPaquete() {
        return identificadorPaquete;
    }


    /**
     * Sets the identificadorPaquete value for this GetResultadoFUACompatResponseType.
     * 
     * @param identificadorPaquete
     */
    public void setIdentificadorPaquete(java.lang.String identificadorPaquete) {
        this.identificadorPaquete = identificadorPaquete;
    }


    /**
     * Gets the retFUAS value for this GetResultadoFUACompatResponseType.
     * 
     * @return retFUAS
     */
    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type getRetFUAS() {
        return retFUAS;
    }


    /**
     * Sets the retFUAS value for this GetResultadoFUACompatResponseType.
     * 
     * @param retFUAS
     */
    public void setRetFUAS(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUAS) {
        this.retFUAS = retFUAS;
    }


    /**
     * Gets the retFUASNSNC value for this GetResultadoFUACompatResponseType.
     * 
     * @return retFUASNSNC
     */
    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type getRetFUASNSNC() {
        return retFUASNSNC;
    }


    /**
     * Sets the retFUASNSNC value for this GetResultadoFUACompatResponseType.
     * 
     * @param retFUASNSNC
     */
    public void setRetFUASNSNC(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.ArchivoResultadoBase64Type retFUASNSNC) {
        this.retFUASNSNC = retFUASNSNC;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetResultadoFUACompatResponseType)) return false;
        GetResultadoFUACompatResponseType other = (GetResultadoFUACompatResponseType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.responseStatus==null && other.getResponseStatus()==null) || 
             (this.responseStatus!=null &&
              this.responseStatus.equals(other.getResponseStatus()))) &&
            ((this.respuestaString==null && other.getRespuestaString()==null) || 
             (this.respuestaString!=null &&
              this.respuestaString.equals(other.getRespuestaString()))) &&
            ((this.identificadorPaquete==null && other.getIdentificadorPaquete()==null) || 
             (this.identificadorPaquete!=null &&
              this.identificadorPaquete.equals(other.getIdentificadorPaquete()))) &&
            ((this.retFUAS==null && other.getRetFUAS()==null) || 
             (this.retFUAS!=null &&
              this.retFUAS.equals(other.getRetFUAS()))) &&
            ((this.retFUASNSNC==null && other.getRetFUASNSNC()==null) || 
             (this.retFUASNSNC!=null &&
              this.retFUASNSNC.equals(other.getRetFUASNSNC())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getResponseStatus() != null) {
            _hashCode += getResponseStatus().hashCode();
        }
        if (getRespuestaString() != null) {
            _hashCode += getRespuestaString().hashCode();
        }
        if (getIdentificadorPaquete() != null) {
            _hashCode += getIdentificadorPaquete().hashCode();
        }
        if (getRetFUAS() != null) {
            _hashCode += getRetFUAS().hashCode();
        }
        if (getRetFUASNSNC() != null) {
            _hashCode += getRetFUASNSNC().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetResultadoFUACompatResponseType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "GetResultadoFUACompatResponseType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("responseStatus");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "responseStatus"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ResponseStatus"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("respuestaString");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "respuestaString"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("identificadorPaquete");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "identificadorPaquete"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("retFUAS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "retFUAS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "ArchivoResultadoBase64Type"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("retFUASNSNC");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "retFUASNSNC"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "ArchivoResultadoBase64Type"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
