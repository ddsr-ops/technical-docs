Security Model

Oracle Database installs this package in the SYS schema. You can then grant package access to existing users and roles as needed.

Ask your system administration to grant access to it:

GRANT EXECUTE ON SYS.DBMS_CRYPTO TO USERXY;
Or even:

GRANT EXECUTE ON SYS.DBMS_CRYPTO TO PUBLIC;


* ���ܺ���
```
CREATE OR REPLACE 
FUNCTION ENCRYPT_FUNCTION(
  V_STR        VARCHAR2, V_KEY VARCHAR2) RETURN VARCHAR2 AS V_KEY_RAW RAW(24);
  V_STR_RAW    RAW(2000);
  V_RETURN_STR VARCHAR2(2000);
  V_TYPE       PLS_INTEGER;
BEGIN
  /*************************************************
    ���ܺ�����FUN_ENCRYPTION��
        ��Σ�
          V_STR ���������ַ���
          V_KEY ������Կ�ַ���������Ϊ24�ֽ�
        ����ֵ��
          V_RETURN_STR�����������ַ�����Լ������Ϊ 16���������ַ���
       ���쳣����
          �˺��������κ��쳣����׽��������Ӧ�ĳ���ģ����쳣����׽����
        ���ܷ�ʽ��
          ��Կλ��:AES192   DBMS_CRYPTO.ENCRYPT_AES192
          ���ӷ�ʽ:CBC      DBMS_CRYPTO.CHAIN_CBC
          ��䷽ʽ:PKCS5    DBMS_CRYPTO.PAD_PKCS5
  **************************************************/
  V_KEY_RAW    := UTL_I18N.STRING_TO_RAW(V_KEY, 'ZHS16GBK');
  V_STR_RAW    := UTL_I18N.STRING_TO_RAW(V_STR, 'ZHS16GBK');
  -- ָ������Կ�㷨����������ģʽ��������䷽ʽ��
  V_TYPE       := DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_ECB +
                  DBMS_CRYPTO.PAD_PKCS5;
  V_STR_RAW    := DBMS_CRYPTO.ENCRYPT(SRC => V_STR_RAW,
                                      TYP => V_TYPE,
                                      KEY => V_KEY_RAW);
  V_RETURN_STR := RAWTOHEX(V_STR_RAW);
  RETURN V_RETURN_STR;
 
  /* EXCEPTION
  WHEN OTHERS THEN
  RETURN SQLERRM||SQLCODE ;   */
END;


```

* ���ܺ���
```
CREATE OR REPLACE 
FUNCTION DECRYPT_FUNCTION(V_STR VARCHAR2, V_KEY VARCHAR2)
  RETURN VARCHAR2 AS
  V_KEY_RAW    RAW(24);
  V_STR_RAW    RAW(2000);
  V_RETURN_STR VARCHAR2(2000);
  V_TYPE       PLS_INTEGER;
 
BEGIN
  /************************************************
     ���ܺ�����FUN_DECRYPTION��
        ��Σ�
          V_STR ���������ַ���,Լ������Ϊ16�����ַ���
          V_KEY ������Կ�ַ���������Ϊ24�ֽ�
        ����ֵ��
          V_RETURN_STR�����������ַ���
        �쳣����
          �˺��������κ��쳣����׽��������Ӧ�ĳ���ģ����쳣����׽����
        ���ܷ�ʽ��
          ��Կλ��:AES192   DBMS_CRYPTO.ENCRYPT_AES192
          ���ӷ�ʽ:CBC      DBMS_CRYPTO.CHAIN_CBC
          ��䷽ʽ:PKCS5    DBMS_CRYPTO.PAD_PKCS5
  ***************************************************/
  V_KEY_RAW := UTL_I18N.STRING_TO_RAW(V_KEY, 'ZHS16GBK');
  V_STR_RAW := HEXTORAW(V_STR);
  -- ָ������Կ�㷨����������ģʽ��������䷽ʽ��
  V_TYPE       := DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_ECB +
                  DBMS_CRYPTO.PAD_PKCS5;
  V_STR_RAW    := DBMS_CRYPTO.DECRYPT(SRC => V_STR_RAW,
                                      TYP => V_TYPE,
                                      KEY => V_KEY_RAW);
  V_RETURN_STR := UTL_I18N.RAW_TO_CHAR(V_STR_RAW, 'ZHS16GBK');
  RETURN V_RETURN_STR;
  /*  EXCEPTION
  WHEN OTHERS THEN
  RETURN SQLERRM||SQLCODE ; */
END;
```


