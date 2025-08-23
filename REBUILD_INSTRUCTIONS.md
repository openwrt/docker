# Instructions for Rebuilding Missing Containers

This document explains how to rebuild missing containers like the reported `ramips-mt7621-v23.05.6` container.

## The Issue

The container `ghcr.io/openwrt/imagebuilder:ramips-mt7621-v23.05.6` was missing due to a workflow issue that prevented manual container builds from working correctly.

## The Fix

Fixed a circular dependency in `.github/workflows/containers.yml` where the `generate_matrix` job was trying to use its own output for `file_host` instead of the workflow input.

## How to Rebuild a Missing Container

To rebuild the missing `ramips-mt7621-v23.05.6` container:

1. Go to the [Actions tab](https://github.com/openwrt/docker/actions/workflows/containers.yml) 
2. Click "Run workflow"
3. Fill in the parameters:
   - **ref**: `v23.05.6`
   - **target**: `ramips/mt7621` 
   - **file_host**: (leave empty for default)
   - **prefix**: (leave empty for default)
4. Click "Run workflow"

This will build and push the container to `ghcr.io/openwrt/imagebuilder:ramips-mt7621-v23.05.6`.

## General Pattern

For any missing container `TARGET-VERSION`:
- **ref**: The version (e.g., `v23.05.6`, `main`)  
- **target**: The target architecture (e.g., `ramips/mt7621`, `x86/64`)

The resulting container will be tagged as:
- `ghcr.io/openwrt/imagebuilder:TARGET-VERSION`
- `ghcr.io/openwrt/imagebuilder:TARGET-REF` (e.g., `ramips-mt7621-v23.05.6`)

## Testing

After the workflow completes successfully, you can test the container:

```bash
podman run -it ghcr.io/openwrt/imagebuilder:ramips-mt7621-v23.05.6
```

Inside the container, run:
```bash
./setup.sh
make image PROFILE=generic
```