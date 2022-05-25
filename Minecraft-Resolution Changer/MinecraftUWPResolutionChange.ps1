## Starts Minecraft for Windows 10 (Bedrock Edition) and changes to an other screen resolution beforehand
## Created: 2022-05-03 LierschIT
## Last Change: 2022-05-25 LierschIT


# Installs needed PS Modules from PSGallery
# https://www.powershellgallery.com/packages/DisplaySettings/0.0.2
# https://www.powershellgallery.com/packages/ChangeScreenResolution/1.2
$Module1 = Get-InstalledModule -Name ChangeScreenResolution
$Module2 = Get-InstalledModule -Name DisplaySettings
if ($null -eq $Module1) {
    Install-Module -Name ChangeScreenResolution -Force -Confirm:$false -Scope CurrentUser
}

if ($null -eq $Module2) {
    Install-Module -Name DisplaySettings -Force -Confirm:$false -Scope CurrentUser
}

# On first start the user must choose the resolution
$defaultresolution = Get-DisplayResolution | Select-Object -Property dmPelsWidth,dmPelsHeight
$ConfigPath = Test-Path -Path .\Config.csv
if ($ConfigPath -ne $true) {
    do {
        $end = 0
        Clear-Host
        Write-Host "#=================================#" -ForegroundColor Green
        Write-Host "|  Choose a Resolution you want   |" -ForegroundColor Green
        Write-Host "|     to play Minecraft with      |" -ForegroundColor Green
        Write-Host "#=================================#" -ForegroundColor Green
        Write-Host " "
        Write-Host " "
        Write-Host "Resolutions:"
        Write-Host "1. 1920x1080"
        Write-Host "2. 2560x1440"
        Write-Host "3. 1280x720"
        Write-Host "4. User Custom Config"
        Write-Host " "
        Write-Host "Please choose a resolution you want to play Minecraft for Windows 10: " -ForegroundColor Red -NoNewline
        $Choice = Read-Host
        Write-Host " "
        if ($Choice -eq 1) {
            $end = 1
            $resolution = @([pscustomobject]@{width=1920;height=1080})
            $resolution | Export-CSV -Path "Config.csv"
        }
        elseif ($Choice -eq 2) {
            $end = 1
            $resolution = @([pscustomobject]@{width=2560;height=1440})
            $resolution | Export-CSV -Path "Config.csv"
        }
        elseif ($Choice -eq 3) {
            $end = 1
            $resolution = @([pscustomobject]@{width=1280;height=720})
            $resolution | Export-CSV -Path "Config.csv"
        }
        elseif ($Choice -eq 4) {
            $end = 1
            Write-Host "Which resolution width? (1920): " -NoNewline -ForegroundColor Red
            $width = Read-Host
            Write-Host "Which resolution height? (1080): " -NoNewline -ForegroundColor Red
            $height = Read-Host

            $resolution = @([pscustomobject]@{width=$width;height=$height})
            $resolution | Export-CSV -Path "Config.csv"
        }
        else {
            Write-Host "Sorry, I don't know your choice."
            Start-Sleep -Seconds 3
        }
        
    } until ($end -eq 1)
    Write-Host " "
    Write-Host "Your choice is saved." -ForegroundColor Cyan
    Write-Host " "
    Start-Sleep -Seconds 3
}

$userresolution = Import-CSV -Path .\Config.csv


# Changing screen resolution
Write-Host ("Changing screen resolution to " + $userresolution[0].width + "x" + $userresolution[0].height + ".") -ForegroundColor Cyan
Set-ScreenResolution -Width $userresolution[0].width -Height $userresolution[0].height

# Starting Minecraft
Write-Host "Starting Minecraft for Windows 10 (Bedrock Edition)." -ForegroundColor Yellow
Start-Sleep -Seconds 5
Start-Process explorer.exe shell:appsFolder\Microsoft.MinecraftUWP_8wekyb3d8bbwe!App
Start-Sleep -Seconds 3

# Waiting for closing Minecraft process
Wait-Process -Name "Minecraft.Windows"
Start-Sleep -Seconds 3
Write-Host "Minecraft for Windows 10 (Bedrock Edition) was closed." -ForegroundColor Yellow

# Changing screen resolution back to normal / only works with 3840 x 2160 (4K), if the resolution was configured before
Write-Host "Changing Screen Resolution to default value" -ForegroundColor Cyan
Set-ScreenResolution -Width $defaultresolution.dmPelsWidth -Height $defaultresolution.dmPelsHeight
Start-Sleep -Seconds 5
