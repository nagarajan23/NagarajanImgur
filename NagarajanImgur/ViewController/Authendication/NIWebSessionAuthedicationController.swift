//
//  NIWebSessionAuthedicationController.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit
import AuthenticationServices

class NIWebSessionAuthedicationController: NIViewController {

    //MARK:- Variables
    //MARK: Properties
    let callbackUrlScheme = "com.exmple.NagarajanImgur"
    let oauthcallback = "oauthcallback"
    var webAuthSession: ASWebAuthenticationSession?
    
    //MARK:- IBOutlets
    @IBOutlet private weak var gradientView: UIView!
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGradientViewColor()
    }
    
    private func setGradientViewColor() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.gradientView.bounds
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor(red: 34.0/255.0, green: 211/255.0, blue: 198/255.0, alpha: 1.0).cgColor, UIColor(red: 145/255.0, green: 72.0/255.0, blue: 203/255.0, alpha: 1.0).cgColor]
        self.gradientView.layer.addSublayer(gradient)
    }
}

//MARK:- Button Action
extension NIWebSessionAuthedicationController {
    @IBAction func didNextButtonPressed(_ sender: UIButton){
        let urlString = oAuthBaseURL + "authorize?client_id=\(CLIENT_ID)&response_type=code"
        if let url = URL(string: urlString) {
            self.loadWebAuthenticationSession(loginUrl: url)
        }
    }
}

//MARK:- Load ASWebAuthenticationSession
extension NIWebSessionAuthedicationController {
    
    func loadWebAuthenticationSession(loginUrl: URL) {
        self.webAuthSession = ASWebAuthenticationSession.init(url: loginUrl, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            self.onAuthSuccess(callBackUrl: callBack, error: error)
        })
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.prefersEphemeralWebBrowserSession = true
        self.webAuthSession?.start()
    }
}

extension NIWebSessionAuthedicationController : ASWebAuthenticationPresentationContextProviding
{
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

//MARK:- Parse CallBack
extension NIWebSessionAuthedicationController: LoadingIndicator, NIKeyChainProtocol {
    private func onAuthSuccess(callBackUrl: URL?, error: Error?) {
        self.webAuthSession?.cancel()
        self.onSuccessCustomUrlRedirect(callBackUrl: callBackUrl, error: error)
    }
    
    private func onSuccessCustomUrlRedirect(callBackUrl: URL?, error: Error?) {
        guard let callBackData = callBackUrl else {
            return
        }
        if let error = error {
            if (error as NSError).code == 1 {
                //self.apiError.value = ""
            } else {
                //self.apiError.value = error.localizedDescription
            }
        }
        self.showLoadingIndicatorView()
        self.parseLoginSuccessQueryParams(callBackData: callBackData)
    }
    
    private func parseLoginSuccessQueryParams(callBackData: URL) {
        let callBackString = callBackData.absoluteString
        if let urlComponents = NSURLComponents(string: callBackString) {
            performActionBasedOnHost(urlComponents: urlComponents)
        }
    }
    
    private func performActionBasedOnHost(urlComponents: NSURLComponents) {
        guard let hostType = urlComponents.host else { return }
        if hostType == oauthcallback {
            self.getCodeFromQueryParams(urlComponents: urlComponents)
        }
    }
    
    private func getCodeFromQueryParams(urlComponents: NSURLComponents) {
        if let queryParams = urlComponents.queryItems {
            if let code = queryParams.first(where: {$0.name == "code"})?.value {
                self.fetchAccessToken(usingAuthorizationCode: code)
            }
        }
    }
}

//MARK:- Fetch Access Token
extension NIWebSessionAuthedicationController {
    private func fetchAccessToken(usingAuthorizationCode code: String) {
        let urlString = oAuthBaseURL + "token"
        let params = self.getAccessTokenParams(code)
        NIAccountNetworkService.fetchAccessToken(usingUrlString: urlString, parameters: params) {[weak self] (responseString, errorMessage) in
            self?.hideLodingIndicatorView()
            self?.computeAccessToken(responseString: responseString)
        }
    }
    
    private func getAccessTokenParams(_ code: String) -> [String: Any] {
        let params = ["client_id" : CLIENT_ID, "client_secret" : CLIENT_SECRET, "code": code, "grant_type": GRANT_TYPE];
        return params
    }
    
    private func computeAccessToken(responseString: String) {
        if !responseString.isEmpty, let data = responseString.data(using: .utf8) {
            do {
                let tokenModel = try JSONDecoder().decode(NITokenModel.self, from: data)
                tokenModel.saveInKeyChain()
                self.initiateViewController()
            } catch let error {
                
            }
        }
    }
    
    private func initiateViewController() {
        DispatchQueue.main.async {
            let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
            sceneDelegate.instantiateRootViewController()
        }
    }
}
