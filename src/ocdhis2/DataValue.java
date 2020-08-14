/**
 * 
 */
package ocdhis2;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;


;

/**
 * @author loic
 * 
 * Used to contain information about one data element
 * For an introduction to the concept, see https://www.dhis2.org/doc/snapshot/en/user/html/ch02s05.html#d5e331
 * For the corresponding DHIS2 API doc, see https://www.dhis2.org/download/apidocs/org/hisp/dhis/datavalue/DataValue.html
 * For valid date format, see https://www.dhis2.org/doc/snapshot/en/user/html/ch30s03.html
 * 
 */

@XmlRootElement(name="dataValue")
public class DataValue
{
    private String dataElement;                 // ex: "Ix2HsbDMLea" (ex: corresponding to 'malaria cases')
    private String categoryOptionCombo;         // ex: "bRowv6yZOF2" (ex: corresponding to '10-15 years, Female')
    private String value;                       // ex: "12" (ex here: 12 cases were counted)
    private String comment;

    // A default constructor is required by JAXB for deserialization purposes
    public DataValue() {}
    
    // constructor with comment
    public DataValue(String dataElement, String categoryOptionCombo, String value, String comment)
    {
        super();
        this.dataElement = dataElement;
        this.categoryOptionCombo = categoryOptionCombo;
        this.value = value;
        this.comment = comment;
    }
    
    
    @XmlAttribute(name="dataElement")
    public String getDataElementID()
    {
        return dataElement;
    }
    
    public void setDataElementID(String dataElementID)
    {
        this.dataElement = dataElementID;
    }
    
    @XmlAttribute(name = "categoryOptionCombo")
    public String getCategoryOptionComboID()
    {
        return categoryOptionCombo;
    }
    
    public void setCategoryOptionComboID(String categoryOptionCombo)
    {
        this.categoryOptionCombo = categoryOptionCombo;
    }
    
    @XmlAttribute(name="value")
    public String getValue()
    {
        return value;
    }
    
    public void setValue(String value)
    {
        this.value = value;
    }

    @XmlAttribute(name="comment")
    public String getComment()
    {
        return comment;
    }

    public void setComment(String comment)
    {
        this.comment = comment;
    }

    @Override
    public String toString()
    {
        return "DataValue(dataElement='" + dataElement + "', " +
                         "categoryOptionCombo='" + categoryOptionCombo + "', " +
                         "value='" + value + "', " +
                         "comment='" + comment + "')";
    }
     
}

