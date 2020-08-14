package ocdhis2;

import java.io.File;
import java.io.StringWriter;
import java.util.ArrayList;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


/**
 * @author loic
 * 
 * See DHIS2 documentation : https://www.dhis2.org/doc/snapshot/en/developer/html/ch01s11.html
 * See DHIS2 corresponding API : https://www.dhis2.org/download/apidocs/org/hisp/dhis/dxf2/datavalueset/DataValueSet.html
 * 
 * Warning : DHIS2 API does not verify if the dataset really uses an attributeOptionCombo.  As long as the
 * attributeOptionCombo uid exists in the system, even if assigned to another dataset, it will accept the data.
 * 
 */


@XmlRootElement(name="dataValueSet")
public class DataValueSet
{
    private String orgUnit;                     // ex: "DiszpKrYNg8" (ex: corresponding to 'Hôpital ABC')
    private String period;                      // ex: "201201" (ex here: January 2012)
    private String completeDate;                // ex: "2015-09-28"
    private String attributeOptionCombo;        // ex: "D2CUIPUKpk3" (ex: corresponding to "médecine interne")
    private String dataSet;                     // ex: "DiszpKrYNg8" (ex: corresponding to 'notification des décès')
    

    private ArrayList<DataValue> dataValues = new ArrayList<>();
    
    @XmlAttribute(name="orgUnit")
    public String getOrgUnit()
    {
        return orgUnit;
    }

    public void setOrgUnit(String orgUnit)
    {
        this.orgUnit = orgUnit;
    }

    @XmlAttribute(name="period")
    public String getPeriod()
    {
        return period;
    }

    public void setPeriod(String period)
    {
        this.period = period;
    }

    @XmlAttribute(name="completeDate")
    public String getCompleteDate()
    {
        return completeDate;
    }

    public void setCompleteDate(String completeDate)
    {
        this.completeDate = completeDate;
    }

    @XmlAttribute(name="attributeOptionCombo")
    public String getAttributeOptionCombo()
    {
        return attributeOptionCombo;
    }

    public void setAttributeOptionCombo(String attributeOptionCombo)
    {
        this.attributeOptionCombo = attributeOptionCombo;
    }

    @XmlAttribute(name="dataSet")
    public String getDataSet()
    {
        return dataSet;
    }

    public void setDataSet(String dataSet)
    {
        this.dataSet = dataSet;
    }

    
    
    @XmlElement(name="dataValue")
    public ArrayList<DataValue> getDataValues()
    {
        return dataValues;
    }

    public void setDataValues(ArrayList<DataValue> dataValues)
    {
        this.dataValues = dataValues;
    }
    
    
    // Produces a file with the XML data, useful for offline data transmission.
    // This file can for example be stored on a USB key transferred to the DSNIS,
    // where it can be uploaded into the database using the DHIS2 import interface.
    // TODO : fix it so that the data is attached to the hospital user 
    //        (ex 'Hopital_XYZ_OpenClinic' user) and not the admin user who uploads it.
    // TODO : add path for the file
    // TODO : add values in the file name (and in comments) about who made it
    //        (so the SNIS doesn't have dozens of "simple.xml" files)
    // TODO : possibly put in its own object, with a name etc as members
    public void toXMLFile() throws JAXBException
    {
        JAXBContext jaxbContext = JAXBContext.newInstance(DataValueSet.class);
        Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
        jaxbMarshaller.marshal(this, new File("simple.xml") );
        jaxbMarshaller.marshal(this, System.out);
    }
    
 // Print the XML data to the console
    public void toXMLConsole() throws JAXBException
    {
        JAXBContext jaxbContext = JAXBContext.newInstance(DataValueSet.class);
        Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
        jaxbMarshaller.marshal(this, System.out);
    }
    
    // Produce a string with the XML content, by converting a stream to a string
    // see http://stackoverflow.com/questions/2472155/
    public String toXMLString() throws JAXBException
    {
        java.io.StringWriter stringWriter = new StringWriter();
        JAXBContext jaxbContext = JAXBContext.newInstance(DataValueSet.class);
        Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
        jaxbMarshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
        jaxbMarshaller.marshal(this,stringWriter);
        return stringWriter.toString();
    }
    
    @Override
    public String toString()
    {
        return "DataValueSet(" + dataValues + ")";    
    }
    
    
}
