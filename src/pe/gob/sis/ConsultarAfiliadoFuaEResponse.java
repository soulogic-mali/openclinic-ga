
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
 *         &lt;element name="ConsultarAfiliadoFuaEResult" type="{http://sis.gob.pe/}ResultQueryAsegurado" minOccurs="0"/>
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
    "consultarAfiliadoFuaEResult"
})
@XmlRootElement(name = "ConsultarAfiliadoFuaEResponse")
public class ConsultarAfiliadoFuaEResponse {

    @XmlElement(name = "ConsultarAfiliadoFuaEResult")
    protected ResultQueryAsegurado consultarAfiliadoFuaEResult;

    /**
     * Gets the value of the consultarAfiliadoFuaEResult property.
     * 
     * @return
     *     possible object is
     *     {@link ResultQueryAsegurado }
     *     
     */
    public ResultQueryAsegurado getConsultarAfiliadoFuaEResult() {
        return consultarAfiliadoFuaEResult;
    }

    /**
     * Sets the value of the consultarAfiliadoFuaEResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link ResultQueryAsegurado }
     *     
     */
    public void setConsultarAfiliadoFuaEResult(ResultQueryAsegurado value) {
        this.consultarAfiliadoFuaEResult = value;
    }

}
