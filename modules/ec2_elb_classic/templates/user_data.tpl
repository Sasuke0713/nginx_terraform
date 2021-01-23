#!/bin/bash

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7oS5p6qcyw1tcnC4yBfj3g1B7W/uJV5AB5YxhXDcbvc/OnQLwRiFNklVa9VvzrPYYxXRAq6NNy6bG/q32aTNsQbzjQVqVs2KRxyuzfj3mi/YkL2j6jhyWJqIrwU2Sd0gbVz1sscEs4CU8tK0yikx1KjKSmaNnC9EQMYkFakeFdTauOSTfenTkDZ2+VK2dyrfeiPphCLZxtsvGOcdJg2HcIBADUMfpKG66FnYSsCdOhGTxWqcIkn10G2BUQSVvafMfcXKq3EAixmi1ByUEcUoNcmBgYXvs/i+vKgdpcgl1ITQrx0nBcaoc0rycCdfnlM2s8eiNskH9vJataAs2k1iOExKO/iLv01iK/YHNFMI7wQvbxapd8trFf7rwbQf4ccdeAcdTPUKKKR0cmNe3xv0ZaZy6qMx/CS0fyCMRSekWdrsQIrbq0TMl+Tqe8a9jcUJjgKewmx8HwGwJp0dS4IVBpaeBLWiSZeYf8MKM6TjtM29ucZAjdEtBD42/mhaxbuj7bgqmjti8oHoud5A42oR3QIzyU8pO2pXdEyqwu0P0QVxp22pKoAk2C263uHiMFdCrSHw2JYuz2LrH6DRn9WM75q9H7qMBiRkkzawrvVraOnYONg2X8xyKAJ+Rhn6mGfu5ipRpz1pu0CaEPvbNs+O2ZrC1Ya5xABDp4mqK21ylyQ== pbarrett" > /home/ubuntu/.ssh/authorized_keys

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

apt-get install docker.io -y
docker pull nginx:stable

sudo mkdir -p /var/www/${webpage}/html
sudo chmod -R 755 /var/www/${webpage}

cat <<EOT >> /var/www/${webpage}/html/index.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>${title_webpage}</title>
</head>
</html>
EOT

docker run --name ${webpage}-nginx -v /var/www/${webpage}/html:/usr/share/nginx/html:ro -p 8080:80 -d nginx:stable
