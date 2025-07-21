import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type2")

    productFlavors {
        create("dev") {
            dimension = "flavor-type2"
            applicationId = "jh.project.datenote.dev"
            resValue(type = "string", name = "app_name", value = "DateNote (개발)")
            resValue(type = "string", name = "app_mode_name", value = "개발모드")
            resValue(type = "string", name = "app_mode_name2", value = "정준형4")
            resValue(type = "bool", name = "is_feature_enabled", value = "true")
        }
        create("prod") {
            dimension = "flavor-type2"
            applicationId = "jh.project.datenote"
            resValue(type = "string", name = "app_name", value = "DateNote")
            resValue(type = "string", name = "app_mode_name", value = "정준형3")
            resValue(type = "string", name = "app_mode_name2", value = "정준형4")
        }
    }
}