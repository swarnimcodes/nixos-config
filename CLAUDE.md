# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## System Overview

This is a NixOS configuration repository using flakes and home-manager. The configuration is structured as a single-user system with declarative package management and system configuration.

## Key Files and Architecture

- `flake.nix` - Main flake configuration defining inputs (nixpkgs, home-manager, zen-browser) and outputs
- `configuration.nix` - System-level NixOS configuration (bootloader, networking, services, system packages)
- `home.nix` - User-level configuration managed by home-manager (user packages, dotfiles, program settings)
- `hardware-configuration.nix` - Auto-generated hardware configuration (DO NOT MODIFY)
- `flake.lock` - Locked input versions for reproducibility

## Common Commands

### System Management
```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake ~/git/nix/nix-config

# Build configuration without switching
sudo nixos-rebuild build --flake ~/git/nix/nix-config

# Update flake inputs
nix flake update

# Show system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Package Management
```bash
# Search for packages
nix search nixpkgs <package-name>

# Temporarily install package
nix shell nixpkgs#<package-name>

# Show derivation
nix show-derivation
```

### Home Manager
```bash
# Switch home-manager configuration (integrated via NixOS rebuild)
sudo nixos-rebuild switch --flake ~/git/nix/nix-config

# List home-manager generations
home-manager generations
```

## Configuration Structure

The system uses a flake-based approach where:
- System configuration is in `configuration.nix`
- User configuration is in `home.nix` and managed by home-manager
- The flake integrates home-manager as a NixOS module
- User `swarnim` is configured with home-manager settings passed via `extraSpecialArgs`

## Key Settings

- **Hostname**: nixos
- **User**: swarnim
- **Desktop**: GNOME with GDM
- **Shell**: bash with custom aliases including `rebuild` shortcut
- **Editors**: helix (configured), neovim
- **Browser**: zen-browser (via flake input) with privacy policies
- **Terminal**: ghostty
- **Automatic cleanup**: Weekly garbage collection, 7-day retention, 10 boot generations max

## Development Notes

- System packages go in `configuration.nix` under `environment.systemPackages`
- User packages and dotfiles go in `home.nix`
- Always use the `rebuild` alias for applying changes: `rebuild`
- Hardware configuration is auto-generated and should not be manually edited
- The system enables experimental features: nix-command and flakes