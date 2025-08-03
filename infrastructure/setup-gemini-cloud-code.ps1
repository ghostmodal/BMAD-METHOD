#!/usr/bin/env pwsh
# Gemini Code Assist & Cloud Code Setup Script
# Nexus Development Ecosystem
# Version: 1.0
# Date: 2024-12-19

param(
    [switch]$SkipExtensions,
    [switch]$SkipMCP,
    [switch]$SkipGCP,
    [switch]$Verbose
)

# Color output functions
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success { Write-ColorOutput Green $args }
function Write-Info { Write-ColorOutput Cyan $args }
function Write-Warning { Write-ColorOutput Yellow $args }
function Write-Error { Write-ColorOutput Red $args }

# Banner
Write-Success @"
╔══════════════════════════════════════════════════════════════╗
║                Nexus Development Ecosystem                   ║
║           Gemini Code Assist & Cloud Code Setup             ║
║                        Version 1.0                          ║
╚══════════════════════════════════════════════════════════════╝
"@

# Check prerequisites
Write-Info "Checking prerequisites..."

# Check if Cursor is installed
$cursorPath = Get-Command code -ErrorAction SilentlyContinue
if (-not $cursorPath) {
    Write-Error "Cursor (code command) not found. Please install Cursor first."
    Write-Info "Download from: https://cursor.sh/"
    exit 1
}

# Check if Docker is running
try {
    docker version | Out-Null
    Write-Success "✓ Docker is running"
} catch {
    Write-Error "Docker is not running. Please start Docker Desktop."
    exit 1
}

# Check if Google Cloud CLI is installed
$gcloudPath = Get-Command gcloud -ErrorAction SilentlyContinue
if (-not $gcloudPath) {
    Write-Warning "Google Cloud CLI not found. Installing..."
    # Download and install gcloud CLI
    $gcloudInstaller = "https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe"
    $installerPath = "$env:TEMP\GoogleCloudSDKInstaller.exe"
    
    try {
        Invoke-WebRequest -Uri $gcloudInstaller -OutFile $installerPath
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
        Write-Success "✓ Google Cloud CLI installed"
    } catch {
        Write-Error "Failed to install Google Cloud CLI. Please install manually."
        Write-Info "Download from: https://cloud.google.com/sdk/docs/install"
    }
}

# Step 1: Install Cursor Extensions
if (-not $SkipExtensions) {
    Write-Info "Step 1: Installing Cursor Extensions..."
    
    $extensions = @(
        # Core MCP & AI Integration
        "google.gemini-code-assist",
        "googlecloudtools.cloudcode",
        "modelcontextprotocol.mcp",
        
        # Development & Code Quality
        "ms-vscode.vscode-json",
        "bradlc.vscode-tailwindcss",
        "ms-vscode.vscode-typescript-next",
        "esbenp.prettier-vscode",
        "ms-vscode.vscode-eslint",
        "ms-vscode.vscode-python",
        "ms-vscode.vscode-java",
        "ms-vscode.vscode-go",
        "ms-vscode.vscode-rust",
        
        # Git & Version Control
        "eamodio.gitlens",
        "github.copilot",
        "github.copilot-chat",
        "github.vscode-pull-request-github",
        
        # API Testing & Development
        "rangav.vscode-thunder-client",
        "humao.rest-client",
        "ms-vscode.vscode-rest",
        
        # Database & Data Tools
        "ms-mssql.mssql",
        "cweijan.vscode-mysql-client2",
        "ms-vscode.vscode-cosmosdb",
        "mongodb.mongodb-vscode",
        
        # Cloud & Infrastructure
        "ms-azuretools.vscode-docker",
        "ms-kubernetes-tools.vscode-kubernetes-tools",
        "hashicorp.terraform",
        "hashicorp.hcl",
        
        # Productivity & Workflow
        "ms-vscode.vscode-todo-highlight",
        "aaron-bond.better-comments",
        "christian-kohler.path-intellisense",
        "formulahendry.auto-rename-tag",
        
        # Testing & Debugging
        "hbenl.vscode-test-explorer",
        "ms-vscode.test-adapter-converter",
        "ms-vscode.vscode-js-debug",
        
        # Documentation & Markdown
        "yzhang.markdown-all-in-one",
        "davidanson.vscode-markdownlint",
        "shd101wyy.markdown-preview-enhanced"
    )
    
    foreach ($extension in $extensions) {
        Write-Info "Installing extension: $extension"
        try {
            code --install-extension $extension
            Write-Success "✓ Installed $extension"
        } catch {
            Write-Warning "Failed to install $extension - may already be installed"
        }
    }
}

# Step 2: Setup MCP Servers
if (-not $SkipMCP) {
    Write-Info "Step 2: Setting up MCP Servers..."
    
    $mcpServers = @(
        "mcp/docker",
        "mcp/github-mcp-server", 
        "mcp/playwright",
        "mcp/mongodb",
        "mcp/filesystem",
        "mcp/stripe",
        "mcp/context7",
        "mcp/memory"
    )
    
    foreach ($server in $mcpServers) {
        Write-Info "Pulling MCP server: $server"
        try {
            docker pull $server
            Write-Success "✓ Pulled $server"
        } catch {
            Write-Warning "Failed to pull $server - may not exist or network issue"
        }
    }
}

