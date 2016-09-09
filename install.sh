#!/bin/bash

mvn install:install-file -Dfile=build/jdk9process.jar -DpomFile=pom.xml
