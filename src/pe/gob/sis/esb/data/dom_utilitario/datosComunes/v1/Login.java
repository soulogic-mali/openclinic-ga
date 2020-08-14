/**
 * Login.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1;

public class Login  implements java.io.Serializable {
    /* Es la contraseña del usuario */
    private java.lang.String contrasena;

    /* Es el resultado de la autenticación */
    private java.lang.String resultado;

    /* usuario */
    private java.lang.String usuario;

    private pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.ServicioWeb servicioWeb;

    private pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.OperacionWeb operacionWeb;

    public Login() {
    }

    public Login(
           java.lang.String contrasena,
           java.lang.String resultado,
           java.lang.String usuario,
           pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.ServicioWeb servicioWeb,
           pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.OperacionWeb operacionWeb) {
           this.contrasena = contrasena;
           this.resultado = resultado;
           this.usuario = usuario;
           this.servicioWeb = servicioWeb;
           this.operacionWeb = operacionWeb;
    }


    /**
     * Gets the contrasena value for this Login.
     * 
     * @return contrasena   * Es la contraseña del usuario
     */
    public java.lang.String getContrasena() {
        return contrasena;
    }


    /**
     * Sets the contrasena value for this Login.
     * 
     * @param contrasena   * Es la contraseña del usuario
     */
    public void setContrasena(java.lang.String contrasena) {
        this.contrasena = contrasena;
    }


    /**
     * Gets the resultado value for this Login.
     * 
     * @return resultado   * Es el resultado de la autenticación
     */
    public java.lang.String getResultado() {
        return resultado;
    }


    /**
     * Sets the resultado value for this Login.
     * 
     * @param resultado   * Es el resultado de la autenticación
     */
    public void setResultado(java.lang.String resultado) {
        this.resultado = resultado;
    }


    /**
     * Gets the usuario value for this Login.
     * 
     * @return usuario   * usuario
     */
    public java.lang.String getUsuario() {
        return usuario;
    }


    /**
     * Sets the usuario value for this Login.
     * 
     * @param usuario   * usuario
     */
    public void setUsuario(java.lang.String usuario) {
        this.usuario = usuario;
    }


    /**
     * Gets the servicioWeb value for this Login.
     * 
     * @return servicioWeb
     */
    public pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.ServicioWeb getServicioWeb() {
        return servicioWeb;
    }


    /**
     * Sets the servicioWeb value for this Login.
     * 
     * @param servicioWeb
     */
    public void setServicioWeb(pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.ServicioWeb servicioWeb) {
        this.servicioWeb = servicioWeb;
    }


    /**
     * Gets the operacionWeb value for this Login.
     * 
     * @return operacionWeb
     */
    public pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.OperacionWeb getOperacionWeb() {
        return operacionWeb;
    }


    /**
     * Sets the operacionWeb value for this Login.
     * 
     * @param operacionWeb
     */
    public void setOperacionWeb(pe.gob.sis.esb.data.dom_utilitario.datosComunes.v1.OperacionWeb operacionWeb) {
        this.operacionWeb = operacionWeb;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Login)) return false;
        Login other = (Login) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.contrasena==null && other.getContrasena()==null) || 
             (this.contrasena!=null &&
              this.contrasena.equals(other.getContrasena()))) &&
            ((this.resultado==null && other.getResultado()==null) || 
             (this.resultado!=null &&
              this.resultado.equals(other.getResultado()))) &&
            ((this.usuario==null && other.getUsuario()==null) || 
             (this.usuario!=null &&
              this.usuario.equals(other.getUsuario()))) &&
            ((this.servicioWeb==null && other.getServicioWeb()==null) || 
             (this.servicioWeb!=null &&
              this.servicioWeb.equals(other.getServicioWeb()))) &&
            ((this.operacionWeb==null && other.getOperacionWeb()==null) || 
             (this.operacionWeb!=null &&
              this.operacionWeb.equals(other.getOperacionWeb())));
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
        if (getContrasena() != null) {
            _hashCode += getContrasena().hashCode();
        }
        if (getResultado() != null) {
            _hashCode += getResultado().hashCode();
        }
        if (getUsuario() != null) {
            _hashCode += getUsuario().hashCode();
        }
        if (getServicioWeb() != null) {
            _hashCode += getServicioWeb().hashCode();
        }
        if (getOperacionWeb() != null) {
            _hashCode += getOperacionWeb().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Login.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "Login"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contrasena");
        elemField.setXmlName(new javax.xml.namespace.QName("", "contrasena"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultado");
        elemField.setXmlName(new javax.xml.namespace.QName("", "resultado"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
        elemField.setFieldName("servicioWeb");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ServicioWeb"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "ServicioWeb"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("operacionWeb");
        elemField.setXmlName(new javax.xml.namespace.QName("", "OperacionWeb"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/datosComunes/v1/", "OperacionWeb"));
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
