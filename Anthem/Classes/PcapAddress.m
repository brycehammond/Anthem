//
//  PcapAddress.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "PcapAddress.h"


@implementation PcapAddress

@synthesize ip = _ip;
@synthesize MACAddress = _MACAddress;
@synthesize lastSeenAt = _lastSeenAt;
@synthesize firstSeenAt = _firstSeenAt;
@synthesize person = _person;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)isEqual:(PcapAddress *)object
{
    return ([[object MACAddress] caseInsensitiveCompare:[self MACAddress]] == NSOrderedSame);
}

@end
