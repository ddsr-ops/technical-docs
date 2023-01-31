Security Model

Oracle Database installs this package in the SYS schema. You can then grant package access to existing users and roles as needed.

Ask your system administration to grant access to it:

GRANT EXECUTE ON SYS.DBMS_CRYPTO TO USERXY;
Or even:

GRANT EXECUTE ON SYS.DBMS_CRYPTO TO PUBLIC;


* 加密函数
```
CREATE OR REPLACE 
FUNCTION ENCRYPT_FUNCTION(
  V_STR        VARCHAR2, V_KEY VARCHAR2) RETURN VARCHAR2 AS V_KEY_RAW RAW(24);
  V_STR_RAW    RAW(2000);
  V_RETURN_STR VARCHAR2(2000);
  V_TYPE       PLS_INTEGER;
BEGIN
  /*************************************************
    加密函数　FUN_ENCRYPTION　
        入参：
          V_STR 输入明文字符串
          V_KEY 输入密钥字符串，长度为24字节
        返回值：
          V_RETURN_STR　返回密文字符串，约定返回为 16进制密文字符串
       　异常处理：
          此函数不对任何异常做捕捉处理，请相应的程序模块对异常做捕捉处理。
        加密方式：
          密钥位数:AES192   DBMS_CRYPTO.ENCRYPT_AES192
          连接方式:CBC      DBMS_CRYPTO.CHAIN_CBC
          填充方式:PKCS5    DBMS_CRYPTO.PAD_PKCS5
  **************************************************/
  V_KEY_RAW    := UTL_I18N.STRING_TO_RAW(V_KEY, 'ZHS16GBK');
  V_STR_RAW    := UTL_I18N.STRING_TO_RAW(V_STR, 'ZHS16GBK');
  -- 指定‘密钥算法’、‘工作模式’、‘填充方式’
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

* 解密函数
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
     解密函数　FUN_DECRYPTION　
        入参：
          V_STR 输入密文字符串,约定密文为16进制字符串
          V_KEY 输入密钥字符串，长度为24字节
        返回值：
          V_RETURN_STR　返回明文字符串
        异常处理：
          此函数不对任何异常做捕捉处理，请相应的程序模块对异常做捕捉处理。
        加密方式：
          密钥位数:AES192   DBMS_CRYPTO.ENCRYPT_AES192
          连接方式:CBC      DBMS_CRYPTO.CHAIN_CBC
          填充方式:PKCS5    DBMS_CRYPTO.PAD_PKCS5
  ***************************************************/
  V_KEY_RAW := UTL_I18N.STRING_TO_RAW(V_KEY, 'ZHS16GBK');
  V_STR_RAW := HEXTORAW(V_STR);
  -- 指定‘密钥算法’、‘工作模式’、‘填充方式’
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


