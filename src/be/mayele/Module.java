package be.mayele;

import javax.servlet.http.HttpServletRequest;

import org.dom4j.Element;

public abstract class Module {
	public abstract void process(HttpServletRequest request, Element root);
}
