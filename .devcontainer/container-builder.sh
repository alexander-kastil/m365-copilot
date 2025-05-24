#!/bin/bash

# M365 Copilot Development Container Builder Script
# This script helps build, update, and export the development container

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="ms-copilots-agents-dev"
DEFAULT_TAG="1.0.0"
BUILDER_TAG="builder"
DOCKERFILE="Dockerfile.standalone"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "M365 Copilot Development Container Builder"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build [TAG]     Build the container image (default: latest)"
    echo "  rebuild [TAG]   Rebuild the container image without cache"
    echo "  test [TAG]      Test the container image"
    echo "  export [TAG]    Export the container image to tar file"
    echo "  push [TAG]      Push the container image to registry"
    echo "  clean           Clean up unused Docker resources"
    echo "  info            Show container information"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build                    # Build with 'latest' tag"
    echo "  $0 build v1.2.0            # Build with specific tag"
    echo "  $0 rebuild                  # Rebuild without cache"
    echo "  $0 export v1.2.0           # Export tagged image"
    echo "  $0 test                     # Test the latest image"
    echo ""
}

# Function to build the container
build_container() {
    local tag=${1:-$DEFAULT_TAG}
    local full_image_name="$IMAGE_NAME:$tag"
    
    print_status "Building container: $full_image_name"
    print_status "Using Dockerfile: $DOCKERFILE"
    
    docker build \
        -f ".devcontainer/$DOCKERFILE" \
        -t "$full_image_name" \
        --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
        --label "org.opencontainers.image.version=$tag" \
        .
    
    print_success "Container built successfully: $full_image_name"
}

# Function to rebuild the container without cache
rebuild_container() {
    local tag=${1:-$DEFAULT_TAG}
    local full_image_name="$IMAGE_NAME:$tag"
    
    print_status "Rebuilding container (no cache): $full_image_name"
    
    docker build \
        --no-cache \
        -f ".devcontainer/$DOCKERFILE" \
        -t "$full_image_name" \
        --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
        --label "org.opencontainers.image.version=$tag" \
        .
    
    print_success "Container rebuilt successfully: $full_image_name"
}

# Function to test the container
test_container() {
    local tag=${1:-$DEFAULT_TAG}
    local full_image_name="$IMAGE_NAME:$tag"
    
    print_status "Testing container: $full_image_name"
    
    # Test if image exists
    if ! docker image inspect "$full_image_name" >/dev/null 2>&1; then
        print_error "Container image $full_image_name not found. Build it first."
        exit 1
    fi
    
    # Run initialization script
    print_status "Running initialization script..."
    docker run --rm "$full_image_name" /usr/local/bin/init-container.sh
    
    # Test basic tools
    print_status "Testing development tools..."
    docker run --rm "$full_image_name" bash -c "
        echo '=== Tool Versions ==='
        echo 'Node.js:' \$(node --version)
        echo '.NET:' \$(dotnet --version)
        echo 'Azure CLI:' \$(az --version | head -n1)
        echo 'GitHub CLI:' \$(gh --version | head -n1)
        echo 'Git:' \$(git --version)
        echo 'Kiota:' \$(kiota --version)
        echo 'Teams Toolkit:' \$(teamsapp --version)
        echo 'Azure Functions:' \$(func --version)
    "
    
    print_success "Container tests passed!"
}

# Function to export the container
export_container() {
    local tag=${1:-$DEFAULT_TAG}
    local full_image_name="$IMAGE_NAME:$tag"
    local export_file="$IMAGE_NAME-$tag.tar"
    
    print_status "Exporting container: $full_image_name"
    
    # Test if image exists
    if ! docker image inspect "$full_image_name" >/dev/null 2>&1; then
        print_error "Container image $full_image_name not found. Build it first."
        exit 1
    fi
    
    docker save "$full_image_name" -o "$export_file"
    
    print_success "Container exported to: $export_file"
    print_status "File size: $(du -h "$export_file" | cut -f1)"
}

# Function to push the container
push_container() {
    local tag=${1:-$DEFAULT_TAG}
    local full_image_name="$IMAGE_NAME:$tag"
    
    print_warning "Push functionality requires configuring a container registry."
    print_status "To push to a registry, tag your image with the registry URL:"
    print_status "Example: docker tag $full_image_name youregistry.azurecr.io/$full_image_name"
    print_status "Then: docker push youregistry.azurecr.io/$full_image_name"
}

# Function to clean up Docker resources
clean_docker() {
    print_status "Cleaning up Docker resources..."
    
    # Remove dangling images
    dangling_images=$(docker images -f "dangling=true" -q)
    if [ -n "$dangling_images" ]; then
        print_status "Removing dangling images..."
        docker rmi $dangling_images
    fi
    
    # Remove unused volumes
    print_status "Removing unused volumes..."
    docker volume prune -f
    
    # Remove unused networks
    print_status "Removing unused networks..."
    docker network prune -f
    
    print_success "Docker cleanup completed!"
}

# Function to show container information
show_info() {
    print_status "M365 Copilot Development Container Information"
    echo ""
    
    # Show available images
    print_status "Available Images:"
    docker images --filter=reference="$IMAGE_NAME:*" --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo ""
    print_status "Container Configuration:"
    echo "  Image Name: $IMAGE_NAME"
    echo "  Dockerfile: $DOCKERFILE"
    echo "  Default Tag: $DEFAULT_TAG"
    echo "  Builder Tag: $BUILDER_TAG"
    
    echo ""
    print_status "Quick Commands:"
    echo "  Build:   ./container-builder.sh build"
    echo "  Test:    ./container-builder.sh test"
    echo "  Export:  ./container-builder.sh export"
    echo "  Clean:   ./container-builder.sh clean"
}

# Main script logic
case "${1:-help}" in
    build)
        build_container "$2"
        ;;
    rebuild)
        rebuild_container "$2"
        ;;
    test)
        test_container "$2"
        ;;
    export)
        export_container "$2"
        ;;
    push)
        push_container "$2"
        ;;
    clean)
        clean_docker
        ;;
    info)
        show_info
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac
