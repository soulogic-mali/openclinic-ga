/**
 * ArchivoResultadoBase64Type.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1;

public class ArchivoResultadoBase64Type  implements java.io.Serializable {
    private java.lang.String nombreZip;

    private java.lang.String dataBase64;

    public ArchivoResultadoBase64Type() {
    }

    public ArchivoResultadoBase64Type(
           java.lang.String nombreZip,
           java.lang.String dataBase64) {
           this.nombreZip = nombreZip;
           this.dataBase64 = dataBase64;
    }


    /**
     * Gets the nombreZip value for this ArchivoResultadoBase64Type.
     * 
     * @return nombreZip
     */
    public java.lang.String getNombreZip() {
        return nombreZip;
    }


    /**
     * Sets the nombreZip value for this ArchivoResultadoBase64Type.
     * 
     * @param nombreZip
     */
    public void setNombreZip(java.lang.String nombreZip) {
        this.nombreZip = nombreZip;
    }


    /**
     * Gets the dataBase64 value for this ArchivoResultadoBase64Type.
     * 
     * @return dataBase64
     */
    public java.lang.String getDataBase64() {
        return dataBase64;
    }


    /**
     * Sets the dataBase64 value for this ArchivoResultadoBase64Type.
     * 
     * @param dataBase64
     */
    public void setDataBase64(java.lang.String dataBase64) {
        this.dataBase64 = dataBase64;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArchivoResultadoBase64Type)) return false;
        ArchivoResultadoBase64Type other = (ArchivoResultadoBase64Type) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.nombreZip==null && other.getNombreZip()==null) || 
             (this.nombreZip!=null &&
              this.nombreZip.equals(other.getNombreZip()))) &&
            ((this.dataBase64==null && other.getDataBase64()==null) || 
             (this.dataBase64!=null &&
              this.dataBase64.equals(other.getDataBase64())));
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
        if (getNombreZip() != null) {
            _hashCode += getNombreZip().hashCode();
        }
        if (getDataBase64() != null) {
            _hashCode += getDataBase64().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArchivoResultadoBase64Type.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "ArchivoResultadoBase64Type"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nombreZip");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "nombreZip"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dataBase64");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/getResultadoFUACompat/v1/", "dataBase64"));
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
