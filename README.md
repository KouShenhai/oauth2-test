# OAuth2 Authorization Server Client Credentials Demo

这个工程使用 Spring Boot 4.1 和 Spring Security OAuth2 Authorization Server 实现
`client_credentials` 授权模式，并提供一个受 `message.read` scope 保护的示例资源接口。

## 启动

```powershell
mvn spring-boot:run
```

默认端口是 `9000`。

## 获取 Access Token

```powershell
$response = Invoke-RestMethod `
  -Method Post `
  -Uri "http://localhost:9000/oauth2/token" `
  -Authentication Basic `
  -Credential (New-Object PSCredential "machine-client", (ConvertTo-SecureString "machine-secret" -AsPlainText -Force)) `
  -ContentType "application/x-www-form-urlencoded" `
  -Body "grant_type=client_credentials&scope=message.read"

$token = $response.access_token
$token
```

也可以用 curl：

```bash
curl -u machine-client:machine-secret \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&scope=message.read" \
  http://localhost:9000/oauth2/token
```

## 访问受保护接口

```powershell
Invoke-RestMethod `
  -Uri "http://localhost:9000/api/messages" `
  -Headers @{ Authorization = "Bearer $token" }
```

返回中会包含 `clientId`、`message` 和 token 里的 `scope`。

## 默认客户端

| 配置项 | 值 |
| --- | --- |
| Client ID | `machine-client` |
| Client Secret | `machine-secret` |
| Grant Type | `client_credentials` |
| Scopes | `message.read`, `message.write` |
| Token Endpoint | `http://localhost:9000/oauth2/token` |
