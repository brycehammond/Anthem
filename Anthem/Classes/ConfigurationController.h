//
//  ConfigurationController.h
//  Anthem
//
//  Created by Bryce Hammond on 7/1/12.
//  Copyright (c) 2012 Imulus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationController : NSObject <NSTableViewDelegate>

@property (nonatomic, retain) IBOutlet NSMutableArray *configurations;

@end
