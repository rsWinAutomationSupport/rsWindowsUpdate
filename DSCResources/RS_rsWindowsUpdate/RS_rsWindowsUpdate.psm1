

function Test-rsRegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

    if(Test-Path $Path){
        
        try {

        Get-ItemProperty $Path -Name $Value -ErrorAction Stop | Out-Null
        return $true
         
         }

        catch {

        return $false

        }

        }
    else{return $false}
    }


function Get-rsRegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

    if(Test-Path $Path){
        
        try {

         Get-ItemProperty $Path -Name $Value -ErrorAction Stop | Select-Object -ExpandProperty $Value -ErrorAction Stop
                 
         }

        catch {}

        }
    }






function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("2","3","4","5")]
		[System.String]
		$AUOptions,

		[ValidateSet("2","3")]
		[System.String]
		$NoRebootWithLoggedOnUsers,

		[ValidateSet("0","1")]
		[System.String]
		$NoAutoUpdate,

		[ValidateSet("0","1","2","3","4","5","6","7")]
		[System.String]
		$ScheduledInstallDay,

		[ValidateSet("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23")]
		[System.String]
		$ScheduledInstallTime,

		[System.String]
		$WUServer,

		[System.String]
		$WUStatusServer,
		
		[ValidateSet("0","1")]
		[System.String]
		$UseWUServer,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	
	$configuration = @{
		AUOptions = $AUOptions
		NoRebootWithLoggedOnUsers = $NoRebootWithLoggedOnUsers
		NoAutoUpdate = $NoAutoUpdate
		ScheduledInstallDay = $ScheduledInstallDay
		ScheduledInstallTime = $ScheduledInstallTime
		WUServer = $WUServer
		WUStatusServer = $WUStatusServer
		UseWUServer = $UseWUServer
		Ensure = $Ensure
	}

	return $configuration
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("2","3","4","5")]
		[System.String]
		$AUOptions,

		[ValidateSet("2","3")]
		[System.String]
		$NoRebootWithLoggedOnUsers,

		[ValidateSet("0","1")]
		[System.String]
		$NoAutoUpdate,

		[ValidateSet("0","1","2","3","4","5","6","7")]
		[System.String]
		$ScheduledInstallDay,

		[ValidateSet("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23")]
		[System.String]
		$ScheduledInstallTime,

		[System.String]
		$WUServer,

		[System.String]
		$WUStatusServer,
		
		[ValidateSet("0","1")]
		[System.String]
		$UseWUServer,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	if(Ensure -like "Absent"){
		if(Test-Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU)
			{ Remove-Item HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Force }
			
		if(Test-RegistryValue -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Value WUServer)
			{ Remove-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer }
		
		if(Test-RegistryValue -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Value WUStatusServer)
			{ Remove-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer }
	}	


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("2","3","4","5")]
		[System.String]
		$AUOptions,

		[ValidateSet("2","3")]
		[System.String]
		$NoRebootWithLoggedOnUsers,

		[ValidateSet("0","1")]
		[System.String]
		$NoAutoUpdate,

		[ValidateSet("0","1","2","3","4","5","6","7")]
		[System.String]
		$ScheduledInstallDay,

		[ValidateSet("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23")]
		[System.String]
		$ScheduledInstallTime,

		[System.String]
		$WUServer,

		[System.String]
		$WUStatusServer,
		
		[ValidateSet("0","1")]
		[System.String]
		$UseWUServer,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	$IsValid = False
	
	if(Ensure -like "Absent"){
		if(Test-Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU)
			{}
		else
			{ $IsValid = True }
	}		
	
	
	else {

	$checkEnsure = if(Test-RegistryValue -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Value AUOptions) { (Get-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name AUOptions).AUOptions }
    $checkAUOptions = "4"
    $checkNoRebootWithLoggedOnUsers = "0"
    $checkNoAutoUpdate = "0"
    $checkScheduledInstallDay = "2"
    $checkScheduledInstallTime = "20"
    $checkWUServer = "https://mywsusserver.contoso.local"
    $checkWUStatusServer = "https://mywsusserver.contoso.local"
    $checkUseWUServer = "1"
	
	
	}
	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

