#!/bin/bash

### Nominatim ###

# Stop existing containers
docker-compose down
docker-compose rm -f
# Clear existing data
sudo rm -Rf ./nominatimdata && mkdir nominatimdata
sudo rm -Rf ./photondata && mkdir photondata

# Build the image
cd nominatim-3.1
docker build -t nominatim .
cd ..
# Get the Rhône-Alpes database
wget --directory-prefix=./nominatimdata https://download.geofabrik.de/africa/kenya-latest.osm.pbf
# Initialize the database
docker run -t \
-v `pwd`/nominatimdata:/data \
mediagis/nominatim \
sh /app/init.sh /data/kenya-latest.osm.pbf postgresdata 4
