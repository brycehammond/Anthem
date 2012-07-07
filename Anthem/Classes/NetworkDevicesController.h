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

@property (nonatomic) NSMutableArray *allDevices;
@property (nonatomic) NSMutableArray *networkInterfaces;
@property (nonatomic, unsafe_unretained) IBOutlet ConfigurationController *configurationController;
@property (nonatomic, assign) NSInteger minutesBetweenAnthems;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *minutesBetweenDisplayField;

@end
