; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "IntuSoft"
!define PRODUCT_VERSION "4.3.0_alpha3"
!define PRODUCT_PUBLISHER "Sigtuple Technologies Pvt Ltd"
!define PRODUCT_WEB_SITE "https//www.sigtuple.com"
!define PRODUCT_MRN_KEY "Software\Intusoft"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\IntuSoft.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define INSTALL_PATH "$PROGRAMFILES64\Intuvision Labs Pvt Ltd\IntuSoft ${PRODUCT_VERSION}"
!define APP_DIR_PATH "Intuvision Labs Pvt Ltd"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "C:\Program Files (x86)\HMSoft\NIS Edit\IntuSoft.ico"
!define MUI_UNICON "C:\Program Files (x86)\HMSoft\NIS Edit\IntuSoft.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "${INSTALL_PATH}\IntuSoft.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "IntuSoftSetup.exe"
InstallDir "${INSTALL_PATH}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  SetRegView 64
ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString"

${If} $0 != ""
${AndIf} ${Cmd} `MessageBox MB_YESNO|MB_ICONQUESTION "Uninstall previous version?" /SD IDYES IDYES`
	 ExecWait $0
	 BringToFront
	 Sleep 20000
	${If} $0 <> 0
		MessageBox MB_YESNO|MB_ICONSTOP "Failed to uninstall, continue anyway?" /SD IDYES IDYES +2
			Abort
	${EndIf}
${EndIf}
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "${INSTALL_PATH}"
  SetOverwrite ifnewer
  File /r "D:\Projects\IntuSoftInstaller\Release\*"
  CreateDirectory "$SMPROGRAMS\IntuSoft"
  ;CreateDirectory "$APPDATA\Intuvision Labs Pvt Ltd\ReportTemplates"
  CreateShortCut "$SMPROGRAMS\IntuSoft\IntuSoft.lnk" "${INSTALL_PATH}\IntuSoft.exe"
  CreateShortCut "$DESKTOP\IntuSoft.lnk" "${INSTALL_PATH}\IntuSoft.exe"
  
  
SectionEnd

Section -Post
  SetRegView 64
  WriteUninstaller "${INSTALL_PATH}\uninst.exe"
  ReadRegStr $0 HKLM "${PRODUCT_MRN_KEY}" "MRN"
${If} $0 == ""
  writeRegStr HKLM "${PRODUCT_MRN_KEY}" "MRN" "0"
${Endif}
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "${INSTALL_PATH}\IntuSoft.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\IntuSoft.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  call Copy2AppData
  ;IfFileExists "$APPDATA\Intuvision Labs Pvt Ltd\ReportTemplates\*.*" +2
      ;Copyfiles "Intusoft_QI_Integration_Alpha5\ReportTemplates\*.*" "$APPDATA\Intuvision Labs Pvt Ltd\ReportTemplates\"
      
SectionEnd

Function Copy2AppData

         CreateDirectory "$APPDATA\Intuvision Labs Pvt Ltd\ReportTemplates"
         CreateDirectory "$APPDATA\Intuvision Labs Pvt Ltd\ImageResources"
         ExpandEnvStrings $0 %COMSPEC%

         ExecWait '"CMD" "/C" "CopyAppData.exe" "${INSTALL_PATH}" "$APPDATA\${APP_DIR_PATH}" '
FunctionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall

 SetRegView 64
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
    CreateDirectory "${INSTALL_PATH}_Backup"
   CopyFiles "${INSTALL_PATH}\*" "${INSTALL_PATH}_Backup\"
  Delete "${INSTALL_PATH}\uninstall.exe"
     Delete "$DESKTOP\Installer.lnk"
  Delete "$SMPROGRAMS\IntuSoftInstaller\Installer.lnk"
   Delete "$PROGRAMFILES64\IntuSoft ${PRODUCT_VERSION}\*"
  delete "${INSTALL_PATH}\*.exe"


  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}${PRODUCT_VERSION}\*"
  RMDir /r "${INSTALL_PATH}\*"

  SetAutoClose true
SectionEnd