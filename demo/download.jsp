<%@page import="java.security.*"%>
<%@page import="javax.crypto.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>

<%!
    Cipher cipher = null;
    String jsPK = null;
%>

<%
    synchronized (this) {
        if (cipher == null) {
            cipher = Cipher.getInstance("RSA");
            KeyFactory fact = KeyFactory.getInstance("RSA");

            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
            keyPairGenerator.initialize(1024);

            KeyPair keyPair = keyPairGenerator.generateKeyPair();
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();
            cipher.init(Cipher.ENCRYPT_MODE, publicKey);
            //JDK 8 Base64
            jsPK = java.util.Base64.getEncoder().encodeToString(privateKey.getEncoded());
        }
    }
%>

<%
    String msg = (new java.util.Date()).toString();

    synchronized (cipher) {
        msg = java.util.Base64.getEncoder().encodeToString(cipher.doFinal(msg.getBytes()));
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RSA Download</title>
        <script src="jsencrypt.min.js"></script>
        <script>
            var encrypt = new JSEncrypt();
            encrypt.setPrivateKey('<%= jsPK%>');

            var msg = encrypt.decrypt('<%=msg%>');

            function lo() {
                document.getElementById('s').innerHTML = msg;
            }
        </script>
    </head>
    <body onload="lo()">
        <h1>RSA DOWNLOAD</h1>

        <hr>
        DOWNLOAD:<span id="s"></span>
    </body>
</html>
