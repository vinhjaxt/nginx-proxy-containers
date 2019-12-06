# Giới thiệu
Branch này thêm modsecurity vào nginx-proxy

# Sử dụng
Ghi đè vào thôi =))
Sau đó, build lại và sửa config của nginx với từng site muốn sử dụng modsecurity:
```
server {
    listen 80;
    ...
    server_tokens off;
    modsecurity on;
    modsecurity_rules_file /etc/nginx/modsec/default-rules.conf;
    ...
}
```
