<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="io.minio.MinioClient" %>
<%@ page import="io.minio.GetObjectArgs" %>
<%@ page import="io.minio.errors.MinioException" %>
<%@ page import="io.minio.ConnectMinio" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.InputStream" %>
<!-- 추가 -->

<!DOCTYPE html>
<html>
<head>
    <title>Image Display Example</title>
</head>
<body>
<h1>Image Display Example</h1>

<%
    // Minio 클라이언트 초기화
    ConnectMinio connectMinio = new ConnectMinio();
    MinioClient minioClient = connectMinio.getInstance();
    String bucket = "users-photo"; // MinIO 버킷 이름
    String filename = request.getParameter("filename"); // 다운로드할 파일 이름

    try {
        InputStream imageStream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucket)
                        .object(filename)
                        .build()
        );

        byte[] imageBytes = org.apache.commons.io.IOUtils.toByteArray(imageStream);
        String base64Image = Base64.encodeBase64String(imageBytes);
%>

<img src="data:image/jpeg;base64, <%= base64Image %>" alt="Downloaded Image">

<%
        imageStream.close();
    } catch (MinioException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
        out.println("Error retrieving image from MinIO: " + e.getMessage());
    } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
        out.println("An error occurred: " + e.getMessage());
    }
%>
</body>
</html>
