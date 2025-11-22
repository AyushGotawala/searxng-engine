#!/bin/bash

# VedaOS SearxNG Service Deployment Script
# Supports both local development and production testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
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

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to check if ports are available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port $port is already in use. Please stop the service using that port."
        echo "You can find what's using the port with: lsof -i :$port"
        return 1
    fi
    return 0
}

# Function to wait for service to be ready
wait_for_service() {
    local url=$1
    local max_attempts=30
    local attempt=1
    
    print_status "Waiting for service to be ready at $url..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "$url" > /dev/null 2>&1; then
            print_success "Service is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    print_error "Service failed to start within expected time"
    return 1
}

# Main deployment function
deploy() {
    local mode=$1
    
    print_status "Starting VedaOS SearxNG deployment in $mode mode..."
    
    # Check prerequisites
    check_docker
    
    if [ "$mode" = "local" ]; then
        # Local development mode with Redis
        print_status "Deploying in LOCAL DEVELOPMENT mode with Redis caching..."
        
        check_port 8081 || exit 1
        
        # Stop any existing services
        print_status "Stopping any existing services..."
        docker-compose -f docker-compose.local.yml down 2>/dev/null || true
        
        # Build and start services
        print_status "Building and starting services..."
        docker-compose -f docker-compose.local.yml up --build -d
        
        # Wait for services to be ready
        wait_for_service "http://localhost:8081"
        
        print_success "Local development deployment complete!"
        echo ""
        echo "🔗 Service URLs:"
        echo "   Web Interface: http://localhost:8081"
        echo "   API Endpoint:  http://localhost:8081/search?q=test&format=json"
        echo ""
        echo "📋 Available Commands:"
        echo "   View logs:     docker-compose -f docker-compose.local.yml logs -f"
        echo "   Stop services: docker-compose -f docker-compose.local.yml down"
        echo "   Test API:      curl 'http://localhost:8081/search?q=python&format=json' | jq '.'"
        
    elif [ "$mode" = "production" ]; then
        # Production mode without Redis (simulates Render deployment)
        print_status "Deploying in PRODUCTION TEST mode (single container, no Redis)..."
        
        check_port 8081 || exit 1
        
        # Stop any existing services
        print_status "Stopping any existing services..."
        docker-compose down 2>/dev/null || true
        
        # Build and start service
        print_status "Building and starting service..."
        docker-compose up --build -d
        
        # Wait for service to be ready
        wait_for_service "http://localhost:8081"
        
        print_success "Production test deployment complete!"
        echo ""
        echo "🔗 Service URLs:"
        echo "   Web Interface: http://localhost:8081"
        echo "   API Endpoint:  http://localhost:8081/search?q=test&format=json"
        echo ""
        echo "📋 Available Commands:"
        echo "   View logs:     docker-compose logs -f"
        echo "   Stop service:  docker-compose down"
        echo "   Test API:      curl 'http://localhost:8081/search?q=python&format=json' | jq '.'"
        echo ""
        echo "💡 This mode simulates the Render.com production environment"
        
    else
        print_error "Invalid mode specified. Use 'local' or 'production'"
        show_usage
        exit 1
    fi
}

# Function to show usage
show_usage() {
    echo ""
    echo "Usage: $0 [local|production]"
    echo ""
    echo "Modes:"
    echo "  local       - Deploy with Redis for local development"
    echo "  production  - Deploy single container for production testing"
    echo ""
    echo "Examples:"
    echo "  $0 local       # Start local development environment"
    echo "  $0 production  # Start production test environment"
    echo ""
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        print_error "No deployment mode specified"
        show_usage
        exit 1
    fi
    
    case "$1" in
        "local"|"development"|"dev")
            deploy "local"
            ;;
        "production"|"prod"|"test")
            deploy "production"
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            print_error "Unknown mode: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run the main function with all arguments
main "$@"