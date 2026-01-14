# Minecraft Fabric Server

Dockerized Minecraft server running Fabric mod loader.

## Quick Start

```bash
docker compose up -d
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MC_VERSION` | `1.21.11` | Minecraft version (set in `.env`) |
| `JAVA_VERSION` | `21` | JRE version (set in `.env`) |
| `JAVA_XMS` | `1G` | Initial Java heap size |
| `JAVA_XMX` | `1G` | Maximum Java heap size |
| `PORT_SERVER` | `25565` | Minecraft server port |

### Changing Minecraft Version

Edit `.env`:

```
MC_VERSION=1.21.11
JAVA_VERSION=21
JAVA_XMS=1G
JAVA_XMX=1G
```

Then rebuild:

```bash
docker compose build
docker compose up -d
```

## Building

### Local Build

```bash
# Uses version from .env
docker compose build

# Or override:
MC_VERSION=1.20.6 docker compose build
```

### CI/CD

The GitHub Actions workflow builds multiple versions in parallel using a matrix strategy. Each push to `main` builds all configured versions.

To add a new version, edit `.github/workflows/build.yaml`:

```yaml
matrix:
  include:
    - mc_version: "1.21.11"
      java_version: "21"
      latest: true          # Tagged as :latest
    - mc_version: "1.20.6"
      java_version: "21"
      latest: false
```

## Image Tags

Images are published to `ghcr.io/excoffierleonard/minecraft-server`:

- `:latest` - Most recent version marked with `latest: true`
- `:1.21.11-fabric` - Specific version tags

## Directory Structure

The container separates application files from server data:

- `/app/server.jar` - The Fabric server binary (immutable, part of image)
- `/data` - Working directory for world saves, configs, mods, and logs (mount as volume for persistence)

This separation ensures the server binary isn't accidentally overwritten when mounting a data volume.

## Java Compatibility

| Minecraft Version | Java Version |
|-------------------|--------------|
| 1.20.5+ | 21 |
| 1.18 - 1.20.4 | 17 |

## Deployment

1. Update the matrix in `build.yaml` with new version
2. Commit and push to `main`
3. CI builds and pushes all versions
4. On your server:

   ```bash
   docker compose pull
   docker compose up -d
   ```
