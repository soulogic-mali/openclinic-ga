
package pe.gob.sis;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="intOpcion" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="strAutorizacion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strDni" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strTipoDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strNroDocumento" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strDisa" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strTipoFormato" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strNroContrato" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strCorrelativo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "intOpcion",
    "strAutorizacion",
    "strDni",
    "strTipoDocumento",
    "strNroDocumento",
    "strDisa",
    "strTipoFormato",
    "strNroContrato",
    "strCorrelativo"
})
@XmlRootElement(name = "ConsultarAfiliadoSIS")
public class ConsultarAfiliadoSIS {

    protected int intOpcion;
    protected String strAutorizacion;
    protected String strDni;
    protected String strTipoDocumento;
    protected String strNroDocumento;
    protected String strDisa;
    protected String strTipoFormato;
    protected String strNroContrato;
    protected String strCorrelativo;

    /**
     * Gets the value of the intOpcion property.
     * 
     */
    public int getIntOpcion() {
        return intOpcion;
    }

    /**
     * Sets the value of the intOpcion property.
     * 
     */
    public void setIntOpcion(int value) {
        this.intOpcion = value;
    }

    /**
     * Gets the value of the strAutorizacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrAutorizacion() {
        return strAutorizacion;
    }

    /**
     * Sets the value of the strAutorizacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrAutorizacion(String value) {
        this.strAutorizacion = value;
    }

    /**
     * Gets the value of the strDni property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrDni() {
        return strDni;
    }

    /**
     * Sets the value of the strDni property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrDni(String value) {
        this.strDni = value;
    }

    /**
     * Gets the value of the strTipoDocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrTipoDocumento() {
        return strTipoDocumento;
    }

    /**
     * Sets the value of the strTipoDocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrTipoDocumento(String value) {
        this.strTipoDocumento = value;
    }

    /**
     * Gets the value of the strNroDocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrNroDocumento() {
        return strNroDocumento;
    }

    /**
     * Sets the value of the strNroDocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrNroDocumento(String value) {
        this.strNroDocumento = value;
    }

    /**
     * Gets the value of the strDisa property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrDisa() {
        return strDisa;
    }

    /**
     * Sets the value of the strDisa property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrDisa(String value) {
        this.strDisa = value;
    }

    /**
     * Gets the value of the strTipoFormato property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrTipoFormato() {
        return strTipoFormato;
    }

    /**
     * Sets the value of the strTipoFormato property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrTipoFormato(String value) {
        this.strTipoFormato = value;
    }

    /**
     * Gets the value of the strNroContrato property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrNroContrato() {
        return strNroContrato;
    }

    /**
     * Sets the value of the strNroContrato property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrNroContrato(String value) {
        this.strNroContrato = value;
    }

    /**
     * Gets the value of the strCorrelativo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrCorrelativo() {
        return strCorrelativo;
    }

    /**
     * Sets the value of the strCorrelativo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrCorrelativo(String value) {
        this.strCorrelativo = value;
    }

}
