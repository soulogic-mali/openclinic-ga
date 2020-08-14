@echo off

setup.exe /s /v"/qn /l*v %temp%\ururte_install.log"

REM Uncomment the line below to install without Authentication Services
REM
REM		setup.exe /s /v"ADDLOCAL=AlwaysInstalled,DotNet,Java,JavaPOS,OPOS /qn /l*v %temp%\ururte_install.log"

REM Uncomment the line below to disable reboot after installation
REM
REM		setup.exe /s /v"REBOOT=ReallySuppress /qn /l*v %temp%\ururte_install.log"


@pause

REM this batch file will perform a silent install