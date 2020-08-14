/**
 * Disa.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1;

public class Disa  implements java.io.Serializable {
    /* Obligatorio según el contrato del asegurado SIS, si se consigna
     * el código debe ser del catálogo de DISAS. Catálogo DISAS. */
    private java.lang.String codigo;

    /* Identifica al código de la DISA del FUA de reconsideración. */
    private java.lang.String reconsideracion;

    public Disa() {
    }

    public Disa(
           java.lang.String codigo,
           java.lang.String reconsideracion) {
           this.codigo = codigo;
           this.reconsideracion = reconsideracion;
    }


    /**
     * Gets the codigo value for this Disa.
     * 
     * @return codigo   * Obligatorio según el contrato del asegurado SIS, si se consigna
     * el código debe ser del catálogo de DISAS. Catálogo DISAS.
     */
    public java.lang.String getCodigo() {
        return codigo;
    }


    /**
     * Sets the codigo value for this Disa.
     * 
     * @param codigo   * Obligatorio según el contrato del asegurado SIS, si se consigna
     * el código debe ser del catálogo de DISAS. Catálogo DISAS.
     */
    public void setCodigo(java.lang.String codigo) {
        this.codigo = codigo;
    }


    /**
     * Gets the reconsideracion value for this Disa.
     * 
     * @return reconsideracion   * Identifica al código de la DISA del FUA de reconsideración.
     */
    public java.lang.String getReconsideracion() {
        return reconsideracion;
    }


    /**
     * Sets the reconsideracion value for this Disa.
     * 
     * @param reconsideracion   * Identifica al código de la DISA del FUA de reconsideración.
     */
    public void setReconsideracion(java.lang.String reconsideracion) {
        this.reconsideracion = reconsideracion;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Disa)) return false;
        Disa other = (Disa) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.codigo==null && other.getCodigo()==null) || 
             (this.codigo!=null &&
              this.codigo.equals(other.getCodigo()))) &&
            ((this.reconsideracion==null && other.getReconsideracion()==null) || 
             (this.reconsideracion!=null &&
              this.reconsideracion.equals(other.getReconsideracion())));
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
        if (getCodigo() != null) {
            _hashCode += getCodigo().hashCode();
        }
        if (getReconsideracion() != null) {
            _hashCode += getReconsideracion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Disa.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Disa"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("codigo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "codigo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reconsideracion");
        elemField.setXmlName(new javax.xml.namespace.QName("", "reconsideracion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
