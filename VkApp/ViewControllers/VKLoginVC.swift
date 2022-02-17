//
//  VKLoginVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 11.02.2022.
//

import UIKit
import WebKit
//import Alamofire


final class VKLoginVC: UIViewController {
    
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
        guard
            let url = urlComponent.url
        else { return }
        webView.load(URLRequest(url: url))
    }
    
    private var urlComponent: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "oauth.vk.com"
        comp.path = "/authorize"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: "8076967"),
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
            
            print("Hello\\!\n", token, userID)
            let request = Request()
//            request.getFriends()
//            request.getPhotos()
//            request.getGroups()
//            request.searchGroups(str: "minimalism", count: 3)
            
            goToNextPage()
            
            decisionHandler(.cancel)
            
    }
    
    
    private func goToNextPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController") as? UIViewController
        nextViewController?.modalPresentationStyle = .fullScreen
        self.present(nextViewController ?? UIViewController(), animated: true, completion: nil)
    }
}

