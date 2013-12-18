//
//  KHSocketManager.m
//  KHTools
//
//  Created by Kosuke Hata on 12/6/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHSocketManager.h"
#import "SocketIOPacket.h"

@implementation KHSocketManager 

+ (KHSocketManager *)sharedManager {
    static KHSocketManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[KHSocketManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)start
{
    // socket setup
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"salty-tor-5399.herokuapp.com" onPort:0];
}

- (void)disconnect
{
    socketIO = nil;
}

#pragma mark - socket.IO-objc send methods

- (void) sendMessage:(NSString *)data
{
    [socketIO sendMessage:data];
}

- (void) sendMessage:(NSString *)data withAcknowledge:(SocketIOCallback)function
{
    [socketIO sendMessage:data withAcknowledge:function];
}

- (void) sendJSON:(NSDictionary *)data
{
    [socketIO sendJSON:data];
}

- (void) sendJSON:(NSDictionary *)data withAcknowledge:(SocketIOCallback)function
{
    [socketIO sendJSON:data withAcknowledge:function];
}

- (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data
{
    [socketIO sendEvent:eventName withData:data];
}

- (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data andAcknowledge:(SocketIOCallback)function
{
    [socketIO sendEvent:eventName withData:data andAcknowledge:function];
}

#pragma mark - socket.IO-objc receive methods

- (void)socketIODidConnect:(SocketIO *)socket
{
    if ([self respondsToSelector:@selector(socketIODidConnect:)]) {
        [self.delegate socketIODidConnect:socket];
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    if ([self respondsToSelector:@selector(socketIODidDisconnect:disconnectedWithError:)]) {
        [self.delegate socketIODidDisconnect:socket disconnectedWithError:error];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    if ([self respondsToSelector:@selector(socketIO:didReceiveMessage:)]) {
        [self.delegate socketIO:socket didReceiveMessage:packet];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
    if ([self respondsToSelector:@selector(socketIO:didReceiveJSON:)]) {
        [self.delegate socketIO:socket didReceiveJSON:packet];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if ([self respondsToSelector:@selector(socketIO:didReceiveEvent:)]) {
        [self.delegate socketIO:socket didReceiveEvent:packet];
    }
}

- (void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet
{
    if ([self respondsToSelector:@selector(socketIO:didSendMessage:)]) {
        [self.delegate socketIO:socket didSendMessage:packet];
    }
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    if ([self respondsToSelector:@selector(socketIO:onError:)]) {
        [self.delegate socketIO:socket onError:error];
    }
}


@end
