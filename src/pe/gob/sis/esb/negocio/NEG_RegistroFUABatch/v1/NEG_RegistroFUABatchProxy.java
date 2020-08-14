package pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1;

public class NEG_RegistroFUABatchProxy implements pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch {
  private String _endpoint = null;
  private pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch nEG_RegistroFUABatch = null;
  
  public NEG_RegistroFUABatchProxy() {
    _initNEG_RegistroFUABatchProxy();
  }
  
  public NEG_RegistroFUABatchProxy(String endpoint) {
    _endpoint = endpoint;
    _initNEG_RegistroFUABatchProxy();
  }
  
  private void _initNEG_RegistroFUABatchProxy() {
    try {
      nEG_RegistroFUABatch = (new pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch_v1Locator()).getNEG_RegistroFUABatchSOAP11Binding();
      if (nEG_RegistroFUABatch != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)nEG_RegistroFUABatch)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)nEG_RegistroFUABatch)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (nEG_RegistroFUABatch != null)
      ((javax.xml.rpc.Stub)nEG_RegistroFUABatch)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public pe.gob.sis.esb.negocio.NEG_RegistroFUABatch.v1.NEG_RegistroFUABatch getNEG_RegistroFUABatch() {
    if (nEG_RegistroFUABatch == null)
      _initNEG_RegistroFUABatchProxy();
    return nEG_RegistroFUABatch;
  }
  
  public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUAResponseType registrarFUA(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUA.v1.RegistrarFUARequestType registrarFUARequest) throws java.rmi.RemoteException{
    if (nEG_RegistroFUABatch == null)
      _initNEG_RegistroFUABatchProxy();
    return nEG_RegistroFUABatch.registrarFUA(registrarFUARequest);
  }
  
  public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatResponseType registrarFUACompat(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.registrarFUACompat.v1.RegistrarFUACompatRequestType registrarFUACompatRequest) throws java.rmi.RemoteException{
    if (nEG_RegistroFUABatch == null)
      _initNEG_RegistroFUABatchProxy();
    return nEG_RegistroFUABatch.registrarFUACompat(registrarFUACompatRequest);
  }
  
  public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUAResponseType getResultadoFUA(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUA.v1.GetResultadoFUARequestType getResultadoFUARequest) throws java.rmi.RemoteException{
    if (nEG_RegistroFUABatch == null)
      _initNEG_RegistroFUABatchProxy();
    return nEG_RegistroFUABatch.getResultadoFUA(getResultadoFUARequest);
  }
  
  public pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatResponseType getResultadoFUACompat(pe.gob.sis.esb.negocio.messages.NEG_RegistroFUABatch.getResultadoFUACompat.v1.GetResultadoFUACompatRequestType getResultadoFUACompatRequest) throws java.rmi.RemoteException{
    if (nEG_RegistroFUABatch == null)
      _initNEG_RegistroFUABatchProxy();
    return nEG_RegistroFUABatch.getResultadoFUACompat(getResultadoFUACompatRequest);
  }
  
  
}