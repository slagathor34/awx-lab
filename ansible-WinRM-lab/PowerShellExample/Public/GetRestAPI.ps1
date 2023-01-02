<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
  Version:        1.0
  Author:         Sonny Stormes
  Creation Date:  1/1/2023
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. "C:\Scripts\Functions\Logging_Functions.ps1"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Log File Info
$sLogPath = "C:\Windows\Temp"
$sLogName = "Sampletemplate.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function Invoke-RestApiGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Uri
    )
    Begin{
        Log-Write -LogPath $sLogFile -LineValue "Getting the URL requested"
      }
    Process{    
        Try{
          # Send the GET request
          $response = Invoke-WebRequest -Method Get -Uri $Uri

          # Return the response as a string
          return $response.Content
        }
        Catch{
          Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
          Break
        }
    End{
            If($?){
              Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
              Log-Write -LogPath $sLogFile -LineValue " "
            }
          }
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
Invoke-RestApiGet
Log-Finish -LogPath $sLogFile
