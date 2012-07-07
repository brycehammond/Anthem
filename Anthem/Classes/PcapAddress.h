//
//  PcapAddress.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PcapAddress : NSObject

@property (nonatomic, strong) NSString *MACAddress;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSDate *lastSeenAt;
@property (nonatomic, strong) NSDate *firstSeenAt;

@end
