#!/bin/bash

# check root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 0
fi

echo "You can enter multiple versions through 'space'."
echo "Enter php version/versions(for example 5.6 7.0 7.1 7.2 7.3 7.4 8.0):"
read -p ">" vers

apt update
add-apt-repository ppa:ondrej/php
a2enmod cgi

site_link="https://raw.githubusercontent.com/rikcage/vst-php-selector/main/cgi"

for ver in $vers; do

    apt install -y php$ver php$ver-fpm php$ver-cgi

    wget $site_link/phpcgi-$ver.stpl -O /usr/local/vesta/data/templates/web/apache2/phpcgi-$ver.stpl
    wget $site_link/phpcgi-$ver.tpl -O /usr/local/vesta/data/templates/web/apache2/phpcgi-$ver.tpl
    wget $site_link/phpcgi-$ver.sh -O /usr/local/vesta/data/templates/web/apache2/phpcgi-$ver.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/phpcgi-$ver.sh

done

systemctl restart apache2
