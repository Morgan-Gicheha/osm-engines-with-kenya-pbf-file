#!/bin/bash

# Create elasticsearch index
if [ ! -d "/photon/photon_data/elasticsearch" ]; then
	echo "Creating search index"
	java -jar photon.jar -nominatim-import -host nominatim -port 5432 -database nominatim -user nominatim -password password1234 -languages es,fr
fi

# Start photon if elastic index exists
if [ -d "/photon/photon_data/elasticsearch" ]; then
	echo "Starting photon"
	java -jar photon.jar -host nominatim -port 5432 -database nominatim -user nominatim -password password1234

	### Start continuous update ###

	# while true; do
	# 	starttime=$(date +%s)
	#
	# 	curl http://localhost:2322/nominatim-update
	#
	# 	# sleep a bit if updates take less than 5 minutes
	# 	endtime=$(date +%s)
	# 	elapsed=$((endtime - starttime))
	# 	if [[ $elapsed -lt 300 ]]; then
	# 		sleepy=$((300 - $elapsed))
	# 		echo "Sleeping for ${sleepy}s..."
	# 		sleep $sleepy
	# 	fi
	# done

else
	echo "Could not start photon, the search index could not be found"
fi
