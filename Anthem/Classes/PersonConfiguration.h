//
//  PersonConfiguration.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/12.
//  Copyright (c) 2012 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonConfiguration : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSString *soundFilePath;

@end
