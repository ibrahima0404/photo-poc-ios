//
//  ShareViewController.swift
//  SharePoc
//
//  Created by Ibrahima KH GUEYE on 02/09/2021.
//

import UIKit
import Social
import CoreServices

protocol  ShareViewControllerDelegate {
    func didFinishLoadImage(isImagesLoaded: Bool)
}
class ShareViewController: SLComposeServiceViewController, ShareViewControllerDelegate {
    
    private var imageString: String?
    private var fileString: String?
    var delegate: ShareViewControllerDelegate?
    
    private var appURL = "sar.poc.sesame.ios.ionic://?text="
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleSharedImages()
    }

    private func openMainApp() {
        appURL = appURL + "&url=" + appURL
        appURL = appURL + "&image=" + (self.imageString ?? "")
        appURL = appURL + "&file=" + (self.fileString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        let url = URL(string:  appURL)!
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
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
        var strBase64String = ""
        
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
                        let imageData2 = UIImage(data: imageData)
                        let imageDataJpeg = imageData2?.jpegData(compressionQuality: 0.0)
                        guard let base64String = imageDataJpeg?.base64EncodedString() else {
                            print("Error converting to base64")
                            return
                        }
                                                
                        imageNames[imageName] = imageName
                        strBase64String += "\(base64String);"
                        if index == (attachments.count - 1) {
                            self.imageString = String(strBase64String.dropLast())
                            self.delegate = self
                            delegate?.didFinishLoadImage(isImagesLoaded: true)
                        }
                    }else {
                        print("Couldn't process item")
                    }
                }
            }
        }
    }
    
    func didFinishLoadImage(isImagesLoaded: Bool) {
        self.openMainApp()
    }
}


