import java9.lang.*;
import java9.lang.Process;
import java9.lang.ProcessBuilder;

public class ExampleProcessHandle {
    
    public static void main(String... argv)
	throws Exception {

	// Load native library
	Jdk9ProcessHandler.init();

	ProcessHandle.allProcesses()
	    .map(ProcessHandle::getPid)
	    .forEach(System.out::println);

	Process process = new ProcessBuilder("echo", "Hello World").redirectOutput(ProcessBuilder.Redirect.INHERIT).start();
	process.waitFor();
	System.out.println("Process complete: " + process.exitValue());
    }
}
