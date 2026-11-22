# xray VLESS+WS（PaaS 形态：平台 TLS 终结，容器内明文 WS）
FROM alpine:3.20
RUN apk add --no-cache ca-certificates curl unzip
WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
