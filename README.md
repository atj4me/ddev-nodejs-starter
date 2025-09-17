[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/atj4me/ddev-nodejs-starter/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/atj4me/ddev-nodejs-starter/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/atj4me/ddev-nodejs-starter)](https://github.com/atj4me/ddev-nodejs-starter/commits)
[![release](https://img.shields.io/github/v/release/atj4me/ddev-nodejs-starter)](https://github.com/atj4me/ddev-nodejs-starter/releases/latest)

# DDEV Node.js Starter Add-on

## Overview

This add-on integrates Node.js development workflows into your [DDEV](https://ddev.com/) project, providing both development server support with Hot Module Reloading (HMR) and production build serving.

## Installation

```bash
ddev add-on get atj4me/ddev-nodejs-starter
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev describe` | View service status and used ports for Node.js development |
| `ddev logs --follow --time` | Check Node.js development server logs |
| `ddev ssh` | Access the container to run npm commands manually |

**Access your application:**
- **Production build**: `https://yourproject.ddev.site`
- **Development server**: `https://yourproject.ddev.site:4321`

## Framework Support

This add-on works with various Node.js frameworks:

- **Astro**: Default configuration with dev server on port 4321
- **Vite**: Compatible with default settings  
- **Next.js**: Customize hostname and port in config
- **Nuxt.js**: Adjust host binding for development server
- **Create React App**: Works with standard React setup
- **Any Node.js framework**: Customizable for your specific needs

## Advanced Customization

### Change Development Server Port

```yaml
# In your .ddev/config.yaml
web_extra_exposed_ports:
  - name: nodejs-dev
    container_port: 3000    # Your framework's dev port
    http_port: 3001
    https_port: 3000
```

### Change Build Output Directory

```yaml
# In your .ddev/config.yaml
docroot: build  # Change from 'dist' to your build directory
```

### Framework-Specific Dev Commands

```yaml
# In your .ddev/config.yaml
web_extra_daemons:
  - name: nodejs-dev-daemon
    # Astro/Vite
    command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --host'
    # Next.js
    # command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --hostname 0.0.0.0'
    # Nuxt.js  
    # command: bash -c 'npm install && touch /var/tmp/npminstalldone && npm run dev -- --host 0.0.0.0'
    directory: /var/www/html
```

### Node.js Version

```yaml
# In your .ddev/config.yaml
nodejs_version: "auto"  # Reads from .nvmrc, or specify "18", "20", etc.
```

## What This Add-on Provides

- **Automatic npm install** on container start
- **Development server** with Hot Module Reloading (HMR)
- **Production build serving** from configurable build directory
- **Smart project detection** with automatic naming
- **Framework flexibility** with customizable commands
- **No database container** by default (appropriate for many Node.js apps)

## Credits

**Contributed and maintained by @atj4me**
