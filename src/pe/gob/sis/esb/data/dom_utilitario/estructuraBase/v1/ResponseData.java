/**
 * ResponseData.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1;


/**
 * Esta estructura está reservada para los datos de respuesta del
 * servicio.
 */
public class ResponseData  implements java.io.Serializable {
    /* estado de respuesta */
    private java.lang.String estadoRespuesta;

    /* código de respuesta */
    private java.lang.Integer codigoRespuesta;

    /* Descripción de la respuesta */
    private java.lang.String descripcionRespuesta;

    /* Origen del error */
    private java.lang.String errorOrigen;

    /* Código de consulta generado por el sis */
    private java.lang.String codigoAutorizacion;

    public ResponseData() {
    }

    public ResponseData(
           java.lang.String estadoRespuesta,
           java.lang.Integer codigoRespuesta,
           java.lang.String descripcionRespuesta,
           java.lang.String errorOrigen,
           java.lang.String codigoAutorizacion) {
           this.estadoRespuesta = estadoRespuesta;
           this.codigoRespuesta = codigoRespuesta;
           this.descripcionRespuesta = descripcionRespuesta;
           this.errorOrigen = errorOrigen;
           this.codigoAutorizacion = codigoAutorizacion;
    }


    /**
     * Gets the estadoRespuesta value for this ResponseData.
     * 
     * @return estadoRespuesta   * estado de respuesta
     */
    public java.lang.String getEstadoRespuesta() {
        return estadoRespuesta;
    }


    /**
     * Sets the estadoRespuesta value for this ResponseData.
     * 
     * @param estadoRespuesta   * estado de respuesta
     */
    public void setEstadoRespuesta(java.lang.String estadoRespuesta) {
        this.estadoRespuesta = estadoRespuesta;
    }


    /**
     * Gets the codigoRespuesta value for this ResponseData.
     * 
     * @return codigoRespuesta   * código de respuesta
     */
    public java.lang.Integer getCodigoRespuesta() {
        return codigoRespuesta;
    }


    /**
     * Sets the codigoRespuesta value for this ResponseData.
     * 
     * @param codigoRespuesta   * código de respuesta
     */
    public void setCodigoRespuesta(java.lang.Integer codigoRespuesta) {
        this.codigoRespuesta = codigoRespuesta;
    }


    /**
     * Gets the descripcionRespuesta value for this ResponseData.
     * 
     * @return descripcionRespuesta   * Descripción de la respuesta
     */
    public java.lang.String getDescripcionRespuesta() {
        return descripcionRespuesta;
    }


    /**
     * Sets the descripcionRespuesta value for this ResponseData.
     * 
     * @param descripcionRespuesta   * Descripción de la respuesta
     */
    public void setDescripcionRespuesta(java.lang.String descripcionRespuesta) {
        this.descripcionRespuesta = descripcionRespuesta;
    }


    /**
     * Gets the errorOrigen value for this ResponseData.
     * 
     * @return errorOrigen   * Origen del error
     */
    public java.lang.String getErrorOrigen() {
        return errorOrigen;
    }


    /**
     * Sets the errorOrigen value for this ResponseData.
     * 
     * @param errorOrigen   * Origen del error
     */
    public void setErrorOrigen(java.lang.String errorOrigen) {
        this.errorOrigen = errorOrigen;
    }


    /**
     * Gets the codigoAutorizacion value for this ResponseData.
     * 
     * @return codigoAutorizacion   * Código de consulta generado por el sis
     */
    public java.lang.String getCodigoAutorizacion() {
        return codigoAutorizacion;
    }


    /**
     * Sets the codigoAutorizacion value for this ResponseData.
     * 
     * @param codigoAutorizacion   * Código de consulta generado por el sis
     */
    public void setCodigoAutorizacion(java.lang.String codigoAutorizacion) {
        this.codigoAutorizacion = codigoAutorizacion;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ResponseData)) return false;
        ResponseData other = (ResponseData) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.estadoRespuesta==null && other.getEstadoRespuesta()==null) || 
             (this.estadoRespuesta!=null &&
              this.estadoRespuesta.equals(other.getEstadoRespuesta()))) &&
            ((this.codigoRespuesta==null && other.getCodigoRespuesta()==null) || 
             (this.codigoRespuesta!=null &&
              this.codigoRespuesta.equals(other.getCodigoRespuesta()))) &&
            ((this.descripcionRespuesta==null && other.getDescripcionRespuesta()==null) || 
             (this.descripcionRespuesta!=null &&
              this.descripcionRespuesta.equals(other.getDescripcionRespuesta()))) &&
            ((this.errorOrigen==null && other.getErrorOrigen()==null) || 
             (this.errorOrigen!=null &&
              this.errorOrigen.equals(other.getErrorOrigen()))) &&
            ((this.codigoAutorizacion==null && other.getCodigoAutorizacion()==null) || 
             (this.codigoAutorizacion!=null &&
              this.codigoAutorizacion.equals(other.getCodigoAutorizacion())));
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
        if (getEstadoRespuesta() != null) {
            _hashCode += getEstadoRespuesta().hashCode();
        }
        if (getCodigoRespuesta() != null) {
            _hashCode += getCodigoRespuesta().hashCode();
        }
        if (getDescripcionRespuesta() != null) {
            _hashCode += getDescripcionRespuesta().hashCode();
        }
        if (getErrorOrigen() != null) {
            _hashCode += getErrorOrigen().hashCode();
        }
        if (getCodigoAutorizacion() != null) {
            _hashCode += getCodigoAutorizacion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ResponseData.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "ResponseData"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("estadoRespuesta");
        elemField.setXmlName(new javax.xml.namespace.QName("", "estadoRespuesta"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("codigoRespuesta");
        elemField.setXmlName(new javax.xml.namespace.QName("", "codigoRespuesta"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("descripcionRespuesta");
        elemField.setXmlName(new javax.xml.namespace.QName("", "descripcionRespuesta"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorOrigen");
        elemField.setXmlName(new javax.xml.namespace.QName("", "errorOrigen"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("codigoAutorizacion");
        elemField.setXmlName(new javax.xml.namespace.QName("", "codigoAutorizacion"));
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
