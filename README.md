# Giới thiệu
Repo này có khả năng phục vụ nhiều host trên các containers khác nhau của docker thông qua nginx làm proxy. Tất cả các containers này cùng chung một network là nginx-proxy

# Sơ đồ ví dụ
```
Internet ---------> Nginx (docker) --------> php-fpm (docker)
                         |
                         |
                         -------> nodejs (docker)
```
- hostname được đặt ở file .env của php.local và node.local

# Sử dụng
1. Vào thư mục nginx-proxy: `docker-compose build && docker-compose up`
2. Vào thư mục internal-php.local: `docker-compose build && docker-compose up`
2. Vào thư mục internal-node.local: `docker-compose build && docker-compose up`

```bash
curl --resolve php.local:80:127.0.0.1 http://php.local/
curl --resolve node.local:80:127.0.0.1 http://node.local/
```
