# #!/bin/bash

# # Define RDS credentials
# db_name="${db_name}"
# db_username="${db_username}"
# db_password="${db_password}"

# # Retrieve RDS endpoint
# db_host=$(aws rds describe-db-instances --db-instance-identifier my-wordpress-rds --query 'DBInstances[0].Endpoint.Address' --output text)


# # Connect to the RDS database
# mysql -h "$db_host" -u "$db_username" -p"$db_password" <<EOF
# EOF

# # Update system
# yum update -y

# # Install Apache, PHP, and MariaDB client (for interacting with RDS)
# amazon-linux-extras install -y php8.2 mariadb10.5
# yum install httpd php php-mysqlnd -y

# # Start and enable Apache
# systemctl start httpd
# systemctl enable httpd

# # Enable and start MariaDB
# systemctl enable mariadb
# systemctl start mariadb

# # Add ec2-user to apache group
# usermod -a -G apache ec2-user

# # Change ownership and permissions for /var/www
# chown -R ec2-user:apache /var/www
# chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \;
# find /var/www -type f -exec chmod 0664 {} \;

# # Remove phpinfo.php if exists
# rm -f /var/www/html/phpinfo.php

# # Download and extract WordPress
# cd /var/www/html
# wget -O latest.tar.gz https://wordpress.org/latest.tar.gz
# tar -xzf latest.tar.gz
# cp -r wordpress/* .
# rm -rf wordpress latest.tar.gz

# # Configure WordPress with RDS credentials
# cp wp-config-sample.php wp-config.php
# sed -i "s/database_name_here/$db_name/" wp-config.php
# sed -i "s/username_here/$db_username/" wp-config.php
# sed -i "s/password_here/$db_password/" wp-config.php
# sed -i "s/localhost/$db_host/" wp-config.php

# # Generate salt keys
# SALT_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# # Append salt keys to wp-config.php
# echo "$SALT_KEYS" | tee -a wp-config.php > /dev/null

# # Modify Apache configuration to allow overrides
# sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# # Set ownership and permissions for WordPress directory
# chown -R apache:apache /var/www/html
# chmod -R 755 /var/www/html

# # Restart Apache
# systemctl restart httpd