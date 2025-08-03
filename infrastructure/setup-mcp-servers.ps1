# MCP Servers Setup Script for Nexus Development Ecosystem
# This script automates the setup of all core MCP servers

Write-Host "🚀 Nexus Development Ecosystem - MCP Servers Setup" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Check if Docker is running
Write-Host "🔍 Checking Docker status..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "SUCCESS: Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check if required MCP server images are available
Write-Host "🔍 Checking MCP server images..." -ForegroundColor Yellow
$requiredImages = @(
    "mcp/docker",
    "mcp/github-mcp-server", 
    "mcp/playwright",
    "mcp/mongodb",
    "mcp/filesystem",
    "mcp/stripe"
)

foreach ($image in $requiredImages) {
    $exists = docker images $image --format "{{.Repository}}:{{.Tag}}" | Select-String $image
    if ($exists) {
        Write-Host "SUCCESS: $image is available" -ForegroundColor Green
    } else {
        Write-Host "❌ $image is missing. Pulling..." -ForegroundColor Red
        docker pull $image
    }
}

# Create .env file if it doesn't exist
$envFile = ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "📝 Creating .env file template..." -ForegroundColor Yellow
    @"
# Nexus Development Ecosystem - Environment Variables
# MCP Server Configuration

# GitHub Configuration
GITHUB_TOKEN=your_github_personal_access_token_here

# MongoDB Atlas Configuration  
MONGODB_ATLAS_URI=mongodb+srv://username:password@cluster.mongodb.net/nexus_development_ecosystem?retryWrites=true

# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Workspace Configuration
WORKSPACE_PATH=C:/Users/level/OneDrive/Documents/GitHub/nexus-development-ecosystem
"@ | Out-File -FilePath $envFile -Encoding UTF8
    
    Write-Host "SUCCESS: .env file created. Please update with your actual values." -ForegroundColor Green
} else {
    Write-Host "SUCCESS: .env file already exists" -ForegroundColor Green
}

# Test MCP server connections
Write-Host "🧪 Testing MCP server connections..." -ForegroundColor Yellow

# Test Docker MCP
Write-Host "Testing Docker MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/docker --help | Out-Null
    Write-Host "SUCCESS: Docker MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker MCP test failed" -ForegroundColor Red
}

# Test GitHub MCP
Write-Host "Testing GitHub MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/github-mcp-server --help | Out-Null
    Write-Host "SUCCESS: GitHub MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ GitHub MCP test failed" -ForegroundColor Red
}

# Test Playwright MCP
Write-Host "Testing Playwright MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/playwright --help | Out-Null
    Write-Host "SUCCESS: Playwright MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ Playwright MCP test failed" -ForegroundColor Red
}

# Test MongoDB MCP
Write-Host "Testing MongoDB MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/mongodb --help | Out-Null
    Write-Host "SUCCESS: MongoDB MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ MongoDB MCP test failed" -ForegroundColor Red
}

# Test Filesystem MCP
Write-Host "Testing Filesystem MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/filesystem --help | Out-Null
    Write-Host "SUCCESS: Filesystem MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ Filesystem MCP test failed" -ForegroundColor Red
}

# Test Stripe MCP
Write-Host "Testing Stripe MCP..." -ForegroundColor Cyan
try {
    docker run --rm -i mcp/stripe --help | Out-Null
    Write-Host "SUCCESS: Stripe MCP is working" -ForegroundColor Green
} catch {
    Write-Host "❌ Stripe MCP test failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "MCP Servers Setup Complete!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Update .env file with your actual API keys and tokens" -ForegroundColor White
Write-Host "2. Configure GitHub personal access token" -ForegroundColor White
Write-Host "3. Set up MongoDB Atlas cluster" -ForegroundColor White
Write-Host "4. Configure Stripe API keys" -ForegroundColor White
Write-Host "5. Test MCP server connections with real credentials" -ForegroundColor White
Write-Host "6. Proceed to Phase 2: Development Environment" -ForegroundColor White
Write-Host ""
Write-Host "💡 For help with API keys and configuration, see:" -ForegroundColor Cyan
Write-Host "   - GitHub: https://github.com/settings/tokens" -ForegroundColor White
Write-Host "   - MongoDB Atlas: https://cloud.mongodb.com" -ForegroundColor White
Write-Host "   - Stripe: https://dashboard.stripe.com/apikeys" -ForegroundColor White 