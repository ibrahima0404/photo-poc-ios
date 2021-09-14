//
//  SharePersistentContainer.swift
//  App
//
//  Created by Ibrahima KH GUEYE on 11/09/2021.
//

import Foundation
import CoreData

class SharePersistentContainer: NSPersistentContainer {
    private static let groupName = "group.ionic.ios.sesame.poc.sar.entreprise"
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName)
        storeURL = storeURL?.appendingPathComponent("ShareContainer")
        return storeURL!
    }
}
