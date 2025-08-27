@ECHO OFF
SET publisher_jar=publisher.jar
SET input_cache_path=%CD%\input-cache
SET txserver="n/a"
SET output_path=%CD%\output

ECHO Checking internet connection...
PING %txserver% -4 -n 1 -w 1000 | FINDSTR TTL && GOTO isonline
ECHO We're offline...
SET txoption="-tx n/a"
GOTO igpublish

:isonline
ECHO We're online

:igpublish

SET JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

IF EXIST "%input_cache_path%\%publisher_jar%" (
	JAVA -jar -Xmx10g "%input_cache_path%\%publisher_jar%" -ig ig.ini -tx %txserver% -authorise-non-conformant-tx-servers -validation-off
) ELSE If exist "..\%publisher_jar%" (
	JAVA -jar -Xmx10g "..\%publisher_jar%" -ig ig.ini -tx %txserver% -authorise-non-conformant-tx-servers -validation-off
) ELSE (
	ECHO IG Publisher NOT FOUND in input-cache or parent folder.  Please run _updatePublisher.  Aborting...
)


REM -------------------------------
REM Copy files from input/files to output/files
REM -------------------------------
IF NOT EXIST "%output_path%\files" (
    MKDIR "%output_path%\files"
)
ECHO Copying files from input/files/ to output/files/
XCOPY /Y /E "%CD%\input\files\*" "%output_path%\files\"

PAUSE
