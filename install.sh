clear;
echo "";
echo "";
echo "";
echo "";
echo "Atlassian Installation";
echo "";
echo "";
echo "";
echo "";
echo "HIER KÖNNTE IHRE WERBUNG STEHEN";
echo "Adresse:DES GEHT DICH GAR NICHTS AN!";
echo "";
read -t 5 -n 1 -s -r -p "Press any key to continue"
clear
apt update && apt upgrade -y && apt dist-upgrade -y
apt install -y wget curl apache2 gzip unzip mysql*
clear
echo "Verzeichnisse werden erstellt";
read -t 5 -n 1 -s -r -p "Press any key to continue"\n;
mkdir -p /opt/atlassian
mkdir -p /opt/inst_files/mysql_connect
cd /opt/inst_files
clear;
###################################################DOWNLOAD CONFLUENCE################################################
echo "Download der Installationsdateien";
echo "";
echo "Download Atlassian Confluence";
echo "";
wget https://maier-itservice.de/download/atlassian-confluence-7.12.4-x64.bin -O /opt/inst_files/atlassian-confluence-7.12.4-x64.bin
cd /opt/inst_files/mysql_connect
echo "Download Mysql-Connector";
wget https://maier-itservice.de/download/mysql-connector-java-8.0.25.zip -O /opt/inst_files/mysql-connector-java-8.0.25.zip
read -t 5 -n 1 -s -r -p "Press any key to continue"
echo "Files ausführbar machen"\n;
chmod a+x /opt/inst_files/atlassian-confluence-7.12.4-x64.bin
echo "Files kopieren";
##################################################MYSQL - CONNECTOR#################################################
mv /opt/inst_files/mysql-connector-java-8.0.25.zip /opt/inst_files/mysql_connect/
cd /opt/inst_files/mysql_connect/
unzip mysql-connector-java-8.0.25.zip -d /opt/inst_files/mysql_connect/
cd mysql-connector-java-8.0.25
mkdir -p /opt/atlassian/confluence
mkdir -p /opt/atlassian/aconfluence/confluence
mkdir -p /opt/atlassian/confluence/confluence/WEB-INF
mkdir -p /opt/atlassian/confluence/confluence/WEB-INF/lib
cp /opt/inst_files/mysql_connect/mysql-connector-java-8.0.25/mysql-connector-java-8.0.25.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
cd /
cd /etc
echo "file:hosts ändern";
################################################ÄNDERN DES HOSTFILES##################################################
mv hosts hosts.backup
ip4=$(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1)
hs=`hostname`
echo -e '127.0.0.1 localhost\n127.0.1.1 '${hs}'\n'${ip4}' '${hs}'\n\n # The following lines are desirable for IPv6 capable hosts\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet
ff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters' >>hosts
###############################################MYSQL DATENBANK UND USER ANLEGEN#################################################
echo "Configuration Mysql File";
cd /etc/mysql
mv /etc/mysql/my.cnf /etc/mysql/my.cnf_backup
wget https://github.com/Bastelkiste/mysql/blob/201badcc84d377cd5dab85cb17b02a10b47844c6/my.cnf
#echo -e '!includedir /etc/mysql/conf.d/\n !includedir /etc/mysql/mysql.conf.d/\n [mysqld]\ncharacter-set-server=utf8mb4\ndefault-storage-engine=INNODB\nmax_allowed_packet=256M\ninnodb_log_file_size=2G\ntransaction-isolation=READ-COMMITTED\nbinlog_format=row\ninnodb_default_row_format=DYNAMIC\nlog_bin_trust_function_creators=1' >>/etc/mysql/my.cnf
echo "Datenbank + User anlegen";
mysql -e "CREATE DATABASE cfdb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -e "CREATE USER 'maincfuser'@'localhost' IDENTIFIED BY 'admin123';"
mysql -e "GRANT ALL PRIVILEGES ON cfdb.* TO 'maincfuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
echo "Systemupdate,download der benötigten packages und einrichten";
echo "abgeschlossen - Setup wird vorgesetzt";
read -t 5 -n 1 -s -r -p "Press any key to continue"\n
#############################################AUSFÜHREN DES SETUPSCRIPTES VON ATLASSIAN CONFLUENCE################################
echo "Atlassian Setup wird gestartet";
cd /opt/inst_files/
./atlassian-confluence-7.12.4-x64.bin
