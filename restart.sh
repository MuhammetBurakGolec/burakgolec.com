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

# Get nginx status summary
status=$(curl -s http://localhost/nginx_status)

# Parse the status information
active=$(echo "$status" | grep 'Active' | awk '{print $NF}')
reading=$(echo "$status" | grep 'Reading' | awk '{print $2}')
writing=$(echo "$status" | grep 'Writing' | awk '{print $4}')
waiting=$(echo "$status" | grep 'Waiting' | awk '{print $6}')

# CPU yüzdesi
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Yük (load)
load=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')

# Kullanılan RAM miktarı
memory_used=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

# Print the summary
echo "Nginx status summary"
echo "Active connections: $active"
echo "Reading: $reading"
echo "Writing: $writing"
echo "Waiting: $waiting"
echo ""
echo "Server status summary"
echo "CPU kullanımı: $cpu_usage"
echo "Yük: $load"
echo "Kullanılan RAM: $memory_used"
