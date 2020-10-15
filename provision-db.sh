set -e
cd /vagrant/html/waca/sql

./test_db.sh 1 localhost acc acc vagrant
mysql -u acc -pvagrant acc < /vagrant/data.sql

touch /vagrant/html/waca/.sql-setup