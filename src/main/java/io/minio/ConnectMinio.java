package io.minio;

public class ConnectMinio {
    private final MinioClient instance;

    public ConnectMinio() {

        java.util.ResourceBundle resource = java.util.ResourceBundle.getBundle("config");
        String endpoint = resource.getString("minio.endpoint");
        String accessKey = resource.getString("minio.accessKey");
        String secretKey = resource.getString("minio.secretKey");
        instance =
                MinioClient.builder()
                        .endpoint(endpoint)
                        .credentials(accessKey, secretKey)
                        .build();
    }

    public MinioClient getInstance() {
        return instance;
    }

}
