PS3='Would you like to install Harbor based on IP or FQDN? '
select option in IP FQDN
do
    case $option in
        IP)
            IPorFQDN=$(hostname -I|cut -d" " -f 1)
            break;;
        FQDN)
            IPorFQDN=$(hostname -f)
            break;;
     esac
done


#Install Latest Stable Harbor Release
HARBORVERSION=$(curl -s https://github.com/goharbor/harbor/releases/latest/download 2>&1 | grep -Po [0-9]+\.[0-9]+\.[0-9]+)
curl -s https://api.github.com/repos/goharbor/harbor/releases/latest | grep browser_download_url | grep online | cut -d '"' -f 4 | wget -qi -
tar xvf harbor-online-installer-v$HARBORVERSION.tgz
cd harbor
sed -i "s/reg.mydomain.com/$IPorFQDN/g" harbor.yml
./install.sh --with-clair --with-chartmuseum
echo -e "Harbor Installation Complete \n\nPlease log out and log in or run the command 'newgrp docker' to use Docker without sudo\n\nLogin to your harbor instance:\n docker login -u admin -p Harbor12345 $IPorFQDN"
