# jdk9process
Simple project to enable Java 8 to use the new and improved Process API available in JDK 9

## Build process
Clone jdk9 the full JDK 9 repository and run build.sh.

#### Cloning JDK 9
    hg clone http://hg.openjdk.java.net/jdk9/jdk9/
    cd jdk9
    sh get_source.sh

#### Building library
    ./build.sh <path to jdk9 source>

## Using
Add jdk9process.jar to the classpath

Classes use the java9.lang package, so a minor edit will be required when switching to Java 9.
Before the first use the native library must be loaded, see example for details.

    javac -cp build/jdk9process.jar  example/ExampleProcessHandle.java
    java -cp example:build/jdk9process.jar  ExampleProcessHandle

## Support
Only supports Linux currently.
