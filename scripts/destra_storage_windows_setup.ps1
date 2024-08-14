function Install-Choco {
    # Check if Chocolatey is installed
    $chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue

    if ($chocoInstalled) {
        Write-Host "Chocolatey is already installed."
    } else {
        Write-Host "Chocolatey not found. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 0x300 -bor 0xC00
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "Chocolatey installed successfully."
    }
}

function Add-NodeJsToPath {
    $nodePath = "$env:ProgramFiles\nodejs"
    if (Test-Path $nodePath) {
        Write-Host "Adding Node.js to PATH..."
        $env:Path = [System.String]::Join(";", $env:Path, $nodePath)
    } else {
        Write-Host "Node.js installation directory not found at $nodePath. Exiting script."
        exit
    }
}

function Check-Version {
    param (
        [string]$command,
        [string]$requiredVersion
    )

    try {
        $currentVersion = & $command --version
        $currentVersion = $currentVersion -replace '[^\d.]', ''
        if ([version]$currentVersion -ge [version]$requiredVersion) {
            return $true
        } else {
            return $false
        }
    } catch {
        return $false
    }
}

function Install-Git {
    # Check if Git is installed
    $gitInstalled = Get-Command git -ErrorAction SilentlyContinue

    if ($gitInstalled) {
        Write-Host "Git is already installed."

        # Check if Git is in PATH
        $gitPath = "C:\Program Files\Git\cmd"
        if ($env:Path -contains $gitPath) {
            Write-Host "Git is found in PATH. Moving on..."
        } else {
            Write-Host "Git is installed but not found in PATH. Adding Git to PATH..."
            $env:Path += ";$gitPath"
            [System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)
            refreshenv
        }
    } else {
        Write-Host "Git not found. Installing Git via Chocolatey..."
        choco install git -y
        refreshenv

        # Manually add Git to PATH if it's not found after installation
        $gitPath = "C:\Program Files\Git\cmd"
        $retryCount = 0
        while (-not (Get-Command git -ErrorAction SilentlyContinue) -and $retryCount -lt 3) {
            Write-Host "Attempting to add Git to PATH and retry..." -ForegroundColor Yellow
            if ($env:Path -notcontains $gitPath) {
                $env:Path += ";$gitPath"
            }
            [System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)
            refreshenv
            Start-Sleep -Seconds 5
            $retryCount++
        }

        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            Write-Host "Git still not found after retries. Continuing with the script..."
        } else {
            Write-Host "Git found after retries. Moving on..."
        }
    }
}

function Install-Tools {
    # Install Chocolatey if not already installed
    Install-Choco

    # Check if Node.js (and npm) is installed and meets the required version
    if (Check-Version -command "node" -requiredVersion "20.0.0") {
        Write-Host "Node.js is already at version 20.0.0 or later."
    } else {
        Write-Host "Installing Node.js version 20.16.0 (includes npm)..."
        choco install nodejs --version=20.16.0 -y

        # Add Node.js to the PATH for the current session
        Add-NodeJsToPath

        # Verify Node.js installation
        if (Get-Command node -ErrorAction SilentlyContinue) {
            Write-Host "Node.js and npm installed successfully."
        } else {
            Write-Host "Node.js installation failed. Exiting script."
            exit
        }
    }

    # Install Git and ensure it's in PATH
    Install-Git

    # Install pm2 globally using npm if not already installed
    if (Get-Command pm2 -ErrorAction SilentlyContinue) {
        Write-Host "pm2 is already installed."
    } else {
        Write-Host "Installing pm2 globally..."
        npm install -g pm2
    }
}

# Install necessary tools
Install-Tools

# Get the path where the script is located
$scriptPath = $PSScriptRoot  # $PSScriptRoot gives the directory where the script is running
$repoPath = Join-Path -Path $scriptPath -ChildPath "destra-storage-node"

