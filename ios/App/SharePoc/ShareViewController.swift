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
    func didFinishLoadingAttachment(isAttachmentLoaded: Bool)
}

class ShareViewController: SLComposeServiceViewController, ShareViewControllerDelegate {
    
    private var imageString: String?
    private var audioString: String?
    private var fileString: String?
    private var delegate: ShareViewControllerDelegate?
    private let messageLoadingSeveralPhotos = "Chargement de %@ vos photos"
    private let messageLoadingOnePhoto = "Chargement de votre photo"
    private var appURL = "sar.poc.sesame.ios.ionic://?text="
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let infoLabel = UILabel()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate = self

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
        customView.backgroundColor = UIColor(red: 175/255, green: 20/255, blue: 30/255, alpha: 1.0)
        
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
        appURL = appURL + "&audio=" + (self.audioString ?? "")
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
        let contentTypeImage = kUTTypeJPEG as String
        let contentTypePDF = kUTTypePDF as String
        let contentTypeAudio = kUTTypeAudio as String
        
        var strBase64String = ""
        
        setupLoadingMessage(with: attachments.count)
        for index in 0..<attachments.count {
            let provider = attachments[index]
            if provider.hasItemConformingToTypeIdentifier(contentTypeImage) {
                print("Content type Image")
                provider.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { [unowned self] (data, error) in
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
                            self.spinner.stopAnimating()
                            delegate?.didFinishLoadingAttachment(isAttachmentLoaded: true)
                        }
                    }else {
                        print("Couldn't process item")
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(contentTypePDF) {
                print("Content type PDF")
                provider.loadItem(forTypeIdentifier: contentTypePDF, options: nil, completionHandler: { [unowned self] (result, error) in
                    if result !=  nil {
                        let url = result as! URL?
                        if url!.isFileURL {
                            self.fileString = url?.absoluteString
                            self.delegate?.didFinishLoadingAttachment(isAttachmentLoaded: true)
                        }
                    }
                } )
            } else if provider.hasItemConformingToTypeIdentifier(contentTypeAudio) {
                print("Content type Audio")
                provider.loadItem(forTypeIdentifier: contentTypeAudio, options: nil, completionHandler: { [unowned self] (result, error) in
                    if result !=  nil {
                        if let url = result as? URL, let audioData = try? Data(contentsOf: url) {
                            let base64String = audioData.base64EncodedString()
                            self.audioString = base64String
                            self.delegate?.didFinishLoadingAttachment(isAttachmentLoaded: true)
                        }
                    }
                } )
            }
        }
    }
    
    func didFinishLoadingAttachment(isAttachmentLoaded: Bool) {
        if isAttachmentLoaded {
            self.openMainApp()
        }
    }
}


