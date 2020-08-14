/**
 * ArchivoPaqueteZipType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1;

public class ArchivoPaqueteZipType  implements java.io.Serializable {
    private java.lang.String nombreZip;

    private byte[] dataZip;

    public ArchivoPaqueteZipType() {
    }

    public ArchivoPaqueteZipType(
           java.lang.String nombreZip,
           byte[] dataZip) {
           this.nombreZip = nombreZip;
           this.dataZip = dataZip;
    }


    /**
     * Gets the nombreZip value for this ArchivoPaqueteZipType.
     * 
     * @return nombreZip
     */
    public java.lang.String getNombreZip() {
        return nombreZip;
    }


    /**
     * Sets the nombreZip value for this ArchivoPaqueteZipType.
     * 
     * @param nombreZip
     */
    public void setNombreZip(java.lang.String nombreZip) {
        this.nombreZip = nombreZip;
    }


    /**
     * Gets the dataZip value for this ArchivoPaqueteZipType.
     * 
     * @return dataZip
     */
    public byte[] getDataZip() {
        return dataZip;
    }


    /**
     * Sets the dataZip value for this ArchivoPaqueteZipType.
     * 
     * @param dataZip
     */
    public void setDataZip(byte[] dataZip) {
        this.dataZip = dataZip;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArchivoPaqueteZipType)) return false;
        ArchivoPaqueteZipType other = (ArchivoPaqueteZipType) obj;
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
            ((this.dataZip==null && other.getDataZip()==null) || 
             (this.dataZip!=null &&
              java.util.Arrays.equals(this.dataZip, other.getDataZip())));
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
        if (getDataZip() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDataZip());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDataZip(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArchivoPaqueteZipType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "ArchivoPaqueteZipType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nombreZip");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "nombreZip"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dataZip");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "dataZip"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
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
