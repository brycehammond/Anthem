//
//  PcapPacket.h
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PcapAddress.h"


@interface PcapPacket : NSObject {
    PcapAddress *_destinationAddress;
    PcapAddress *_sourceAddress;
}

@property (nonatomic, strong) PcapAddress *destinationAddress;
@property (nonatomic, strong) PcapAddress *sourceAddress;

- (id)initWithPacket:(const u_char *)packet;

@end
