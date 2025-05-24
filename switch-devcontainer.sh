#!/bin/bash
# Script to switch between devcontainer configurations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVCONTAINER_DIR="$SCRIPT_DIR/.devcontainer"

show_help() {
    echo "Usage: $0 [compose|standalone]"
    echo ""
    echo "Switch between devcontainer configurations:"
    echo "  compose    - Use docker-compose based devcontainer (default, with features)"
    echo "  standalone - Use standalone Dockerfile based devcontainer"
    echo ""
    echo "Current configuration:"
    if [[ -f "$DEVCONTAINER_DIR/devcontainer.json" ]]; then
        if grep -q "dockerComposeFile" "$DEVCONTAINER_DIR/devcontainer.json"; then
            echo "  Currently using: docker-compose configuration"
        elif grep -q "dockerfile" "$DEVCONTAINER_DIR/devcontainer.json"; then
            echo "  Currently using: standalone Dockerfile configuration"
        else
            echo "  Currently using: unknown configuration"
        fi
    else
        echo "  No devcontainer.json found"
    fi
}

switch_to_compose() {
    echo "Switching to docker-compose based devcontainer..."
    
    # Backup current if it exists and is not the original
    if [[ -f "$DEVCONTAINER_DIR/devcontainer.json" ]] && ! grep -q "dockerComposeFile" "$DEVCONTAINER_DIR/devcontainer.json"; then
        echo "Backing up current devcontainer.json to devcontainer.backup.json"
        cp "$DEVCONTAINER_DIR/devcontainer.json" "$DEVCONTAINER_DIR/devcontainer.backup.json"
    fi
    
    # Check if original compose file exists
    if [[ -f "$DEVCONTAINER_DIR/devcontainer.compose.json" ]]; then
        cp "$DEVCONTAINER_DIR/devcontainer.compose.json" "$DEVCONTAINER_DIR/devcontainer.json"
        echo "Switched to docker-compose configuration"
    else
        echo "Error: devcontainer.compose.json not found. Please restore the original docker-compose configuration."
        exit 1
    fi
}

switch_to_standalone() {
    echo "Switching to standalone Dockerfile based devcontainer..."
    
    # Backup current if it exists and is the compose version
    if [[ -f "$DEVCONTAINER_DIR/devcontainer.json" ]] && grep -q "dockerComposeFile" "$DEVCONTAINER_DIR/devcontainer.json"; then
        echo "Backing up current devcontainer.json to devcontainer.compose.json"
        cp "$DEVCONTAINER_DIR/devcontainer.json" "$DEVCONTAINER_DIR/devcontainer.compose.json"
    fi
    
    # Switch to standalone
    if [[ -f "$DEVCONTAINER_DIR/devcontainer.standalone.json" ]]; then
        cp "$DEVCONTAINER_DIR/devcontainer.standalone.json" "$DEVCONTAINER_DIR/devcontainer.json"
        echo "Switched to standalone Dockerfile configuration"
    else
        echo "Error: devcontainer.standalone.json not found"
        exit 1
    fi
}

# Main logic
case "${1:-help}" in
    "compose")
        switch_to_compose
        ;;
    "standalone")
        switch_to_standalone
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac
