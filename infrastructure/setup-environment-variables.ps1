# Nexus Development Ecosystem - Environment Variables Setup
# ========================================================

Write-Host "Setting up environment variables for Nexus Development Ecosystem..." -ForegroundColor Green

# Create .env file in the root directory
$envFile = "C:\Users\level\OneDrive\Documents\GitHub\nexus-development-ecosystem\.env"

if (-not (Test-Path $envFile)) {
    $envContent = @"
# Nexus Development Ecosystem - Environment Variables
# ===================================================

# GitHub Configuration
GITHUB_TOKEN=your_github_personal_access_token_here
GITHUB_USERNAME=levelupreserved
GITHUB_API_URL=https://api.github.com

# MongoDB Atlas Configuration
MONGODB_ATLAS_URI=mongodb+srv://username:password@cluster.mongodb.net/nexus_development_ecosystem?retryWrites=true&w=majority
MONGODB_DATABASE=nexus_development_ecosystem

# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key_here

# Google Cloud Platform Configuration
GOOGLE_APPLICATION_CREDENTIALS=path/to/your/google-credentials.json
GCP_PROJECT_ID=nexus-development-ecosystem
GCP_REGION=us-central1

# SonarQube Configuration
SONARQUBE_TOKEN=your_sonarqube_token_here
SONARQUBE_URL=http://localhost:9000

# Sentry Configuration
SENTRY_AUTH_TOKEN=your_sentry_auth_token_here
SENTRY_ORG=your_sentry_org
SENTRY_PROJECT=nexus-development-ecosystem

# Workspace Configuration
WORKSPACE_PATH=C:/Users/level/OneDrive/Documents/GitHub/nexus-development-ecosystem
NODE_ENV=development

# MCP Server Configuration
MCP_DOCKER_HOST=unix:///var/run/docker.sock
MCP_SERVER_PORT=3000

# Context7 Configuration
CONTEXT7_API_KEY=your_context7_api_key_here

# Memory Server Configuration
MEMORY_SERVER_URL=http://localhost:3001

# Additional Services
SLACK_BOT_TOKEN=your_slack_bot_token_here
NOTION_API_KEY=your_notion_api_key_here
ATLASSIAN_API_TOKEN=your_atlassian_api_token_here

# Development Configuration
DEBUG=true
LOG_LEVEL=info
"@

    $envContent | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host "SUCCESS: .env file created at $envFile" -ForegroundColor Green
} else {
    Write-Host "INFO: .env file already exists at $envFile" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Update the .env file with your actual API keys and tokens" -ForegroundColor White
Write-Host "2. Set up GitHub Personal Access Token" -ForegroundColor White
Write-Host "3. Configure MongoDB Atlas connection string" -ForegroundColor White
Write-Host "4. Set up Stripe API keys" -ForegroundColor White
Write-Host "5. Configure Google Cloud credentials" -ForegroundColor White
Write-Host "6. Set up SonarQube and Sentry tokens" -ForegroundColor White
Write-Host ""
Write-Host "Environment variables setup complete!" -ForegroundColor Green 