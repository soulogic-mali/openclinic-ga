/**
 * EAfiliadoSIASIS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package pe.gob.sis;

public class EAfiliadoSIASIS  implements java.io.Serializable {
    private java.lang.String idError;

    private java.lang.String resultado;

    private java.lang.String msgConfidencial;

    private java.lang.String tabla;

    private java.lang.String idNumReg;

    private java.lang.String contrato;

    private java.lang.String tipoDocumento;

    private java.lang.String nroDocumento;

    private java.lang.String disa;

    private java.lang.String tipoFormato;

    private java.lang.String nroContrato;

    private java.lang.String correlativo;

    private java.lang.String idSituacion;

    private java.lang.String idComponente;

    private java.lang.String idRegimen;

    private java.lang.String idTipoSeguro;

    private java.lang.String apePaterno;

    private java.lang.String apeMaterno;

    private java.lang.String priNombre;

    private java.lang.String segNombre;

    private java.lang.String idGenero;

    private java.lang.String fecNacimiento;

    private java.lang.String direccion;

    private java.lang.String edad;

    private java.lang.String idPersona;

    private java.lang.String autogenerado;

    private java.lang.String afiUbigeo;

    private java.lang.String idEESS;

    private java.lang.String EESSUbigeo;

    private java.lang.String idGrupoPoblacional;

    private java.lang.String fecCrea;

    private java.lang.String userCrea;

    private java.lang.String fecAfiliacion;

    private java.lang.String fecBaja;

    private java.lang.String estado;

    private java.lang.String fecFinCobertura;

    private java.lang.String fecFallecimiento;

    private java.lang.String idZonaAUS;

    private java.lang.String idPlanCobertura;

    private java.lang.String idMotivoBaja;

    private java.lang.String userBaja;

    private java.lang.String disaFESE;

    private java.lang.String loteFESE;

    private java.lang.String numeroFESE;

    private java.lang.String benSepTipoDoc;

    private java.lang.String benSepDocumento;

    private java.lang.String benSepApePaterno;

    private java.lang.String benSepApeMaterno;

    private java.lang.String benSepPriNombre;

    private java.lang.String benSepSegNombre;

    private java.lang.String reniecValida;

    private java.lang.String descTipoSeguro;

    public EAfiliadoSIASIS() {
    }

    public EAfiliadoSIASIS(
           java.lang.String idError,
           java.lang.String resultado,
           java.lang.String msgConfidencial,
           java.lang.String tabla,
           java.lang.String idNumReg,
           java.lang.String contrato,
           java.lang.String tipoDocumento,
           java.lang.String nroDocumento,
           java.lang.String disa,
           java.lang.String tipoFormato,
           java.lang.String nroContrato,
           java.lang.String correlativo,
           java.lang.String idSituacion,
           java.lang.String idComponente,
           java.lang.String idRegimen,
           java.lang.String idTipoSeguro,
           java.lang.String apePaterno,
           java.lang.String apeMaterno,
           java.lang.String priNombre,
           java.lang.String segNombre,
           java.lang.String idGenero,
           java.lang.String fecNacimiento,
           java.lang.String direccion,
           java.lang.String edad,
           java.lang.String idPersona,
           java.lang.String autogenerado,
           java.lang.String afiUbigeo,
           java.lang.String idEESS,
           java.lang.String EESSUbigeo,
           java.lang.String idGrupoPoblacional,
           java.lang.String fecCrea,
           java.lang.String userCrea,
           java.lang.String fecAfiliacion,
           java.lang.String fecBaja,
           java.lang.String estado,
           java.lang.String fecFinCobertura,
           java.lang.String fecFallecimiento,
           java.lang.String idZonaAUS,
           java.lang.String idPlanCobertura,
           java.lang.String idMotivoBaja,
           java.lang.String userBaja,
           java.lang.String disaFESE,
           java.lang.String loteFESE,
           java.lang.String numeroFESE,
           java.lang.String benSepTipoDoc,
           java.lang.String benSepDocumento,
           java.lang.String benSepApePaterno,
           java.lang.String benSepApeMaterno,
           java.lang.String benSepPriNombre,
           java.lang.String benSepSegNombre,
           java.lang.String reniecValida,
           java.lang.String descTipoSeguro) {
           this.idError = idError;
           this.resultado = resultado;
           this.msgConfidencial = msgConfidencial;
           this.tabla = tabla;
           this.idNumReg = idNumReg;
           this.contrato = contrato;
           this.tipoDocumento = tipoDocumento;
           this.nroDocumento = nroDocumento;
           this.disa = disa;
           this.tipoFormato = tipoFormato;
           this.nroContrato = nroContrato;
           this.correlativo = correlativo;
           this.idSituacion = idSituacion;
           this.idComponente = idComponente;
           this.idRegimen = idRegimen;
           this.idTipoSeguro = idTipoSeguro;
           this.apePaterno = apePaterno;
           this.apeMaterno = apeMaterno;
           this.priNombre = priNombre;
           this.segNombre = segNombre;
           this.idGenero = idGenero;
           this.fecNacimiento = fecNacimiento;
           this.direccion = direccion;
           this.edad = edad;
           this.idPersona = idPersona;
           this.autogenerado = autogenerado;
           this.afiUbigeo = afiUbigeo;
           this.idEESS = idEESS;
           this.EESSUbigeo = EESSUbigeo;
           this.idGrupoPoblacional = idGrupoPoblacional;
           this.fecCrea = fecCrea;
           this.userCrea = userCrea;
           this.fecAfiliacion = fecAfiliacion;
           this.fecBaja = fecBaja;
           this.estado = estado;
           this.fecFinCobertura = fecFinCobertura;
           this.fecFallecimiento = fecFallecimiento;
           this.idZonaAUS = idZonaAUS;
           this.idPlanCobertura = idPlanCobertura;
           this.idMotivoBaja = idMotivoBaja;
           this.userBaja = userBaja;
           this.disaFESE = disaFESE;
           this.loteFESE = loteFESE;
           this.numeroFESE = numeroFESE;
           this.benSepTipoDoc = benSepTipoDoc;
           this.benSepDocumento = benSepDocumento;
           this.benSepApePaterno = benSepApePaterno;
           this.benSepApeMaterno = benSepApeMaterno;
           this.benSepPriNombre = benSepPriNombre;
           this.benSepSegNombre = benSepSegNombre;
           this.reniecValida = reniecValida;
           this.descTipoSeguro = descTipoSeguro;
    }


    /**
     * Gets the idError value for this EAfiliadoSIASIS.
     * 
     * @return idError
     */
    public java.lang.String getIdError() {
        return idError;
    }


    /**
     * Sets the idError value for this EAfiliadoSIASIS.
     * 
     * @param idError
     */
    public void setIdError(java.lang.String idError) {
        this.idError = idError;
    }


    /**
     * Gets the resultado value for this EAfiliadoSIASIS.
     * 
     * @return resultado
     */
    public java.lang.String getResultado() {
        return resultado;
    }


    /**
     * Sets the resultado value for this EAfiliadoSIASIS.
     * 
     * @param resultado
     */
    public void setResultado(java.lang.String resultado) {
        this.resultado = resultado;
    }


    /**
     * Gets the msgConfidencial value for this EAfiliadoSIASIS.
     * 
     * @return msgConfidencial
     */
    public java.lang.String getMsgConfidencial() {
        return msgConfidencial;
    }


    /**
     * Sets the msgConfidencial value for this EAfiliadoSIASIS.
     * 
     * @param msgConfidencial
     */
    public void setMsgConfidencial(java.lang.String msgConfidencial) {
        this.msgConfidencial = msgConfidencial;
    }


    /**
     * Gets the tabla value for this EAfiliadoSIASIS.
     * 
     * @return tabla
     */
    public java.lang.String getTabla() {
        return tabla;
    }


    /**
     * Sets the tabla value for this EAfiliadoSIASIS.
     * 
     * @param tabla
     */
    public void setTabla(java.lang.String tabla) {
        this.tabla = tabla;
    }


    /**
     * Gets the idNumReg value for this EAfiliadoSIASIS.
     * 
     * @return idNumReg
     */
    public java.lang.String getIdNumReg() {
        return idNumReg;
    }


    /**
     * Sets the idNumReg value for this EAfiliadoSIASIS.
     * 
     * @param idNumReg
     */
    public void setIdNumReg(java.lang.String idNumReg) {
        this.idNumReg = idNumReg;
    }


    /**
     * Gets the contrato value for this EAfiliadoSIASIS.
     * 
     * @return contrato
     */
    public java.lang.String getContrato() {
        return contrato;
    }


    /**
     * Sets the contrato value for this EAfiliadoSIASIS.
     * 
     * @param contrato
     */
    public void setContrato(java.lang.String contrato) {
        this.contrato = contrato;
    }


    /**
     * Gets the tipoDocumento value for this EAfiliadoSIASIS.
     * 
     * @return tipoDocumento
     */
    public java.lang.String getTipoDocumento() {
        return tipoDocumento;
    }


    /**
     * Sets the tipoDocumento value for this EAfiliadoSIASIS.
     * 
     * @param tipoDocumento
     */
    public void setTipoDocumento(java.lang.String tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }


    /**
     * Gets the nroDocumento value for this EAfiliadoSIASIS.
     * 
     * @return nroDocumento
     */
    public java.lang.String getNroDocumento() {
        return nroDocumento;
    }


    /**
     * Sets the nroDocumento value for this EAfiliadoSIASIS.
     * 
     * @param nroDocumento
     */
    public void setNroDocumento(java.lang.String nroDocumento) {
        this.nroDocumento = nroDocumento;
    }


    /**
     * Gets the disa value for this EAfiliadoSIASIS.
     * 
     * @return disa
     */
    public java.lang.String getDisa() {
        return disa;
    }


    /**
     * Sets the disa value for this EAfiliadoSIASIS.
     * 
     * @param disa
     */
    public void setDisa(java.lang.String disa) {
        this.disa = disa;
    }


    /**
     * Gets the tipoFormato value for this EAfiliadoSIASIS.
     * 
     * @return tipoFormato
     */
    public java.lang.String getTipoFormato() {
        return tipoFormato;
    }


    /**
     * Sets the tipoFormato value for this EAfiliadoSIASIS.
     * 
     * @param tipoFormato
     */
    public void setTipoFormato(java.lang.String tipoFormato) {
        this.tipoFormato = tipoFormato;
    }


    /**
     * Gets the nroContrato value for this EAfiliadoSIASIS.
     * 
     * @return nroContrato
     */
    public java.lang.String getNroContrato() {
        return nroContrato;
    }


    /**
     * Sets the nroContrato value for this EAfiliadoSIASIS.
     * 
     * @param nroContrato
     */
    public void setNroContrato(java.lang.String nroContrato) {
        this.nroContrato = nroContrato;
    }


    /**
     * Gets the correlativo value for this EAfiliadoSIASIS.
     * 
     * @return correlativo
     */
    public java.lang.String getCorrelativo() {
        return correlativo;
    }


    /**
     * Sets the correlativo value for this EAfiliadoSIASIS.
     * 
     * @param correlativo
     */
    public void setCorrelativo(java.lang.String correlativo) {
        this.correlativo = correlativo;
    }


    /**
     * Gets the idSituacion value for this EAfiliadoSIASIS.
     * 
     * @return idSituacion
     */
    public java.lang.String getIdSituacion() {
        return idSituacion;
    }


    /**
     * Sets the idSituacion value for this EAfiliadoSIASIS.
     * 
     * @param idSituacion
     */
    public void setIdSituacion(java.lang.String idSituacion) {
        this.idSituacion = idSituacion;
    }


    /**
     * Gets the idComponente value for this EAfiliadoSIASIS.
     * 
     * @return idComponente
     */
    public java.lang.String getIdComponente() {
        return idComponente;
    }


    /**
     * Sets the idComponente value for this EAfiliadoSIASIS.
     * 
     * @param idComponente
     */
    public void setIdComponente(java.lang.String idComponente) {
        this.idComponente = idComponente;
    }


    /**
     * Gets the idRegimen value for this EAfiliadoSIASIS.
     * 
     * @return idRegimen
     */
    public java.lang.String getIdRegimen() {
        return idRegimen;
    }


    /**
     * Sets the idRegimen value for this EAfiliadoSIASIS.
     * 
     * @param idRegimen
     */
    public void setIdRegimen(java.lang.String idRegimen) {
        this.idRegimen = idRegimen;
    }


    /**
     * Gets the idTipoSeguro value for this EAfiliadoSIASIS.
     * 
     * @return idTipoSeguro
     */
    public java.lang.String getIdTipoSeguro() {
        return idTipoSeguro;
    }


    /**
     * Sets the idTipoSeguro value for this EAfiliadoSIASIS.
     * 
     * @param idTipoSeguro
     */
    public void setIdTipoSeguro(java.lang.String idTipoSeguro) {
        this.idTipoSeguro = idTipoSeguro;
    }


    /**
     * Gets the apePaterno value for this EAfiliadoSIASIS.
     * 
     * @return apePaterno
     */
    public java.lang.String getApePaterno() {
        return apePaterno;
    }


    /**
     * Sets the apePaterno value for this EAfiliadoSIASIS.
     * 
     * @param apePaterno
     */
    public void setApePaterno(java.lang.String apePaterno) {
        this.apePaterno = apePaterno;
    }


    /**
     * Gets the apeMaterno value for this EAfiliadoSIASIS.
     * 
     * @return apeMaterno
     */
    public java.lang.String getApeMaterno() {
        return apeMaterno;
    }


    /**
     * Sets the apeMaterno value for this EAfiliadoSIASIS.
     * 
     * @param apeMaterno
     */
    public void setApeMaterno(java.lang.String apeMaterno) {
        this.apeMaterno = apeMaterno;
    }


    /**
     * Gets the priNombre value for this EAfiliadoSIASIS.
     * 
     * @return priNombre
     */
    public java.lang.String getPriNombre() {
        return priNombre;
    }


    /**
     * Sets the priNombre value for this EAfiliadoSIASIS.
     * 
     * @param priNombre
     */
    public void setPriNombre(java.lang.String priNombre) {
        this.priNombre = priNombre;
    }


    /**
     * Gets the segNombre value for this EAfiliadoSIASIS.
     * 
     * @return segNombre
     */
    public java.lang.String getSegNombre() {
        return segNombre;
    }


    /**
     * Sets the segNombre value for this EAfiliadoSIASIS.
     * 
     * @param segNombre
     */
    public void setSegNombre(java.lang.String segNombre) {
        this.segNombre = segNombre;
    }


    /**
     * Gets the idGenero value for this EAfiliadoSIASIS.
     * 
     * @return idGenero
     */
    public java.lang.String getIdGenero() {
        return idGenero;
    }


    /**
     * Sets the idGenero value for this EAfiliadoSIASIS.
     * 
     * @param idGenero
     */
    public void setIdGenero(java.lang.String idGenero) {
        this.idGenero = idGenero;
    }


    /**
     * Gets the fecNacimiento value for this EAfiliadoSIASIS.
     * 
     * @return fecNacimiento
     */
    public java.lang.String getFecNacimiento() {
        return fecNacimiento;
    }


    /**
     * Sets the fecNacimiento value for this EAfiliadoSIASIS.
     * 
     * @param fecNacimiento
     */
    public void setFecNacimiento(java.lang.String fecNacimiento) {
        this.fecNacimiento = fecNacimiento;
    }


    /**
     * Gets the direccion value for this EAfiliadoSIASIS.
     * 
     * @return direccion
     */
    public java.lang.String getDireccion() {
        return direccion;
    }


    /**
     * Sets the direccion value for this EAfiliadoSIASIS.
     * 
     * @param direccion
     */
    public void setDireccion(java.lang.String direccion) {
        this.direccion = direccion;
    }


    /**
     * Gets the edad value for this EAfiliadoSIASIS.
     * 
     * @return edad
     */
    public java.lang.String getEdad() {
        return edad;
    }


    /**
     * Sets the edad value for this EAfiliadoSIASIS.
     * 
     * @param edad
     */
    public void setEdad(java.lang.String edad) {
        this.edad = edad;
    }


    /**
     * Gets the idPersona value for this EAfiliadoSIASIS.
     * 
     * @return idPersona
     */
    public java.lang.String getIdPersona() {
        return idPersona;
    }


    /**
     * Sets the idPersona value for this EAfiliadoSIASIS.
     * 
     * @param idPersona
     */
    public void setIdPersona(java.lang.String idPersona) {
        this.idPersona = idPersona;
    }


    /**
     * Gets the autogenerado value for this EAfiliadoSIASIS.
     * 
     * @return autogenerado
     */
    public java.lang.String getAutogenerado() {
        return autogenerado;
    }


    /**
     * Sets the autogenerado value for this EAfiliadoSIASIS.
     * 
     * @param autogenerado
     */
    public void setAutogenerado(java.lang.String autogenerado) {
        this.autogenerado = autogenerado;
    }


    /**
     * Gets the afiUbigeo value for this EAfiliadoSIASIS.
     * 
     * @return afiUbigeo
     */
    public java.lang.String getAfiUbigeo() {
        return afiUbigeo;
    }


    /**
     * Sets the afiUbigeo value for this EAfiliadoSIASIS.
     * 
     * @param afiUbigeo
     */
    public void setAfiUbigeo(java.lang.String afiUbigeo) {
        this.afiUbigeo = afiUbigeo;
    }


    /**
     * Gets the idEESS value for this EAfiliadoSIASIS.
     * 
     * @return idEESS
     */
    public java.lang.String getIdEESS() {
        return idEESS;
    }


    /**
     * Sets the idEESS value for this EAfiliadoSIASIS.
     * 
     * @param idEESS
     */
    public void setIdEESS(java.lang.String idEESS) {
        this.idEESS = idEESS;
    }


    /**
     * Gets the EESSUbigeo value for this EAfiliadoSIASIS.
     * 
     * @return EESSUbigeo
     */
    public java.lang.String getEESSUbigeo() {
        return EESSUbigeo;
    }


    /**
     * Sets the EESSUbigeo value for this EAfiliadoSIASIS.
     * 
     * @param EESSUbigeo
     */
    public void setEESSUbigeo(java.lang.String EESSUbigeo) {
        this.EESSUbigeo = EESSUbigeo;
    }


    /**
     * Gets the idGrupoPoblacional value for this EAfiliadoSIASIS.
     * 
     * @return idGrupoPoblacional
     */
    public java.lang.String getIdGrupoPoblacional() {
        return idGrupoPoblacional;
    }


    /**
     * Sets the idGrupoPoblacional value for this EAfiliadoSIASIS.
     * 
     * @param idGrupoPoblacional
     */
    public void setIdGrupoPoblacional(java.lang.String idGrupoPoblacional) {
        this.idGrupoPoblacional = idGrupoPoblacional;
    }


    /**
     * Gets the fecCrea value for this EAfiliadoSIASIS.
     * 
     * @return fecCrea
     */
    public java.lang.String getFecCrea() {
        return fecCrea;
    }


    /**
     * Sets the fecCrea value for this EAfiliadoSIASIS.
     * 
     * @param fecCrea
     */
    public void setFecCrea(java.lang.String fecCrea) {
        this.fecCrea = fecCrea;
    }


    /**
     * Gets the userCrea value for this EAfiliadoSIASIS.
     * 
     * @return userCrea
     */
    public java.lang.String getUserCrea() {
        return userCrea;
    }


    /**
     * Sets the userCrea value for this EAfiliadoSIASIS.
     * 
     * @param userCrea
     */
    public void setUserCrea(java.lang.String userCrea) {
        this.userCrea = userCrea;
    }


    /**
     * Gets the fecAfiliacion value for this EAfiliadoSIASIS.
     * 
     * @return fecAfiliacion
     */
    public java.lang.String getFecAfiliacion() {
        return fecAfiliacion;
    }


    /**
     * Sets the fecAfiliacion value for this EAfiliadoSIASIS.
     * 
     * @param fecAfiliacion
     */
    public void setFecAfiliacion(java.lang.String fecAfiliacion) {
        this.fecAfiliacion = fecAfiliacion;
    }


    /**
     * Gets the fecBaja value for this EAfiliadoSIASIS.
     * 
     * @return fecBaja
     */
    public java.lang.String getFecBaja() {
        return fecBaja;
    }


    /**
     * Sets the fecBaja value for this EAfiliadoSIASIS.
     * 
     * @param fecBaja
     */
    public void setFecBaja(java.lang.String fecBaja) {
        this.fecBaja = fecBaja;
    }


    /**
     * Gets the estado value for this EAfiliadoSIASIS.
     * 
     * @return estado
     */
    public java.lang.String getEstado() {
        return estado;
    }


    /**
     * Sets the estado value for this EAfiliadoSIASIS.
     * 
     * @param estado
     */
    public void setEstado(java.lang.String estado) {
        this.estado = estado;
    }


    /**
     * Gets the fecFinCobertura value for this EAfiliadoSIASIS.
     * 
     * @return fecFinCobertura
     */
    public java.lang.String getFecFinCobertura() {
        return fecFinCobertura;
    }


    /**
     * Sets the fecFinCobertura value for this EAfiliadoSIASIS.
     * 
     * @param fecFinCobertura
     */
    public void setFecFinCobertura(java.lang.String fecFinCobertura) {
        this.fecFinCobertura = fecFinCobertura;
    }


    /**
     * Gets the fecFallecimiento value for this EAfiliadoSIASIS.
     * 
     * @return fecFallecimiento
     */
    public java.lang.String getFecFallecimiento() {
        return fecFallecimiento;
    }


    /**
     * Sets the fecFallecimiento value for this EAfiliadoSIASIS.
     * 
     * @param fecFallecimiento
     */
    public void setFecFallecimiento(java.lang.String fecFallecimiento) {
        this.fecFallecimiento = fecFallecimiento;
    }


    /**
     * Gets the idZonaAUS value for this EAfiliadoSIASIS.
     * 
     * @return idZonaAUS
     */
    public java.lang.String getIdZonaAUS() {
        return idZonaAUS;
    }


    /**
     * Sets the idZonaAUS value for this EAfiliadoSIASIS.
     * 
     * @param idZonaAUS
     */
    public void setIdZonaAUS(java.lang.String idZonaAUS) {
        this.idZonaAUS = idZonaAUS;
    }


    /**
     * Gets the idPlanCobertura value for this EAfiliadoSIASIS.
     * 
     * @return idPlanCobertura
     */
    public java.lang.String getIdPlanCobertura() {
        return idPlanCobertura;
    }


    /**
     * Sets the idPlanCobertura value for this EAfiliadoSIASIS.
     * 
     * @param idPlanCobertura
     */
    public void setIdPlanCobertura(java.lang.String idPlanCobertura) {
        this.idPlanCobertura = idPlanCobertura;
    }


    /**
     * Gets the idMotivoBaja value for this EAfiliadoSIASIS.
     * 
     * @return idMotivoBaja
     */
    public java.lang.String getIdMotivoBaja() {
        return idMotivoBaja;
    }


    /**
     * Sets the idMotivoBaja value for this EAfiliadoSIASIS.
     * 
     * @param idMotivoBaja
     */
    public void setIdMotivoBaja(java.lang.String idMotivoBaja) {
        this.idMotivoBaja = idMotivoBaja;
    }


    /**
     * Gets the userBaja value for this EAfiliadoSIASIS.
     * 
     * @return userBaja
     */
    public java.lang.String getUserBaja() {
        return userBaja;
    }


    /**
     * Sets the userBaja value for this EAfiliadoSIASIS.
     * 
     * @param userBaja
     */
    public void setUserBaja(java.lang.String userBaja) {
        this.userBaja = userBaja;
    }


    /**
     * Gets the disaFESE value for this EAfiliadoSIASIS.
     * 
     * @return disaFESE
     */
    public java.lang.String getDisaFESE() {
        return disaFESE;
    }


    /**
     * Sets the disaFESE value for this EAfiliadoSIASIS.
     * 
     * @param disaFESE
     */
    public void setDisaFESE(java.lang.String disaFESE) {
        this.disaFESE = disaFESE;
    }


    /**
     * Gets the loteFESE value for this EAfiliadoSIASIS.
     * 
     * @return loteFESE
     */
    public java.lang.String getLoteFESE() {
        return loteFESE;
    }


    /**
     * Sets the loteFESE value for this EAfiliadoSIASIS.
     * 
     * @param loteFESE
     */
    public void setLoteFESE(java.lang.String loteFESE) {
        this.loteFESE = loteFESE;
    }


    /**
     * Gets the numeroFESE value for this EAfiliadoSIASIS.
     * 
     * @return numeroFESE
     */
    public java.lang.String getNumeroFESE() {
        return numeroFESE;
    }


    /**
     * Sets the numeroFESE value for this EAfiliadoSIASIS.
     * 
     * @param numeroFESE
     */
    public void setNumeroFESE(java.lang.String numeroFESE) {
        this.numeroFESE = numeroFESE;
    }


    /**
     * Gets the benSepTipoDoc value for this EAfiliadoSIASIS.
     * 
     * @return benSepTipoDoc
     */
    public java.lang.String getBenSepTipoDoc() {
        return benSepTipoDoc;
    }


    /**
     * Sets the benSepTipoDoc value for this EAfiliadoSIASIS.
     * 
     * @param benSepTipoDoc
     */
    public void setBenSepTipoDoc(java.lang.String benSepTipoDoc) {
        this.benSepTipoDoc = benSepTipoDoc;
    }


    /**
     * Gets the benSepDocumento value for this EAfiliadoSIASIS.
     * 
     * @return benSepDocumento
     */
    public java.lang.String getBenSepDocumento() {
        return benSepDocumento;
    }


    /**
     * Sets the benSepDocumento value for this EAfiliadoSIASIS.
     * 
     * @param benSepDocumento
     */
    public void setBenSepDocumento(java.lang.String benSepDocumento) {
        this.benSepDocumento = benSepDocumento;
    }


    /**
     * Gets the benSepApePaterno value for this EAfiliadoSIASIS.
     * 
     * @return benSepApePaterno
     */
    public java.lang.String getBenSepApePaterno() {
        return benSepApePaterno;
    }


    /**
     * Sets the benSepApePaterno value for this EAfiliadoSIASIS.
     * 
     * @param benSepApePaterno
     */
    public void setBenSepApePaterno(java.lang.String benSepApePaterno) {
        this.benSepApePaterno = benSepApePaterno;
    }


    /**
     * Gets the benSepApeMaterno value for this EAfiliadoSIASIS.
     * 
     * @return benSepApeMaterno
     */
    public java.lang.String getBenSepApeMaterno() {
        return benSepApeMaterno;
    }


    /**
     * Sets the benSepApeMaterno value for this EAfiliadoSIASIS.
     * 
     * @param benSepApeMaterno
     */
    public void setBenSepApeMaterno(java.lang.String benSepApeMaterno) {
        this.benSepApeMaterno = benSepApeMaterno;
    }


    /**
     * Gets the benSepPriNombre value for this EAfiliadoSIASIS.
     * 
     * @return benSepPriNombre
     */
    public java.lang.String getBenSepPriNombre() {
        return benSepPriNombre;
    }


    /**
     * Sets the benSepPriNombre value for this EAfiliadoSIASIS.
     * 
     * @param benSepPriNombre
     */
    public void setBenSepPriNombre(java.lang.String benSepPriNombre) {
        this.benSepPriNombre = benSepPriNombre;
    }


    /**
     * Gets the benSepSegNombre value for this EAfiliadoSIASIS.
     * 
     * @return benSepSegNombre
     */
    public java.lang.String getBenSepSegNombre() {
        return benSepSegNombre;
    }


    /**
     * Sets the benSepSegNombre value for this EAfiliadoSIASIS.
     * 
     * @param benSepSegNombre
     */
    public void setBenSepSegNombre(java.lang.String benSepSegNombre) {
        this.benSepSegNombre = benSepSegNombre;
    }


    /**
     * Gets the reniecValida value for this EAfiliadoSIASIS.
     * 
     * @return reniecValida
     */
    public java.lang.String getReniecValida() {
        return reniecValida;
    }


    /**
     * Sets the reniecValida value for this EAfiliadoSIASIS.
     * 
     * @param reniecValida
     */
    public void setReniecValida(java.lang.String reniecValida) {
        this.reniecValida = reniecValida;
    }


    /**
     * Gets the descTipoSeguro value for this EAfiliadoSIASIS.
     * 
     * @return descTipoSeguro
     */
    public java.lang.String getDescTipoSeguro() {
        return descTipoSeguro;
    }


    /**
     * Sets the descTipoSeguro value for this EAfiliadoSIASIS.
     * 
     * @param descTipoSeguro
     */
    public void setDescTipoSeguro(java.lang.String descTipoSeguro) {
        this.descTipoSeguro = descTipoSeguro;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof EAfiliadoSIASIS)) return false;
        EAfiliadoSIASIS other = (EAfiliadoSIASIS) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.idError==null && other.getIdError()==null) || 
             (this.idError!=null &&
              this.idError.equals(other.getIdError()))) &&
            ((this.resultado==null && other.getResultado()==null) || 
             (this.resultado!=null &&
              this.resultado.equals(other.getResultado()))) &&
            ((this.msgConfidencial==null && other.getMsgConfidencial()==null) || 
             (this.msgConfidencial!=null &&
              this.msgConfidencial.equals(other.getMsgConfidencial()))) &&
            ((this.tabla==null && other.getTabla()==null) || 
             (this.tabla!=null &&
              this.tabla.equals(other.getTabla()))) &&
            ((this.idNumReg==null && other.getIdNumReg()==null) || 
             (this.idNumReg!=null &&
              this.idNumReg.equals(other.getIdNumReg()))) &&
            ((this.contrato==null && other.getContrato()==null) || 
             (this.contrato!=null &&
              this.contrato.equals(other.getContrato()))) &&
            ((this.tipoDocumento==null && other.getTipoDocumento()==null) || 
             (this.tipoDocumento!=null &&
              this.tipoDocumento.equals(other.getTipoDocumento()))) &&
            ((this.nroDocumento==null && other.getNroDocumento()==null) || 
             (this.nroDocumento!=null &&
              this.nroDocumento.equals(other.getNroDocumento()))) &&
            ((this.disa==null && other.getDisa()==null) || 
             (this.disa!=null &&
              this.disa.equals(other.getDisa()))) &&
            ((this.tipoFormato==null && other.getTipoFormato()==null) || 
             (this.tipoFormato!=null &&
              this.tipoFormato.equals(other.getTipoFormato()))) &&
            ((this.nroContrato==null && other.getNroContrato()==null) || 
             (this.nroContrato!=null &&
              this.nroContrato.equals(other.getNroContrato()))) &&
            ((this.correlativo==null && other.getCorrelativo()==null) || 
             (this.correlativo!=null &&
              this.correlativo.equals(other.getCorrelativo()))) &&
            ((this.idSituacion==null && other.getIdSituacion()==null) || 
             (this.idSituacion!=null &&
              this.idSituacion.equals(other.getIdSituacion()))) &&
            ((this.idComponente==null && other.getIdComponente()==null) || 
             (this.idComponente!=null &&
              this.idComponente.equals(other.getIdComponente()))) &&
            ((this.idRegimen==null && other.getIdRegimen()==null) || 
             (this.idRegimen!=null &&
              this.idRegimen.equals(other.getIdRegimen()))) &&
            ((this.idTipoSeguro==null && other.getIdTipoSeguro()==null) || 
             (this.idTipoSeguro!=null &&
              this.idTipoSeguro.equals(other.getIdTipoSeguro()))) &&
            ((this.apePaterno==null && other.getApePaterno()==null) || 
             (this.apePaterno!=null &&
              this.apePaterno.equals(other.getApePaterno()))) &&
            ((this.apeMaterno==null && other.getApeMaterno()==null) || 
             (this.apeMaterno!=null &&
              this.apeMaterno.equals(other.getApeMaterno()))) &&
            ((this.priNombre==null && other.getPriNombre()==null) || 
             (this.priNombre!=null &&
              this.priNombre.equals(other.getPriNombre()))) &&
            ((this.segNombre==null && other.getSegNombre()==null) || 
             (this.segNombre!=null &&
              this.segNombre.equals(other.getSegNombre()))) &&
            ((this.idGenero==null && other.getIdGenero()==null) || 
             (this.idGenero!=null &&
              this.idGenero.equals(other.getIdGenero()))) &&
            ((this.fecNacimiento==null && other.getFecNacimiento()==null) || 
             (this.fecNacimiento!=null &&
              this.fecNacimiento.equals(other.getFecNacimiento()))) &&
            ((this.direccion==null && other.getDireccion()==null) || 
             (this.direccion!=null &&
              this.direccion.equals(other.getDireccion()))) &&
            ((this.edad==null && other.getEdad()==null) || 
             (this.edad!=null &&
              this.edad.equals(other.getEdad()))) &&
            ((this.idPersona==null && other.getIdPersona()==null) || 
             (this.idPersona!=null &&
              this.idPersona.equals(other.getIdPersona()))) &&
            ((this.autogenerado==null && other.getAutogenerado()==null) || 
             (this.autogenerado!=null &&
              this.autogenerado.equals(other.getAutogenerado()))) &&
            ((this.afiUbigeo==null && other.getAfiUbigeo()==null) || 
             (this.afiUbigeo!=null &&
              this.afiUbigeo.equals(other.getAfiUbigeo()))) &&
            ((this.idEESS==null && other.getIdEESS()==null) || 
             (this.idEESS!=null &&
              this.idEESS.equals(other.getIdEESS()))) &&
            ((this.EESSUbigeo==null && other.getEESSUbigeo()==null) || 
             (this.EESSUbigeo!=null &&
              this.EESSUbigeo.equals(other.getEESSUbigeo()))) &&
            ((this.idGrupoPoblacional==null && other.getIdGrupoPoblacional()==null) || 
             (this.idGrupoPoblacional!=null &&
              this.idGrupoPoblacional.equals(other.getIdGrupoPoblacional()))) &&
            ((this.fecCrea==null && other.getFecCrea()==null) || 
             (this.fecCrea!=null &&
              this.fecCrea.equals(other.getFecCrea()))) &&
            ((this.userCrea==null && other.getUserCrea()==null) || 
             (this.userCrea!=null &&
              this.userCrea.equals(other.getUserCrea()))) &&
            ((this.fecAfiliacion==null && other.getFecAfiliacion()==null) || 
             (this.fecAfiliacion!=null &&
              this.fecAfiliacion.equals(other.getFecAfiliacion()))) &&
            ((this.fecBaja==null && other.getFecBaja()==null) || 
             (this.fecBaja!=null &&
              this.fecBaja.equals(other.getFecBaja()))) &&
            ((this.estado==null && other.getEstado()==null) || 
             (this.estado!=null &&
              this.estado.equals(other.getEstado()))) &&
            ((this.fecFinCobertura==null && other.getFecFinCobertura()==null) || 
             (this.fecFinCobertura!=null &&
              this.fecFinCobertura.equals(other.getFecFinCobertura()))) &&
            ((this.fecFallecimiento==null && other.getFecFallecimiento()==null) || 
             (this.fecFallecimiento!=null &&
              this.fecFallecimiento.equals(other.getFecFallecimiento()))) &&
            ((this.idZonaAUS==null && other.getIdZonaAUS()==null) || 
             (this.idZonaAUS!=null &&
              this.idZonaAUS.equals(other.getIdZonaAUS()))) &&
            ((this.idPlanCobertura==null && other.getIdPlanCobertura()==null) || 
             (this.idPlanCobertura!=null &&
              this.idPlanCobertura.equals(other.getIdPlanCobertura()))) &&
            ((this.idMotivoBaja==null && other.getIdMotivoBaja()==null) || 
             (this.idMotivoBaja!=null &&
              this.idMotivoBaja.equals(other.getIdMotivoBaja()))) &&
            ((this.userBaja==null && other.getUserBaja()==null) || 
             (this.userBaja!=null &&
              this.userBaja.equals(other.getUserBaja()))) &&
            ((this.disaFESE==null && other.getDisaFESE()==null) || 
             (this.disaFESE!=null &&
              this.disaFESE.equals(other.getDisaFESE()))) &&
            ((this.loteFESE==null && other.getLoteFESE()==null) || 
             (this.loteFESE!=null &&
              this.loteFESE.equals(other.getLoteFESE()))) &&
            ((this.numeroFESE==null && other.getNumeroFESE()==null) || 
             (this.numeroFESE!=null &&
              this.numeroFESE.equals(other.getNumeroFESE()))) &&
            ((this.benSepTipoDoc==null && other.getBenSepTipoDoc()==null) || 
             (this.benSepTipoDoc!=null &&
              this.benSepTipoDoc.equals(other.getBenSepTipoDoc()))) &&
            ((this.benSepDocumento==null && other.getBenSepDocumento()==null) || 
             (this.benSepDocumento!=null &&
              this.benSepDocumento.equals(other.getBenSepDocumento()))) &&
            ((this.benSepApePaterno==null && other.getBenSepApePaterno()==null) || 
             (this.benSepApePaterno!=null &&
              this.benSepApePaterno.equals(other.getBenSepApePaterno()))) &&
            ((this.benSepApeMaterno==null && other.getBenSepApeMaterno()==null) || 
             (this.benSepApeMaterno!=null &&
              this.benSepApeMaterno.equals(other.getBenSepApeMaterno()))) &&
            ((this.benSepPriNombre==null && other.getBenSepPriNombre()==null) || 
             (this.benSepPriNombre!=null &&
              this.benSepPriNombre.equals(other.getBenSepPriNombre()))) &&
            ((this.benSepSegNombre==null && other.getBenSepSegNombre()==null) || 
             (this.benSepSegNombre!=null &&
              this.benSepSegNombre.equals(other.getBenSepSegNombre()))) &&
            ((this.reniecValida==null && other.getReniecValida()==null) || 
             (this.reniecValida!=null &&
              this.reniecValida.equals(other.getReniecValida()))) &&
            ((this.descTipoSeguro==null && other.getDescTipoSeguro()==null) || 
             (this.descTipoSeguro!=null &&
              this.descTipoSeguro.equals(other.getDescTipoSeguro())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getIdError() != null) {
            _hashCode += getIdError().hashCode();
        }
        if (getResultado() != null) {
            _hashCode += getResultado().hashCode();
        }
        if (getMsgConfidencial() != null) {
            _hashCode += getMsgConfidencial().hashCode();
        }
        if (getTabla() != null) {
            _hashCode += getTabla().hashCode();
        }
        if (getIdNumReg() != null) {
            _hashCode += getIdNumReg().hashCode();
        }
        if (getContrato() != null) {
            _hashCode += getContrato().hashCode();
        }
        if (getTipoDocumento() != null) {
            _hashCode += getTipoDocumento().hashCode();
        }
        if (getNroDocumento() != null) {
            _hashCode += getNroDocumento().hashCode();
        }
        if (getDisa() != null) {
            _hashCode += getDisa().hashCode();
        }
        if (getTipoFormato() != null) {
            _hashCode += getTipoFormato().hashCode();
        }
        if (getNroContrato() != null) {
            _hashCode += getNroContrato().hashCode();
        }
        if (getCorrelativo() != null) {
            _hashCode += getCorrelativo().hashCode();
        }
        if (getIdSituacion() != null) {
            _hashCode += getIdSituacion().hashCode();
        }
        if (getIdComponente() != null) {
            _hashCode += getIdComponente().hashCode();
        }
        if (getIdRegimen() != null) {
            _hashCode += getIdRegimen().hashCode();
        }
        if (getIdTipoSeguro() != null) {
            _hashCode += getIdTipoSeguro().hashCode();
        }
        if (getApePaterno() != null) {
            _hashCode += getApePaterno().hashCode();
        }
        if (getApeMaterno() != null) {
            _hashCode += getApeMaterno().hashCode();
        }
        if (getPriNombre() != null) {
            _hashCode += getPriNombre().hashCode();
        }
        if (getSegNombre() != null) {
            _hashCode += getSegNombre().hashCode();
        }
        if (getIdGenero() != null) {
            _hashCode += getIdGenero().hashCode();
        }
        if (getFecNacimiento() != null) {
            _hashCode += getFecNacimiento().hashCode();
        }
        if (getDireccion() != null) {
            _hashCode += getDireccion().hashCode();
        }
        if (getEdad() != null) {
            _hashCode += getEdad().hashCode();
        }
        if (getIdPersona() != null) {
            _hashCode += getIdPersona().hashCode();
        }
        if (getAutogenerado() != null) {
            _hashCode += getAutogenerado().hashCode();
        }
        if (getAfiUbigeo() != null) {
            _hashCode += getAfiUbigeo().hashCode();
        }
        if (getIdEESS() != null) {
            _hashCode += getIdEESS().hashCode();
        }
        if (getEESSUbigeo() != null) {
            _hashCode += getEESSUbigeo().hashCode();
        }
        if (getIdGrupoPoblacional() != null) {
            _hashCode += getIdGrupoPoblacional().hashCode();
        }
        if (getFecCrea() != null) {
            _hashCode += getFecCrea().hashCode();
        }
        if (getUserCrea() != null) {
            _hashCode += getUserCrea().hashCode();
        }
        if (getFecAfiliacion() != null) {
            _hashCode += getFecAfiliacion().hashCode();
        }
        if (getFecBaja() != null) {
            _hashCode += getFecBaja().hashCode();
        }
        if (getEstado() != null) {
            _hashCode += getEstado().hashCode();
        }
        if (getFecFinCobertura() != null) {
            _hashCode += getFecFinCobertura().hashCode();
        }
        if (getFecFallecimiento() != null) {
            _hashCode += getFecFallecimiento().hashCode();
        }
        if (getIdZonaAUS() != null) {
            _hashCode += getIdZonaAUS().hashCode();
        }
        if (getIdPlanCobertura() != null) {
            _hashCode += getIdPlanCobertura().hashCode();
        }
        if (getIdMotivoBaja() != null) {
            _hashCode += getIdMotivoBaja().hashCode();
        }
        if (getUserBaja() != null) {
            _hashCode += getUserBaja().hashCode();
        }
        if (getDisaFESE() != null) {
            _hashCode += getDisaFESE().hashCode();
        }
        if (getLoteFESE() != null) {
            _hashCode += getLoteFESE().hashCode();
        }
        if (getNumeroFESE() != null) {
            _hashCode += getNumeroFESE().hashCode();
        }
        if (getBenSepTipoDoc() != null) {
            _hashCode += getBenSepTipoDoc().hashCode();
        }
        if (getBenSepDocumento() != null) {
            _hashCode += getBenSepDocumento().hashCode();
        }
        if (getBenSepApePaterno() != null) {
            _hashCode += getBenSepApePaterno().hashCode();
        }
        if (getBenSepApeMaterno() != null) {
            _hashCode += getBenSepApeMaterno().hashCode();
        }
        if (getBenSepPriNombre() != null) {
            _hashCode += getBenSepPriNombre().hashCode();
        }
        if (getBenSepSegNombre() != null) {
            _hashCode += getBenSepSegNombre().hashCode();
        }
        if (getReniecValida() != null) {
            _hashCode += getReniecValida().hashCode();
        }
        if (getDescTipoSeguro() != null) {
            _hashCode += getDescTipoSeguro().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(EAfiliadoSIASIS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://sis.gob.pe/", "EAfiliadoSIASIS"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idError");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdError"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultado");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Resultado"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("msgConfidencial");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "MsgConfidencial"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tabla");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Tabla"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idNumReg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdNumReg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contrato");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Contrato"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tipoDocumento");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "TipoDocumento"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nroDocumento");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "NroDocumento"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("disa");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Disa"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tipoFormato");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "TipoFormato"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nroContrato");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "NroContrato"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("correlativo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Correlativo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idSituacion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdSituacion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idComponente");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdComponente"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idRegimen");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdRegimen"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idTipoSeguro");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdTipoSeguro"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("apePaterno");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "ApePaterno"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("apeMaterno");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "ApeMaterno"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("priNombre");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "PriNombre"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("segNombre");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "SegNombre"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idGenero");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdGenero"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecNacimiento");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecNacimiento"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("direccion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Direccion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("edad");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Edad"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idPersona");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdPersona"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("autogenerado");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Autogenerado"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("afiUbigeo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "AfiUbigeo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idEESS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdEESS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EESSUbigeo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "EESSUbigeo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idGrupoPoblacional");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdGrupoPoblacional"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecCrea");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecCrea"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userCrea");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "UserCrea"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecAfiliacion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecAfiliacion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecBaja");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecBaja"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("estado");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "Estado"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecFinCobertura");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecFinCobertura"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fecFallecimiento");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "FecFallecimiento"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idZonaAUS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdZonaAUS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idPlanCobertura");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdPlanCobertura"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("idMotivoBaja");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "IdMotivoBaja"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userBaja");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "UserBaja"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("disaFESE");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "DisaFESE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("loteFESE");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "LoteFESE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("numeroFESE");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "NumeroFESE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepTipoDoc");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepTipoDoc"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepDocumento");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepDocumento"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepApePaterno");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepApePaterno"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepApeMaterno");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepApeMaterno"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepPriNombre");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepPriNombre"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("benSepSegNombre");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "BenSepSegNombre"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reniecValida");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "ReniecValida"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("descTipoSeguro");
        elemField.setXmlName(new javax.xml.namespace.QName("http://sis.gob.pe/", "DescTipoSeguro"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
