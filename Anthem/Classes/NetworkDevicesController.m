//
//  NetworkDevicesController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "NetworkDevicesController.h"
#import <pcap.h>

@interface NetworkDevicesController ()
{
    __weak PacketSniffer *_sniffer;
}

- (void)addDevice:(PcapAddress *)deviceAddress;
- (void)setPersonForDeviceAddress:(PcapAddress *)deviceAddress;

@end

@implementation NetworkDevicesController

@synthesize allDevices = _allDevices;
@synthesize networkInterfaces = _networkInterfaces;

- (id)init
{
    self = [super init];
    if (self) {
        
         _sniffer = [PacketSniffer sharedSniffer];
         [_sniffer setDelegate:self];
         [_sniffer startListening:nil];
        
        _networkInterfaces = [[NSMutableArray alloc] init];
        
        pcap_if_t *alldevsp;       /* list of interfaces */
        char errbuf[PCAP_ERRBUF_SIZE];
        
        if (pcap_findalldevs (&alldevsp, errbuf) == 0)    
        {
            while (alldevsp != NULL)
            {
                NSString *deviceName = [NSString stringWithCString:alldevsp->name encoding:NSASCIIStringEncoding];
                if([deviceName hasPrefix:@"en"])
                {
                    if(alldevsp->description != NULL)
                    {
                        NSLog(@"network interface: %@",[NSString stringWithCString:alldevsp->description encoding:NSASCIIStringEncoding]);
                    }
                    [_networkInterfaces addObject:deviceName];
                }
                alldevsp = alldevsp->next;
            }
        }
        
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
    /*
    NSString *person = [s_peopleByDevice objectForKey:[[deviceAddress MACAddress] lowercaseString]];
    if(nil != person)
    {
        [deviceAddress setPerson:person];
    }
     */
}


@end
