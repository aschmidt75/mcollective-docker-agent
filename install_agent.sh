MCOBASEDIR=$(cat /etc/mcollective/server.cfg | awk  '/^libdir/ { print $3 }')/mcollective
echo Installing docker agent to $MCOBASEDIR
cp agent/docker* $MCOBASEDIR/agent/


MCOBASEDIR=$(cat /etc/mcollective/client.cfg | awk  '/^libdir/ { print $3 }')/mcollective
echo Installing docker agent to $MCOBASEDIR
cp application/docker* $MCOBASEDIR/application/

echo Restarting service ...
service mcollective restart