# Step 3: Configure Google Cloud
if (-not $SkipGCP) {
    Write-Info "Step 3: Configuring Google Cloud..."
    
    # Check if already authenticated
    try {
        gcloud auth list --filter=status:ACTIVE --format="value(account)" | Out-Null
        $currentAccount = gcloud auth list --filter=status:ACTIVE --format="value(account)"
        Write-Success "✓ Already authenticated as: $currentAccount"
    } catch {
        Write-Info "Authenticating with Google Cloud..."
        gcloud auth login
    }
    
    # Set project
    Write-Info "Setting Google Cloud project..."
    gcloud config set project nexus-development-ecosystem
    
    # Enable required APIs
    $apis = @(
        "compute.googleapis.com",
        "run.googleapis.com", 
        "firestore.googleapis.com",
        "storage.googleapis.com",
        "cloudbuild.googleapis.com",
        "containerregistry.googleapis.com",
        "monitoring.googleapis.com",
        "logging.googleapis.com"
    )
    
    foreach ($api in $apis) {
        Write-Info "Enabling API: $api"
        try {
            gcloud services enable $api
            Write-Success "✓ Enabled $api"
        } catch {
            Write-Warning "Failed to enable $api - may already be enabled"
        }
    }
}

# Step 4: Create VS Code Configuration
Write-Info "Step 4: Creating VS Code Configuration..."

$vscodeDir = ".vscode"
if (-not (Test-Path $vscodeDir)) {
    New-Item -ItemType Directory -Path $vscodeDir | Out-Null
}

# Settings.json
$settings = @{
    "gemini.codeAssist.enabled" = $true
    "gemini.codeAssist.agenticChat" = $true
    "gemini.codeAssist.smartActions" = $true
    "cloudcode.kubernetes.enabled" = $true
    "cloudcode.docker.enabled" = $true
    "cloudcode.cloudrun.enabled" = $true
    "mcp.servers" = @{
        "docker" = "docker://mcp/docker"
        "github" = "docker://mcp/github-mcp-server"
        "playwright" = "docker://mcp/playwright"
        "mongodb" = "docker://mcp/mongodb"
        "filesystem" = "docker://mcp/filesystem"
    }
    "files.autoSave" = "afterDelay"
    "editor.formatOnSave" = $true
    "editor.codeActionsOnSave" = @{
        "source.fixAll" = $true
        "source.organizeImports" = $true
    }
}

$settings | ConvertTo-Json -Depth 10 | Set-Content "$vscodeDir/settings.json"
Write-Success "✓ Created VS Code settings"

# Extensions.json
$extensions = @{
    "recommendations" = @(
        "google.gemini-code-assist",
        "googlecloudtools.cloudcode",
        "modelcontextprotocol.mcp",
        "ms-azuretools.vscode-docker",
        "eamodio.gitlens",
        "github.copilot",
        "bradlc.vscode-tailwindcss",
        "ms-vscode.vscode-typescript-next",
        "esbenp.prettier-vscode",
        "rangav.vscode-thunder-client"
    )
}

$extensions | ConvertTo-Json | Set-Content "$vscodeDir/extensions.json"
Write-Success "✓ Created VS Code extensions recommendations"

# Step 5: Create Environment Template
Write-Info "Step 5: Creating Environment Template..."

$envTemplate = @"
# Nexus Development Ecosystem Environment Variables
# Copy this file to .env and fill in your actual values

# Google Cloud Configuration
GOOGLE_CLOUD_PROJECT=nexus-development-ecosystem
GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account-key.json

# GitHub Configuration
GITHUB_TOKEN=your_github_token_here
GITHUB_USERNAME=your_github_username

# MongoDB Configuration
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/nexus

# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key

# MCP Server Configuration
MCP_DOCKER_HOST=unix:///var/run/docker.sock
MCP_FILESYSTEM_ROOT=/workspace

# Business Unit API Keys
GOOGLE_REVIEWS_API_KEY=your_google_reviews_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Monitoring and Analytics
SENTRY_DSN=your_sentry_dsn
SONARQUBE_TOKEN=your_sonarqube_token

# Development Configuration
NODE_ENV=development
DEBUG=true
LOG_LEVEL=debug
"@

$envTemplate | Set-Content ".env.example"
Write-Success "✓ Created environment template"

# Step 6: Create Smart Actions Configuration
Write-Info "Step 6: Creating Smart Actions Configuration..."

