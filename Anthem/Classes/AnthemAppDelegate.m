//
//  AnthemAppDelegate.m
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "AnthemAppDelegate.h"
#import "PacketSniffer.h"
#import "ConfigurationController.h"

@implementation AnthemAppDelegate

@synthesize window;
@synthesize configController = _configController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
        
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self.configController saveConfigurations];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.configController saveConfigurations];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [window makeKeyAndOrderFront:self];
    return YES;
}

@end
