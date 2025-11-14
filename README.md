# 🚀 Caddy Docker Stack - Multi-Language Web Server

A complete Docker-based development stack with Caddy as reverse proxy, serving multiple web applications across different programming languages (PHP, Go, Python) in isolated containers.

## 🌟 Features

- **🔄 Reverse Proxy**: Caddy server with automatic virtual host routing
- **🐘 PHP Applications**: Laravel, Symfony, WordPress, and static sites
- **⚡ Go Microservice**: High-performance Go application
- **🐍 Django Framework**: Python web application
- **🗄️ Database**: MariaDB with phpMyAdmin management
- **🔒 Isolated Containers**: Secure, independent service architecture

## 🛠 Tech Stack

- **Web Server**: Caddy 2
- **PHP**: PHP-FPM 8.3 with extensions (GD, MySQL, ZIP)
- **Database**: MariaDB + phpMyAdmin
- **Containers**: Docker + Docker Compose
- **Languages**: PHP, Go, Python
- **Frameworks**: Laravel, Symfony, WordPress, Django

---

## 📥 Installation Step by Step

### 1. Prerequisites

```bash
# Install Docker and Docker Compose
# Visit: https://docs.docker.com/get-docker/
```

### 2. Clone the Repository
```bash
git clone https://github.com/DjKhireddine/caddy_server_multi_sites.git
cd caddy_server_multi_sites
```

### 3. Environment Configuration
```bash
# Copy the environment template
cp .env.example .env

# Edit the configuration
nano .env  # or use your favorite editor
```

Configure these key variables in .env:

```bash
# Domain configuration
DOMAIN=your_domain.dev

# Database configuration
DB_HOST=mariadb
DB_ROOT_PASSWORD=your_secure_password
DB_USER=your_DB_USER
DB_PASSWORD=your_DB_PASSWORD

# Application paths (usually keep defaults)
PROJECTS_PATH=/var/www
LARAVEL_ROOT=${PROJECTS_PATH}/PHP/laravel/public
SYMFONY_ROOT=${PROJECTS_PATH}/PHP/symfony/public
WORDPRESS_ROOT=${PROJECTS_PATH}/PHP/wordpress
```

### 4. Configure Local DNS (Hosts File)
#### 🐧 Linux / macOS
```bash
sudo nano /etc/hosts
```
Add these lines:
```bash
127.0.0.1 laravel.mydomain.com
127.0.0.1 symfony.your_domain.dev
127.0.0.1 wordpress.your_domain.dev
127.0.0.1 php.your_domain.dev
127.0.0.1 html.your_domain.dev
127.0.0.1 landing.your_domain.dev
127.0.0.1 phpmyadmin.your_domain.dev
127.0.0.1 go.your_domain.dev
127.0.0.1 django.your_domain.dev
```
#### 🪟 Windows
- Open Notepad as Administrator
- File → Open → C:\Windows\System32\drivers\etc\hosts
- Add the same lines as above
- Save the file

## Install missed applications
```bash
# access to your PHP path
cd site/PHP
# create laravel project
composer create-project laravel/laravel laravel
# create symfony project
composer create-project symfony/skeleton symfony
```

## 🗄️ Database Setup
### Start database service
```bash
make start-db
```
### Create Databases for Applications
After starting the stack, you can create databases for your Wordpress and Django applications:

```bash
# Access MySQL container
docker compose exec db mysql -u root -p

# In MySQL, create databases:
CREATE DATABASE wordpress;
CREATE DATABASE django;

GRANT ALL PRIVILEGES ON wordpress.* TO 'your_db_user'@'%';
GRANT ALL PRIVILEGES ON django.* TO 'your_db_user'@'%';

FLUSH PRIVILEGES;

```

## 🚀 Usage
### Start All Services
From the root of your project
```bash
make start
```
This will start:

- ✅ Caddy reverse proxy (port 80)
- ✅ PHP-FPM service
- ✅ MariaDB database
- ✅ phpMyAdmin (port 8080)
- ✅ Go application
- ✅ Django application

### Access Your Applications
After starting, access these URLs in your browser:

- 🌐 HTML Site: https://html.your_domain.dev
- 🐘 PHP Simple: https://php.your_domain.dev
- 📱 Landing Page: https://landing.your_domain.dev
- ⚡ Laravel: https://laravel.your_domain.dev
- 🎯 Symfony: https://symfony.your_domain.dev
- 📝 WordPress: https://wordpress.your_domain.dev
- 🛠️ Go App: https://go.your_domain.dev
- 🐍 Django: https://django.your_domain.dev
- 🗄️ phpMyAdmin: https://phpmyadmin.your_domain.dev

