/**
 * GetResultadoFUARequestType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1;

public class GetResultadoFUARequestType  implements java.io.Serializable {
    private java.lang.String paqueteId;

    private java.lang.String paqueteDescripcion;

    public GetResultadoFUARequestType() {
    }

    public GetResultadoFUARequestType(
           java.lang.String paqueteId,
           java.lang.String paqueteDescripcion) {
           this.paqueteId = paqueteId;
           this.paqueteDescripcion = paqueteDescripcion;
    }


    /**
     * Gets the paqueteId value for this GetResultadoFUARequestType.
     * 
     * @return paqueteId
     */
    public java.lang.String getPaqueteId() {
        return paqueteId;
    }


    /**
     * Sets the paqueteId value for this GetResultadoFUARequestType.
     * 
     * @param paqueteId
     */
    public void setPaqueteId(java.lang.String paqueteId) {
        this.paqueteId = paqueteId;
    }


    /**
     * Gets the paqueteDescripcion value for this GetResultadoFUARequestType.
     * 
     * @return paqueteDescripcion
     */
    public java.lang.String getPaqueteDescripcion() {
        return paqueteDescripcion;
    }


    /**
     * Sets the paqueteDescripcion value for this GetResultadoFUARequestType.
     * 
     * @param paqueteDescripcion
     */
    public void setPaqueteDescripcion(java.lang.String paqueteDescripcion) {
        this.paqueteDescripcion = paqueteDescripcion;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetResultadoFUARequestType)) return false;
        GetResultadoFUARequestType other = (GetResultadoFUARequestType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.paqueteId==null && other.getPaqueteId()==null) || 
             (this.paqueteId!=null &&
              this.paqueteId.equals(other.getPaqueteId()))) &&
            ((this.paqueteDescripcion==null && other.getPaqueteDescripcion()==null) || 
             (this.paqueteDescripcion!=null &&
              this.paqueteDescripcion.equals(other.getPaqueteDescripcion())));
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
        if (getPaqueteId() != null) {
            _hashCode += getPaqueteId().hashCode();
        }
        if (getPaqueteDescripcion() != null) {
            _hashCode += getPaqueteDescripcion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetResultadoFUARequestType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "GetResultadoFUARequestType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("paqueteId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "paqueteId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("paqueteDescripcion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUA/v1/", "paqueteDescripcion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
