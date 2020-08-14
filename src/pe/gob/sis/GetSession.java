
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
 *         &lt;element name="strUsuario" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="strClave" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
    "strUsuario",
    "strClave"
})
@XmlRootElement(name = "GetSession")
public class GetSession {

    protected String strUsuario;
    protected String strClave;

    /**
     * Gets the value of the strUsuario property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrUsuario() {
        return strUsuario;
    }

    /**
     * Sets the value of the strUsuario property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrUsuario(String value) {
        this.strUsuario = value;
    }

    /**
     * Gets the value of the strClave property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrClave() {
        return strClave;
    }

    /**
     * Sets the value of the strClave property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrClave(String value) {
        this.strClave = value;
    }

}
