pluginManagement {
    val flutterSdkPath: String by lazy {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.exists()) {
            java.io.FileInputStream(localPropertiesFile).use { inputStream ->
                properties.load(inputStream)
            }
        }
        properties.getProperty("flutter.sdk")?.also {
            includeBuild("$it/packages/flutter_tools/gradle")
        } ?: error("flutter.sdk not set in local.properties")
    }

    settings.extra.set("flutterSdkPath", flutterSdkPath)

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    plugins {
        id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.13.0" apply false
}

include(":app")

rootProject.name = "Olo Pay Flutter"