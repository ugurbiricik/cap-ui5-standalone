# CAP Application with Fiori Frontend - Standalone Deployment

This project demonstrates a complete SAP CAP (Cloud Application Programming Model) application with a Fiori frontend, deployed as a standalone application on SAP BTP Cloud Foundry using HTML5 Application Repository.

## 🚀 Quick Start

### Prerequisites
- SAP BTP Trial Account
- Cloud Foundry CLI
- Node.js 20+
- SAP Business Application Studio (optional)

### Initial Setup

1. **Create a new CAP project:**
   ```bash
   cds init cap-ui5-standalone --add sample
   cd cap-ui5-standalone
   ```

2. **Add required features:**
   ```bash
   cds add hana,xsuaa,destination,html5-repo,approuter,mta
   ```

3. **Install dependencies:**
   ```bash
   npm install
   ```

## 📋 Required Configuration Adjustments

### 1. MTA Configuration (`mta.yaml`)

**Add destination service binding:**
```yaml
resources:
  - name: cap-ui5-standalone-destination
    type: org.cloudfoundry.managed-service
    parameters:
      service: destination
      service-plan: lite
      config:
        HTML5Runtime_enabled: true
        init_data:
          instance:
            existing_destinations_policy: update
            destinations:
              - Name: srv-api
                URL: ~{srv-api/srv-url}
                Authentication: NoAuthentication
                Type: HTTP
                ProxyType: Internet
                HTML5.ForwardAuthToken: true
                HTML5.DynamicDestination: true
              - Name: ui5
                URL: https://ui5.sap.com
                Authentication: NoAuthentication
                Type: HTTP
                ProxyType: Internet
    requires:
      - name: srv-api  # ← Add this line
```

**Fix XSUAA configuration for organization names with spaces:**
```yaml
resources:
  - name: cap-ui5-standalone-auth
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
      path: ./xs-security.json
      config:
        xsappname: cap-ui5-standalone-${space}  # Remove or use backticks for spaces
        tenant-mode: dedicated
```

### 2. UI5 Application Configuration

**For custom UI5 applications, add to `ui5-dist.yaml`:**
```yaml
builder:
  customTasks:
    - name: ui5-task-zipper
      afterTask: generateVersionInfo
      configuration:
        archiveName: test
        additionalFiles:
          - xs-app.json
```

**Add to `package.json` devDependencies:**
```json
{
  "devDependencies": {
    "ui5-task-zipper": "^3.4.2"
  }
}
```

### 3. Approuter Configuration (`app/router/xs-app.json`)

**Standard configuration for standalone deployment:**

> **💡 Tip**: For more `xs-app.json` examples and patterns, refer to the [SAP UI5 Deployments GitHub Repository](https://github.com/SAP-samples/ui5-deployments/blob/main/approuter/xs-app.json).
```json
{
  "welcomeFile": "/index.html",
  "authenticationMethod": "route",
  "routes": [
    {
      "source": "^/resources/(.*)$",
      "target": "/resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "^/?odata/(.*)$",
      "target": "/odata/$1",
      "destination": "srv-api",
      "authenticationType": "xsuaa",
      "csrfProtection": true
    },
    {
      "source": "^/test-resources/(.*)$",
      "target": "/test-resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "/user-api/currentUser$",
      "target": "/currentUser",
      "service": "sap-approuter-userapi"
    },
    {
      "source": "^(.*)$",
      "target": "/test/$1",  !! important !!
      "service": "html5-apps-repo-rt",
      "authenticationType": "xsuaa"
    }
  ]
}
```

### 4. Fiori App Configuration (`app/test/xs-app.json`)

**UI module configuration:**
```json
{
  "welcomeFile": "/index.html",
  "authenticationMethod": "route",
  "routes": [
    {
      "source": "^/resources/(.*)$",
      "target": "/resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "^/?odata/(.*)$",
      "target": "/odata/$1",
      "destination": "srv-api",
      "authenticationType": "xsuaa",
      "csrfProtection": true
    },
    {
      "source": "^/test-resources/(.*)$",
      "target": "/test-resources/$1",
      "authenticationType": "none",
      "destination": "ui5"
    },
    {
      "source": "^(.*)$",
      "target": "$1",
      "service": "html5-apps-repo-rt",
      "authenticationType": "xsuaa"
    }
  ]
}
```

## 🔧 Deployment Steps

1. **Install all dependencies:**
   ```bash
   npm install
   cd app/test && npm install
   cd ../router && npm install
   cd ../..
   ```

2. **Build the application:**
   ```bash
   mbt build
   ```

3. **Deploy to Cloud Foundry:**
   ```bash
   cf deploy mta_archives/cap-ui5-standalone_1.0.0.mtar
   ```

4. **Verify deployment:**
   ```bash
   cf apps
   cf services
   ```

## 🌐 Access the Application

After successful deployment, access your application at:
```
https://[your-app-name].cfapps.us10-001.hana.ondemand.com
```

## 📁 Project Structure

```
myapp/
├── app/
│   ├── router/
│   │   ├── xs-app.json          # Approuter configuration
│   │   ├── package.json
│   │   └── default-env.json
│   └── test/
│       ├── xs-app.json          # Fiori app configuration
│       ├── webapp/
│       └── package.json
├── srv/
│   └── service.cds              # CAP service definitions
├── db/
│   └── schema.cds               # Database schema
├── mta.yaml                     # Multi-target application
├── xs-security.json             # XSUAA security configuration
└── package.json
```

## 🔍 Key Features

- **Standalone Deployment**: No dependency on SAP Workzone or Launchpad
- **HTML5 Application Repository**: UI modules served from dedicated service
- **Zero Downtime**: UI updates without approuter restart
- **Authentication**: XSUAA integration
- **Dynamic Routing**: Backend and frontend properly separated

## 🛠️ Troubleshooting

### Common Issues

1. **503 Service Unavailable**: Check HTML5 repository service binding
2. **404 UI5 Resources**: Verify approuter routing configuration
3. **Authentication Errors**: Ensure XSUAA service is properly configured
4. **Organization Name with Spaces**: Remove or escape spaces in xsappname

### Useful Commands

```bash
# Check application logs
cf logs [app-name] --recent

# List HTML5 applications
cf html5-list -a [app-name]-srv -u

# Check service bindings
cf services
```

## 📚 Additional Resources

- [SAP CAP Documentation](https://cap.cloud.sap.io/)
- [SAP Fiori Development Guidelines](https://experience.sap.com/fiori-design-web/)
- [HTML5 Application Repository](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/7c8d2d3c6c4b2a4a8b8b8b8b8b8b8b8b.html)
- [SAP UI5 Deployments GitHub Repository](https://github.com/SAP-samples/ui5-deployments) - Official SAP samples for UI5 deployment patterns and `xs-app.json` configurations

## 🤝 Contributing

This project follows SAP CAP best practices and can be extended with additional UI5 applications or CAP services.

---

**Note**: This setup provides a complete standalone CAP application with Fiori frontend, suitable for production deployment on SAP BTP Cloud Foundry.
