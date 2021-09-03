//
//  ShareViewController.swift
//  SharePoc
//
//  Created by Ibrahima KH GUEYE on 02/09/2021.
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController {
    
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private let appURL = "sar.poc.sesame.ios.ionic://"
    private let groupName = "group.ionic.ios.sesame.poc.sar.entreprise"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleSharedImages()
    }

    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURL) else {
                print("Error bad url")
                return
            }
            _ = self.openURL(url)
        })
    }

    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    private func handleSharedImages() {
        var imageNames = [String: String]()
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        
        for index in 0..<attachments.count {
            let provider = attachments[index]
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
                    guard error == nil else {
                        print("Error loading item: \(error!.localizedDescription)")
                        return
                    }

                    if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                        let imageName = "image\(index)"
                        saveDataBase64(imageName: imageName, imageData: imageData)
                        imageNames[imageName] = imageName
                        if index == (attachments.count - 1) {
                            self.saveImagesName(imageNames: imageNames , key: "images")
                        }
                    }else {
                        print("Couldn't process item")
                    }
                    self.openMainApp()
                }
            }
        }
    }
    
    private func saveDataBase64(imageName: String, imageData: Data) {
        guard let fileManager = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) else {
            print("Error: No containe with groupId \(groupName)")
            return
        }
        
        let imageURL = URL(string: "\(fileManager)\(imageName)")!
        
        do {
            try imageData.write(to: imageURL, options: .atomic)
        }
        catch {
            print("Error writing data \(error.localizedDescription)")
        }
    }
    
    private func saveImagesName(imageNames: [String: String], key: String) {
        if let userDefaults = UserDefaults(suiteName: groupName) {
            userDefaults.set(imageNames, forKey: key)
        }
    }
}


