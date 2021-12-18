@echo off

for /f "delims=" %%a in ('gzip.exe -c9 ignition_config.json ^| base64.exe -w0') do set _CmdResult=%%a

echo %_CmdResult%

SET GOVC_INSECURE=1
SET GOVC_URL=https://192.168.178.22/sdk
SET GOVC_USERNAME=root
SET GOVC_PASSWORD=vmware-password
SET GOVC_DATASTORE=ds1
SET GOVC_NETWORK="VM Network"
SET GOVC_RESOURCE_POOL=
govc.exe import.ova -name=testvm flatcar_production_vmware_ova.ova
govc.exe vm.change -e="guestinfo.ignition.config.data=%_CmdResult%" -vm=testvm
govc.exe vm.change -e="guestinfo.ignition.config.data.encoding=gzip+base64" -vm=testvm
govc.exe vm.power -on=true testvm