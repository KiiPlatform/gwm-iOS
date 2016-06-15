import ThingIFSDK


//TODO: implementation
class ApiBuilder {
    static let SCHEMA_NAME = "Smart-Light-Demo"
    static let SCHEMA_VERSION = 1

    class func buildApi (owner : KiiUser) -> ThingIFAPI{

        let appId = ""
        let appKey = ""
        let site : Site

        switch Kii.kiiAppsBaseURL() {
        case "https://api-jp.kii.com/api":
            site = .JP
            break
        case "https://api-sg.kii.com/api":
            site = .SG
            break
        case "https://api-cn3.kii.com/api":
            site = .CN3
            break
        default:
            site = .US
            break
        }
        let app = App(appID: appId, appKey: appKey, site: site)
        let builder = ThingIFAPIBuilder(app: app, owner: Owner(typedID: TypedID(type: "user", id: owner.userID!), accessToken: owner.accessToken!))
        return builder.build()
    }

}
