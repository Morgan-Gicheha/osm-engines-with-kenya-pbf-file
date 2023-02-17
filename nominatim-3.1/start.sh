#!/bin/bash
service postgresql start
/usr/sbin/apache2ctl start

## Set up nominatim updates ###

while true; do

	result=`sudo -u nominatim ./src/build/utils/update.php --check-for-updates`

	if [ "$result" = "Database up to date." ]; then
		sleepy=300 
		echo "The Nominatim database in already up to date. Sleeping for ${sleepy}s..."
                sleep $sleepy
	else

		curl http://photon:2322/api
		isPhotonAlive=$?

		if [ $isPhotonAlive -ne 0 ]; then
			sleepy=300
			echo "Photon is not available. Sleeping for ${sleepy}s, in order to let Photon wake up..."
			sleep $sleepy
			continue
		fi

		sudo -u nominatim ./src/build/utils/update.php --init-updates
		sudo -u nominatim ./src/build/utils/update.php --import-osmosis --no-index
		curl -v http://photon:2322/nominatim-update # this line triggers the Photon update following the Nominatim update

		sleepy=1800
		echo "Sleeping for ${sleepy}s, in order to let Photon update..."
		sleep $sleepy

		sudo -u nominatim ./src/build/utils/update.php --index

	fi

done



## Follow log ###

#tail -f /var/log/postgresql/postgresql-9.5-main.log
