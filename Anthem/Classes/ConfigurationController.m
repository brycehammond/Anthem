//
//  ConfigurationController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/12.
//  Copyright (c) 2012 Imulus, LLC. All rights reserved.
//

#import "ConfigurationController.h"

@implementation ConfigurationController

@synthesize configurations = _configurations;

- (id)init
{
    self = [super init];
    if (self) {
        [self setConfigurations:[NSMutableArray array]];
    }
    
    return self;
}

@end
