//
//  PacketSniffer.m
//  Anthem
//
//  Created by Bryce Hammond on 6/30/11.
//  Copyright 2011 Imulus, LLC. All rights reserved.
//

#import "PacketSniffer.h"

@interface PacketSniffer ()
{
    BOOL _isListening;
    pcap_t *pcap_handle;
    dispatch_queue_t _listeningQueue;
}

@end

@implementation PacketSniffer

@synthesize delegate;

static PacketSniffer* s_sharedSniffer = nil;

+ (PacketSniffer *)sharedSniffer
{
    @synchronized([PacketSniffer class])
	{
		if (nil == s_sharedSniffer)
			s_sharedSniffer = [[PacketSniffer alloc] init];
        
		return s_sharedSniffer;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([PacketSniffer class])
	{
		NSAssert(s_sharedSniffer == nil, @"Attempted to allocate a second instance of PacketSniffer.");
		s_sharedSniffer = [super alloc];
		return s_sharedSniffer;
	}
    
	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _isListening = NO;
        _listeningQueue = dispatch_queue_create("com.imulus.anthem.packetsniffer", NULL);
    }
    
    return self;
}

void gotPacket(u_char *args, const struct pcap_pkthdr *header, const u_char *packet)
{
    PcapPacket *pcapPacket = [[[PcapPacket alloc] initWithPacket:packet] autorelease];
    PacketSniffer *sniffer = (id)args;
    
    //call back to our delegate that we have a packet
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[sniffer delegate] packetSniffer:sniffer didSniffPacket:pcapPacket];
    });
  
}

- (BOOL)startListening:(NSError **)error
{
    if(NO == _isListening)
    {     
        
            char errbuf[PCAP_ERRBUF_SIZE];
            
            pcap_handle = pcap_open_live("en1", BUFSIZ, 1, 0, errbuf);
            if(pcap_handle)
            {
                dispatch_async(_listeningQueue, ^
                {
                    pcap_loop(pcap_handle, -1, gotPacket, (u_char *)self);
                });
            }
            else
            {
                NSString *errorString = [NSString stringWithCString:errbuf encoding:NSASCIIStringEncoding];
                if(error != NULL)
                {
                    *error = [NSError errorWithDomain:@"PCAPError" code:100 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorString,NSLocalizedDescriptionKey, nil]];
                }
                return NO;
            }             
        
        
        _isListening = YES;
    }
    
    return YES;
}

- (BOOL)stopListening:(NSError **)error
{
    if(_isListening)
    {
        dispatch_async(_listeningQueue, ^
        {
            pcap_close(pcap_handle);
        });
        _isListening = NO;
    }
    
    return NO;
}



@end
