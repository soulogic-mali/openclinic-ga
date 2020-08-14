
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
 *         &lt;element name="coError" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="txNombre" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="coIafa" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="txRespuesta" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    "coError",
    "txNombre",
    "coIafa",
    "txRespuesta"
})
@XmlRootElement(name = "getConsultaSCTRResponse")
public class GetConsultaSCTRResponse {

    @XmlElement(required = true)
    protected String coError;
    @XmlElement(required = true)
    protected String txNombre;
    @XmlElement(required = true)
    protected String coIafa;
    @XmlElement(required = true)
    protected String txRespuesta;

    /**
     * Gets the value of the coError property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCoError() {
        return coError;
    }

    /**
     * Sets the value of the coError property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCoError(String value) {
        this.coError = value;
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
     * Gets the value of the txRespuesta property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTxRespuesta() {
        return txRespuesta;
    }

    /**
     * Sets the value of the txRespuesta property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTxRespuesta(String value) {
        this.txRespuesta = value;
    }

}
