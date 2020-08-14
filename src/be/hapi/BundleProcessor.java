package be.hapi;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.Bundle.BundleEntryComponent;
import org.hl7.fhir.r4.model.Resource;

public class BundleProcessor {
	
	public static Vector extractResourcesFromBundle(Bundle bundle, String sResourceType) {
		Vector resources = new Vector();
		List<BundleEntryComponent> bundleResources = bundle.getEntry();
		Iterator<BundleEntryComponent> iBundleResources = bundleResources.iterator();
		while(iBundleResources.hasNext()){
			Resource resource = iBundleResources.next().getResource();
			if(resource.getResourceType().toString().equalsIgnoreCase(sResourceType)){
				resources.add(resource);
			}
		}
		return resources;
	}

}
