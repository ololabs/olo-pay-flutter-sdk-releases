import org.gradle.api.tasks.testing.logging.TestLogEvent
import org.gradle.api.tasks.testing.Test
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
    kotlin("android")
}

if (file("load-local-dev-settings.gradle").exists()) {
    apply(from = "load-local-dev-settings.gradle")
}

group = "com.olo.flutter.olo_pay_sdk"
version = "1.0-SNAPSHOT"

android {
    namespace = "com.olo.flutter.olo_pay_sdk"
    compileSdk = 36

    defaultConfig {
        minSdk = 23
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget = JvmTarget.JVM_17
        }
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("test").java.srcDirs("src/test/kotlin")
        getByName("androidTest").java.srcDirs("src/androidTest/kotlin")
    }

}

repositories {
    google()
    mavenCentral()
    if (file("load-local-dev-repository.gradle").exists()) {
        apply(from = "load-local-dev-repository.gradle")
    }
}

dependencies {
    if (file("load-local-dev-dependency.gradle").exists()) {
        apply(from = "load-local-dev-dependency.gradle")
    }

    if (!rootProject.extra.has("localDevReleaseRepoVersion")) {
        implementation("com.olo.olopay:olo-pay-android-sdk:5.0.0")
    }

    implementation("androidx.constraintlayout:constraintlayout:2.2.1")
    implementation("androidx.core:core-ktx:1.17.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
    implementation("com.google.android.material:material:1.13.0")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.20.0")
    testImplementation("org.mockito.kotlin:mockito-kotlin:6.0.0")
    testImplementation("junit:junit:4.13.2")

    androidTestImplementation("androidx.test.ext:junit:1.3.0")
    androidTestImplementation("androidx.test.ext:junit-ktx:1.3.0")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.7.0")
    androidTestImplementation("org.mockito:mockito-android:5.19.0")
    androidTestImplementation("androidx.test:runner:1.7.0")
    androidTestUtil("androidx.test:orchestrator:1.6.1")
    androidTestImplementation("org.testng:testng:7.11.0")
}

tasks.withType<Test> {
    useJUnitPlatform()

    testLogging {
        events = setOf(
            TestLogEvent.PASSED,
            TestLogEvent.SKIPPED,
            TestLogEvent.FAILED,
            TestLogEvent.STANDARD_OUT,
            TestLogEvent.STANDARD_ERROR
        )
        outputs.upToDateWhen { false }
        showStandardStreams = true
    }
}

configurations.configureEach {
    resolutionStrategy {
        force("com.google.guava:guava:31.1-android")
    }
}