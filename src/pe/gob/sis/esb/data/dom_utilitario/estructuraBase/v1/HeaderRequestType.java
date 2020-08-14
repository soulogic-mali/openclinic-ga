/**
 * HeaderRequestType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1;


/**
 * Todas las operaciones de los servicios implementaran esta cabecera
 * para el envío de los datos de entrada.
 */
public class HeaderRequestType  implements java.io.Serializable {
    private java.lang.String canal;

    private java.lang.Integer idAplicacion;

    /* Id de la transacción de negocio quien consume.
     * 					Concatenación año,mes,dia,hora(24h),minuto,segundo,milisegundos
     * y numero aleatorio de 3 cifras.
     * 					Ejemplo : 20171124154121123211 */
    private java.lang.String idTransaccionNegocio;

    private java.lang.Object nodoAdicional;

    private java.lang.String usuario;

    private java.lang.String autorizacion;

    public HeaderRequestType() {
    }

    public HeaderRequestType(
           java.lang.String canal,
           java.lang.Integer idAplicacion,
           java.lang.String idTransaccionNegocio,
           java.lang.Object nodoAdicional,
           java.lang.String usuario,
           java.lang.String autorizacion) {
           this.canal = canal;
           this.idAplicacion = idAplicacion;
           this.idTransaccionNegocio = idTransaccionNegocio;
           this.nodoAdicional = nodoAdicional;
           this.usuario = usuario;
           this.autorizacion = autorizacion;
    }


    /**
     * Gets the canal value for this HeaderRequestType.
     * 
     * @return canal
     */
    public java.lang.String getCanal() {
        return canal;
    }


    /**
     * Sets the canal value for this HeaderRequestType.
     * 
     * @param canal
     */
    public void setCanal(java.lang.String canal) {
        this.canal = canal;
    }


    /**
     * Gets the idAplicacion value for this HeaderRequestType.
     * 
     * @return idAplicacion
     */
    public java.lang.Integer getIdAplicacion() {
        return idAplicacion;
    }


    /**
     * Sets the idAplicacion value for this HeaderRequestType.
     * 
     * @param idAplicacion
     */
    public void setIdAplicacion(java.lang.Integer idAplicacion) {
        this.idAplicacion = idAplicacion;
    }


    /**
     * Gets the idTransaccionNegocio value for this HeaderRequestType.
     * 
     * @return idTransaccionNegocio   * Id de la transacción de negocio quien consume.
     * 					Concatenación año,mes,dia,hora(24h),minuto,segundo,milisegundos
     * y numero aleatorio de 3 cifras.
     * 					Ejemplo : 20171124154121123211
     */
    public java.lang.String getIdTransaccionNegocio() {
        return idTransaccionNegocio;
    }


    /**
     * Sets the idTransaccionNegocio value for this HeaderRequestType.
     * 
     * @param idTransaccionNegocio   * Id de la transacción de negocio quien consume.
     * 					Concatenación año,mes,dia,hora(24h),minuto,segundo,milisegundos
     * y numero aleatorio de 3 cifras.
     * 					Ejemplo : 20171124154121123211
     */
    public void setIdTransaccionNegocio(java.lang.String idTransaccionNegocio) {
        this.idTransaccionNegocio = idTransaccionNegocio;
    }


    /**
     * Gets the nodoAdicional value for this HeaderRequestType.
     * 
     * @return nodoAdicional
     */
    public java.lang.Object getNodoAdicional() {
        return nodoAdicional;
    }


    /**
     * Sets the nodoAdicional value for this HeaderRequestType.
     * 
     * @param nodoAdicional
     */
    public void setNodoAdicional(java.lang.Object nodoAdicional) {
        this.nodoAdicional = nodoAdicional;
    }


    /**
     * Gets the usuario value for this HeaderRequestType.
     * 
     * @return usuario
     */
    public java.lang.String getUsuario() {
        return usuario;
    }


    /**
     * Sets the usuario value for this HeaderRequestType.
     * 
     * @param usuario
     */
    public void setUsuario(java.lang.String usuario) {
        this.usuario = usuario;
    }


    /**
     * Gets the autorizacion value for this HeaderRequestType.
     * 
     * @return autorizacion
     */
    public java.lang.String getAutorizacion() {
        return autorizacion;
    }


    /**
     * Sets the autorizacion value for this HeaderRequestType.
     * 
     * @param autorizacion
     */
    public void setAutorizacion(java.lang.String autorizacion) {
        this.autorizacion = autorizacion;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof HeaderRequestType)) return false;
        HeaderRequestType other = (HeaderRequestType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.canal==null && other.getCanal()==null) || 
             (this.canal!=null &&
              this.canal.equals(other.getCanal()))) &&
            ((this.idAplicacion==null && other.getIdAplicacion()==null) || 
             (this.idAplicacion!=null &&
              this.idAplicacion.equals(other.getIdAplicacion()))) &&
            ((this.idTransaccionNegocio==null && other.getIdTransaccionNegocio()==null) || 
             (this.idTransaccionNegocio!=null &&
              this.idTransaccionNegocio.equals(other.getIdTransaccionNegocio()))) &&
            ((this.nodoAdicional==null && other.getNodoAdicional()==null) || 
             (this.nodoAdicional!=null &&
              this.nodoAdicional.equals(other.getNodoAdicional()))) &&
            ((this.usuario==null && other.getUsuario()==null) || 
             (this.usuario!=null &&
              this.usuario.equals(other.getUsuario()))) &&
            ((this.autorizacion==null && other.getAutorizacion()==null) || 
             (this.autorizacion!=null &&
              this.autorizacion.equals(other.getAutorizacion())));
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
        if (getCanal() != null) {
            _hashCode += getCanal().hashCode();
        }
        if (getIdAplicacion() != null) {
            _hashCode += getIdAplicacion().hashCode();
        }
        if (getIdTransaccionNegocio() != null) {
            _hashCode += getIdTransaccionNegocio().hashCode();
        }
        if (getNodoAdicional() != null) {
            _hashCode += getNodoAdicional().hashCode();
        }
        if (getUsuario() != null) {
            _hashCode += getUsuario().hashCode();
        }
        if (getAutorizacion() != null) {
            _hashCode += getAutorizacion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(HeaderRequestType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "HeaderRequestType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("canal");
        elemField.setXmlName(new javax.xml.namespace.QName("", "canal"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idAplicacion");
        elemField.setXmlName(new javax.xml.namespace.QName("", "idAplicacion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idTransaccionNegocio");
        elemField.setXmlName(new javax.xml.namespace.QName("", "idTransaccionNegocio"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nodoAdicional");
        elemField.setXmlName(new javax.xml.namespace.QName("", "nodoAdicional"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("usuario");
        elemField.setXmlName(new javax.xml.namespace.QName("", "usuario"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("autorizacion");
        elemField.setXmlName(new javax.xml.namespace.QName("", "autorizacion"));
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
