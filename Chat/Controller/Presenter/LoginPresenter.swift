//
//  LoginHelper.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/1/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import Firebase
import CryptoKit

protocol LoginView {
    func onLoginSucceed(message : String)
    func onLoginFailed(message : String)
    func onShowSpinner()
    func onRemoveSpinner()
}

class LoginPresenter: NSObject{
    var loginView : LoginView?
    fileprivate var currentNonce: String?
    
    // class B extends class A
    // class B implements protocol C
    // => C = A(cast)
    
    init(view : LoginView) {
        loginView = view
    }
    
}

//MARK: - Auth With Firebase
extension LoginPresenter{
    func authWithFirebase(credential : AuthCredential){
        loginView?.onShowSpinner()
        Auth.auth().signIn(with: credential) { [unowned self] (authResult, error) in
            self.loginView?.onRemoveSpinner()
            if error != nil {
                print("Auth Fail")
                print(error!)
                return
            }
            self.markLogined()
            print("Auth Succeed!")
            self.loginView?.onLoginSucceed(message: "Login Succeed!")
        }
    }
    
    private func markLogined(){
        UserDefaults.standard.set(true, forKey: "Login")
    }
}

//MARK: - Handle Facebook Login
extension LoginPresenter{
    func requestFacebookLogin(){
        let vc = loginView as! UIViewController
        let loginFb = LoginManager()
        loginFb.logIn(permissions: ["public_profile"], from: vc){ (result,error) in
            self.handleFacebookLogin(result,error)
        }
    }
    
    func handleFacebookLogin(_ result : LoginManagerLoginResult?,_ error :Error?){
        if error != nil || result!.isCancelled{
            handleFacebookLoginFail(result, error)
            return
        }
        handleFacebookLoginSucceed()
    }
    
    
    func handleFacebookLoginSucceed(){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        authWithFirebase(credential: credential)
    }
    
    
    func handleFacebookLoginFail(_ result : LoginManagerLoginResult?,_ error :Error?){
        if (error != nil) {
            loginView?.onLoginFailed(message: "Process FB error! ")
        }
        else if (result!.isCancelled) {
            loginView?.onLoginFailed(message: "User FB Cancelled !")
        } else {
            loginView?.onLoginFailed(message: "Unknown FB Error")
        }
    }
    
}


//MARK: - Handle Google Login
extension LoginPresenter : GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            handleLoginGoogleFail(error,user)
        }
        if let user = user{
            handleLoginGoogleSucceed(user)
        }
    }
    
    func requestGoogleLogin(){
        let vc = loginView as! UIViewController
        GIDSignIn.sharedInstance().presentingViewController = vc
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().clientID = "681455285113-89b35qfqbftdfc9m85bcp6n00u912c18.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func handleLoginGoogleSucceed(_ user : GIDGoogleUser){
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        authWithFirebase(credential: credential)
    }
    
    func handleLoginGoogleFail(_ error : Error!, _ user : GIDGoogleUser!){
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            loginView?.onLoginFailed(message: "The user has not signed in before or they have since signed out.")
        }
        else if(user == nil){
            loginView?.onLoginFailed(message: "User GG cancelled !")
        }
        else {
            loginView?.onLoginFailed(message: "\(error.localizedDescription)")
        }
        return
    }
}

//MARK: - Handle Apple Login
extension LoginPresenter:  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func requestAppleLogin(){
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            authWithFirebase(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginView?.onLoginFailed(message: "\(error)")
    }
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = loginView as! UIViewController
        return vc.view.window!
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

