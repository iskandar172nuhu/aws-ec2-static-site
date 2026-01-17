#!/usr/bin/env bash
set -euo pipefail

apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html <<'HTML'
<!doctype html>
<html>
<body>
  <h1>EC2 Nginx Static Site</h1>
  <p>Deployed automatically using cloud-init.</p>
</body>
</html>
HTML

echo "ok" > /var/www/html/health

systemctl enable nginx
systemctl restart nginx

