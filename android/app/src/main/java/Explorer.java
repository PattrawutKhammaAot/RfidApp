import java.io.*;
import java.util.jar.*;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class Explorer {
    public static void main(String[] args) {
        try {
            File aarFile = new File("D:/work-mobile/RfidApp/android/app/libs/URFIDLibrary-v2.4.0307.aar");
            if (!aarFile.exists()) {
                System.out.println("AAR file not found!");
                return;
            }

            // Extract the classes.jar file from the .aar file
            try (ZipInputStream zipInputStream = new ZipInputStream(new FileInputStream(aarFile))) {
                ZipEntry entry;
                while ((entry = zipInputStream.getNextEntry()) != null) {
                    if (entry.getName().endsWith("classes.jar")) {
                        File tempFile = File.createTempFile("classes", ".jar");
                        try (FileOutputStream fileOutputStream = new FileOutputStream(tempFile)) {
                            byte[] buffer = new byte[1024];
                            int length;
                            while ((length = zipInputStream.read(buffer)) > 0) {
                                fileOutputStream.write(buffer, 0, length);
                            }
                        }

                        // Now inspect the classes.jar file
                        JarFile jarFile = new JarFile(tempFile);
                        Enumeration<JarEntry> jarEntries = jarFile.entries();
                        while (jarEntries.hasMoreElements()) {
                            JarEntry jarEntry = jarEntries.nextElement();
                            if (jarEntry.getName().endsWith(".class")) {
                                String className = jarEntry.getName().replace("/", ".").replace(".class", "");
                                System.out.println(className);
                            }
                        }

                        jarFile.close();
                        tempFile.delete();
                        break;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// //jar
// import java.io.*;
// import java.util.jar.*;
// import java.util.Enumeration;
// import java.util.zip.ZipEntry;
// import java.util.zip.ZipInputStream;

// public class Explorer {
//     public static void main(String[] args) {
//         try {
//             JarFile jarFile = new JarFile("D:/work-mobile/RfidApp/android/app/libs/platform_sdk_v3.1.221124.jar");
//             Enumeration<JarEntry> entries = jarFile.entries();

//             while (entries.hasMoreElements()) {
//                 JarEntry entry = entries.nextElement();
//                 if (entry.getName().endsWith(".class")) {
//                     System.out.println(entry.getName());
//                 }
//             }
//         } catch (IOException e) {
//             e.printStackTrace();
//         }
//     }
// }
