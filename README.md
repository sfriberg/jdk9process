# jdk9process
Simple project to enable Java 8 to use the new and improved Process API available in JDK 9

## Build process
Clone jdk9 repository and sub repositories
./build <path to jdk9 source>

## Using
Add jdk9process.jar to the bootclasspath

Classes use the java9.lang package, so a minor edit will be required when switching to Java 9.
Before the first use the native library must be loaded, see example for details.

    javac -cp build/jdk9process.jar  example/ExampleProcessHandle.java
    java -cp example -Xbootclasspath/p:build/jdk9process.jar  ExampleProcessHandle

## Support
Only supports Linux currently.
