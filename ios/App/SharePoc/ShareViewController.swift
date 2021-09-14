//
//  ShareViewController.swift
//  SharePoc
//
//  Created by Ibrahima KH GUEYE on 02/09/2021.
//

import UIKit
import Social
import CoreServices

protocol ShareViewControllerDelegate {
    func didFinishLoadingAttachment(isAttachmentLoaded: Bool)
}

class ShareViewController: UIViewController, ShareViewControllerDelegate {
    
    private var imageString: String?
    private var audioString: String?
    private var fileString: String?
    private var delegate: ShareViewControllerDelegate?
    private let messageLoadingSeveralPhotos = "Chargement de %@ vos photos"
    private let messageLoadingOnePhoto = "Chargement de votre photo"
    private var appURL = "sar.poc.sesame.ios.ionic://"
    private let groupName = "group.ionic.ios.sesame.poc.sar.entreprise"
    private let shareButtonTitle = "Share"
    
    let spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    }()
    
    let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return infoLabel
    }()
    
    let shareButton: UIButton = {
        let validateButton = UIButton()
        validateButton.translatesAutoresizingMaskIntoConstraints = false
        validateButton.layer.cornerRadius = 3.0
        validateButton.backgroundColor = .blue
        validateButton.addTarget(self, action: #selector(validateAction), for: .touchUpInside)
        return validateButton
    }()

    override func viewDidLoad() {
        self.delegate = self

        setupLoadingView()
        handleSharedImages()
    }
    
    private func setupLoadingView() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.textColor = .white
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        let customView = UIView(frame: view.frame)
        customView.backgroundColor = UIColor(red: 175/255, green: 20/255, blue: 30/255, alpha: 1.0)
        shareButton.setTitle(shareButtonTitle, for: .normal)
        shareButton.isEnabled = false
        shareButton.backgroundColor = .gray
        
        customView.addSubview(spinner)
        customView.addSubview(infoLabel)
        customView.addSubview(shareButton)
        view.addSubview(customView)
        
  
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            infoLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            spinner.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant:35),
            shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.55),
            shareButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.055)
        ])
    }
    
    @objc private func validateAction() {
        self.openMainApp()
    }
    
    private func setupLoadingMessage(with numberOfPhoto: Int) {
        DispatchQueue.main.async {
            self.infoLabel.text = numberOfPhoto > 1 ? String(format: self.messageLoadingSeveralPhotos, "\(numberOfPhoto)") : self.messageLoadingOnePhoto
        }
    }
    
    private func openMainApp() {
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
        let contentTypeJpeg = kUTTypeJPEG as String
        let contentTypePng = kUTTypePNG as String
        let contentTypePDF = kUTTypePDF as String
        let contentTypeAudio = kUTTypeAudio as String
        
        var strBase64String = ""
        
        setupLoadingMessage(with: attachments.count)
        for index in 0..<attachments.count {
            let provider = attachments[index]
            if provider.hasItemConformingToTypeIdentifier(contentTypeJpeg) {
                print("Content type Jpeg")
                provider.loadItem(forTypeIdentifier: contentTypeJpeg, options: nil) { [unowned self] (data, error) in
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
                            CoreDataStore.shared.storeShareAttachement(image: self.imageString, file: self.fileString, audio: self.audioString)
                            delegate?.didFinishLoadingAttachment(isAttachmentLoaded: true)
                        }
                    }else {
                        print("Couldn't process item")
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(contentTypePng) {
                print("Content type Png")
                provider.loadItem(forTypeIdentifier: contentTypePng, options: nil) { [unowned self] (data, error) in
                    guard error == nil else {
                        print("Error loading item: \(error!.localizedDescription)")
                        return
                    }

                    if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                        let uiImageData = UIImage(data: imageData)
                        let imageDataPng = uiImageData?.pngData()
                        guard let base64String = imageDataPng?.base64EncodedString() else {
                            print("Error converting to base64")
                            return
                        }
                                                
                        strBase64String += "\(base64String);"
                        if index == (attachments.count - 1) {
                            self.imageString = String(strBase64String.dropLast())
                            CoreDataStore.shared.storeShareAttachement(image: self.imageString, file: self.fileString, audio: self.audioString)
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
                            CoreDataStore.shared.storeShareAttachement(image: self.imageString, file: self.fileString, audio: self.audioString)
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
                            CoreDataStore.shared.storeShareAttachement(image: self.imageString, file: self.fileString, audio: self.audioString)
                            self.delegate?.didFinishLoadingAttachment(isAttachmentLoaded: true)
                        }
                    }
                } )
            }
        }
    }
    
    func didFinishLoadingAttachment(isAttachmentLoaded: Bool) {
        DispatchQueue.main.async {
            self.shareButton.isEnabled = isAttachmentLoaded
            self.shareButton.backgroundColor = .blue
            self.spinner.stopAnimating()
        }
    }
}


