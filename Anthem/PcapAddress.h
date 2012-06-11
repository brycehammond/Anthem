//
//  PcapAddress.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PcapAddress : NSObject {
    NSString *_MACAddress;
    NSString *_ip;
    NSDate *_lastSeenAt;
    NSDate *_firstSeenAt;
}

@property (nonatomic, retain) NSString *MACAddress;
@property (nonatomic, retain) NSString *ip;
@property (nonatomic, retain) NSDate *lastSeenAt;
@property (nonatomic, retain) NSDate *firstSeenAt;
@property (nonatomic, retain) NSString *person;

@end
