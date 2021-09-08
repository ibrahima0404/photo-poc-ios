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
    
    let store = ShareStore.store

    @objc func checkSendIntentReceived(_ call: CAPPluginCall) {
        if !store.processed {
            call.resolve([
                "text": store.text,
                "url": store.url,
                "image": store.image,
                "audio": store.audio,
                "file": store.file
            ])
            store.processed = true
        } else {
            call.reject("No processing needed.")
        }
    }

    public override func load() {
        let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(eval), name: Notification.Name("triggerSendIntent"), object: nil)
    }

    @objc open func eval(){
        self.bridge?.eval(js: "window.dispatchEvent(new Event('sendIntentReceived'))");
    }
}
