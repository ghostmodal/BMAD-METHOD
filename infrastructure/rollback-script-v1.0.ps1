# Nexus Development Ecosystem - Rollback Script v1.0 (PowerShell)
# This script provides rollback capabilities for the infrastructure deployment

Write-Host "🔄 Nexus Development Ecosystem - Rollback Script v1.0" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "README.md")) {
    Write-Host "❌ Error: Must run this script from the nexus-development-ecosystem root directory" -ForegroundColor Red
    exit 1
}

# Function to rollback to tagged version
function Rollback-ToVersion {
    param([string]$Version)
    Write-Host "🔄 Rolling back to version: $Version" -ForegroundColor Yellow
    
    # Stash any current changes
    git stash
    
    # Checkout the tagged version
    git checkout $Version
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully rolled back to $Version" -ForegroundColor Green
        Write-Host "📝 Current status:" -ForegroundColor Cyan
        git status --porcelain
    } else {
        Write-Host "❌ Failed to rollback to $Version" -ForegroundColor Red
        git stash pop
        exit 1
    }
}

# Function to rollback to backup branch
function Rollback-ToBackup {
    Write-Host "🔄 Rolling back to backup branch: backup-before-infrastructure-deployment" -ForegroundColor Yellow
    
    # Stash any current changes
    git stash
    
    # Checkout the backup branch
    git checkout backup-before-infrastructure-deployment
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully rolled back to backup branch" -ForegroundColor Green
        Write-Host "📝 Current status:" -ForegroundColor Cyan
        git status --porcelain
    } else {
        Write-Host "❌ Failed to rollback to backup branch" -ForegroundColor Red
        git stash pop
        exit 1
    }
}

# Function to restore from main branch
function Rollback-ToMain {
    Write-Host "🔄 Rolling back to main branch" -ForegroundColor Yellow
    
    # Stash any current changes
    git stash
    
    # Checkout main branch
    git checkout main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully rolled back to main branch" -ForegroundColor Green
        Write-Host "📝 Current status:" -ForegroundColor Cyan
        git status --porcelain
    } else {
        Write-Host "❌ Failed to rollback to main branch" -ForegroundColor Red
        git stash pop
        exit 1
    }
}

# Function to list available rollback points
function Show-RollbackPoints {
    Write-Host "📋 Available rollback points:" -ForegroundColor Cyan
    Write-Host "1. v1.0-complete-business-portfolio (tagged version)" -ForegroundColor White
    Write-Host "2. backup-before-infrastructure-deployment (backup branch)" -ForegroundColor White
    Write-Host "3. main (main branch)" -ForegroundColor White
    Write-Host ""
}

# Main script logic
$action = $args[0]

switch ($action) {
    "tag" { Rollback-ToVersion "v1.0-complete-business-portfolio" }
    "v1.0" { Rollback-ToVersion "v1.0-complete-business-portfolio" }
    "backup" { Rollback-ToBackup }
    "main" { Rollback-ToMain }
    "list" { 
        Show-RollbackPoints
        Write-Host "Usage: .\rollback-script-v1.0.ps1 [tag|backup|main|list]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Cyan
        Write-Host "  tag|v1.0  - Rollback to tagged version v1.0-complete-business-portfolio" -ForegroundColor White
        Write-Host "  backup    - Rollback to backup branch" -ForegroundColor White
        Write-Host "  main      - Rollback to main branch" -ForegroundColor White
        Write-Host "  list      - List available rollback points" -ForegroundColor White
        Write-Host "  help      - Show this help message" -ForegroundColor White
    }
    "help" { 
        Show-RollbackPoints
        Write-Host "Usage: .\rollback-script-v1.0.ps1 [tag|backup|main|list]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Cyan
        Write-Host "  tag|v1.0  - Rollback to tagged version v1.0-complete-business-portfolio" -ForegroundColor White
        Write-Host "  backup    - Rollback to backup branch" -ForegroundColor White
        Write-Host "  main      - Rollback to main branch" -ForegroundColor White
        Write-Host "  list      - List available rollback points" -ForegroundColor White
        Write-Host "  help      - Show this help message" -ForegroundColor White
    }
    default { 
        Show-RollbackPoints
        Write-Host "Usage: .\rollback-script-v1.0.ps1 [tag|backup|main|list]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Cyan
        Write-Host "  tag|v1.0  - Rollback to tagged version v1.0-complete-business-portfolio" -ForegroundColor White
        Write-Host "  backup    - Rollback to backup branch" -ForegroundColor White
        Write-Host "  main      - Rollback to main branch" -ForegroundColor White
        Write-Host "  list      - List available rollback points" -ForegroundColor White
        Write-Host "  help      - Show this help message" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "🎯 Rollback complete! The system is now in a safe state." -ForegroundColor Green
Write-Host "💡 If you need to continue with infrastructure deployment, run the deployment script again." -ForegroundColor Cyan 