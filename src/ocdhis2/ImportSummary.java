package ocdhis2;


import java.util.ArrayList;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;


/**
 * Holds the answer received from DHIS2 after sending data.
 * 
 * See package org.hisp.dhis.dxf2.importsummary in DHIS2 Code for a precise
 * definition, which is not available in the published documentation.
 */


@XmlRootElement(name="importSummary")
public class ImportSummary
{

    private String status;
    private String description;
    private ImportCount importCount = new ImportCount();
    private ImportDataValueCount dataValueCount = new ImportDataValueCount();
    private ArrayList<ImportConflict> conflicts = new ArrayList<>();
    private String dataSetComplete;
    private String reference;
    private String href;
    
    public String getStatus()
    {
        return status;
    }
    
    @XmlElement(name="status")
    public void setStatus(String status)
    {
        this.status = status;
    }
    
    public String getDescription()
    {
        return description;
    }
    
    @XmlElement(name="description")
    public void setDescription(String description)
    {
        this.description = description;
    }
    
    public ImportCount getImportCount()
    {
        return importCount;
    }
    
    @XmlElement(name="importCount", type = ImportCount.class)
    public void setImportCount(ImportCount importCount)
    {
        this.importCount = importCount;
    }
    
    public ImportDataValueCount getDataValueCount()
    {
        return dataValueCount;
    }
    
    @XmlElement(name="dataValueCount", type = ImportDataValueCount.class)
    public void setDataValueCount(ImportDataValueCount dataValueCount)
    {
        this.dataValueCount = dataValueCount;
    }
    
    public ArrayList<ImportConflict> getConflicts()
    {
        return conflicts;
    }
    
    @XmlElementWrapper(name = "conflicts")
    @XmlElement(name="conflict", type = ImportConflict.class)
    public void setConflicts(ArrayList<ImportConflict> conflicts)
    {
        this.conflicts = conflicts;
    }
    
    public String getDataSetComplete()
    {
        return dataSetComplete;
    }
    
    @XmlElement(name="dataSetComplete")
    public void setDataSetComplete(String dataSetComplete)
    {
        this.dataSetComplete = dataSetComplete;
    }
    
    public String getReference()
    {
        return reference;
    }
    
    @XmlElement(name="reference")
    public void setReference(String reference)
    {
        this.reference = reference;
    }
    
    public String getHref()
    {
        return href;
    }
    
    @XmlElement(name="href")
    public void setHref(String href)
    {
        this.href = href;
    }
    
    @Override
    public String toString()
    {
        return "ImportSummary(status='" + status + "', " +
                            "description='" + description + "', " +
                            importCount + ", " +
                            dataValueCount + ", " +
                            "conflicts=" + conflicts + ", " +
                            "dataSetComplete='" + dataSetComplete + "', " +
                            "reference='" + reference + "', " +
                            "href='" + href + ")";    
    }
    
}

