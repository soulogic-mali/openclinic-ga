/**
 * RegistrarFUACompatRequestType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1;

public class RegistrarFUACompatRequestType  implements java.io.Serializable {
    private pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.ArchivoPaqueteZipCompatType paquete;

    private pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Login login;

    public RegistrarFUACompatRequestType() {
    }

    public RegistrarFUACompatRequestType(
           pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.ArchivoPaqueteZipCompatType paquete,
           pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Login login) {
           this.paquete = paquete;
           this.login = login;
    }


    /**
     * Gets the paquete value for this RegistrarFUACompatRequestType.
     * 
     * @return paquete
     */
    public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.ArchivoPaqueteZipCompatType getPaquete() {
        return paquete;
    }


    /**
     * Sets the paquete value for this RegistrarFUACompatRequestType.
     * 
     * @param paquete
     */
    public void setPaquete(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.ArchivoPaqueteZipCompatType paquete) {
        this.paquete = paquete;
    }


    /**
     * Gets the login value for this RegistrarFUACompatRequestType.
     * 
     * @return login
     */
    public pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Login getLogin() {
        return login;
    }


    /**
     * Sets the login value for this RegistrarFUACompatRequestType.
     * 
     * @param login
     */
    public void setLogin(pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.Login login) {
        this.login = login;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RegistrarFUACompatRequestType)) return false;
        RegistrarFUACompatRequestType other = (RegistrarFUACompatRequestType) obj;
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
              this.paquete.equals(other.getPaquete()))) &&
            ((this.login==null && other.getLogin()==null) || 
             (this.login!=null &&
              this.login.equals(other.getLogin())));
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
        if (getLogin() != null) {
            _hashCode += getLogin().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RegistrarFUACompatRequestType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "RegistrarFUACompatRequestType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("paquete");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "paquete"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "ArchivoPaqueteZipCompatType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("login");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/esb/negocio/messages/NEG_RegistroFUABatch/registrarFUACompat/v1/", "login"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Login"));
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
