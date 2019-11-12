# Giới thiệu
Repo này có khả năng phục vụ nhiều host trên các containers khác nhau của docker thông qua nginx làm proxy. Tất cả các containers này cùng chung một network là nginx-proxy

# Sơ đồ ví dụ
```
Internet ---------> Nginx (docker-container) --------> php-fpm (docker-container)
                         |
                         |
                         -------> nodejs (docker-container)
```
- hostname được đặt ở file `.env` của `internal-php.local` và `internal-node.local`

# Sử dụng nhanh
Tạo network: `docker network create nginx-proxy`
1. Vào thư mục `nginx-proxy`:
 - build: `docker-compose build`
 - start nginx: `docker-compose up -d`
2. Vào thư mục `internal-php.local`:
 - build: `docker-compose build`
 - start site php.local `docker-compose up` (Ctrl-C để stop site php.local)
 - thêm `127.0.0.1 php.local` vào `/etc/hosts`, truy cập: [http://php.local](http://php.local)
 - nếu không muốn thêm vào file hosts, bạn có thể sử dụng `curl --resolve php.local:80:127.0.0.1 http://php.local/`
2. Vào thư mục `internal-node.local`:
 - build: `docker-compose build`
 - start site node.local `docker-compose up` (Ctrl-C để stop site node.local)
 - thêm `127.0.0.1 node.local` vào `/etc/hosts`, truy cập: [http://node.local](http://node.local)
 - nếu không muốn thêm vào file hosts, bạn có thể sử dụng `curl --resolve node.local:80:127.0.0.1 http://node.local/`

# Giới thiệu sâu
1. Cây thư mục:
```bash
$ tree -a .
.
├── data
│   ├── node.local
│   │   └── postgresql
│   └── php.local
│       ├── mysql
│       └── redis
├── internal-node.local
│   ├── app
│   │   └── app.js
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── .env
│   └── postgresql
│       └── Dockerfile
├── internal-php.local
│   ├── conf
│   │   ├── custom-php-fpm.conf
│   │   └── custom-php.ini
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── .env
│   ├── mysql
│   │   └── Dockerfile
│   └── redis
│       ├── Dockerfile
│       ├── entrypoint.sh
│       └── redis.conf
├── nginx-proxy
│   ├── conf.d
│   │   ├── default.conf
│   │   ├── node.local.conf
│   │   └── php.local.conf
│   ├── docker-compose.yml
│   └── Dockerfile
├── public_html
│   ├── node.local
│   │   └── index.html
│   └── php.local
│       ├── index.php
│       ├── nginx-index.html
│       └── phpinfo.php
├── README.md
└── run
    ├── main
    │   ├── node.local
    │   │   └── unix.sock
    │   └── php.local
    │       └── unix.sock
    ├── node.local
    │   └── postgresql
    │       ├── .s.PGSQL.5432
    │       └── .s.PGSQL.5432.lock
    └── php.local
        ├── mysqld
        │   └── mysqld.sock
        └── redis
            └── redis.sock
```
- thư mục `./data` là nơi lưu trữ data của csdl, redis,.. bạn nên lưu trữ data của ứng dụng vào đây để tiện cho việc backup sau này
- thư mục `./run` chứa các tập tin unix socket cho việc kết nối IPC: `./run/main` cho việc kết nối IPC giữa nginx và apps, `./run/[HOST_NAME]/*` cho việc kết nối IPC giữa app với dbms hoặc các container khác mà app cần tới, ví dụ: với app node.local, file unix socket `./run/node.local/postgresql/.s.PGSQL.5432` được dùng để giao tiếp giữa node và postgresql; `node` sẽ kết nối với `postgresql` qua file `/var/run/postgresql/.s.PGSQL.5432` (đọc file [./internal-node.local/docker-compose.yml](./internal-node.local/docker-compose.yml))
- thư mục `./public_html/[HOST_NAME]` được sử dụng để lưu trữ trang web tương ứng với từng HOST_NAME (node.local hay php.local)
- các files `./nginx-proxy/conf.d/[HOST_NAME].conf` chứa thông tin cấu hình của nginx tương ứng với từng HOST_NAME
- các thư mục `./internal-node.local` và `./internal-php.local` chứa thông tin cấu hình của container cũng như php hay nodejs. Trong các thư mục này chứa file `.env` với biến `HOST_NAME` định nghĩa hostname là `node.local` hay `php.local`. `.env` cũng chứa thông tin đăng nhập database
- Sau khi bạn thay đổi cấu hình nginx, hãy restart lại container `nginx-proxy`

# Làm sao để backup dữ liệu?
Đơn giản là backup thư mục `data`, ví dụ như:
1. `sudo zip data.zip data -r`
2. Chuyển file data.zip đến server đích: `unzip data.zip`

# Làm sao để backup code?
Backup các thư mục sau: `internal-*`, `public_html`, `nginx-proxy`. Ví dụ
1. `zip backup.zip internal-* public_html nginx-proxy -r`
2. Chuyển file backup.zip đến server đích: `unzip backup.zip`

# Làm sao để thêm một website mới?
Xác định hostname. Ví dụ bạn muốn tạo website với hosttname là: example.com
1. Tạo thư mục `internal-example.com`: Setup container trong này, file .env với HOST_NAME=example.com. App cần listen unix file với đường dẫn `/home/run/unix.sock` hoặc tcp (ưu tiên unix file). Mount `../public_html/[hostname]/` thành thư mục bạn cần trên container, mount `../run/main/[hostname]` thành `/home/run` trên container. Nếu ứng dụng có dbms, hãy mount `../data/[hostname]/dbms` thành nơi lưu data trên container của dbms đó
2. Tạo file config của nginx `./nginx-proxy/conf.d/[hostname].conf`: File config cần cấu hình sao cho nginx kết nối với app qua tcp hoặc unix file `/home/run/[hostname]/unix.sock`
và sau đó là docker-compose build/up, restart nginx-proxy
Hoặc, đơn giản hơn là copy `internal-php.local` hoặc `internal-node.local` rồi thay đổi một chút, một chút hihi (tham khảo dưới đây) =)))

