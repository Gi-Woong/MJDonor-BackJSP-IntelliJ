<%@ page language="java" contentType="image/jpeg" pageEncoding="UTF-8"%>
<%@ page import="io.minio.MinioClient" %>
<%@ page import="io.minio.GetObjectArgs" %>
<%@ page import="io.minio.errors.MinioException" %>
<%@ page import="io.minio.ConnectMinio" %>
<%@ page import="java.io.InputStream" %>

<%
    try {
        // Minio 클라이언트 초기화
        ConnectMinio connectMinio = new ConnectMinio();
        MinioClient minioClient = connectMinio.getInstance();
        String bucket = "users-photo"; // MinIO 버킷 이름
        String filename = request.getParameter("filename"); // 다운로드할 파일 이름

        InputStream imageStream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucket)
                        .object(filename)
                        .build()
        );

        // 응답의 컨텐츠 타입 설정
//        response.setContentType("image/jpeg");

        // 이미지 바이너리 데이터를 응답에 기록
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = imageStream.read(buffer)) != -1) {
            response.getOutputStream().write(buffer, 0, bytesRead);
        }

        imageStream.close();
    } catch (MinioException e) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving image from MinIO: " + e.getMessage());
    } catch (Exception e) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
    }
%>
