//
//  LightSocket.m
//  LightSocket
//
//  Created by Kevin Piacentini on 22/12/2016.
//  Copyright © 2016 Kevin Piacentini. All rights reserved.
//

#import "LightSocket.h"

@implementation LightSocket

- (id)initWithPort:(int)port
{
    if ((self = [super init]))
    {
        _port = port;
        _sockfd = 0;
        _listening = NO;
    }
    return self;
}

- (id)initWithFileDescriptor:(int)fd
{
    if ((self = [super init]))
    {
        _sockfd = fd;
        _buff_size = BUFF_SIZE;
    }
    return self;
}

- (void)onMessageAction:(NSString *)message
{
    [self sendMessage:message];
}

- (void)readMessage
{
    BOOL                continueReading;
    FILE                *stream;

    continueReading = YES;
    stream = fdopen(_sockfd, "r");
    while ((getdelim((char **)(&_buffer), (size_t *)(&_buff_size), END_OF_MSG, stream)) != -1)
    {
        [self onMessageAction:[NSString stringWithUTF8String:(const char *)_buffer]];
        bzero(_buffer, _buff_size);
    }
    [self close];
}

- (void)sendMessage:(NSString *)message
{
    const char *msg;

    msg = [message UTF8String];
    write(_sockfd, msg, strlen((const char *)msg));
}

- (BOOL)close {
    if (_sockfd > 0 && close(_sockfd) < 0)
        return NO;
    _sockfd = 0;
    return YES;
}

- (void)dealloc {
    [self close];
    free(_buffer);
}

- (BOOL)startServer
{
    struct sockaddr_in serv_addr;
    
    _sockfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serv_addr, '0', sizeof(serv_addr));
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(_port);
    
    bind(_sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    if (listen(_sockfd, MAX_CONN) == -1)
        return NO;
    _listening = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (_listening) {
            __block int connfd = accept(_sockfd, (struct sockaddr*)NULL, NULL);
            if (connfd != -1)
            {
                LightSocket *socket = [[LightSocket alloc] initWithFileDescriptor:connfd];
                [socket readMessage];
                [socket close];
            }
        }
    });
    return YES;
}
@end
