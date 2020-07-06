import UIKit
import PutioAPI

let CLIENT_ID = ""
let CLIENT_SECRET = ""
let DEV_TOKEN = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let api = PutioAPI(clientID: CLIENT_ID, clientSecret: CLIENT_SECRET)
        api.setToken(token: DEV_TOKEN)

        api.getFiles(parentID: 0, query: [:]) { (file, files, error) in
            print("parent", file as Any)
            print("children", files as Any)
            print("error", error as Any)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
