<#  
    Starts Minecraft for Windows 10 (Bedrock Edition) and changes to an other screen resolution beforehand
    Created: 2022-05-03 LierschIT
    Last Change: 2022-05-25 LierschIT
    License: MIT

    -----------

    MIT License

    Copyright (c) 2022 LierschIT

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
    and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>




# Creates the variables for the script
Set-Variable Module1,Module2,defaultresolution,ConfigPath,Choice,userresolution,width,height,ResolutionConfirm
Clear-Variable Module1,Module2,defaultresolution,ConfigPath,Choice,userresolution,width,height,ResolutionConfirm

# Function to write the values of the resolution as CSV
function func_resolution {
    param (
        $funcvar_width,
        $funcvar_height
    )
    $funcvar_resolution = @([pscustomobject]@{width=$funcvar_width;height=$funcvar_height})
    $funcvar_resolution | Export-CSV -Path "Config.csv"
    return 1
}

# Function to get the value from the user
function func_userchoice {
    param (
        $funcvar_object
    )
    do {
        Write-Host ("Which resolution " + $funcvar_object + "? (Example:1920): ") -NoNewline -ForegroundColor Red
        $funcvar_value = Read-Host
        if ($funcvar_value -notmatch "^[0-9]+$" -or $funcvar_value.Length -gt 4 -or $funcvar_value.Length -lt 3) {
            Write-Host "Your value is not numeric, to long or to short." -BackgroundColor Red -ForegroundColor White
        }

    } until ($funcvar_value -match "^[0-9]+$" -and $funcvar_value.Length -le 4 -and $funcvar_value.Length -ge 3)
    return $funcvar_value
}

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
# The first three entries are automatic and for the last the user can choose for himself
$defaultresolution = Get-DisplayResolution | Select-Object -Property dmPelsWidth,dmPelsHeight
$ConfigPath = Test-Path -Path .\Config.csv
if ($ConfigPath -ne $true) {
    do {

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
            $do_resolution = func_resolution 1920 1080
        }
        elseif ($Choice -eq 2) {
            $do_resolution = func_resolution 2560 1440
        }
        elseif ($Choice -eq 3) {
            $do_resolution = func_resolution 1280 720
        }
        elseif ($Choice -eq 4) {
            do {
                
                $width = func_userchoice "width"
                $height = func_userchoice "height"
                
                # User must confirm the custom config
                Write-Host ("Is the resolution ") -ForegroundColor DarkGreen -NoNewline
                Write-Host ($width + "x" + $height) -ForegroundColor White -NoNewline
                Write-Host (" ok? [y/N] ") -ForegroundColor DarkGreen -NoNewline
                $ResolutionConfirm = Read-Host
                if ($ResolutionConfirm -notmatch "[yY]") {
                    Write-Host " "
                    Write-Host "Please choose again!" -BackgroundColor Yellow -ForegroundColor Black
                    Write-Host " "
                }

            } until ($ResolutionConfirm -eq "y" -or $ResolutionChoice -eq "Y")    
            $do_resolution = func_resolution $width $height
        }
        else {
            Write-Host " "
            Write-Host "Sorry, I don't know your choice." -BackgroundColor Yellow -ForegroundColor Black
            Start-Sleep -Seconds 3
        }
        
    } until ($do_resolution)
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
Write-Host ("Changing Screen Resolution to default value "+ $defaultresolution.dmPelsWidth + "x" + $defaultresolution.dmPelsHeight + ".") -ForegroundColor Cyan
Set-ScreenResolution -Width $defaultresolution.dmPelsWidth -Height $defaultresolution.dmPelsHeight
Start-Sleep -Seconds 5
