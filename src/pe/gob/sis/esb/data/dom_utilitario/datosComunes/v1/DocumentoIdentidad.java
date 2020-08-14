/**
 * DocumentoIdentidad.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1;

public class DocumentoIdentidad  implements java.io.Serializable {
    /* Debe contener uno de los siguientes valores: 1=DNI; 3=Carné
     * de Extranjería; 
     * 						Catálogo TIPODOCIDENTIDAD */
    private java.lang.String tipo;

    /* Si el “Tipo de documento de identidad del asegurado” es:
     * 							- “DNI”  se deben consignar 8 dígitos.	
     * 							- “Carné de Extranjería” se deben consignar 9 dígitos. */
    private java.lang.String numero;

    public DocumentoIdentidad() {
    }

    public DocumentoIdentidad(
           java.lang.String tipo,
           java.lang.String numero) {
           this.tipo = tipo;
           this.numero = numero;
    }


    /**
     * Gets the tipo value for this DocumentoIdentidad.
     * 
     * @return tipo   * Debe contener uno de los siguientes valores: 1=DNI; 3=Carné
     * de Extranjería; 
     * 						Catálogo TIPODOCIDENTIDAD
     */
    public java.lang.String getTipo() {
        return tipo;
    }


    /**
     * Sets the tipo value for this DocumentoIdentidad.
     * 
     * @param tipo   * Debe contener uno de los siguientes valores: 1=DNI; 3=Carné
     * de Extranjería; 
     * 						Catálogo TIPODOCIDENTIDAD
     */
    public void setTipo(java.lang.String tipo) {
        this.tipo = tipo;
    }


    /**
     * Gets the numero value for this DocumentoIdentidad.
     * 
     * @return numero   * Si el “Tipo de documento de identidad del asegurado” es:
     * 							- “DNI”  se deben consignar 8 dígitos.	
     * 							- “Carné de Extranjería” se deben consignar 9 dígitos.
     */
    public java.lang.String getNumero() {
        return numero;
    }


    /**
     * Sets the numero value for this DocumentoIdentidad.
     * 
     * @param numero   * Si el “Tipo de documento de identidad del asegurado” es:
     * 							- “DNI”  se deben consignar 8 dígitos.	
     * 							- “Carné de Extranjería” se deben consignar 9 dígitos.
     */
    public void setNumero(java.lang.String numero) {
        this.numero = numero;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DocumentoIdentidad)) return false;
        DocumentoIdentidad other = (DocumentoIdentidad) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.tipo==null && other.getTipo()==null) || 
             (this.tipo!=null &&
              this.tipo.equals(other.getTipo()))) &&
            ((this.numero==null && other.getNumero()==null) || 
             (this.numero!=null &&
              this.numero.equals(other.getNumero())));
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
        if (getTipo() != null) {
            _hashCode += getTipo().hashCode();
        }
        if (getNumero() != null) {
            _hashCode += getNumero().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DocumentoIdentidad.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "DocumentoIdentidad"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tipo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "tipo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("numero");
        elemField.setXmlName(new javax.xml.namespace.QName("", "numero"));
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
