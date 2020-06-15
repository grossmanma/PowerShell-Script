If not exist c:\windows\ccmsetup  goto nosccm
Start /wait c:\windows\ccmsetup\ccmsetup.exe /uninstall 
 rd c:\windows\ccm /q /s
rd c:\windows\ccmcache /q /s
rd c:\windows\ccmsetup  /q /s
del c:\windows\smscfg.ini
reg delete HKLM\software\Microsoft\ccm  /f
reg delete HKLM\software\Microsoft\CCMSETUP /f
reg delete HKLM\software\Microsoft\SMS\ /f
reg delete HKLM\software\Microsoft\Systemcertificates\SMS\Certificates /f
shutdown -r -t 15
:nosccm
exit
