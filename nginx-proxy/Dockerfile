FROM nginx:alpine

RUN apk add --no-cache tzdata
ENV TZ Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# From: https://www.nginx.com/blog/compiling-and-installing-modsecurity-for-open-source-nginx/

# Compile modsecurity
RUN apk add --update git wget
WORKDIR /home/
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity
WORKDIR /home/ModSecurity
RUN git submodule init
RUN git submodule update
WORKDIR /home/
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar zxvf nginx-${NGINX_VERSION}.tar.gz

# RUN apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
# https://github.com/dotnet/core/issues/226
# https://www.lizettepreiss.com/setup-nginx-alpine-docker-container-modsecurity-redis/
# RUN apk add --update build-base
RUN apk add --update gcc libc-dev linux-headers zlib-dev openrc autoconf automake make curl-dev geoip-dev lmdb-dev pcre-dev libtool libxml2-dev yajl-dev pkgconf g++ libcurl

# RUN cd ModSecurity
WORKDIR /home/ModSecurity
RUN ./build.sh
RUN ./configure
RUN make
RUN make install
RUN make clean

# Compile nginx connector
WORKDIR /home/nginx-${NGINX_VERSION}
RUN ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
RUN make modules
RUN cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
RUN make clean

# Clean
WORKDIR /home/
RUN rm -rf /home/*

# Configure, Enable ModSecurity
# /etc/nginx/nginx.conf load_module modules/ngx_http_modsecurity_module.so;
RUN sed -i -E 's/events\s*\{/include \/etc\/nginx\/modules-enabled\/*.conf;\n\nevents {/g' /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/modules-enabled/
RUN echo 'load_module modules/ngx_http_modsecurity_module.so;' > /etc/nginx/modules-enabled/modsecurity.conf

# Download Recommend rules
RUN mkdir /home/modsec-recommended
# https://github.com/SpiderLabs/ModSecurity/issues/1941
RUN wget -P /home/modsec-recommended/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/unicode.mapping
RUN wget -P /home/modsec-recommended/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
RUN mv /home/modsec-recommended/modsecurity.conf-recommended /home/modsec-recommended/modsecurity.conf
RUN sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /home/modsec-recommended/modsecurity.conf

# Download OWASP rules
RUN git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
RUN cp owasp-modsecurity-crs/crs-setup.conf.example owasp-modsecurity-crs/crs-setup.conf

# Enable Site rules
RUN mkdir /etc/nginx/modsec
COPY ./modsec-default-rules.conf /etc/nginx/modsec/default-rules.conf

# Custom config enabled modsec
# COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
