//
//  PluginShare.m
//  App
//
//  Created by Ibrahima KH GUEYE on 02/09/2021.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
CAP_PLUGIN(PluginShare, "PluginShare",
           CAP_PLUGIN_METHOD(checkSendIntentReceived, CAPPluginReturnPromise);
)
