import UIKit
import PutioSDK
import AuthenticationServices

class ViewController: UIViewController {
    var api: PutioSDK?
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
        api = PutioSDK(config: PutioSDKConfig(clientID: clientID))
        startAuthFlow()
    }

    // https://developer.apple.com/documentation/authenticationservices/authenticating_a_user_through_a_web_service
    func startAuthFlow() {
        guard let api = api else { return }

        let scheme = "putioswift"
        let url = api.getAuthURL(redirectURI: "\(scheme)://auth")

        session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
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

        Task {
            await fetchAccountInfo(token: token)
        }
    }

    @MainActor
    func fetchAccountInfo(token: String) async {
        api?.setToken(token: token)

        guard let api else { return }

        do {
            let account = try await api.getAccountInfo()
            fetchAccountInfoSuccess(account: account)
        } catch {
            fetchAccountInfoFailure(error: error)
        }
    }

    func fetchAccountInfoFailure(error: Error) {
        let alertController = UIAlertController(title: "API: Fetch Account Info Failure", message: error.localizedDescription, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(closeButton)
        present(alertController, animated: true, completion: nil)
    }

    func fetchAccountInfoSuccess(account: PutioAccount) {
        let alertController = UIAlertController(title: "API: Fetch Account Info Success", message: account.username, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            guard let api = self.api else { return }
            Task {
                do {
                    let response = try await api.getFiles(parentID: 0)
                    print("Files result: \(response.children.count)")
                } catch let error as PutioSDKError {
                    print("Files error: \(error.type)")
                } catch {
                    print("Files error: \(error.localizedDescription)")
                }
            }
        })
        alertController.addAction(closeButton)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
