//
//  VKLoginVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 11.02.2022.
//

import UIKit
import WebKit
import KeychainSwift
import FirebaseDatabase
//import Alamofire


final class VKLoginVC: UIViewController {
    
    private let reference = Database.database().reference()
    
    private let keychainSwift = KeychainSwift()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    @IBAction func unwindToVKLogin(_ segue: UIStoryboardSegue) {
        SessionData.data.token = ""
        SessionData.data.userId = 0
        let dataSource = WKWebsiteDataStore.default()
        dataSource.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach {
                if $0.displayName.contains("vk") {
                    dataSource.removeData(
                        ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                        for: [$0],
                        completionHandler: { [weak self] in
                            guard
                                let self = self,
                                let url = self.urlComponent.url
                            else { return }
                            self.webView.load(URLRequest(url: url))
                        })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try RealmService.clear()
        } catch {
            print(error)
        } 
        guard
            let url = urlComponent.url
        else { return }
        webView.load(URLRequest(url: url))
//        self.saveToUserDefaults()
//        self.loadFromUserDefaults()
//        self.deleteFromUserDefaults()
//
//        saveToKeychain()
//        loadFromKeychain()
//        removeFromKeychain()
//
//        saveFile()
//        loadFromDisk()
//        saveToCoreData()
//        loadFromCoreData()
    }
    
    
    
    private var urlComponent: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "oauth.vk.com"
        comp.path = "/authorize"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: "8089393"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        return comp
    }()
    
}

extension VKLoginVC: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            guard
                let url = navigationResponse.response.url,
                url.path == "/blank.html",
                let fragment = url.fragment
            else { return decisionHandler(.allow) }
            
            let parameters = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { partialResult, params in
                    var dict = partialResult
                    let key = params[0]
                    let value = params[1]
                    dict[key] = value
                    return dict
                }
            guard
                let token = parameters["access_token"],
                let userIDString = parameters["user_id"],
                let userID = Int(userIDString)
            else { return decisionHandler(.allow) }
            
            SessionData.data.token = token
            SessionData.data.userId = userID
            
            self.reference.child(String(SessionData.data.userId)).child("status").setValue("initialized")
            
            goToNextPage()
            
            decisionHandler(.cancel)
            
    }
    
    
    private func goToNextPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? UIViewController
        nextViewController?.modalPresentationStyle = .fullScreen
        self.present(nextViewController ?? UIViewController(), animated: true, completion: nil)
    }
    
    
    
}


extension VKLoginVC {
    private func saveToUserDefaults() {
        UserDefaults.standard.set("black", forKey: UserDefaults.Keys.backgroundColor.rawValue)
    }
    
    private func loadFromUserDefaults() {
        UserDefaults.standard.string(forKey: UserDefaults.Keys.backgroundColor.rawValue)
    }
    
    private func removeFromUserDefaults() {
        UserDefaults.Keys.allCases.forEach() { i in
            UserDefaults.standard.removeObject(forKey: i.rawValue)
        }
        
    }
    
    // MARK: Keychain
    
    private func saveToKeychain() {
        keychainSwift.set(
            SessionData.data.token,
            forKey: UserDefaults.Keys.token.rawValue,
            withAccess: nil)
        
        
    }
    
    private func loadFromKeychain() {
        let password = keychainSwift.get(UserDefaults.Keys.token.rawValue)
        print(password)
    }
    
    private func removeFromKeychain() {
        keychainSwift.delete(UserDefaults.Keys.token.rawValue)
        keychainSwift.clear()
    }
    
    // MARK: File manager
    
    private func saveFile() {
        guard
            let url = FileManager.default
                .urls(
                    for: .documentDirectory,
                       in: .userDomainMask)
                .first,
            let someImage = UIImage(named: "diagram")?.pngData()
        else { return }
        print(url)
        let someFileURL = url.appendingPathComponent("someImage")
        do {
            try someImage.write(to: someFileURL)
        } catch {
            print(error)
        }
    }
    
    @discardableResult
    private func loadFromDisk() -> UIImage? {
        guard
            let url = FileManager.default
                .urls(
                    for: .documentDirectory,
                       in: .userDomainMask)
                .first
        else { return nil }
        let someFileURL = url.appendingPathComponent("someImage.png")
        guard
            let imageData = try? Data(contentsOf: someFileURL),
            let image = UIImage(data: imageData)
        else { return nil }
        
        return image
    }
    
    // MARK: CoreData
    
    private func saveToCoreData() {
        guard
            let currentContext = appDelegate?.persistentContainer.viewContext
        else { return }
        let user = UserData(context: currentContext)
        user.id = UUID()
        do {
            try currentContext.save()
        } catch {
            print(error)
        }
    }
    
    private func loadFromCoreData() {
        guard
            let currentContext = appDelegate?.persistentContainer.viewContext
        else { return }
        do {
            let usersData = try currentContext.fetch(UserData.fetchRequest())
            print(usersData)
        } catch {
            let nsError = error as NSError
            print(nsError.userInfo)
        }
    }
}
