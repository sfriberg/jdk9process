package java9.lang;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class Jdk9ProcessHandler {

    public static void init()
	throws IOException {
	Path library = Files.createTempFile("libjdk9_", ".so");
	Files.copy(Jdk9ProcessHandler.class.getResourceAsStream("libjdk9.so"), library, StandardCopyOption.REPLACE_EXISTING);
	System.load(library.toAbsolutePath().toString());
	library.toFile().deleteOnExit();
    }
}
