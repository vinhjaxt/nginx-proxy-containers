#!/usr/bin/env sh
read -p "Enter website name or domain (unique): " localdomainname
cp internal-php.local internal-${localdomainname} -r
cp nginx-proxy/conf.d/php.local.conf nginx-proxy/conf.d/${localdomainname}.conf
mkdir public_html/${localdomainname}
echo 'Hello world, it works!' > public_html/${localdomainname}/index.html
sed -i "s/php.local/${localdomainname}/g" internal-${localdomainname}/.env nginx-proxy/conf.d/${localdomainname}.conf
nano nginx-proxy/conf.d/${localdomainname}.conf

