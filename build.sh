#!/bin/bash

JDK9_SRC=${1:-jdk9}

if [[ ! -d ${JDK9_SRC} ]]; then
    echo "Can't find jdk9 source tree at \"${JDK9_SRC}\"."
    exit 1
fi

#Copy Java files
JAVA_SRC_FILES='jdk/src/java.base/share/classes/java/lang/ProcessBuilder.java
 jdk/src/java.base/unix/classes/java/lang/ProcessEnvironment.java
 jdk/src/java.base/share/classes/java/lang/ProcessHandleImpl.java
 jdk/src/java.base/share/classes/java/lang/ProcessHandle.java
 jdk/src/java.base/unix/classes/java/lang/ProcessImpl.java
 jdk/src/java.base/share/classes/java/lang/Process.java
 jdk/src/java.base/share/classes/sun/security/action/GetPropertyAction.java'

mkdir -p build/generated/java9/lang
for src_file in ${JAVA_SRC_FILES}; do
    cat ${JDK9_SRC}/${src_file} | sed 's/package java.lang/package java9.lang/g' | sed 's/sun.security.action/java9.lang/g' | sed 's/import java.lang.Process/import java9.lang.Process/g' | sed 's/, stackSize, false/, stackSize/' | sed 's/import jdk.internal.misc./import sun.misc./' > build/generated/java9/lang/`basename ${src_file}`
done

#Compile Java
mkdir -p build/classes
javac src/java9/lang/*.java build/generated/java9/lang/*.java -d build/classes


#Generate headers
mkdir -p build/generated/native
(cd build/classes; ls java9/lang/Process*.class) | sed 's/\//./g' |sed 's/.class//'|xargs javah -cp build/classes -d build/generated/native

#Copy C files
C_SRC_FILES='jdk/src/java.base/unix/native/libjava/ProcessEnvironment_md.c
 jdk/src/java.base/linux/native/libjava/ProcessHandleImpl_linux.c
 jdk/src/java.base/unix/native/libjava/ProcessHandleImpl_unix.c
 jdk/src/java.base/unix/native/libjava/ProcessHandleImpl_unix.h
 jdk/src/java.base/unix/native/libjava/ProcessImpl_md.c'

for src_file in ${C_SRC_FILES}; do
    cat ${JDK9_SRC}/${src_file} | sed 's/java_lang/java9_lang/g' > build/generated/native/`basename ${src_file}`
done

#Build library
mkdir -p build/lib/java9/lang/
gcc -fPIC -shared -D_GNU_SOURCE -D_REENTRANT -D_LARGEFILE64_SOURCE -fno-omit-frame-pointer -D_LITTLE_ENDIAN -DLINUX -I/usr/lib/jvm/java-8-oracle/include -I/usr/lib/jvm/java-8-oracle/include/linux -I${JDK9_SRC}/jdk/src/java.base/share/native/include -I${JDK9_SRC}/jdk/src/java.base/unix/native/include -I${JDK9_SRC}/jdk/src/java.base/share/native/libjava -I${JDK9_SRC}/jdk/src/java.base/unix/native/libjava  ${JDK9_SRC}/jdk/src/java.base/unix/native/jspawnhelper/jspawnhelper.c ${JDK9_SRC}/jdk/src/java.base/unix/native/libjava/childproc.c build/generated/native/*.c -o build/lib/java9/lang/libjdk9.so

#Make jar file
jar cf build/jdk9process.jar -C build/classes java9 -C build/lib java9/lang/libjdk9.so
