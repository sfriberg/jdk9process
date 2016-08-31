public class ExampleProcessHandle {
    
    public static void main(String... argv)
	throws java.io.IOException {

	// Load native library
	java9.lang.Jdk9ProcessHandler.init();

	java9.lang.ProcessHandle.allProcesses()
	    .map(java9.lang.ProcessHandle::getPid)
	    .forEach(System.out::println);
    }
}
