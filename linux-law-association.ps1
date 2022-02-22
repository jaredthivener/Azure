$RGName = '<rg-name>'
$VmName = '<vm-name>'
$Location = '<location>'

$ExtensionName = 'OmsAgentForLinux'
$Publisher = 'Microsoft.EnterpriseCloud.Monitoring'
$Version = '1.13'

$PublicConf = '{
    "workspaceId": <work-space-Id>,
    "stopOnMultipleConnections": "false"
}'
$PrivateConf = '{
    "workspaceKey": <work-space-key>,
    "vmResourceId": <resourceId>
}'

Set-AzVMExtension -ResourceGroupName $RGName -VMName $VmName -Location $Location `
  -Name $ExtensionName -Publisher $Publisher `
  -ExtensionType $ExtensionName -TypeHandlerVersion $Version `
  -Settingstring $PublicConf -ProtectedSettingString $PrivateConf
