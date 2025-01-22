# Set terminal colors
$originalBackgroundColor = $host.UI.RawUI.BackgroundColor
$originalForegroundColor = $host.UI.RawUI.ForegroundColor
$host.UI.RawUI.BackgroundColor = "Blue"
$host.UI.RawUI.ForegroundColor = "Yellow"
Clear-Host

function Show-Menu {
    param (
        [string]$Title = 'Intune For Expert - Marcelo Goncalves MVP Security - v.1 - 2024'
    )
    cls
    Write-Host "================ $Title ================"
    Write-Host " 1. Connection Test (Application)"
    Write-Host " 2. Windows Autopilot (Application)"
    Write-Host " 3. Windows Autopilot (Login)"
    Write-Host " 4. Create Win32 App"
    Write-Host " 5. Install Microsoft Graph for Intune"
    Write-Host " 6. List Sync Devices"
    Write-Host " 7. Force Sync Devices"
    Write-Host " 8. All devices NonCompliant"
    Write-Host " 9. List Devices UserPrincipalName"
    Write-Host "10. List Serial Number"
    Write-Host "11. List Device Clean UP - Days"
    Write-Host "99. Disconnect Microsoft Graph"
    Write-Host " 0. Exit"
}

function Run-ConnectionTest {
    $appId = Read-Host "Enter your Application ID"
    $tenantId = Read-Host "Enter your Tenant ID"
    $appSecret = Read-Host "Enter your Application Secret" -AsSecureString

    $appSecretPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($appSecret))

    $Env:AZURE_CLIENT_ID = $appId
    $Env:AZURE_TENANT_ID = $tenantId
    $Env:AZURE_CLIENT_SECRET = $appSecretPlainText

    Connect-MgGraph -EnvironmentVariable
}

function Run-WindowsAutopilot {
    $appId = Read-Host "Enter your Application ID"
    $tenantId = Read-Host "Enter your Tenant ID"
    $appSecret = Read-Host "Enter your Application Secret" -AsSecureString
    $grouptag = Read-Host "Enter your Group Tag"

    $appSecretPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($appSecret))

    $Env:AZURE_CLIENT_ID = $appId
    $Env:AZURE_TENANT_ID = $tenantId
    $Env:AZURE_CLIENT_SECRET = $appSecretPlainText
    $Env:M365_CLIENT_GROUPTAG = $grouptag

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    Install-Module Microsoft.Graph -AllowClobber -Force
    Install-Script get-windowsautopilotinfo -Confirm:$false -Force:$true
    get-windowsautopilotinfo -Online -TenantId $tenantId -AppId $appId -AppSecret $appSecretPlainText -GroupTag $grouptag
}

function Run-WindowsAutopilotLogin {
    $grouptag = Read-Host "Enter your Group Tag"

    $Env:M365_CLIENT_GROUPTAG = $grouptag

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    Install-Module Microsoft.Graph -AllowClobber -Force

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force:$true
    Install-Script get-windowsautopilotinfo -Confirm:$false -Force:$true
    Get-WindowsAutoPilotInfo.ps1 -online -GroupTag $grouptag
}

function Run-CreateWin32App {
    $sourceFolder = Read-Host "Enter the source folder path"
    $setupFile = Read-Host "Enter the setup file name"
    $outputFolder = Read-Host "Enter the output folder path"

    $exePath = ".\Microsoft-Win32-Content-Prep-Tool-master\intuneWinAppUtil.exe"
    & $exePath -c $sourceFolder -s $setupFile -o $outputFolder
}

function Install-MicrosoftGraphIntune {
    Install-Module -Name Microsoft.Graph.Intune -Force -Confirm:$false
}

function List-SyncDevices {
    $device = Read-Host "Enter the device name to filter"
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.PrivilegedOperations.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementManagedDevices.Read.All" -NoWelcome
    Get-MgDeviceManagementManagedDevice -Filter "contains(deviceName,'$device')" | fl deviceName, ID, lastsyncdatetime
}

function Force-SyncDevices {
    $ID_Device = Read-Host "Enter the device ID to sync"
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementManagedDevices.Read.All" -NoWelcome
    Sync-MgDeviceManagementManagedDevice -ManagedDeviceId $ID_Device
}

function List-NonCompliantDevices {
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.PrivilegedOperations.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementManagedDevices.Read.All" -NoWelcome
    Get-MgDeviceManagementManagedDevice -Filter "complianceState eq 'noncompliant' and complianceState ne 'configManager'" | fl deviceName, ID, lastSyncDateTime, complianceState
}

