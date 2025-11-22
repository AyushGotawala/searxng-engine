#!/bin/bash

# VedaOS SearxNG Service - Deployment Script
# This script helps deploy the SearxNG service to various platforms

set -e

echo "🔍 VedaOS SearxNG Service Deployment"
echo "===================================="

# Function to check dependencies
check_dependencies() {
    echo "📋 Checking dependencies..."
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        echo "❌ Git is not installed. Please install Git first."
        exit 1
    fi
    
    echo "✅ All dependencies found"
}

# Function to test local deployment
test_local() {
    echo "🧪 Testing local deployment..."
    
    # Start services
    docker-compose up --build -d
    
    # Wait for services to be ready
    echo "⏳ Waiting for services to start..."
    sleep 30
    
    # Test the service
    echo "🔍 Testing search endpoint..."
    if curl -f -s "http://localhost:8080/search?q=test&format=json" > /dev/null; then
        echo "✅ Local deployment successful!"
        echo "🌐 Service running at: http://localhost:8080"
        echo "🧪 Test search: curl \"http://localhost:8080/search?q=test&format=json\""
    else
        echo "❌ Local deployment failed!"
        docker-compose logs --tail=50 searxng
        exit 1
    fi
}

# Function to prepare for Git deployment
prepare_git() {
    echo "📦 Preparing for Git deployment..."
    
    # Initialize git if not already done
    if [ ! -d ".git" ]; then
        git init
        echo "✅ Git repository initialized"
    fi
    
    # Add all files
    git add .
    git status
    
    echo "📝 Ready to commit. Run:"
    echo "   git commit -m \"Initial VedaOS SearxNG service setup\""
    echo "   git remote add origin <your-github-repo-url>"
    echo "   git push -u origin main"
}

# Function to generate Render deployment URL
generate_render_url() {
    echo "🚀 Render.com Deployment Instructions"
    echo "======================================"
    echo ""
    echo "1. Push this repository to GitHub:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/vedaos-searxng-service.git"
    echo "   git push -u origin main"
    echo ""
    echo "2. Deploy on Render.com:"
    echo "   • Go to https://dashboard.render.com/"
    echo "   • Click 'New +' → 'Blueprint'"
    echo "   • Connect your GitHub repository"
    echo "   • Render will automatically use render.yaml"
    echo ""
    echo "3. Your service will be available at:"
    echo "   https://vedaos-searxng.onrender.com"
    echo ""
    echo "4. Update your VedaOS app environment:"
    echo "   SEARXNG_BASE_URL=https://vedaos-searxng.onrender.com"
    echo ""
}

# Main script logic
case "${1:-help}" in
    "local")
        check_dependencies
        test_local
        ;;
    "prepare")
        prepare_git
        ;;
    "render")
        generate_render_url
        ;;
    "full")
        check_dependencies
        test_local
        prepare_git
        generate_render_url
        ;;
    "help"|*)
        echo "Usage: $0 {local|prepare|render|full}"
        echo ""
        echo "Commands:"
        echo "  local   - Test local deployment with Docker Compose"
        echo "  prepare - Prepare Git repository for deployment"
        echo "  render  - Show Render.com deployment instructions"
        echo "  full    - Run all steps above"
        echo ""
        ;;
esac

echo ""
echo "✨ VedaOS SearxNG Service setup complete!"