### Management Commands
```bash
# Start all services
make start

# Stop all services
make stop

# Restart all services
make restart

# Check service status
make status

# View Caddy logs
make logs-caddy

# View all logs
make logs

# Clean everything (containers, volumes, networks)
make clean

# Rebuild and restart all services
make rebuild
```

### Individual Service Control
```bash
# Start only Caddy + PHP
make start-caddy

# Start only database
make start-db

# Start only Go app
make start-go

# Start only Django
make start-django
```

## 🏗️ Project Structure
```
caddy_server_multi_sites/
├── 🐳 docker-compose.yml          # Main orchestration
├── ⚙️ Makefile                    # Automation commands
├── 🔧 .env.example                # Environment template
├── 📁 caddy/                      # Caddy reverse proxy
│   ├── 🐳 Dockerfile              # Caddy with envsubst
│   ├── 📄 Caddyfile.template      # Dynamic configuration
│   └── 🚀 start-caddy.sh          # Startup script
├── 📁 services/                   # Individual service configs
│   ├── 📁 php/                    # PHP-FPM configuration
│   ├── 📁 go/                     # Go service
│   ├── 📁 node/                   # Node service
│   ├── 📁 python/                 # Django service
│   └── 📁 database/               # MariaDB + phpMyAdmin services
└── 📁 sites/                      # Web applications
    ├── 📁 PHP/
    │   ├── 🎯 laravel/            # Laravel application
    │   ├── ⚡ symfony/             # Symfony application
    │   ├── 📝 wordpress/          # WordPress site
    │   ├── 🐘 php-simple/         # Simple PHP scripts
    │   ├── 🌐 html/               # Static HTML site
    │   └── 📱 landingpage/        # Landing page
    ├── 📁 NODE/
    │   └── 🎯 express/            # NodeJS application
    ├── 📁 GO/
    │   └── 📚 gin/                # Go application
    └── 📁 PYTHON/
        └── 🐍 django/             # Django project
```

## 🔧 Development
### Adding New PHP Application
1. Add directory in `sites/PHP/your-app/`
2. Add configuration in `caddy/Caddyfile.template`:

```caddy
@yourapp host yourapp.{$DOMAIN}
handle @yourapp {
    root * /var/www/PHP/your-app/public
    php_fastcgi php:{$PHP_INTERNAL_PORT}
    file_server
}
```

3. Add to /etc/hosts: 127.0.0.1 yourapp.your_domain.dev
4. Restart: make restart

### Custom Domains
Edit `DOMAIN` in `.env` to use your own domain:

```env
DOMAIN=localhost
# or
DOMAIN=myproject.test
```

## 🐛 Troubleshooting
### Common Issues
#### Port 80 already in use:
```bash
sudo lsof -i :80
# Kill the process or change CADDY_HTTP_PORT in .env
```

#### Hosts file not working:
- On Windows: Run Notepad as Administrator
- On Linux/macOS: Use `sudo`

#### Database connection issues:
- Check if database container is running: `docker ps`
- Verify credentials in `.env`
- Check database exists in phpMyAdmin

#### Application not loading:
- Check logs: make logs-caddy
- Verify directory structure exists
- Check file permissions

### Logs and Debugging
```bash
# View specific service logs
make logs-caddy
make logs-go
make logs-django
make logs-db

# Real-time monitoring
docker compose logs -f

# Check service status
docker ps
docker network ls
```

## 📝 License
This project is open source and available under the MIT License.

## 🤝 Contributing
1. Fork the project 
2. Create your feature branch (git checkout -b feature/AmazingFeature)
3. Commit your changes (git commit -m 'Add some AmazingFeature')
4. Push to the branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

## 📞 Support
If you have any questions or issues, please open an issue on GitHub.

### Happy coding! 🚀

This stack is perfect for development, testing, and learning multi-language web application deployment.
```
Ce README fournit :

1. **✅ Instructions d'installation complètes** avec copie du .env
2. **✅ Configuration hosts pour Linux/macOS/Windows**
3. **✅ Configuration des bases de données** pour chaque application
4. **✅ Commandes Make** bien expliquées
5. **✅ Structure du projet** claire
6. **✅ Dépannage** des problèmes courants
7. **✅ Exemples de configuration** pour chaque framework

Votre projet est maintenant parfaitement documenté ! 🎉
```
