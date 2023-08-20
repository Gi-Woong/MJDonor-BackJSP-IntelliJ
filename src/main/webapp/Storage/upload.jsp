<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="io.minio.MinioClient" %>
<%@ page import="io.minio.PutObjectArgs" %>
<%@ page import="io.minio.errors.MinioException" %>
<%@ page import="io.minio.ConnectMinio" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>

<%
response.setContentType("application/json");
Map<String, Object> jsonResponse = new HashMap<>();

try {
    // Minio 클라이언트 초기화
    ConnectMinio connectMinio = new ConnectMinio();
    MinioClient minioClient = connectMinio.getInstance();
    String bucket = "users-photo"; // MinIO 버킷 이름

    HttpServletRequest httpRequest = (HttpServletRequest) request;


    if (ServletFileUpload.isMultipartContent(httpRequest)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        List<FileItem> items = upload.parseRequest(httpRequest);
        for (FileItem item : items) {
            if (!item.isFormField() && item.getContentType().startsWith("image/")) {
                String fileName = item.getName();
                InputStream fileContent = item.getInputStream();

                // MinIO에 파일 업로드
                minioClient.putObject(
                    PutObjectArgs.builder()
                        .bucket(bucket)
                        .object(fileName)
                        .stream(fileContent, -1, PutObjectArgs.MIN_MULTIPART_SIZE)
                        .build()
                );
                response.setStatus(HttpServletResponse.SC_OK); // OK 상태 코드 (200)
                jsonResponse.put("success", true);
                jsonResponse.put("message", "File uploaded successfully to MinIO: " + fileName);
            }
            else {
                    // 이미지가 아닌 경우는 처리하지 않음
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Bad Request 상태 코드 (400)
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "File is not an image. Skipped processing.");

                }
        }
    }
} catch (MinioException e) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Internal Server Error 상태 코드 (500)
    jsonResponse.put("success", false);
    jsonResponse.put("message", "Error uploading file to MinIO: " + e.getMessage());
} catch (Exception e) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Internal Server Error 상태 코드 (500)
    jsonResponse.put("success", false);
    jsonResponse.put("message", "An error occurred: " + e.getMessage());
}

JSONObject json = new JSONObject();
json.putAll(jsonResponse);
out.print(json.toJSONString());
%>
