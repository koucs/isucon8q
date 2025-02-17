# restart.sh
echo "start deploying"

# sudo -H -u isucon bash -c 'source /home/isucon/.bash_profile && cd /home/isucon/torb/webapp/go && git fetch origin master && git reset --hard origin/master && make'
sudo -H -u isucon bash -c 'source /home/isucon/.bash_profile && cd /home/isucon/torb/webapp/python && git fetch origin master && git reset --hard origin/master && sh ./setup.sh'
sudo -H bash -c "cp /home/isucon/torb/config/torb.python.service /etc/systemd/system/torb.python.service"
sudo systemctl daemon-reload
sudo systemctl restart torb.python.service

# Clean up /var/log/h2o/access.log
sudo -H bash -c "echo '' > /var/log/h2o/access.log"
sudo -H bash -c "cp /home/isucon/torb/config/h2o/h2o.conf /etc/h2o/h2o.conf"
sudo systemctl restart h2o.service

sudo -H bash -c "cp /home/isucon/torb/config/mysql/server.cnf /etc/my.cnf.d/server.cnf"
if sudo mysqladmin -uroot status; then
  sudo mysqladmin -uroot flush-logs
fi
sudo systemctl restart mariadb

echo "end deploying"