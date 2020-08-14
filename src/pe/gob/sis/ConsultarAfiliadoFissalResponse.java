
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
 *         &lt;element name="ConsultarAfiliadoFissalResult" type="{http://sis.gob.pe/}ResultQueryAseguradoFISSAL" minOccurs="0"/>
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
    "consultarAfiliadoFissalResult"
})
@XmlRootElement(name = "ConsultarAfiliadoFissalResponse")
public class ConsultarAfiliadoFissalResponse {

    @XmlElement(name = "ConsultarAfiliadoFissalResult")
    protected ResultQueryAseguradoFISSAL consultarAfiliadoFissalResult;

    /**
     * Gets the value of the consultarAfiliadoFissalResult property.
     * 
     * @return
     *     possible object is
     *     {@link ResultQueryAseguradoFISSAL }
     *     
     */
    public ResultQueryAseguradoFISSAL getConsultarAfiliadoFissalResult() {
        return consultarAfiliadoFissalResult;
    }

    /**
     * Sets the value of the consultarAfiliadoFissalResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link ResultQueryAseguradoFISSAL }
     *     
     */
    public void setConsultarAfiliadoFissalResult(ResultQueryAseguradoFISSAL value) {
        this.consultarAfiliadoFissalResult = value;
    }

}
