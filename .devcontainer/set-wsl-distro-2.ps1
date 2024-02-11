$global:WSL_DISTRO="NO DISTRO"


function debug($fname, $message) {
    Write-Host "[$fname] $message" -ForegroundColor Green
}

function get-ubuntu-distro() {
    # Identify if distro has (Predeterminado) or something like that
    Invoke-Expression "wsl --list" | ForEach-Object {
        if ($_ -match '\)' ) {
            $global:WSL_DISTRO=$_.split('(')[0].replace(" ","")
        }
    }

    debug "get-ubuntu-distro" "Linux distribution: $global:WSL_DISTRO"


    #debug "get-ubuntu-distro" "Stored variable: $([System.Environment]::GetEnvironmentVariable('WSL_DISTRO', 'User'))"
}


get-ubuntu-distro

[Environment]::SetEnvironmentVariable("WSL_DISTRO", $global:WSL_DISTRO, "User")
#[Environment]::SetEnvironmentVariable("WSL_DISTRO", "$global:WSL_DISTRO", "Machine")
