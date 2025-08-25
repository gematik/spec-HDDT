#!/bin/bash
publisher_jar=publisher.jar
input_cache_path=./input-cache/
validation=-validation-off
java_memory=-Xmx10g
echo Checking internet connection...
curl -sSf tx.fhir.org > /dev/null

if [ $? -eq 0 ]; then
	echo "Online"
	txoption="-tx n/a"
else
	echo "Offline"
	txoption="-tx n/a"
fi

echo "$txoption"
echo "$validation"

publisher=$input_cache_path/$publisher_jar
if test -f "$publisher"; then
	java -jar $java_memory -Djava.awt.headless=true $publisher -no-sushi -ig ig.ini $txoption $validation $*

else
	publisher=../$publisher_jar
	if test -f "$publisher"; then
		java -jar $java_memory -Djava.awt.headless=true $publisher -no-sushi -ig ig.ini $txoption $validation $*
	else
		echo IG Publisher NOT FOUND in input-cache or parent folder.  Please run _updatePublisher.  Aborting...
	fi
fi
