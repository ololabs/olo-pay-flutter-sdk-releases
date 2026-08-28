import org.gradle.api.tasks.Delete

buildscript {
    val kotlinVersion = "2.2.20"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // 'classpath' declarations are now function calls requiring parentheses.
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

if (file("$rootDir/../../android/load-local-dev-settings.gradle").exists()) {
    apply(from = "$rootDir/../../android/load-local-dev-settings.gradle")
}

allprojects {
    repositories {
        google()
        mavenCentral()
        if (file("$rootDir/../../android/load-local-dev-repository.gradle").exists()) {
            apply(from = "$rootDir/../../android/load-local-dev-repository.gradle")
        }
    }
}

// This is the new, recommended way using the layout API
rootProject.layout.buildDirectory.set(layout.projectDirectory.dir("../build"))
subprojects {
    layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(name))
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

configurations.configureEach {
    resolutionStrategy {
        force("com.google.guava:guava:31.1-android")
    }
}