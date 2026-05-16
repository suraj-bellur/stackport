# StackPort - Multi-Tier DevOps Lab Application

StackPort (formerly VProfile demo) is a lightweight, full-stack Spring MVC application designed for practicing realistic infrastructure deployment, provisioning, and DevOps workflows. It's an internal directory and profile management system that exercises modern deployment patterns across multiple tiers.

## Project Overview

StackPort is a repeatable, full-stack target for DevOps practice, allowing you to:
- Practice automated provisioning and deployment pipelines
- Exercise multi-tier infrastructure (web, application, caching, messaging, and data layers)
- Customize branding, features, and backing services without modifying core flows
- Implement realistic Spring MVC patterns in a lab environment

**Maven Artifact:** `stackport-v2.war`

---

## Prerequisites

### Required Software
- **JDK 17 or 21** - Java Development Kit
- **Maven 3.9+** - Build automation tool
- **MySQL 8.0+** - Relational database
- **Git** - Version control

### Optional (for full stack deployment)
- **Tomcat 8/9/10** - Application server
- **Memcached** - Caching layer
- **RabbitMQ** - Message broker
- **Elasticsearch** - Search and analytics
- **Nginx** - Reverse proxy/web server

---

## Core Technologies

### Backend Stack
- **Spring Framework**
  - Spring MVC - Web framework
  - Spring Security - Authentication & authorization
  - Spring Data JPA - Object-relational mapping
  - Spring AMQP - Message-driven architecture
  
- **Build & Dependency Management**
  - Maven 3.9
  - JUnit - Unit testing
  
### Frontend Stack
- **JSP (JavaServer Pages)** - Server-side templating
- **Bootstrap 3.3.7** - Responsive CSS framework
- **jQuery 3.2.1** - JavaScript library
- **Font Awesome 4.7.0** - Icon library
- **Material Design Iconic Font** - Additional icons

### Infrastructure & Services
- **Tomcat 8/9/10** - Servlet container
- **MySQL 8** - Primary database
- **Memcached** - Session and data caching
- **RabbitMQ** - Asynchronous message processing
- **Elasticsearch** - Full-text search and logging
- **Nginx** - Web server & load balancer

---

## Database Setup

### Database Initialization

The application uses **MySQL** with a pre-configured database schema.

#### SQL Dump Location
- Path: `src/main/resources/db_backup.sql`
- Contains: Complete database schema and initial data for the `accounts` database

#### Import Database
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE accounts"

# Import dump file
mysql -u root -p accounts < src/main/resources/db_backup.sql

