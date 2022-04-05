"vm1","vm2","vm3","vm4","vm5" | Foreach-Object {
  Start-Job -ScriptBlock {
      Start-AzVM -ResourceGroupName <rg-name> -Name $using:PSItem -Force
    }
}    
