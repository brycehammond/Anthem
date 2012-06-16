//
//  PcapPacket.m
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "PcapPacket.h"
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <arpa/inet.h>

@implementation PcapPacket

@synthesize destinationAddress = _destinationAddress;
@synthesize sourceAddress = _sourceAddress;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithPacket:(const u_char *)packet
{
    self = [self init];
    if(self)
    {
        
        const struct ether_header *ethernet; /* The ethernet header */
        const struct ip *ip; /* The IP header */
        int size_ethernet = sizeof(struct ether_header);
        
        ethernet = (struct ether_header*)(packet);
        ip = (struct ip*)(packet + size_ethernet);
        
        char *addr;
        struct ether_addr host;
        
        
        //Get the MAC addresses in readable form
        
        memcpy(&host, ethernet->ether_shost, sizeof(host));
        addr = ether_ntoa(&host);
        
        NSString *sourceMAC = [NSString stringWithCString:addr encoding:NSASCIIStringEncoding];
        
        memcpy(&host, ethernet->ether_dhost, sizeof(host));
        addr = ether_ntoa(&host);
        
        NSString *destMAC = [NSString stringWithCString:addr encoding:NSASCIIStringEncoding];
        
        //Get the IP addresses in a readable form
        
        addr = inet_ntoa(ip->ip_src);
        NSString *sourceIP = [NSString stringWithCString:addr encoding:NSASCIIStringEncoding];
        
        addr = inet_ntoa(ip->ip_dst);
        NSString *destIP = [NSString stringWithCString:addr encoding:NSASCIIStringEncoding];
        
        //fill in the packet with the addresses
        
        PcapAddress *address = [[PcapAddress alloc] init];
        [address setIp:sourceIP];
        [address setMACAddress:sourceMAC];
        [self setSourceAddress:address];
        
        address = [[PcapAddress alloc] init];
        [address setIp:destIP];
        [address setMACAddress:destMAC];
        [self setDestinationAddress:address];
        
    }
    
    return self;
}

@end
