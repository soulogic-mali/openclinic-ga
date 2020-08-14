/**
 * SisFault.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis.esb.data.dom_utilitario.estructuraBase.v1;

public class SisFault  implements java.io.Serializable {
    private java.lang.String codigoError;

    private java.lang.String descripcionError;

    private java.lang.Object errorOrigen;

    private java.util.Calendar fecha;

    private java.lang.String idAuditoria;

    private java.lang.String ubicacionError;

    public SisFault() {
    }

    public SisFault(
           java.lang.String codigoError,
           java.lang.String descripcionError,
           java.lang.Object errorOrigen,
           java.util.Calendar fecha,
           java.lang.String idAuditoria,
           java.lang.String ubicacionError) {
           this.codigoError = codigoError;
           this.descripcionError = descripcionError;
           this.errorOrigen = errorOrigen;
           this.fecha = fecha;
           this.idAuditoria = idAuditoria;
           this.ubicacionError = ubicacionError;
    }


    /**
     * Gets the codigoError value for this SisFault.
     * 
     * @return codigoError
     */
    public java.lang.String getCodigoError() {
        return codigoError;
    }


    /**
     * Sets the codigoError value for this SisFault.
     * 
     * @param codigoError
     */
    public void setCodigoError(java.lang.String codigoError) {
        this.codigoError = codigoError;
    }


    /**
     * Gets the descripcionError value for this SisFault.
     * 
     * @return descripcionError
     */
    public java.lang.String getDescripcionError() {
        return descripcionError;
    }


    /**
     * Sets the descripcionError value for this SisFault.
     * 
     * @param descripcionError
     */
    public void setDescripcionError(java.lang.String descripcionError) {
        this.descripcionError = descripcionError;
    }


    /**
     * Gets the errorOrigen value for this SisFault.
     * 
     * @return errorOrigen
     */
    public java.lang.Object getErrorOrigen() {
        return errorOrigen;
    }


    /**
     * Sets the errorOrigen value for this SisFault.
     * 
     * @param errorOrigen
     */
    public void setErrorOrigen(java.lang.Object errorOrigen) {
        this.errorOrigen = errorOrigen;
    }


    /**
     * Gets the fecha value for this SisFault.
     * 
     * @return fecha
     */
    public java.util.Calendar getFecha() {
        return fecha;
    }


    /**
     * Sets the fecha value for this SisFault.
     * 
     * @param fecha
     */
    public void setFecha(java.util.Calendar fecha) {
        this.fecha = fecha;
    }


    /**
     * Gets the idAuditoria value for this SisFault.
     * 
     * @return idAuditoria
     */
    public java.lang.String getIdAuditoria() {
        return idAuditoria;
    }


    /**
     * Sets the idAuditoria value for this SisFault.
     * 
     * @param idAuditoria
     */
    public void setIdAuditoria(java.lang.String idAuditoria) {
        this.idAuditoria = idAuditoria;
    }


    /**
     * Gets the ubicacionError value for this SisFault.
     * 
     * @return ubicacionError
     */
    public java.lang.String getUbicacionError() {
        return ubicacionError;
    }


    /**
     * Sets the ubicacionError value for this SisFault.
     * 
     * @param ubicacionError
     */
    public void setUbicacionError(java.lang.String ubicacionError) {
        this.ubicacionError = ubicacionError;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SisFault)) return false;
        SisFault other = (SisFault) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.codigoError==null && other.getCodigoError()==null) || 
             (this.codigoError!=null &&
              this.codigoError.equals(other.getCodigoError()))) &&
            ((this.descripcionError==null && other.getDescripcionError()==null) || 
             (this.descripcionError!=null &&
              this.descripcionError.equals(other.getDescripcionError()))) &&
            ((this.errorOrigen==null && other.getErrorOrigen()==null) || 
             (this.errorOrigen!=null &&
              this.errorOrigen.equals(other.getErrorOrigen()))) &&
            ((this.fecha==null && other.getFecha()==null) || 
             (this.fecha!=null &&
              this.fecha.equals(other.getFecha()))) &&
            ((this.idAuditoria==null && other.getIdAuditoria()==null) || 
             (this.idAuditoria!=null &&
              this.idAuditoria.equals(other.getIdAuditoria()))) &&
            ((this.ubicacionError==null && other.getUbicacionError()==null) || 
             (this.ubicacionError!=null &&
              this.ubicacionError.equals(other.getUbicacionError())));
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
        if (getCodigoError() != null) {
            _hashCode += getCodigoError().hashCode();
        }
        if (getDescripcionError() != null) {
            _hashCode += getDescripcionError().hashCode();
        }
        if (getErrorOrigen() != null) {
            _hashCode += getErrorOrigen().hashCode();
        }
        if (getFecha() != null) {
            _hashCode += getFecha().hashCode();
        }
        if (getIdAuditoria() != null) {
            _hashCode += getIdAuditoria().hashCode();
        }
        if (getUbicacionError() != null) {
            _hashCode += getUbicacionError().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SisFault.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/esb/data/dom_utilitario/estructuraBase/v1/", "SisFault"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("codigoError");
        elemField.setXmlName(new javax.xml.namespace.QName("", "codigoError"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("descripcionError");
        elemField.setXmlName(new javax.xml.namespace.QName("", "descripcionError"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorOrigen");
        elemField.setXmlName(new javax.xml.namespace.QName("", "errorOrigen"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecha");
        elemField.setXmlName(new javax.xml.namespace.QName("", "fecha"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idAuditoria");
        elemField.setXmlName(new javax.xml.namespace.QName("", "idAuditoria"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ubicacionError");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ubicacionError"));
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
