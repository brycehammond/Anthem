
//
//  AnthemAppDelegate.h
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ConfigurationController;
@interface AnthemAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet ConfigurationController *configController;

@end
