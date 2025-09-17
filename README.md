# DDEV Node.js Starter Add-on

[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)

A DDEV add-on for running Node.js applications with development server support and production builds.

## What does this add-on do?

This add-on provides a complete DDEV configuration template for Node.js applications, supporting:

- 🚀 **Development server** with Hot Module Reloading (HMR) on port 4321
- 📦 **Production builds** served from the `dist` directory  
- 🔄 **Automatic npm install** and build processes
- 🎯 **Framework flexibility** - works with Astro, Vite, Next.js, Nuxt.js, React, and more
- 🛠️ **Customizable configuration** for different project needs

## Installation

```bash
ddev add-on get atj4me/ddev-nodejs-starter
```

## Configuration

After installation, you'll have a `config.nodejs.yaml` template file. Key settings to customize:

### Project Settings
```yaml
name: my-nodejs-app              # Your project name
docroot: dist                    # Your build output directory
nodejs_version: "auto"           # Node.js version (auto, 18, 20, etc.)
```

### Development Server Ports
```yaml
web_extra_exposed_ports:
  - name: nodejs-dev
    container_port: 4321         # Your dev server port
    http_port: 4322             # External HTTP port  
    https_port: 4321            # External HTTPS port
```

### Framework-Specific Commands

#### Astro/Vite
```yaml
command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --host'
```

#### Next.js
```yaml  
command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --hostname 0.0.0.0'
```

#### Create React App
```yaml
command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm start'
```

#### Nuxt.js
```yaml
command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --host 0.0.0.0'
```

## Usage

1. **Install the add-on** in your Node.js project directory:
   ```bash
   ddev add-on get atj4me/ddev-nodejs-starter
   ```

2. **Review and customize** the configuration:
   - If you have an existing `.ddev/config.yaml`, merge the Node.js settings manually
   - If not, the `config.nodejs.yaml` will become your main config
   - Adjust ports, commands, and directories for your framework

3. **Start your project**:
   ```bash
   ddev restart
   ```

4. **Access your application**:
   - **Production build**: `https://yourproject.ddev.site`
   - **Development server**: `https://yourproject.ddev.site:4321`

## Project Structure

This add-on assumes the following project structure:
```
your-nodejs-project/
├── package.json          # Node.js dependencies and scripts
├── dist/                 # Production build output (configurable)
├── src/                  # Source code
├── .nvmrc               # Node.js version (optional)
└── .ddev/
    ├── config.yaml      # Main DDEV configuration
    ├── config.nodejs.yaml  # Node.js template (reference)
    └── docker-compose.nodejs.yaml  # Additional services
```

## Customization

### Different Build Directory
If your framework builds to a different directory (e.g., `build`, `public`, `out`):
```yaml
docroot: build  # Change from 'dist' to your build directory
```

### Different Development Port
If your framework uses a different development port:
```yaml
web_extra_exposed_ports:
  - name: nodejs-dev
    container_port: 3000    # Change from 4321 to your port
    http_port: 3001
    https_port: 3000
```

### Additional Services
Uncomment and customize services in `docker-compose.nodejs.yaml`:
- Redis for session storage
- PostgreSQL database
- Additional development tools

## Framework Examples

### Astro Project
```yaml
name: my-astro-site
docroot: dist
nodejs_version: "20"
web_extra_exposed_ports:
  - name: astro-dev
    container_port: 4321
    http_port: 4322
    https_port: 4321
web_extra_daemons:
  - name: astro-dev-daemon
    command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --host'
```

### Next.js Project  
```yaml
name: my-nextjs-app
docroot: out  # or .next/static for static export
nodejs_version: "18"
web_extra_exposed_ports:
  - name: nextjs-dev
    container_port: 3000
    http_port: 3001
    https_port: 3000
web_extra_daemons:
  - name: nextjs-dev-daemon
    command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --hostname 0.0.0.0'
```

## Troubleshooting

### Development server not starting
Check the logs:
```bash
ddev logs --follow --time
```

### Build failures
Run npm commands manually:
```bash
ddev ssh
npm install
npm run build
```

### Port conflicts
Change the `container_port` and external ports in your configuration.

### Framework-specific issues
Ensure your dev server command includes the `--host` or hostname flag to bind to all interfaces.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Credits

**Contributed and maintained by @atj4me**

Based on the DDEV add-on template and inspired by the ddev.com Astro configuration.
