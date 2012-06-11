//
//  NetworkDevicesController.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketSniffer.h"

@interface NetworkDevicesController : NSObject <PacketSnifferDelegate> 
{
    PacketSniffer *_sniffer; //weak
    
    IBOutlet NSMutableArray *_allDevices;
        
}

@property (nonatomic, retain) NSMutableArray *allDevices;

@end
