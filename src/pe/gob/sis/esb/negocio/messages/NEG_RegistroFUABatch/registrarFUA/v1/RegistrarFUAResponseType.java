/**
 * RegistrarFUAResponseType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1;

public class RegistrarFUAResponseType  implements java.io.Serializable {
    private pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus;

    private java.lang.String respuestaString;

    private java.lang.String identificadorPaquete;

    private int paqueteIdGenerado;

    public RegistrarFUAResponseType() {
    }

    public RegistrarFUAResponseType(
           pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus,
           java.lang.String respuestaString,
           java.lang.String identificadorPaquete,
           int paqueteIdGenerado) {
           this.responseStatus = responseStatus;
           this.respuestaString = respuestaString;
           this.identificadorPaquete = identificadorPaquete;
           this.paqueteIdGenerado = paqueteIdGenerado;
    }


    /**
     * Gets the responseStatus value for this RegistrarFUAResponseType.
     * 
     * @return responseStatus
     */
    public pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus getResponseStatus() {
        return responseStatus;
    }


    /**
     * Sets the responseStatus value for this RegistrarFUAResponseType.
     * 
     * @param responseStatus
     */
    public void setResponseStatus(pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1.ResponseStatus responseStatus) {
        this.responseStatus = responseStatus;
    }


    /**
     * Gets the respuestaString value for this RegistrarFUAResponseType.
     * 
     * @return respuestaString
     */
    public java.lang.String getRespuestaString() {
        return respuestaString;
    }


    /**
     * Sets the respuestaString value for this RegistrarFUAResponseType.
     * 
     * @param respuestaString
     */
    public void setRespuestaString(java.lang.String respuestaString) {
        this.respuestaString = respuestaString;
    }


    /**
     * Gets the identificadorPaquete value for this RegistrarFUAResponseType.
     * 
     * @return identificadorPaquete
     */
    public java.lang.String getIdentificadorPaquete() {
        return identificadorPaquete;
    }


    /**
     * Sets the identificadorPaquete value for this RegistrarFUAResponseType.
     * 
     * @param identificadorPaquete
     */
    public void setIdentificadorPaquete(java.lang.String identificadorPaquete) {
        this.identificadorPaquete = identificadorPaquete;
    }


    /**
     * Gets the paqueteIdGenerado value for this RegistrarFUAResponseType.
     * 
     * @return paqueteIdGenerado
     */
    public int getPaqueteIdGenerado() {
        return paqueteIdGenerado;
    }


    /**
     * Sets the paqueteIdGenerado value for this RegistrarFUAResponseType.
     * 
     * @param paqueteIdGenerado
     */
    public void setPaqueteIdGenerado(int paqueteIdGenerado) {
        this.paqueteIdGenerado = paqueteIdGenerado;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RegistrarFUAResponseType)) return false;
        RegistrarFUAResponseType other = (RegistrarFUAResponseType) obj;
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
            this.paqueteIdGenerado == other.getPaqueteIdGenerado();
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
        _hashCode += getPaqueteIdGenerado();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RegistrarFUAResponseType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUAResponseType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("responseStatus");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "responseStatus"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ResponseStatus"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("respuestaString");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "respuestaString"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("identificadorPaquete");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "identificadorPaquete"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("paqueteIdGenerado");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "paqueteIdGenerado"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
