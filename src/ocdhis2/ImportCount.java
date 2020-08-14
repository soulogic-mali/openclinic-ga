package ocdhis2;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="count")
public class ImportCount
{

    private int imported;
    private int updated;
    private int ignored;
    private int deleted;
    
    public int getImported()
    {
        return imported;
    }
    
    @XmlAttribute(name = "imported")
    public void setImported(int imported)
    {
        this.imported = imported;
    }
    
    public int getUpdated()
    {
        return updated;
    }
    
    @XmlAttribute(name = "updated")
    public void setUpdated(int updated)
    {
        this.updated = updated;
    }
    
    public int getIgnored()
    {
        return ignored;
    }
    
    @XmlAttribute(name = "ignored")
    public void setIgnored(int ignored)
    {
        this.ignored = ignored;
    }
    
    public int getDeleted()
    {
        return deleted;
    }
    
    @XmlAttribute(name = "deleted")
    public void setDeleted(int deleted)
    {
        this.deleted = deleted;
    }
    
    @Override
    public String toString()
    {
        return "importCount(imported=" + imported + ", " + 
                            "updated=" + updated + ", " +
                            "ignored=" + ignored + ", " +
                            "deleted=" + deleted + ")";
    }
    
}