# Verify
mysql -u root -p -e "USE accounts; SHOW TABLES;"
```

#### Database Configuration
Configure database connection in application properties:
```properties
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/accounts?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
jdbc.username=admin
jdbc.password=admin123
```

---

## Project Structure

```
stackport-project/
├── src/
│   ├── main/
│   │   ├── java/com/visualpathit/account/
│   │   │   ├── beans/           # Spring beans & configuration
│   │   │   │   └── Components.java
│   │   │   ├── controller/      # Spring MVC controllers
│   │   │   │   ├── UserController.java
│   │   │   │   ├── FileUploadController.java
│   │   │   │   ├── ElasticSearchController.java
│   │   │   │   └── RabbitMQController.java
│   │   │   ├── service/         # Business logic & services
│   │   │   │   ├── ConsumerServiceImpl.java
│   │   │   │   └── UserService.java
│   │   │   ├── model/           # Entity models
│   │   │   └── dao/             # Data access objects
│   │   ├── webapp/
│   │   │   ├── WEB-INF/
│   │   │   │   ├── views/       # JSP templates
│   │   │   │   │   ├── index_home.jsp
│   │   │   │   │   ├── login.jsp
│   │   │   │   │   ├── registration.jsp
│   │   │   │   │   ├── welcome.jsp
│   │   │   │   │   ├── user.jsp
│   │   │   │   │   ├── userUpdate.jsp
│   │   │   │   │   ├── upload.jsp
│   │   │   │   │   └── rabbitmq.jsp
│   │   │   │   └── web.xml      # Servlet configuration
│   │   │   └── resources/
│   │   │       ├── css/         # Stylesheets
│   │   │       ├── js/          # JavaScript files
│   │   │       ├── fonts/       # Font files
│   │   │       └── Images/      # Image assets
│   │   └── resources/
│   │       ├── application.properties
│   │       └── db_backup.sql    # Database dump
│   └── test/
│       └── java/                # Unit tests
├── ansible/                     # Infrastructure as Code
│   ├── ansible.cfg
│   ├── site.yml
│   ├── vpro-app-setup.yml
│   ├── tomcat_setup.yml
│   └── templates/
│       └── application.j2
├── vagrant/                     # Vagrant provisioning scripts
│   ├── Automated_provisioning_MacOSM1/
│   │   ├── tomcat.sh
│   │   ├── mysql.sh
│   │   ├── backend.sh
│   │   └── tomcat_ubuntu.sh
│   └── Automated_provisioning_WinMacIntel/
│       ├── tomcat.sh
│       └── mysql.sh
├── target/                      # Build output
├── pom.xml                      # Maven configuration
├── Jenkinsfile                  # CI/CD pipeline
└── README.md                    # This file
```

---

## Building the Application

### Prerequisites Check
```bash
java -version      # Should be JDK 17 or 21
mvn -version       # Should be 3.9+
mysql --version    # Should be 8.0+
```

### Build Steps

#### 1. Clone Repository
```bash
git clone https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
```

#### 2. Setup Database
```bash
mysql -u root -p accounts < src/main/resources/db_backup.sql
```

#### 3. Configure Application Properties
Update `src/main/resources/application.properties` with your environment:
```properties
# Database Configuration
jdbc.url=jdbc:mysql://localhost:3306/accounts
jdbc.username=admin
jdbc.password=admin123

# Memcached Configuration
memcached.active.host=127.0.0.1
memcached.active.port=11211

# RabbitMQ Configuration
rabbitmq.address=localhost
rabbitmq.port=5672
rabbitmq.username=test
rabbitmq.password=test

# Elasticsearch Configuration
elasticsearch.host=localhost
elasticsearch.port=9300
elasticsearch.cluster=stackport
elasticsearch.node=stackport-node
```

#### 4. Build with Maven
```bash
# Clean and compile
mvn clean install

# Skip tests (optional)
mvn clean install -DskipTests

# Run tests
mvn test

# Code analysis
mvn verify
```

#### 5. Build Output
```
target/
├── stackport-v2.war           # Deployable web archive
├── classes/                   # Compiled classes
├── jacoco.exec                # Code coverage reports
└── surefire-reports/          # Test reports
```

---

## Deployment

### Local Tomcat Deployment

#### 1. Download & Extract Tomcat
```bash
wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz
tar -xzf apache-tomcat-10.1.26.tar.gz
```

#### 2. Deploy WAR File
```bash
# Stop Tomcat
./catalina.sh stop

# Deploy
cp target/stackport-v2.war $CATALINA_HOME/webapps/ROOT.war

