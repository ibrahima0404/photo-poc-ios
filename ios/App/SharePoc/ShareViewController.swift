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
    private var delegate: ShareViewControllerDelegate?
    private let messageLoadingSeveralPhotos = "Chargement de %@ vos photos"
    private let messageLoadingOnePhoto = "Chargement de votre photo"
    private var appURL = "sar.poc.sesame.ios.ionic://?text="
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let infoLabel = UILabel()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLoadingView()
        handleSharedImages()
    }
    
    private func setupLoadingView() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.textColor = .white
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        let customView = UIView(frame: view.frame)
        customView.backgroundColor = .red
        
        customView.addSubview(spinner)
        customView.addSubview(infoLabel)
        view.addSubview(customView)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            ])
        
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: spinner.topAnchor, constant: -20),
            infoLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    private func setupLoadingMessage(with numberOfPhoto: Int) {
        DispatchQueue.main.async {
            self.infoLabel.text = numberOfPhoto > 1 ? String(format: self.messageLoadingSeveralPhotos, "\(numberOfPhoto)") : self.messageLoadingOnePhoto
        }
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
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        var strBase64String = ""
        
        setupLoadingMessage(with: attachments.count)
        for index in 0..<attachments.count {
            let provider = attachments[index]
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
                    guard error == nil else {
                        print("Error loading item: \(error!.localizedDescription)")
                        return
                    }

                    if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                        let uiImageData = UIImage(data: imageData)
                        let imageDataJpeg = uiImageData?.jpegData(compressionQuality: 0.0)
                        guard let base64String = imageDataJpeg?.base64EncodedString() else {
                            print("Error converting to base64")
                            return
                        }
                                                
                        strBase64String += "\(base64String);"
                        if index == (attachments.count - 1) {
                            self.imageString = String(strBase64String.dropLast())
                            self.delegate = self
                            self.spinner.stopAnimating()
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


