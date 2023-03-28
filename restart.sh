#!/bin/bash

# Pull latest image
sudo docker pull muahmmetburakgolec/website

# Find container ID
container_id=$(sudo docker ps -q --filter ancestor=muhammetburakgolec/website)

# kill container
if [ ! -z "$container_id" ]; then
  sudo docker kill $container_id
  echo "Container $container_id killed."
else
  echo "No container found."
fi

# Run lastest image
sudo docker run -p 8081:8000 -d muhammetburakgolec/website

# Remove unused images
sudo docker system prune -a

# Restart nginx
sudo systemctl restart nginx

sleep 4

# CPU yüzdesi
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Yük (load)
load=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')

# Kullanılan RAM miktarı
memory_used=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

# Print the summary
echo $(sudo systemctl status nginx)
echo " "
echo "Server status summary"
echo "CPU kullanımı: $cpu_usage"
echo "Yük: $load"
echo "Kullanılan RAM: $memory_used"
