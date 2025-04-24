import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("DEV") {
            dimension = "flavor-type"
            applicationId = "com.task.manager.dev"
            resValue(type = "string", name = "app_name", value = "Task Manager DEV")
        }
        create("QA") {
            dimension = "flavor-type"
            applicationId = "com.task.manager.qa"
            resValue(type = "string", name = "app_name", value = "Task Manager QA")
        }
        create("UAT") {
            dimension = "flavor-type"
            applicationId = "com.task.manager.uat"
            resValue(type = "string", name = "app_name", value = "Task Manager UAT")
        }
        create("PROD") {
            dimension = "flavor-type"
            applicationId = "com.task.manager"
            resValue(type = "string", name = "app_name", value = "Task Manager PROD")
        }
    }
}