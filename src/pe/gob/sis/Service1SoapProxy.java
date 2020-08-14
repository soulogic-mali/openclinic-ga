package pe.gob.sis;

public class Service1SoapProxy implements pe.gob.sis.Service1Soap {
  private String _endpoint = null;
  private pe.gob.sis.Service1Soap service1Soap = null;
  
  public Service1SoapProxy() {
    _initService1SoapProxy();
  }
  
  public Service1SoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initService1SoapProxy();
  }
  
  private void _initService1SoapProxy() {
      service1Soap = new pe.gob.sis.Service1().getService1Soap();
      if (service1Soap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)service1Soap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)service1Soap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (service1Soap != null)
      ((javax.xml.rpc.Stub)service1Soap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public pe.gob.sis.Service1Soap getService1Soap() {
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap;
  }
  
  public java.lang.String getSession(java.lang.String strUsuario, java.lang.String strClave){
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.getSession(strUsuario, strClave);
  }
  
  public pe.gob.sis.ResultQueryAsegurado consultarAfiliadoSIS(int intOpcion, java.lang.String strAutorizacion, java.lang.String strDni, java.lang.String strTipoDocumento, java.lang.String strNroDocumento, java.lang.String strDisa, java.lang.String strTipoFormato, java.lang.String strNroContrato, java.lang.String strCorrelativo){
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.consultarAfiliadoSIS(intOpcion, strAutorizacion, strDni, strTipoDocumento, strNroDocumento, strDisa, strTipoFormato, strNroContrato, strCorrelativo);
  }
  
  public pe.gob.sis.ResultQueryJuntos consultarAfiliadoJuntos(int intOpcion, java.lang.String strAutorizacion, java.lang.String strDni, java.lang.String strTipoDocumento, java.lang.String strNroDocumento, java.lang.String strDisa, java.lang.String strTipoFormato, java.lang.String strNroContrato, java.lang.String strCorrelativo){
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.consultarAfiliadoJuntos(intOpcion, strAutorizacion, strDni, strTipoDocumento, strNroDocumento, strDisa, strTipoFormato, strNroContrato, strCorrelativo);
  }
  
  public pe.gob.sis.ResultQueryAsegurado consultarAfiliadoFuaE(int intOpcion, java.lang.String strAutorizacion, java.lang.String strDni, java.lang.String strTipoDocumento, java.lang.String strNroDocumento, java.lang.String strDisa, java.lang.String strTipoFormato, java.lang.String strNroContrato, java.lang.String strCorrelativo){
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.consultarAfiliadoFuaE(intOpcion, strAutorizacion, strDni, strTipoDocumento, strNroDocumento, strDisa, strTipoFormato, strNroContrato, strCorrelativo);
  }
  
  public pe.gob.sis.ResultQueryAseguradoFISSAL consultarAfiliadoFissal(int intOpcion, java.lang.String strAutorizacion, java.lang.String strDni, java.lang.String strTipoDocumento, java.lang.String strNroDocumento, java.lang.String strDisa, java.lang.String strTipoFormato, java.lang.String strNroContrato, java.lang.String strCorrelativo){
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.consultarAfiliadoFissal(intOpcion, strAutorizacion, strDni, strTipoDocumento, strNroDocumento, strDisa, strTipoFormato, strNroContrato, strCorrelativo);
  }
  
  
}