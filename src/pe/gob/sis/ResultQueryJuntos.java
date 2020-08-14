
package pe.gob.sis;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ResultQueryJuntos complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ResultQueryJuntos">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="IdError" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Resultado" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Contrato" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Disa" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoFormato" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Numero" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Correlativo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="IdEESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="CategoriaEESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="NroDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="ApellidoPaterno" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="ApellidoMaterno" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Nombres" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FechaNacimiento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Genero" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="UbigeoEESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Ubigeo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoDocumentoMadre" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="NroDocumentoMadre" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FechaAfiliacion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="IdTipoSeguro" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TipoSeguro" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="NacidoVivo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ResultQueryJuntos", propOrder = {
    "idError",
    "resultado",
    "contrato",
    "disa",
    "tipoFormato",
    "numero",
    "correlativo",
    "idEESS",
    "categoriaEESS",
    "tipoDocumento",
    "nroDocumento",
    "apellidoPaterno",
    "apellidoMaterno",
    "nombres",
    "fechaNacimiento",
    "genero",
    "ubigeoEESS",
    "ubigeo",
    "tipoDocumentoMadre",
    "nroDocumentoMadre",
    "fechaAfiliacion",
    "idTipoSeguro",
    "tipoSeguro",
    "nacidoVivo"
})
public class ResultQueryJuntos {

    @XmlElement(name = "IdError")
    protected String idError;
    @XmlElement(name = "Resultado")
    protected String resultado;
    @XmlElement(name = "Contrato")
    protected String contrato;
    @XmlElement(name = "Disa")
    protected String disa;
    @XmlElement(name = "TipoFormato")
    protected String tipoFormato;
    @XmlElement(name = "Numero")
    protected String numero;
    @XmlElement(name = "Correlativo")
    protected String correlativo;
    @XmlElement(name = "IdEESS")
    protected String idEESS;
    @XmlElement(name = "CategoriaEESS")
    protected String categoriaEESS;
    @XmlElement(name = "TipoDocumento")
    protected String tipoDocumento;
    @XmlElement(name = "NroDocumento")
    protected String nroDocumento;
    @XmlElement(name = "ApellidoPaterno")
    protected String apellidoPaterno;
    @XmlElement(name = "ApellidoMaterno")
    protected String apellidoMaterno;
    @XmlElement(name = "Nombres")
    protected String nombres;
    @XmlElement(name = "FechaNacimiento")
    protected String fechaNacimiento;
    @XmlElement(name = "Genero")
    protected String genero;
    @XmlElement(name = "UbigeoEESS")
    protected String ubigeoEESS;
    @XmlElement(name = "Ubigeo")
    protected String ubigeo;
    @XmlElement(name = "TipoDocumentoMadre")
    protected String tipoDocumentoMadre;
    @XmlElement(name = "NroDocumentoMadre")
    protected String nroDocumentoMadre;
    @XmlElement(name = "FechaAfiliacion")
    protected String fechaAfiliacion;
    @XmlElement(name = "IdTipoSeguro")
    protected String idTipoSeguro;
    @XmlElement(name = "TipoSeguro")
    protected String tipoSeguro;
    @XmlElement(name = "NacidoVivo")
    protected String nacidoVivo;

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
     * Gets the value of the disa property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDisa() {
        return disa;
    }

    /**
     * Sets the value of the disa property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDisa(String value) {
        this.disa = value;
    }

    /**
     * Gets the value of the tipoFormato property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTipoFormato() {
        return tipoFormato;
    }

    /**
     * Sets the value of the tipoFormato property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTipoFormato(String value) {
        this.tipoFormato = value;
    }

    /**
     * Gets the value of the numero property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNumero() {
        return numero;
    }

    /**
     * Sets the value of the numero property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNumero(String value) {
        this.numero = value;
    }

    /**
     * Gets the value of the correlativo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCorrelativo() {
        return correlativo;
    }

    /**
     * Sets the value of the correlativo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCorrelativo(String value) {
        this.correlativo = value;
    }

    /**
     * Gets the value of the idEESS property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdEESS() {
        return idEESS;
    }

    /**
     * Sets the value of the idEESS property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdEESS(String value) {
        this.idEESS = value;
    }

    /**
     * Gets the value of the categoriaEESS property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCategoriaEESS() {
        return categoriaEESS;
    }

    /**
     * Sets the value of the categoriaEESS property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCategoriaEESS(String value) {
        this.categoriaEESS = value;
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
     * Gets the value of the apellidoPaterno property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    /**
     * Sets the value of the apellidoPaterno property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setApellidoPaterno(String value) {
        this.apellidoPaterno = value;
    }

    /**
     * Gets the value of the apellidoMaterno property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    /**
     * Sets the value of the apellidoMaterno property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setApellidoMaterno(String value) {
        this.apellidoMaterno = value;
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
     * Gets the value of the fechaNacimiento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    /**
     * Sets the value of the fechaNacimiento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFechaNacimiento(String value) {
        this.fechaNacimiento = value;
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
     * Gets the value of the ubigeoEESS property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUbigeoEESS() {
        return ubigeoEESS;
    }

    /**
     * Sets the value of the ubigeoEESS property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUbigeoEESS(String value) {
        this.ubigeoEESS = value;
    }

    /**
     * Gets the value of the ubigeo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUbigeo() {
        return ubigeo;
    }

    /**
     * Sets the value of the ubigeo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUbigeo(String value) {
        this.ubigeo = value;
    }

    /**
     * Gets the value of the tipoDocumentoMadre property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTipoDocumentoMadre() {
        return tipoDocumentoMadre;
    }

    /**
     * Sets the value of the tipoDocumentoMadre property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTipoDocumentoMadre(String value) {
        this.tipoDocumentoMadre = value;
    }

    /**
     * Gets the value of the nroDocumentoMadre property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNroDocumentoMadre() {
        return nroDocumentoMadre;
    }

    /**
     * Sets the value of the nroDocumentoMadre property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNroDocumentoMadre(String value) {
        this.nroDocumentoMadre = value;
    }

    /**
     * Gets the value of the fechaAfiliacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFechaAfiliacion() {
        return fechaAfiliacion;
    }

    /**
     * Sets the value of the fechaAfiliacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFechaAfiliacion(String value) {
        this.fechaAfiliacion = value;
    }

    /**
     * Gets the value of the idTipoSeguro property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdTipoSeguro() {
        return idTipoSeguro;
    }

    /**
     * Sets the value of the idTipoSeguro property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdTipoSeguro(String value) {
        this.idTipoSeguro = value;
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
     * Gets the value of the nacidoVivo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNacidoVivo() {
        return nacidoVivo;
    }

    /**
     * Sets the value of the nacidoVivo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNacidoVivo(String value) {
        this.nacidoVivo = value;
    }

}
