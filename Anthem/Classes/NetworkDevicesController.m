//
//  NetworkDevicesController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "NetworkDevicesController.h"

@interface NetworkDevicesController ()
{
    __weak PacketSniffer *_sniffer;
}

- (void)addDevice:(PcapAddress *)deviceAddress;
- (void)setPersonForDeviceAddress:(PcapAddress *)deviceAddress;

@end

@implementation NetworkDevicesController

@synthesize allDevices = _allDevices;

static NSMutableDictionary *s_peopleByDevice;

- (id)init
{
    self = [super init];
    if (self) {
        
        if(nil == s_peopleByDevice)
        {
            s_peopleByDevice = [[NSMutableDictionary alloc] init];
        }
        
         _sniffer = [PacketSniffer sharedSniffer];
         [_sniffer setDelegate:self];
         [_sniffer startListening:nil];
        
        [self setAllDevices:[NSMutableArray array]];
        
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)dealloc
{
    [_sniffer stopListening:nil];
}

- (void)packetSniffer:(PacketSniffer *)sniffer
       didSniffPacket:(PcapPacket *)packet
{
    NSLog(@"dest %@ : %@", [[packet destinationAddress] MACAddress], [[packet destinationAddress] ip]);
    NSLog(@"src %@ : %@", [[packet sourceAddress] MACAddress], [[packet sourceAddress] ip]);
    
    [self addDevice:[packet sourceAddress]];
    [self addDevice:[packet destinationAddress]];
    
    [self setAllDevices:[self allDevices]];  //trigger KVO up in here
}
    
- (void)addDevice:(PcapAddress *)deviceAddress
{
    NSDate *currentTime = [NSDate date];
    NSUInteger deviceIdx = [[self allDevices] indexOfObject:deviceAddress];
    if(deviceIdx == NSNotFound)
    {
        //don't have it yet so add it and set the last seen and first seen times to now
        [deviceAddress setLastSeenAt:currentTime];
        [deviceAddress setFirstSeenAt:currentTime];
        [self setPersonForDeviceAddress:deviceAddress];
        
        [[self allDevices] addObject:deviceAddress];
        
    }
    else
    {
        //update the last seen at time
        PcapAddress *existingAddress = [[self allDevices] objectAtIndex:deviceIdx];
        [existingAddress setLastSeenAt:currentTime];
    }
}

- (void)setPersonForDeviceAddress:(PcapAddress *)deviceAddress
{
    NSString *person = [s_peopleByDevice objectForKey:[[deviceAddress MACAddress] lowercaseString]];
    if(nil != person)
    {
        [deviceAddress setPerson:person];
    }
}


@end
