package be.presis;

public class Session {
	final static int ERR_DATOS_EXITOSOS=0;
	final static int ERR_USUARIO_INVALIDO=1;
	final static int ERR_CLAVE_INCORRECTA=2;
	final static int ERR_USUARIO_CADUCADO=3;
	final static int ERR_USUARIO_FUERA_DE_HORARIO_DE_CONSULTA=5;
	final static int ERR_USUARIO_FUERA_DEL_LIMITE_DE_CONSULTAS_POR_DIA=6;
	final static int ERR_AUTORIZACION_CADUCADA=7;
	final static int ERR_AUTORIZACION_YA_UTILIZADA=8;
	final static int ERR_AUTORIZACION_NO_VALIDA=9;
	final static int ERR_DNI_NO_VALIDO=10;
	final static int ERR_DNI_INACTIVO=11;
	final static int ERR_DNI_CADUCADO=12;
	final static int ERR_SIN_ACCESO_AL_TIPO_DE_CONSULTA_SOLICITADA=13;
	final static int ERR_NO_SE_ENCONTRO_AFILIACION_PARA_EL_DNI_CONSULTADO=14;
	
	final static int DOC_DNI=1;
	final static int DOC_CE=3;
		
	private String userName;
	private String passWord;
	private String authorizationCode;
	private int errorCode;
	private String errorDescription;
	
	
}
