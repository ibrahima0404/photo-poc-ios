//
//  PluginShare.swift
//  App
//
//  Created by Ibrahima KH GUEYE on 02/09/2021.
//

import Foundation
import Capacitor
import Photos

@objc(PluginShare)
public class PluginShare: CAPPlugin {
    private let groupName = "group.ionic.ios.sesame.poc.sar.entreprise"
    @objc func getSharedPhotos(_ call: CAPPluginCall) {
        let userDefault = UserDefaults(suiteName: groupName)
        
        if let photos = userDefault?.value(forKey: "images") as? [String: String] {
            var strBase64String = ""
            for photo in photos {
                let imgPath = getImagePath(imageName: photo.key)
                let imageData = UIImage(contentsOfFile: imgPath)
                let imageDataJpeg = imageData?.jpegData(compressionQuality: 1)
                guard let base64String = imageDataJpeg?.base64EncodedString() else {
                    print("Error encoding to base64")
                    return
                }
                strBase64String += "\(base64String);"
            }
            
            call.resolve(["listImages": strBase64String.dropLast()])
        }
    }
    
    private func getImagePath(imageName: String) -> String {
        guard var fileManager = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) else {
            print("Error: No containe with groupId \(groupName)")
            return ""
        }
        
        fileManager.appendPathComponent("\(imageName)")
        
        let imagePath = fileManager.absoluteString.split(separator: ":")[1].replacingOccurrences(of: "///", with: "/")
        if FileManager().fileExists(atPath: imagePath) {
            return imagePath
        } else {
            print("Error: path doesn't exist \(imagePath)")
            return ""
        }
    }
}