# Check if the repository directory already exists
if (Test-Path $repoPath) {
    Write-Host "The repository directory 'destra-storage-node' already exists."
    Write-Host "Skipping cloning the repository."

    # Empty the .env file if it exists
    $envFile = Join-Path -Path $repoPath -ChildPath ".env"
    if (Test-Path $envFile) {
        Write-Host "Emptying the existing .env file..."
        Clear-Content $envFile
    }

    # Copy .env.example to .env
    $envExampleFile = Join-Path -Path $repoPath -ChildPath ".env.example"
    if (Test-Path $envExampleFile) {
        Write-Host "Copying .env.example to .env..."
        Copy-Item $envExampleFile $envFile -Force
    } else {
        Write-Host ".env.example file not found. Please ensure it exists in the repository."
        exit
    }
} else {
    # Clone the repository
    Write-Host "Cloning the repository..."
    git clone https://github.com/DestraNetwork/destra-storage-node $repoPath

    # Navigate to the repository directory
    Set-Location -Path $repoPath

    # Install npm dependencies
    Write-Host "Installing npm dependencies..."
    npm install

    # Copy .env.example to .env
    $envExampleFile = Join-Path -Path $repoPath -ChildPath ".env.example"
    $envFile = Join-Path -Path $repoPath -ChildPath ".env"
    if (Test-Path $envExampleFile) {
        Write-Host "Copying .env.example to .env..."
        Copy-Item $envExampleFile $envFile
    } else {
        Write-Host ".env.example file not found. Please ensure it exists in the repository."
        exit
    }
}

# Prompt user for input
$RPC_URL = Read-Host "Enter your Sepolia RPC Endpoint (e.g., https://sepolia.infura.io/v3/<Infura_Key>)"
$PRIVATE_KEY = Read-Host "Enter your private key"

# Check if the private key starts with "0x" and prepend it if necessary
if (-not $PRIVATE_KEY.StartsWith("0x")) {
    $PRIVATE_KEY = "0x" + $PRIVATE_KEY
}

$PUBLIC_IP = Read-Host "Enter your public IP address"
$NODE_PORT = Read-Host "Enter the port for your node to listen on (default: 10806)"
if (-not $NODE_PORT) { $NODE_PORT = "10806" }

# Default values for fixed contract addresses and URLs
$BOOTSTRAP_CONTRACT_ADDRESS = "0xf0DB1777c6f5E7Afb6d9a5af095AE008B9B2aA98"
$STORAGE_NODE_CONTRACT_ADDRESS = "0x03C66CB1826BDB0395BF31E68Bf7E873e9564fFB"
$BLOCKSTORE_DIRECTORY = "./block_store/"
$SUBGRAPH_URL = "https://api.studio.thegraph.com/query/69390/destra-storage-bootstrap-nodes/version/latest"

# Update .env file with the provided values
Write-Host "Updating .env file with the provided values..."
(Get-Content $envFile) -replace "RPC_URL=", "RPC_URL=$RPC_URL" `
                      -replace "PRIVATE_KEY=", "PRIVATE_KEY=$PRIVATE_KEY" `
                      -replace "BOOTSTRAP_CONTRACT_ADDRESS=", "BOOTSTRAP_CONTRACT_ADDRESS=$BOOTSTRAP_CONTRACT_ADDRESS" `
                      -replace "STORAGE_NODE_CONTRACT_ADDRESS=", "STORAGE_NODE_CONTRACT_ADDRESS=$STORAGE_NODE_CONTRACT_ADDRESS" `
                      -replace "PUBLIC_IP=", "PUBLIC_IP=$PUBLIC_IP" `
                      -replace "NODE_PORT=10806", "NODE_PORT=$NODE_PORT" `
                      -replace "BLOCKSTORE_DIRECTORY=./block_store/", "BLOCKSTORE_DIRECTORY=$BLOCKSTORE_DIRECTORY" `
                      -replace "SUBGRAPH_URL=", "SUBGRAPH_URL=$SUBGRAPH_URL" | Set-Content $envFile

# Run the Destra Storage Node using pm2
Write-Host "Starting the Destra Storage Node using pm2..."
$storageNodeScript = Join-Path -Path $repoPath -ChildPath "storage-node.js"
pm2 start $storageNodeScript --name "destra-storage-node"

Write-Host "Destra Storage Node is now running under pm2."