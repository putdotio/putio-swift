import UIKit
import PutioAPI
import AuthenticationServices

@available(iOS 13.0, *)
class ViewController: UIViewController {
    var api: PutioAPI?
    var session: ASWebAuthenticationSession?

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
        api = PutioAPI(config: PutioAPIConfig(clientID: clientID))
        startAuthFlow()
    }

    // https://developer.apple.com/documentation/authenticationservices/authenticating_a_user_through_a_web_service
    func startAuthFlow() {
        guard let api = api else { return }

        let scheme = "putioswift"
        let loginURL = api.getLoginURL(redirectURI: "\(scheme)://auth")

        session = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                return self.handleAuthCallbackFailure(error: error!)

            }

            // Callback URL: putioswift://auth#access_token={TOKEN}
            return self.handleAuthCallbackSuccess(callbackURL: callbackURL)
        }

        session?.presentationContextProvider = self
        session?.start()
    }

    func handleAuthCallbackFailure(error: Error) {
        let alertController = UIAlertController(title: "Auth Failure", message: error.localizedDescription, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(closeButton)
        present(alertController, animated: true, completion: nil)
    }

    func handleAuthCallbackSuccess(callbackURL: URL) {
        var urlComponents = URLComponents()
        urlComponents.query = callbackURL.fragment

        guard let tokenFragment = urlComponents.queryItems?.first(where: { $0.name == "access_token" }), let token = tokenFragment.value else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing access_token in the callback URL"])
            return handleAuthCallbackFailure(error: error)
        }

        fetchAccountInfo(token: token)
    }

    func fetchAccountInfo(token: String) {
        api?.setToken(token: token)

        api?.getAccountInfo(completion: { result in
            switch result {
            case .success(let account):
                return self.fetchAccountInfoSuccess(account: account)
            case .failure(let error):
                return self.fetchAccountInfoFailure(error: error)
            }
        })
    }

    func fetchAccountInfoFailure(error: PutioAPIError) {
        let alertController = UIAlertController(title: "API: Fetch Account Info Failure", message: error.message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(closeButton)
        present(alertController, animated: true, completion: nil)
    }

    func fetchAccountInfoSuccess(account: PutioAccount) {
        let alertController = UIAlertController(title: "API: Fetch Account Info Success", message: account.username, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.api?.getFiles(parentID: 0, completion: { result in
                switch result {
                case .success(let data):
                    return print("Files result: \(data.children.count)")

                case .failure(let error):
                    return print("Files error: \(error.type)")
                }
            })
        })
        alertController.addAction(closeButton)
        present(alertController, animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
