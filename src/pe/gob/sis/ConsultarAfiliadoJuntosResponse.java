
package pe.gob.sis;

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
 *         &lt;element name="ConsultarAfiliadoJuntosResult" type="{http://sis.gob.pe/}ResultQueryJuntos" minOccurs="0"/>
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
    "consultarAfiliadoJuntosResult"
})
@XmlRootElement(name = "ConsultarAfiliadoJuntosResponse")
public class ConsultarAfiliadoJuntosResponse {

    @XmlElement(name = "ConsultarAfiliadoJuntosResult")
    protected ResultQueryJuntos consultarAfiliadoJuntosResult;

    /**
     * Gets the value of the consultarAfiliadoJuntosResult property.
     * 
     * @return
     *     possible object is
     *     {@link ResultQueryJuntos }
     *     
     */
    public ResultQueryJuntos getConsultarAfiliadoJuntosResult() {
        return consultarAfiliadoJuntosResult;
    }

    /**
     * Sets the value of the consultarAfiliadoJuntosResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link ResultQueryJuntos }
     *     
     */
    public void setConsultarAfiliadoJuntosResult(ResultQueryJuntos value) {
        this.consultarAfiliadoJuntosResult = value;
    }

}
