package ocdhis2;

import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.security.NoSuchAlgorithmException;

import javax.ws.rs.core.Response;
import javax.xml.bind.JAXBException;

import org.glassfish.jersey.message.internal.MessageBodyProviderNotFoundException;

/*
 * HelloWorld to demonstrate the use of the library.
 * 
 * For the DHIS2 API documentation, see 
 * https://www.dhis2.org/doc/snapshot/en/developer/html/dhis2_developer_manual_full.html#d5173e30
 * 
 * Marshalling and unmarshalling is done through annotations inside classes, using 
 * Java Architecture for XML Binding (JAXB), rather than through explicit transformations
 * of XML to objects or objects to XML.  See the use of '@XmlAttribute(name="dataElement")'
 * in the DataValue class for example, which becomes 'dataElement="EF3XigZnKTj"' in the 
 * <dataValue> XML node.
 * 
 * Handling the REST service is done through Jersey: https://jersey.java.net/
 * 
 */

// TODO : decide on the way to handle exceptions within OC
// TODO : add a function to verify the version of the DHIS2 server.  The API works with version 17
//        to 19 and will normally work with 20, but API modifications are planned for version 21.
//        The latest DHIS2 release is 19 and the DSNIS Burundi uses version 18.

public class HelloWorldHTTPS
{

    // TODO : use URI objects instead of String for the URI
    
    /** Oslo DHIS2 Demo server: 
    private static final String DHIS2_SERVER_URI        = "https://apps.dhis2.org";     // server address
    private static final String DHIS2_SERVER_BASE_API   = "/demo/api";                  // api suffix
    private static final String DHIS2_SERVER_PORT       = "443";                        // port (443 is usually SSL)
    private static final String ORGUNIT_ID              = "ueuQlqb8ccl";                // test orgunit on Oslo's database
    private static final String OC_DHIS2_USER_NAME      = "admin";
    private static final String OC_DHIS2_USER_PWD       = "district";
    **/
    
    /** BURUNDI 
    private static final String DHIS2_SERVER_URI        = "https://dhis.snis.bi";
    private static final String DHIS2_SERVER_BASE_API   = "/api";
    private static final String DHIS2_SERVER_PORT       = "443";
    private static final String ORGUNIT_ID              = "noop";
    // on the DHIS2 server, a user should be created for the OC instance of a specific hospital
    // for example with the name "OC_Prince_Regent"
    private static final String OC_DHIS2_USER_NAME      = "";
    private static final String OC_DHIS2_USER_PWD       = "";
    **/
    
    /** BURUNDI demo server **/
    private static final String DHIS2_SERVER_URI        = "https://192.168.1.8";        // server address
    private static final String DHIS2_SERVER_BASE_API   = "/hopitalprod/api";           // api suffix
    private static final String DHIS2_SERVER_PORT       = "443";                        // port (443 is usually SSL)
    private static final String ORGUNIT_ID              = "yjN7n5M9Hph";                // test orgunit on Oslo's database
    private static final String OC_DHIS2_USER_NAME      = "lvaes";
    private static final String OC_DHIS2_USER_PWD       = "LVaes2015";
    
    /** LOCAL
    private static final String DHIS2_SERVER_URI        = "http://192.168.0.71";
    private static final String DHIS2_SERVER_BASE_API   = "/api";
    private static final String DHIS2_SERVER_PORT       = "8080";
    private static final String ORGUNIT_ID              = "A3u6arsTDmT";
    private static final String OC_DHIS2_USER_NAME      = "admin";
    private static final String OC_DHIS2_USER_PWD       = "district";
     * @throws UnknownHostException 
    **/
    
    
    public static void main(String[] args) throws JAXBException, SocketTimeoutException, NoSuchAlgorithmException, MessageBodyProviderNotFoundException
    {
        
        System.out.println("Starting demo\n");
        
        // prepare and populate a dataValueSet : a set of values that will be sent during one transaction
        // (not the same thing as a 'dataset', which are semantically related data in the DHIS2 data model)
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet("zmCc5BPQjPp");
        dataValueSet.setOrgUnit(ORGUNIT_ID);
        dataValueSet.setPeriod("201507");
        dataValueSet.setCompleteDate("2015-09-28");
        dataValueSet.setAttributeOptionCombo("");
        
        
        // adding a DataValue with arguments: dataElement, categoryOptionCombo, value, comment
        // There needs to be a translation process to query the information from OC and match it 
        // to the proper DHIS2 UIDs, which are different for each instance of DHIS2
        // Example values for the DHIS2 demo server :
        dataValueSet.getDataValues().add(new DataValue("h9EytkY6M2z","YvCUIPUKLle","123",""));
        //dataValueSet.getDataValues().add(new DataValue("M05bXYBMpU0","hdW79u4HG4n","234",""));
        
        
        System.out.println("Message being sent:");
        dataValueSet.toXMLConsole();                             // example of outputs: print the content to the console
        System.out.println("\n");
        // dataValueSet.toXMLFile();                             // print the content to a local file
        // System.out.println(dataValueSet.toXMLString());       // print the content into a string
               
        
        // create a DHIS2Server and configure it
        DHIS2Server server = new DHIS2Server(DHIS2_SERVER_URI, DHIS2_SERVER_BASE_API, DHIS2_SERVER_PORT);
        server.setUserName(OC_DHIS2_USER_NAME);
        server.setUserPassword(OC_DHIS2_USER_PWD);
        
        try {
            Response postResponse = server.sendToServer(dataValueSet);
            System.out.println("Status: " + postResponse.getStatus());
            System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
            
            if(postResponse.hasEntity())
            {
                ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
                // elements of importSummary can also be read individually, and put on a feedback page for example
                // a feedback should be given especially if conflicts are reported
                System.out.println("Import summary: ");
                System.out.println(importSummary);
            }
            
        }
        catch (SocketTimeoutException e)
        {
            e.printStackTrace();
        }
      
    }
    
}
