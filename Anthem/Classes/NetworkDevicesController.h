//
//  NetworkDevicesController.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pcap.h>
#import "PacketSniffer.h"

@class ConfigurationController;
@interface NetworkDevicesController : NSObject <PacketSnifferDelegate> 

@property (nonatomic, retain) NSMutableArray *allDevices;
@property (nonatomic, retain) NSMutableArray *networkInterfaces;
@property (nonatomic, weak) IBOutlet ConfigurationController *configurationController;
@property (nonatomic, assign) NSInteger minutesBetweenAnthems;
@property (weak) IBOutlet NSTextField *minutesBetweenDisplayField;

@end
