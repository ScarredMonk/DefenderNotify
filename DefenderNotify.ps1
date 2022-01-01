$DefenderNotify = @{
    Query = "SELECT * FROM __InstanceModificationEvent WITHIN 5 WHERE TargetInstance ISA 'MSFT_MpPreference' AND TargetInstance.DisableRealtimeMonitoring=True"
    Action = {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = ‘MS Defender has been disabled remotely'
        $balmsg.BalloonTipTitle = "Alert from Administrator for $Env:USERNAME"
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(20000)
    }

	Namespace = 'root\microsoft\windows\defender'
    SourceIdentifier = "Defender.DisableRealtimeMonitoring"
}

$Null = Register-WMIEvent @DefenderNotify

#Uninstall: Unregister-Event Defender.DisableRealtimeMonitoring