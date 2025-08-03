#!/bin/bash

# Nexus Development Ecosystem - Rollback Script v1.0
# This script provides rollback capabilities for the infrastructure deployment

echo "🔄 Nexus Development Ecosystem - Rollback Script v1.0"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: Must run this script from the nexus-development-ecosystem root directory"
    exit 1
fi

# Function to rollback to tagged version
rollback_to_version() {
    local version=$1
    echo "🔄 Rolling back to version: $version"
    
    # Stash any current changes
    git stash
    
    # Checkout the tagged version
    git checkout $version
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully rolled back to $version"
        echo "📝 Current status:"
        git status --porcelain
    else
        echo "❌ Failed to rollback to $version"
        git stash pop
        exit 1
    fi
}

# Function to rollback to backup branch
rollback_to_backup() {
    echo "🔄 Rolling back to backup branch: backup-before-infrastructure-deployment"
    
    # Stash any current changes
    git stash
    
    # Checkout the backup branch
    git checkout backup-before-infrastructure-deployment
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully rolled back to backup branch"
        echo "📝 Current status:"
        git status --porcelain
    else
        echo "❌ Failed to rollback to backup branch"
        git stash pop
        exit 1
    fi
}

# Function to restore from main branch
rollback_to_main() {
    echo "🔄 Rolling back to main branch"
    
    # Stash any current changes
    git stash
    
    # Checkout main branch
    git checkout main
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully rolled back to main branch"
        echo "📝 Current status:"
        git status --porcelain
    else
        echo "❌ Failed to rollback to main branch"
        git stash pop
        exit 1
    fi
}

# Function to list available rollback points
list_rollback_points() {
    echo "📋 Available rollback points:"
    echo "1. v1.0-complete-business-portfolio (tagged version)"
    echo "2. backup-before-infrastructure-deployment (backup branch)"
    echo "3. main (main branch)"
    echo ""
}

# Main script logic
case "${1:-}" in
    "tag"|"v1.0")
        rollback_to_version "v1.0-complete-business-portfolio"
        ;;
    "backup")
        rollback_to_backup
        ;;
    "main")
        rollback_to_main
        ;;
    "list"|"help"|"")
        list_rollback_points
        echo "Usage: $0 [tag|backup|main|list]"
        echo ""
        echo "Options:"
        echo "  tag|v1.0  - Rollback to tagged version v1.0-complete-business-portfolio"
        echo "  backup    - Rollback to backup branch"
        echo "  main      - Rollback to main branch"
        echo "  list      - List available rollback points"
        echo "  help      - Show this help message"
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

echo ""
echo "🎯 Rollback complete! The system is now in a safe state."
echo "💡 If you need to continue with infrastructure deployment, run the deployment script again." 