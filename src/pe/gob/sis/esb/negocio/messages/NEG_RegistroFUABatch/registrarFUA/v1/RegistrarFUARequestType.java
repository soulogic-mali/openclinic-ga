/**
 * RegistrarFUARequestType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1;

public class RegistrarFUARequestType  implements java.io.Serializable {
    private pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.ArchivoPaqueteZipType paquete;

    public RegistrarFUARequestType() {
    }

    public RegistrarFUARequestType(
           pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.ArchivoPaqueteZipType paquete) {
           this.paquete = paquete;
    }


    /**
     * Gets the paquete value for this RegistrarFUARequestType.
     * 
     * @return paquete
     */
    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.ArchivoPaqueteZipType getPaquete() {
        return paquete;
    }


    /**
     * Sets the paquete value for this RegistrarFUARequestType.
     * 
     * @param paquete
     */
    public void setPaquete(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.ArchivoPaqueteZipType paquete) {
        this.paquete = paquete;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RegistrarFUARequestType)) return false;
        RegistrarFUARequestType other = (RegistrarFUARequestType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.paquete==null && other.getPaquete()==null) || 
             (this.paquete!=null &&
              this.paquete.equals(other.getPaquete())));
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
        if (getPaquete() != null) {
            _hashCode += getPaquete().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RegistrarFUARequestType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "RegistrarFUARequestType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("paquete");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "paquete"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUA/v1/", "ArchivoPaqueteZipType"));
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
