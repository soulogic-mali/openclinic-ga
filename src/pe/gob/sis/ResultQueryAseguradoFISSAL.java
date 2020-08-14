
package pe.gob.sis;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ResultQueryAseguradoFISSAL complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ResultQueryAseguradoFISSAL">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="IdError" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Resultado" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="NroDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="ApePaterno" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="ApeMaterno" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Nombres" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FecAfiliacion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="EESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DescEESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="EESSUbigeo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DescEESSUbigeo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Regimen" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoSeguro" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DescTipoSeguro" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Contrato" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FecCaducidad" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Estado" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Genero" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FecNacimiento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="IdUbigeo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Direccion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="MsgConfidencial" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ResultQueryAseguradoFISSAL", propOrder = {
    "idError",
    "resultado",
    "tipoDocumento",
    "nroDocumento",
    "apePaterno",
    "apeMaterno",
    "nombres",
    "fecAfiliacion",
    "eess",
    "descEESS",
    "eessUbigeo",
    "descEESSUbigeo",
    "regimen",
    "tipoSeguro",
    "descTipoSeguro",
    "contrato",
    "fecCaducidad",
    "estado",
    "genero",
    "fecNacimiento",
    "idUbigeo",
    "direccion",
    "msgConfidencial"
})
public class ResultQueryAseguradoFISSAL {

    @XmlElement(name = "IdError")
    protected String idError;
    @XmlElement(name = "Resultado")
    protected String resultado;
    @XmlElement(name = "TipoDocumento")
    protected String tipoDocumento;
    @XmlElement(name = "NroDocumento")
    protected String nroDocumento;
    @XmlElement(name = "ApePaterno")
    protected String apePaterno;
    @XmlElement(name = "ApeMaterno")
    protected String apeMaterno;
    @XmlElement(name = "Nombres")
    protected String nombres;
    @XmlElement(name = "FecAfiliacion")
    protected String fecAfiliacion;
    @XmlElement(name = "EESS")
    protected String eess;
    @XmlElement(name = "DescEESS")
    protected String descEESS;
    @XmlElement(name = "EESSUbigeo")
    protected String eessUbigeo;
    @XmlElement(name = "DescEESSUbigeo")
    protected String descEESSUbigeo;
    @XmlElement(name = "Regimen")
    protected String regimen;
    @XmlElement(name = "TipoSeguro")
    protected String tipoSeguro;
    @XmlElement(name = "DescTipoSeguro")
    protected String descTipoSeguro;
    @XmlElement(name = "Contrato")
    protected String contrato;
    @XmlElement(name = "FecCaducidad")
    protected String fecCaducidad;
    @XmlElement(name = "Estado")
    protected String estado;
    @XmlElement(name = "Genero")
    protected String genero;
    @XmlElement(name = "FecNacimiento")
    protected String fecNacimiento;
    @XmlElement(name = "IdUbigeo")
    protected String idUbigeo;
    @XmlElement(name = "Direccion")
    protected String direccion;
    @XmlElement(name = "MsgConfidencial")
    protected String msgConfidencial;

