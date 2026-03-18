function Install-WingetPackages {
    <#
    .SYNOPSIS
        Installs a curated list of packages using winget with error handling
    .DESCRIPTION
        Attempts to install each package individually, logging successes and failures
    #>

    # List of packages to install
    $packages = @(
        'Nvidia.PhysX',
        '9NF8H0H7WMLT',
        'abbodi1406.vcredist',
        'Realtek.RealtekAudioControl',
        'seerge.g-helper',
        '9MWF2DWS5Z9N',
        'Parsec.Parsec',
        'Microsoft.VisualStudio.2022.BuildTools',
        'AutoHotkey.AutoHotkey',
        'Git.Git',
        'GitHub.cli'
    )

    # Common arguments for all installations
    $wingetArgs = @(
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--silent'
    )

    # Track results
    $successful = @()
    $failed = @()

    Write-Host "Starting installation of $($packages.Count) packages..." -ForegroundColor Cyan
    Write-Host ""

    foreach ($package in $packages) {
        Write-Host "Installing $package..." -ForegroundColor Yellow

        try {
            $process = Start-Process -FilePath "winget" `
                                    -ArgumentList (@('install') + $wingetArgs + $package) `
                                    -NoNewWindow `
                                    -Wait `
                                    -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host "  ✓ $package installed successfully" -ForegroundColor Green
                $successful += $package
            } else {
                Write-Host "  ✗ $package failed (Exit Code: $($process.ExitCode))" -ForegroundColor Red
                $failed += $package
            }
        }
        catch {
            Write-Host "  ✗ $package failed with error: $($_.Exception.Message)" -ForegroundColor Red
            $failed += $package
        }

        Write-Host ""
    }

    # Summary
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "Installation Summary" -ForegroundColor Cyan
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "Successful: $($successful.Count)" -ForegroundColor Green
    Write-Host "Failed: $($failed.Count)" -ForegroundColor Red

    if ($failed.Count -gt 0) {
        Write-Host "`nFailed packages:" -ForegroundColor Red
        $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    }

    Write-Host ""
}

# Alias for easier use
Set-Alias -Name wingit -Value Install-WingetPackages

# Export the function
Export-ModuleMember -Function Install-WingetPackages -Alias wingit
