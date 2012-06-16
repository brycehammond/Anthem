//
//  PacketSniffer.h
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pcap.h>
#import "PcapPacket.h"

@class PacketSniffer;

@protocol PacketSnifferDelegate <NSObject>

- (void)packetSniffer:(PacketSniffer *)sniffer
       didSniffPacket:(PcapPacket *)packet;

@end

@interface PacketSniffer : NSObject 

@property (nonatomic, assign) NSObject<PacketSnifferDelegate> *delegate;

+ (PacketSniffer *)sharedSniffer;
- (BOOL)startListening:(NSError **)error;
- (BOOL)stopListening:(NSError **)error;

@end
