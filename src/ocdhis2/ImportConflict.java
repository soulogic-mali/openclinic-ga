package ocdhis2;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name="conflict")
public class ImportConflict
{
    private String object;
    private String value;
    
    public String getObject()
    {
        return object;
    }
    
    @XmlAttribute(name="object")
    public void setObject(String object)
    {
        this.object = object;
    }
    
    public String getValue()
    {
        return value;
    }
    
    @XmlAttribute(name="value")
    public void setValue(String value)
    {
        this.value = value;
    }
    
    @Override
    public String toString()
    {
        return "ImportConflict(object='" + object + "', " + 
                                "value='" + value + "')";
    }
    
}
