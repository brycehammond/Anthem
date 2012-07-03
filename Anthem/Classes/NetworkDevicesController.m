//
//  NetworkDevicesController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "NetworkDevicesController.h"
#import "ConfigurationController.h"
#import "PersonConfiguration.h"
#import <pcap.h>

@interface NetworkDevicesController ()
{
    __weak PacketSniffer *_sniffer;
}

- (void)addDevice:(PcapAddress *)deviceAddress;
- (PersonConfiguration *)configurationForDeviceAddress:(PcapAddress *)deviceAddress;
- (BOOL)shouldAnthemForPerson:(PersonConfiguration *)personConfig;

@end

@implementation NetworkDevicesController

@synthesize allDevices = _allDevices;
@synthesize networkInterfaces = _networkInterfaces;
@synthesize configurationController = _configurationController;
@synthesize minutesBetweenAnthems = _minutesBetweenAnthems;

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
        
        self.minutesBetweenAnthems = [NSNumber numberWithInt:1];
        
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
    [self willChangeValueForKey:@"allDevices"];
    [self addDevice:[packet sourceAddress]];
    [self addDevice:[packet destinationAddress]];
    [self didChangeValueForKey:@"allDevices"];
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
        [[self allDevices] addObject:deviceAddress];
        
    }
    else
    {
        //update the last seen at time
        PcapAddress *existingAddress = [[self allDevices] objectAtIndex:deviceIdx];
        [existingAddress setLastSeenAt:currentTime];
    }
    
    //See if there is a configuration for the device and if we should anthem
    PersonConfiguration *config = [self configurationForDeviceAddress:deviceAddress];
    [config setLastSeenAt:currentTime];
    if(nil != config && YES == [self shouldAnthemForPerson:config])
    {
        //Play their Anthem
        if([[NSFileManager defaultManager] fileExistsAtPath:[config soundFilePath]])
        {
            NSSound *anthem = [[NSSound alloc] initWithContentsOfFile:[config soundFilePath] byReference:YES];
            [anthem play];
        }
        else 
        {
            NSLog(@"File does not exist at path %@",[config soundFilePath]);
        }
        
        //Mark them as played
        [config setLastPlayedAt:currentTime];
    }
}

- (PersonConfiguration *)configurationForDeviceAddress:(PcapAddress *)deviceAddress
{
    NSPredicate *addressPredicate = [NSPredicate predicateWithFormat:@"%@ LIKE[c] macAddress",[deviceAddress MACAddress]]; 
    NSArray *configurations = [[self.configurationController configurations] filteredArrayUsingPredicate:addressPredicate];
    
    if([configurations count] > 0)
    {
        return [configurations objectAtIndex:0];
    }
    
    return nil;
}

- (BOOL)shouldAnthemForPerson:(PersonConfiguration *)personConfig
{
    if(nil == personConfig.lastPlayedAt)
    {
        
        return YES;
    }
    
    NSTimeInterval timeInternalSinceLastPlayed = [[NSDate date] timeIntervalSinceDate:personConfig.lastPlayedAt];
    return  timeInternalSinceLastPlayed > self.minutesBetweenAnthems.intValue * 60;
}


@end
