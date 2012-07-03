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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setMACAddress:(NSString *)MACAddress
{
    //0 prefixed values are stripped so add them back
    NSArray *hexComponents = [MACAddress componentsSeparatedByString:@":"];
    NSMutableArray *updatedComponents = [[NSMutableArray alloc] init];
    for(NSString *component in hexComponents)
    {
        NSString *updatedComponent = component;
        if([component length] == 1)
        {
            updatedComponent = [@"0" stringByAppendingString:component];
        }
        [updatedComponents addObject:updatedComponent];
    }
    
    _MACAddress = [[updatedComponents componentsJoinedByString:@":"] uppercaseString];
}

- (BOOL)isEqual:(PcapAddress *)object
{
    return ([[object MACAddress] caseInsensitiveCompare:[self MACAddress]] == NSOrderedSame);
}

@end
