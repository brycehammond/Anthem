//
//  ConfigurationController.m
//  Anthem
//
//  Created by Bryce Hammond on 7/1/12.
//  Copyright (c) 2012 Imulus, LLC. All rights reserved.
//

#import "ConfigurationController.h"
#import "PersonConfiguration.h"

#define kConfigDefaultsKey @"UserConfigurations"

@interface ConfigurationController ()
{
    dispatch_queue_t _savingQueue;
}

@end


@implementation ConfigurationController

@synthesize configurations = _configurations;


- (id)init
{
    self = [super init];
    if (self) {
        NSData *configData = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigDefaultsKey];
        if(nil != configData)
        {
            NSMutableArray *savedConfigs = [NSKeyedUnarchiver unarchiveObjectWithData:configData];
            [self setConfigurations:savedConfigs];
        }
        else 
        {
            [self setConfigurations:[NSMutableArray array]];
        }
        
        _savingQueue = dispatch_queue_create("com.imulus.anthem.saving", NULL);
        
        //look for changes on the configurations array
        [self addObserver:self forKeyPath:@"configurations" options:0 context:NULL];
    }
    
    return self;
}

- (void)saveConfigurations
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.configurations] 
                                              forKey:kConfigDefaultsKey];
}

- (void)saveConfigurationsInBackground
{
    //saves the current configurations to the 
    __weak ConfigurationController *weakSelf = self;
    
    dispatch_async(_savingQueue, ^{
        [weakSelf saveConfigurations];
    });
}

#pragma mark -
#pragma mark NSTableViewDelegate methods

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    //If any values changed then we should re-save the configurations
    
    [self saveConfigurationsInBackground];
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"configurations"])
    {
        //The array changed so time to trigger a save
        [self saveConfigurationsInBackground];
    }
}

@end
