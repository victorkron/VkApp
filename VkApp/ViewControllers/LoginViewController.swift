//
//  ViewController.swift
//  WeatherApp
//
//  Created by Карим Руабхи on 15.12.2021.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func logInButtonPressed(_ sender: Any) {
//        print(userNameTextField.text)
//        print(userPasswordTextField.text)
        guard
            let username = userNameTextField.text,
            let password = userPasswordTextField.text
        else { return }
        authBy(email: username, password: password)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard
            let username = userNameTextField.text,
            let password = userPasswordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            return presentAlert(message: "Invalid data")
        }
        
        Auth.auth().createUser(
            withEmail: username,
            password: password) { [weak self] resultRegister, errorRegister in
                guard let self = self else { return }
                if let error = errorRegister {
                    self.presentAlert(message: error.localizedDescription)
                } else {
                    self.authBy(
                        email: username,
                        password: password)
                }
            }
        
    }
    
    
    @IBAction func unwindToMain(unwindSegue: UIStoryboardSegue) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func logOut(unwindSegue: UIStoryboardSegue) {
        try? Auth.auth().signOut()
    }
    
    private var authNatification: AuthStateDidChangeListenerHandle?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(hideKeyboard)))
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.navigationBar.isHidden = true
        
        self.authNatification = Auth.auth().addStateDidChangeListener({ auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "goToMain", sender: nil)
                self.userNameTextField.text = nil
                self.userPasswordTextField.text = nil
            }
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.navigationBar.isHidden = false
        guard let authNatification = authNatification else {
            return
        }

        Auth.auth().removeStateDidChangeListener(authNatification)
    }
    
    
    private func authBy(email: String, password: String) {
        Auth.auth().signIn(
            withEmail: email,
            password: password) { [weak self] authResult, error in
                guard
                    let self = self,
                    let error = error
                else { return }
                
                self.presentAlert(message: error.localizedDescription)
            }
    }
    
    // MARK: Actions
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue)
            .cgRectValue
            .size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .required
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .defaultHigh
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .defaultHigh
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .required
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        switch identifier {
//        case "goToMain":
//            if !checkUser() {
//                presentAlert()
//                return false
//            } else {
//                 clearData()
//                return true
//            }
//        default:
//            return false
//        }
//    }
    
    // MARK: Private methods
//    private func checkUser() -> Bool {
//        Auth.auth().signIn(
//            withEmail: userNameTextField.text ?? "",
//            password: userPasswordTextField.text ?? "")
//        return userNameTextField.text == "" && userPasswordTextField.text == ""
//    }
    
    private func presentAlert(message: String = "Uncorrect username or password") {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func clearData() {
        userNameTextField.text = nil
        userPasswordTextField.text = nil
    }
}


