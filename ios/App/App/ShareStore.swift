//
//  ShareStore.swift
//  App
//
//  Created by Ibrahima KH GUEYE on 07/09/2021.
//

import Foundation

public final class ShareStore {

    public static let store = ShareStore()
    private init() {
        self.text = ""
        self.url = ""
        self.image = ""
        self.file = ""
        self.processed = false
    }

    public var text: String;
    public var url: String;
    public var image: String;
    public var file: String;
    public var processed: Bool;
}
