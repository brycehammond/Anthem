//
//  NetworkDevicesController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "NetworkDevicesController.h"

@interface NetworkDevicesController (Private)

- (void)addDevice:(PcapAddress *)deviceAddress;
- (void)setPersonForDeviceAddress:(PcapAddress *)deviceAddress;

@end

@implementation NetworkDevicesController

@synthesize allDevices = _allDevices;

static NSDictionary *s_peopleByDevice;

- (id)init
{
    self = [super init];
    if (self) {
        
        if(nil == s_peopleByDevice)
        {
            s_peopleByDevice = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Erik", @"44:a7:cf:7b:49:b0:cd",
                                @"Casey", @"5c:da:d4:2d:b3:72",
                                @"Mario", @"0:23:76:ad:63:1a",
                                @"Bruce", @"14:5a:5:30:1a:c8",
                                @"Taylor", @"90:27:e4:5a:8:77",
                                @"George", @"90:27:e4:d:60:c2",
                                @"Bryce", @"c:74:c2:db:3e:b0", nil];
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
    [super dealloc];
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
        
        if(nil != [deviceAddress person])
        {
            [[self allDevices] addObject:deviceAddress];
        }
        
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