    /**
     * Gets the value of the idError property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdError() {
        return idError;
    }

    /**
     * Sets the value of the idError property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdError(String value) {
        this.idError = value;
    }

    /**
     * Gets the value of the resultado property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getResultado() {
        return resultado;
    }

    /**
     * Sets the value of the resultado property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setResultado(String value) {
        this.resultado = value;
    }

    /**
     * Gets the value of the tipoDocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTipoDocumento() {
        return tipoDocumento;
    }

    /**
     * Sets the value of the tipoDocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTipoDocumento(String value) {
        this.tipoDocumento = value;
    }

    /**
     * Gets the value of the nroDocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNroDocumento() {
        return nroDocumento;
    }

    /**
     * Sets the value of the nroDocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNroDocumento(String value) {
        this.nroDocumento = value;
    }

    /**
     * Gets the value of the apePaterno property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getApePaterno() {
        return apePaterno;
    }

    /**
     * Sets the value of the apePaterno property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setApePaterno(String value) {
        this.apePaterno = value;
    }

    /**
     * Gets the value of the apeMaterno property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getApeMaterno() {
        return apeMaterno;
    }

    /**
     * Sets the value of the apeMaterno property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setApeMaterno(String value) {
        this.apeMaterno = value;
    }

    /**
     * Gets the value of the nombres property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNombres() {
        return nombres;
    }

    /**
     * Sets the value of the nombres property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNombres(String value) {
        this.nombres = value;
    }

    /**
     * Gets the value of the fecAfiliacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFecAfiliacion() {
        return fecAfiliacion;
    }

    /**
     * Sets the value of the fecAfiliacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFecAfiliacion(String value) {
        this.fecAfiliacion = value;
    }

    /**
     * Gets the value of the eess property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEESS() {
        return eess;
    }

    /**
     * Sets the value of the eess property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEESS(String value) {
        this.eess = value;
    }

    /**
     * Gets the value of the descEESS property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescEESS() {
        return descEESS;
    }

    /**
     * Sets the value of the descEESS property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescEESS(String value) {
        this.descEESS = value;
    }

    /**
     * Gets the value of the eessUbigeo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEESSUbigeo() {
        return eessUbigeo;
    }

    /**
     * Sets the value of the eessUbigeo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEESSUbigeo(String value) {
        this.eessUbigeo = value;
    }

    /**
     * Gets the value of the descEESSUbigeo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescEESSUbigeo() {
        return descEESSUbigeo;
    }

    /**
     * Sets the value of the descEESSUbigeo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescEESSUbigeo(String value) {
        this.descEESSUbigeo = value;
    }

    /**
     * Gets the value of the regimen property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRegimen() {
        return regimen;
    }

    /**
     * Sets the value of the regimen property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRegimen(String value) {
        this.regimen = value;
    }

    /**
     * Gets the value of the tipoSeguro property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTipoSeguro() {
        return tipoSeguro;
    }

    /**
     * Sets the value of the tipoSeguro property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTipoSeguro(String value) {
        this.tipoSeguro = value;
    }

    /**
     * Gets the value of the descTipoSeguro property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescTipoSeguro() {
        return descTipoSeguro;
    }

    /**
     * Sets the value of the descTipoSeguro property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescTipoSeguro(String value) {
        this.descTipoSeguro = value;
    }

    /**
     * Gets the value of the contrato property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getContrato() {
        return contrato;
    }

    /**
     * Sets the value of the contrato property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setContrato(String value) {
        this.contrato = value;
    }

    /**
     * Gets the value of the fecCaducidad property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFecCaducidad() {
        return fecCaducidad;
    }

    /**
     * Sets the value of the fecCaducidad property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFecCaducidad(String value) {
        this.fecCaducidad = value;
    }

    /**
     * Gets the value of the estado property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEstado() {
        return estado;
    }

    /**
     * Sets the value of the estado property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEstado(String value) {
        this.estado = value;
    }

    /**
     * Gets the value of the genero property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getGenero() {
        return genero;
    }

    /**
     * Sets the value of the genero property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setGenero(String value) {
        this.genero = value;
    }

    /**
     * Gets the value of the fecNacimiento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFecNacimiento() {
        return fecNacimiento;
    }

    /**
     * Sets the value of the fecNacimiento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFecNacimiento(String value) {
        this.fecNacimiento = value;
    }

    /**
     * Gets the value of the idUbigeo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdUbigeo() {
        return idUbigeo;
    }

    /**
     * Sets the value of the idUbigeo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdUbigeo(String value) {
        this.idUbigeo = value;
    }

    /**
     * Gets the value of the direccion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDireccion() {
        return direccion;
    }

    /**
     * Sets the value of the direccion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDireccion(String value) {
        this.direccion = value;
    }

    /**
     * Gets the value of the msgConfidencial property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMsgConfidencial() {
        return msgConfidencial;
    }

    /**
     * Sets the value of the msgConfidencial property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMsgConfidencial(String value) {
        this.msgConfidencial = value;
    }

}