# Start Tomcat
./catalina.sh start
```

#### 3. Access Application
```
http://localhost:8080
```

### Vagrant Automated Provisioning

Deploy complete stack using Vagrant:

```bash
cd vagrant/Automated_provisioning_MacOSM1/
vagrant up
```

This automatically provisions:
- Java 17
- Tomcat 10
- MySQL 8
- Memcached
- RabbitMQ
- Elasticsearch

### Ansible Configuration

Configure multi-server deployment:

```bash
cd ansible/
# Edit inventory and variables in ansible.cfg
ansible-playbook site.yml
```

### Jenkins CI/CD Pipeline

The `Jenkinsfile` defines automated build, test, and deployment stages:

```bash
# Stages included:
# - BUILD: mvn clean install
# - UNIT TEST: mvn test
# - INTEGRATION TEST: mvn verify
# - CODE ANALYSIS: Checkstyle, SonarQube
# - ARTIFACT UPLOAD: Nexus repository
```

---

## Application Features

### User Management
- User registration and authentication
- User profile management
- Profile picture upload
- Update user information (personal, professional details)

### Social Feed
- Post creation and sharing
- Comments and interactions
- User mentions and hashtags

### Search & Analytics
- Full-text search via Elasticsearch
- User search across profiles
- Query optimization with Memcached

### Asynchronous Processing
- Message queue via RabbitMQ
- Background job processing
- Event-driven architecture

### Data Caching
- Session caching with Memcached
- Active/standby cache configuration
- High-availability setup

---

## Configuration Files

### Application Properties
- **Location:** `src/main/resources/application.properties`
- **Contains:** Database, cache, messaging, and search configurations

### Ansible Templates
- **Location:** `ansible/templates/application.j2`
- **Purpose:** Dynamic configuration generation for different environments

### Vagrant Provisioning
- **Bash Scripts:** Automated infrastructure setup
- **Supports:** Multiple OS (CentOS, Ubuntu)
- **Includes:** All required services installation and configuration

---

## Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify -DskipUnitTests
```

### Code Coverage
```bash
# Coverage reports in target/site/jacoco/
mvn jacoco:report
```

---

## Troubleshooting

### Database Connection Issues
```bash
# Verify MySQL is running
mysql -u admin -p -e "SELECT 1"

# Check JDBC URL in application.properties
jdbc.url=jdbc:mysql://localhost:3306/accounts
```

### Tomcat Deployment Issues
```bash
# Check Tomcat logs
tail -f $CATALINA_HOME/logs/catalina.out

# Verify WAR extraction
ls -la $CATALINA_HOME/webapps/ROOT/
```

### Memcached Connection
```bash
# Test Memcached
telnet localhost 11211
stats
quit
```

### RabbitMQ Issues
```bash
# Check RabbitMQ status
sudo systemctl status rabbitmq-server

# Access management UI
http://localhost:15672
```

---

## Development Workflow

### IDE Setup (IntelliJ IDEA / Eclipse)
1. Import project as Maven project
2. Configure JDK 17/21
3. Update Maven settings
4. Run database setup script
5. Configure Run/Debug configurations

### Local Development
```bash
# Run on embedded Tomcat (if configured)
mvn tomcat7:run

# Or deploy to local Tomcat and monitor
tail -f $CATALINA_HOME/logs/catalina.out
```

---

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## Production Considerations

### Security
- Enable SSL/TLS for HTTPS
- Implement Spring Security with proper authentication
- Use environment variables for sensitive credentials
- Regular security patching

### Performance
- Configure connection pooling (HikariCP)
- Enable Memcached for session management
- Optimize database queries with JPA
- Monitor with Elasticsearch logging

### Scalability
- Use load balancer (Nginx, HAProxy)
- Horizontal scaling with multiple Tomcat instances
- Database replication and backups
- RabbitMQ clustering for messaging

### Monitoring
- Application performance monitoring (APM)
- Log aggregation with Elasticsearch
- Health checks and alerts
- JMX metrics and profiling

---

## License

[Specify your license here]

---

## Support & Documentation

- **GitHub Repository:** https://github.com/hkhcoder/vprofile-project
- **Issues:** [GitHub Issues](https://github.com/hkhcoder/vprofile-project/issues)
- **Wiki:** [Project Documentation]
- **Changelog:** See Git commit history

---

## Changelog

### Latest Updates
- JDK 17/21 support
- Tomcat 10 compatibility
- Enhanced security configurations
- Improved database schema
- Additional test coverage

---

## Authors & Maintainers

- **Original Project:** VProfile Project
- **Current Maintainer:** [Your Name/Team]

---

*Last Updated: 2024*