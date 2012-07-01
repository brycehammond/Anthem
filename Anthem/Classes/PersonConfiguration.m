//
//  PersonConfiguration.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/12.
//  Copyright (c) 2012 Imulus, LLC. All rights reserved.
//

#import "PersonConfiguration.h"

@implementation PersonConfiguration

@synthesize name = _name;
@synthesize macAddress = _macAddress;
@synthesize soundFilePath = _soundFilePath;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.name = @"Name";
        self.macAddress = @"00:00:00:00:00:00";
        self.soundFilePath = @"/Path/to/sound/file";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.macAddress forKey:@"macAddress"];
    [aCoder encodeObject:self.soundFilePath forKey:@"soundFilePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.macAddress = [aDecoder decodeObjectForKey:@"macAddress"];
        self.soundFilePath = [aDecoder decodeObjectForKey:@"soundFilePath"];
    }
    
    return self;
}

@end
