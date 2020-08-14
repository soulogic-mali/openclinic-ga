
package pe.gob.susalud;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
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
 *         &lt;element name="coExcepcion" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="txNombre" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="coIafa" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="txPeticion" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    "coExcepcion",
    "txNombre",
    "coIafa",
    "txPeticion"
})
@XmlRootElement(name = "getConsultaAsegNomRequest")
public class GetConsultaAsegNomRequest {

    @XmlElement(required = true)
    protected String coExcepcion;
    @XmlElement(required = true)
    protected String txNombre;
    @XmlElement(required = true)
    protected String coIafa;
    @XmlElement(required = true)
    protected String txPeticion;

    /**
     * Gets the value of the coExcepcion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCoExcepcion() {
        return coExcepcion;
    }

    /**
     * Sets the value of the coExcepcion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCoExcepcion(String value) {
        this.coExcepcion = value;
    }

    /**
     * Gets the value of the txNombre property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTxNombre() {
        return txNombre;
    }

    /**
     * Sets the value of the txNombre property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTxNombre(String value) {
        this.txNombre = value;
    }

    /**
     * Gets the value of the coIafa property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCoIafa() {
        return coIafa;
    }

    /**
     * Sets the value of the coIafa property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCoIafa(String value) {
        this.coIafa = value;
    }

    /**
     * Gets the value of the txPeticion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTxPeticion() {
        return txPeticion;
    }

    /**
     * Sets the value of the txPeticion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTxPeticion(String value) {
        this.txPeticion = value;
    }

}
