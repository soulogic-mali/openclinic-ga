/**
 * ArchivoPaqueteZipCompatType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1;

public class ArchivoPaqueteZipCompatType  implements java.io.Serializable {
    private java.lang.String nombreZip;

    private java.lang.String dataZipBase64;

    public ArchivoPaqueteZipCompatType() {
    }

    public ArchivoPaqueteZipCompatType(
           java.lang.String nombreZip,
           java.lang.String dataZipBase64) {
           this.nombreZip = nombreZip;
           this.dataZipBase64 = dataZipBase64;
    }


    /**
     * Gets the nombreZip value for this ArchivoPaqueteZipCompatType.
     * 
     * @return nombreZip
     */
    public java.lang.String getNombreZip() {
        return nombreZip;
    }


    /**
     * Sets the nombreZip value for this ArchivoPaqueteZipCompatType.
     * 
     * @param nombreZip
     */
    public void setNombreZip(java.lang.String nombreZip) {
        this.nombreZip = nombreZip;
    }


    /**
     * Gets the dataZipBase64 value for this ArchivoPaqueteZipCompatType.
     * 
     * @return dataZipBase64
     */
    public java.lang.String getDataZipBase64() {
        return dataZipBase64;
    }


    /**
     * Sets the dataZipBase64 value for this ArchivoPaqueteZipCompatType.
     * 
     * @param dataZipBase64
     */
    public void setDataZipBase64(java.lang.String dataZipBase64) {
        this.dataZipBase64 = dataZipBase64;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArchivoPaqueteZipCompatType)) return false;
        ArchivoPaqueteZipCompatType other = (ArchivoPaqueteZipCompatType) obj;
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
            ((this.dataZipBase64==null && other.getDataZipBase64()==null) || 
             (this.dataZipBase64!=null &&
              this.dataZipBase64.equals(other.getDataZipBase64())));
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
        if (getDataZipBase64() != null) {
            _hashCode += getDataZipBase64().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArchivoPaqueteZipCompatType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "ArchivoPaqueteZipCompatType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nombreZip");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "nombreZip"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dataZipBase64");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "dataZipBase64"));
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
