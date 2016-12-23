//
//  LightSocket.h
//  LightSocket
//
//  Created by Kevin Piacentini on 22/12/2016.
//  Copyright © 2016 Kevin Piacentini. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define BUFF_SIZE 1024
#define MAX_CONN 10
#define END_OF_MSG '\n'

@interface LightSocket : NSObject

@property (nonatomic) int                   port;
@property (nonatomic) int                   sockfd;
@property (nonatomic) BOOL                  listening;
@property (nonatomic) void                  *buffer;
@property (nonatomic) int                   buff_size;

- (id)initWithPort:(int)port;
- (id)initWithFileDescriptor:(int)fd;
- (void)readMessage;
- (void)sendMessage:(NSString *)message;
- (BOOL)startServer;

@end
