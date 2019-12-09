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
với wordpress:
```
    location ~ ^/wp-admin/(post|admin-ajax|edit)\.php(/|$) {
        modsecurity off;
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        if (!-f $document_root$fastcgi_script_name) {
            return 404;
        }

        # Mitigate https://httpoxy.org/ vulnerabilities
        fastcgi_param HTTP_PROXY "";

        # fastcgi_pass internal-percre.com:9000;
        fastcgi_pass unix:/home/run/php.local/unix.sock;
        fastcgi_index index.php;

        # include the fastcgi_param setting
        include fastcgi_params;

        # SCRIPT_FILENAME parameter is used for PHP FPM determining
        #  the script name. If it is not set in fastcgi_params file,
        # i.e. /etc/nginx/fastcgi_params or in the parent contexts,
        # please comment off following line:
        fastcgi_param  SCRIPT_FILENAME   /home/public_html$fastcgi_script_name;
    }
```
