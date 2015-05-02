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
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            //JDK 8 Base64
            jsPK = java.util.Base64.getEncoder().encodeToString(publicKey.getEncoded());
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RSA Upload</title>
        <script src="jsencrypt.min.js"></script>
        <script>
            var encrypt = new JSEncrypt();
            encrypt.setPublicKey('<%= jsPK%>');

            function sub() {
                var ip = document.getElementsByName("input1")[0];
                ip.value = encrypt.encrypt(ip.value);
            }
        </script>
    </head>
    <body>
        <h1>RSA UPLOAD</h1>
        <form action="upload.jsp" method="post" onsubmit="sub();">
            <input name="input1" />
            <input type="submit" />
        </form>
        <%
            String input1 = request.getParameter("input1");
            if (input1 != null) {
                byte[] bsinput = java.util.Base64.getDecoder().decode(input1);
                synchronized (cipher) {
                    byte[] decrypted = cipher.doFinal(bsinput);
                    input1 = new String(decrypted);
                }
            }
        %>
        <hr>
        UPLOADED:<%= input1%>
    </body>
</html>
