# Minecraft-Resolution Changer
A Powershell script for changing the resolution before starting Minecraft for Windows 10 (Bedrock Edition).

## Description
Minecraft for Windows 10 (Bedrock Edition) has no integrated resolution slider in the options. <br>
So the Windows App will start in the Desktop resolution, if the game is configured for fullscreen. 

In particular if you use RTX Resource Packs for Minecraft for Windows 10, the native Desktop resolution can have an big impact in performance. 

The best solution is to reduce the resolution. This script helps you to do this automatically with one double click.

## Requirements
You need to start Powershell with administrator privilege rights and execute the following command:
```powershell
Set-ExecutionPolicy Unrestriced
```
**You enabling unrestricted script support. So please be carefull which scripts you are using!**

## Usage
Double click on the "Start Minecraft-Resolution Changer.cmd". It will start automatically the Powershell Script.

On the first run the Powershell Script will install two PSGallery Modules for the current user:<br>
https://www.powershellgallery.com/packages/DisplaySettings/0.0.2 <br>
https://www.powershellgallery.com/packages/ChangeScreenResolution/1.2

Also it will ask the user to set the gaming resolution for Minecraft for Windows 10 and will save the choice in a CSV file. <br>
Afterwards it will change the Desktop resolution to the users choice and starts Minecraft for Windows 10. <br>
When Minecraft will be closed, the resolution will change back to the default resolution that was active before. <br>

## Known Issues
Really rare it can be that the script can't change back to the default 4k resolution.