# Làm thế nào để thêm nhanh một website php với mysql, redis?
Ví dụ hostname là example.com
1. Copy những thứ cần thiết từ php.local
```bash
cp internal-php.local internal-example.com -r
cp nginx-proxy/conf.d/php.local.conf nginx-proxy/conf.d/example.com.conf
cp public_html/php.local public_html/example.com -r
```
2. Thay `php.local` thành `example.com`
```bash
sed -i 's/php.local/example.com/g' internal-example.com/.env nginx-proxy/conf.d/example.com.conf
```
3. Vào thư mục `internal-example.com`
```bash
docker-compose build
docker-compose up
```
4. Restart nginx
```bash
docker restart nginx-proxy
```

# Làm thế nào để thêm nhanh một website nodejs với postgresql?
Tương tự, copy `internal-node.local` và file cấu hình cũng như thư mục `public_html/node.local`. Sau đó thay thế node.local thành hostname của bạn

# Tôi không thể truy cập php.local hay node.local?
- Hãy chắc chắn rằng bạn đã start `nginx-proxy` và `internal-node.local` hay `internal-php.local`.
- Sử dụng `docker ps` để kiểm tra container nào đang chạy

# Website của tôi không thể upload, tạo file mới lên public_html?
Đơn giản, hãy chmod 777 thư mục bạn muốn ghi lên đó.
Bạn có thể chmod `./public_html/[hostname]` hoặc `docker exec` rồi chmod `/home/public_html` trong container

# Kết
Hãy đọc các tệp `docker-compose.yml` trong `internal-php.local` và `internal-node.local` để hiểu hơn về cấu trúc.

Nếu bạn thấy có gì sai sai, cứ tạo một issue, pull request để fix lại vấn đề đó. Cảm ơn bạn!

@vinhjaxt
