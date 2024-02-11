function debug($fname, $message) {
    Write-Host "[$fname] $message" -ForegroundColor Green
}


function get-ubuntu-distro() {
    # Identify if distro has (Predeterminado) or something like that
    Invoke-Expression "wsl --list" | ForEach-Object {
        if ($_ -match '\)' ) {
            $distro=$_.split('(')[0].replace(" ","")

            debug 'get-ubuntu-distro' $_
            debug 'get-ubuntu-distro' $distro

            Out-String -InputObject $distro
        }
    }
}

[Environment]::SetEnvironmentVariable("WSL_DISTRO", $null, "User")

$WSL_DISTRO='Ubuntu-22.05'
$WSL_DISTRO=get-ubuntu-distro

debug 'main' $(Out-String -InputObject $WSL_DISTRO)

[Environment]::SetEnvironmentVariable("WSL_DISTRO", $WSL_DISTRO, "User")

#[Environment]::SetEnvironmentVariable("WSL_DISTRO", $global:WSL_DISTRO, "User")
#[Environment]::SetEnvironmentVariable("WSL_DISTRO", $global:WSL_DISTRO, "Machine")