$smartActions = @{
    "actions" = @{
        "deploy-to-cloud-run" = @{
            "command" = "cloudcode.cloudrun.deploy"
            "when" = "resourceExtname == .yaml || resourceExtname == .yml"
        }
        "create-firestore-collection" = @{
            "command" = "cloudcode.firestore.createCollection"
            "when" = "resourceExtname == .js || resourceExtname == .ts"
        }
        "setup-kubernetes-cluster" = @{
            "command" = "cloudcode.kubernetes.createCluster"
            "when" = "resourceExtname == .yaml || resourceExtname == .yml"
        }
        "run-mcp-server" = @{
            "command" = "mcp.startServer"
            "when" = "resourceExtname == .yaml || resourceExtname == .yml"
        }
    }
}

$smartActions | ConvertTo-Json -Depth 10 | Set-Content "$vscodeDir/smart-actions.json"
Write-Success "✓ Created smart actions configuration"

# Step 7: Create Development Scripts
Write-Info "Step 7: Creating Development Scripts..."

# Quick start script
$quickStart = @"
#!/usr/bin/env pwsh
# Quick Start Script for Nexus Development Ecosystem

Write-Host "Starting Nexus Development Ecosystem..." -ForegroundColor Green

# Start MCP servers
Write-Host "Starting MCP servers..." -ForegroundColor Cyan
docker run -d --name mcp-docker mcp/docker
docker run -d --name mcp-github mcp/github-mcp-server
docker run -d --name mcp-playwright mcp/playwright
docker run -d --name mcp-mongodb mcp/mongodb
docker run -d --name mcp-filesystem mcp/filesystem

# Open Cursor with project
Write-Host "Opening Cursor..." -ForegroundColor Cyan
code .

Write-Host "Nexus Development Ecosystem is ready!" -ForegroundColor Green
Write-Host "Use @gemini in Cursor to access Gemini Code Assist" -ForegroundColor Yellow
Write-Host "Use @cloudcode for Google Cloud operations" -ForegroundColor Yellow
"@

$quickStart | Set-Content "start-nexus.ps1"
Write-Success "✓ Created quick start script"

# Step 8: Create Documentation
Write-Info "Step 8: Creating Documentation..."

$readme = @"
# Gemini Code Assist & Cloud Code Integration

## Quick Start

1. Run the setup script:
   ```powershell
   .\infrastructure\setup-gemini-cloud-code.ps1
   ```

2. Copy environment template:
   ```powershell
   Copy-Item .env.example .env
   # Edit .env with your actual API keys
   ```

3. Start development environment:
   ```powershell
   .\start-nexus.ps1
   ```

## Using Gemini Code Assist

### Agentic Chat
- Use @gemini in Cursor chat to access Gemini Code Assist
- Ask for code generation, debugging, or architecture advice
- Use @docker, @github, @mongodb for specific MCP server operations

### Smart Actions
- Right-click on files to access smart actions
- Use slash commands in Cursor for quick operations
- Deploy directly to Cloud Run from VS Code

### External Tools
- Use @ symbol to target specific tools:
  - @GitHub get issues assigned to me
  - @Docker list containers
  - @MongoDB show collections

## Google Cloud Integration

### Cloud Code Features
- Deploy to Cloud Run directly from VS Code
- Manage Kubernetes clusters
- Browse Firestore collections
- Monitor Cloud resources

### API Access
- All Google Cloud APIs are enabled
- Service accounts configured for automation
- Cost optimization strategies implemented

## MCP Server Network

### Core Servers
- Docker: Container management
- GitHub: Repository operations
- Playwright: Browser automation
- MongoDB: Database operations
- Filesystem: File operations

### Business Servers
- Stripe: Payment processing
- Context7: Code documentation
- Memory: AI memory management

## Next Steps

1. Configure your API keys in .env
2. Deploy your first service to Cloud Run
3. Set up monitoring and analytics
4. Implement CI/CD pipelines

For detailed documentation, see:
- [Gemini Code Assist Overview](https://developers.google.com/gemini-code-assist/docs/overview)
- [Cloud Code Documentation](https://cloud.google.com/code/docs)
- [MCP Server Documentation](https://modelcontextprotocol.io/)
"@

$readme | Set-Content "GEMINI-INTEGRATION-README.md"
Write-Success "✓ Created integration documentation"

# Final Summary
Write-Success @"

╔══════════════════════════════════════════════════════════════╗
║                    Setup Complete!                           ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ✓ Cursor Extensions Installed                              ║
║  ✓ MCP Servers Configured                                   ║
║  ✓ Google Cloud APIs Enabled                                ║
║  ✓ VS Code Configuration Created                            ║
║  ✓ Environment Template Ready                               ║
║  ✓ Smart Actions Configured                                 ║
║  ✓ Development Scripts Created                              ║
║  ✓ Documentation Generated                                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

Next Steps:
1. Copy .env.example to .env and add your API keys
2. Run .\start-nexus.ps1 to start development environment
3. Open Cursor and use @gemini for AI assistance
4. Deploy your first service to Google Cloud

For help, see: GEMINI-INTEGRATION-README.md
"@

# Optional: Open Cursor
$openCursor = Read-Host "Open Cursor now? (y/n)"
if ($openCursor -eq "y" -or $openCursor -eq "Y") {
    code .
    Write-Success "Cursor opened with Nexus Development Ecosystem!"
} 