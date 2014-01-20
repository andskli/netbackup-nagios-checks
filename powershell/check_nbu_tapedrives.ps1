# check_nbu_tapedrives.ps1
#
# NetBackup cleaning tape checker - now in powerkjell!
#
# Author: Andreas Lindh <andreas@innovationgroup.se>
#

Param (
	[string]$health
	)

$RC = 0

# Error handling
trap {
    Write-Warning "EXCEPTION: ${$_.Exception.Message}";
    exit 2;
}


# Get NBU masterserver
Function Get-MasterServer {
    $NBUServerRegKey = "Software\Veritas\NetBackup\CurrentVersion\Config\";
    $NBUServers = Get-ItemProperty -path HKLM:\$NBUServerRegKey |% {$_.Server}
    $NBUMasterServer = $NBUServers[0]
    return $NBUMasterServer
}


$mastersrv = Get-MasterServer
Write-Host $mastersrv
#$out = & 'C:\Program Files\Veritas\Volmgr\bin\vmquery.exe' -h $mastersrv -b -a
#Write-Host $out