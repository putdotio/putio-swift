import UIKit
import PutioAPI
import AuthenticationServices

@available(iOS 13.0, *)
class ViewController: UIViewController {
    var api: PutioAPI?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        guard let clientID = textField.text else { return }
        createAPI(clientID: clientID)
    }

    func createAPI(clientID: String) {
        api = PutioAPI(clientID: clientID)
        startAuthFlow()
    }

    func startAuthFlow() {
        guard let api = api else { return }

        let scheme = "putioswift"
        let loginURL = api.getLoginURL(redirectURI: "\(scheme)://auth")

        print(loginURL.absoluteString)

        let session = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                return print("an error occurred: \(error!.localizedDescription)")
            }

            // putioswift://auth#access_token=1234
            print(callbackURL.absoluteString)
        }

        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
}

@available(iOS 13.0, *)
extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
