
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
 *         &lt;element name="coAfPaciente" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="coIafa" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="txFecha" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="imFoto" type="{http://www.w3.org/2001/XMLSchema}base64Binary"/>
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
    "coAfPaciente",
    "coIafa",
    "txFecha",
    "imFoto"
})
@XmlRootElement(name = "getFotoResponse")
public class GetFotoResponse {

    @XmlElement(required = true)
    protected String coError;
    @XmlElement(required = true)
    protected String coAfPaciente;
    @XmlElement(required = true)
    protected String coIafa;
    @XmlElement(required = true)
    protected String txFecha;
    @XmlElement(required = true)
    protected byte[] imFoto;

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
     * Gets the value of the coAfPaciente property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCoAfPaciente() {
        return coAfPaciente;
    }

    /**
     * Sets the value of the coAfPaciente property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCoAfPaciente(String value) {
        this.coAfPaciente = value;
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
     * Gets the value of the txFecha property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTxFecha() {
        return txFecha;
    }

    /**
     * Sets the value of the txFecha property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTxFecha(String value) {
        this.txFecha = value;
    }

    /**
     * Gets the value of the imFoto property.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getImFoto() {
        return imFoto;
    }

    /**
     * Sets the value of the imFoto property.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setImFoto(byte[] value) {
        this.imFoto = value;
    }

}