function List-DevicesUserPrincipalName {
    $userPrincipalName = Read-Host "Enter the User Principal Name to filter"
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.PrivilegedOperations.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementManagedDevices.Read.All" -NoWelcome
    Get-MgDeviceManagementManagedDevice -Filter "contains(UserPrincipalName,'$userPrincipalName')" | fl userPrincipalName, deviceName, ID, lastsyncdatetime
}

function List-SerialNumber {
    $ID_Device = Read-Host "Enter the device ID to filter"
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.PrivilegedOperations.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementManagedDevices.Read.All" -NoWelcome
    $device = Get-MgDeviceManagementManagedDevice | Where-Object { $_.id -eq $ID_Device }
    if ($device) {
        $serialNumber = $device | Select-Object -ExpandProperty serialNumber
        Write-Host "Serial Number is: $serialNumber"
    } else {
        Write-Host "No device found with the specified ID."
    }
}

function List-DeviceCleanUpDays {
   

    function Login {
        try {
            Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All" -NoWelcome
            Write-Host "Login successful!" -ForegroundColor Green
        } catch {
            Write-Host "Login failed: $_" -ForegroundColor Red
            exit
        }
    }

    function Get-DeviceListForCleanUp {
        $days = Read-Host "Enter the number of days to use as the threshold"
        $thresholdDate = (Get-Date).AddDays(-[int]$days)

        try {
            $devices = Get-MgDeviceManagementManagedDevice |
                Where-Object { $_.LastSyncDateTime -lt $thresholdDate } |
                Select-Object LastSyncDateTime, 
                              @{Name="DaysSinceLastSync"; Expression={(Get-Date) - $_.LastSyncDateTime | Select-Object -ExpandProperty Days}},
                              UserPrincipalName, 
                              DeviceName, 
                              Manufacturer, 
                              Model, 
                              OperatingSystem

            if ($devices) {
                Write-Host "Devices that need clean up:" -ForegroundColor Yellow
                $devices | Format-Table -AutoSize
            } else {
                Write-Host "No devices need clean up." -ForegroundColor Green
            }
        } catch {
            Write-Host "Failed to retrieve devices: $_" -ForegroundColor Red
            Write-Host "Exception details: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Main script execution
    Login
    Get-DeviceListForCleanUp
}

function Disconnect-MicrosoftGraph {
    Disconnect-MgGraph
    Write-Host "Disconnected from Microsoft Graph." -ForegroundColor Green
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        1 {
            Write-Host "Running Connection Test (Application)..."
            Run-ConnectionTest
            Pause
        }
        2 {
            Write-Host "Running Windows Autopilot (Application)..."
            Run-WindowsAutopilot
            Pause
        }
        3 {
            Write-Host "Running Windows Autopilot (Login)..."
            Run-WindowsAutopilotLogin
            Pause
        }
        4 {
            Write-Host "Running Create Win32 App..."
            Run-CreateWin32App
            Pause
        }
        5 {
            Write-Host "Installing Microsoft Graph for Intune..."
            Install-MicrosoftGraphIntune
            Pause
        }
        6 {
            Write-Host "Listing Sync Devices..."
            List-SyncDevices
            Pause
        }
        7 {
            Write-Host "Forcing Sync Devices..."
            Force-SyncDevices
            Pause
        }
        8 {
            Write-Host "Listing All NonCompliant Devices..."
            List-NonCompliantDevices
            Pause
        }
        9 {
            Write-Host "Listing Devices with UserPrincipalName..."
            List-DevicesUserPrincipalName
            Pause
        }
        10 {
            Write-Host "Listing Serial Number..."
            List-SerialNumber
            Pause
        }
        11 {
            Write-Host "Listing Device Clean UP - Days..."
            List-DeviceCleanUpDays
            Pause
        }
        99 {
            Write-Host "Disconnecting Microsoft Graph..."
            Disconnect-MicrosoftGraph
            Pause
        }
        0 {
            Write-Host "Exiting..."
        }
        default {
            Write-Host "Invalid choice, please try again."
        }
    }
} while ($choice -ne 0)

# Restore original terminal colors
$host.UI.RawUI.BackgroundColor = $originalBackgroundColor
$host.UI.RawUI.ForegroundColor = $originalForegroundColor
Clear-Host