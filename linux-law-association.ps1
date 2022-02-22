$RGName = '<rg-name>'
$VmName = '<vm-name>'
$Location = '<location>'

$ExtensionName = 'OmsAgentForLinux'
$Publisher = 'Microsoft.EnterpriseCloud.Monitoring'
$Version = '1.13'

$PublicConf = '{
    "workspaceId": "72ed5d97-12b6-4927-9968-26b0938ecc31",
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
