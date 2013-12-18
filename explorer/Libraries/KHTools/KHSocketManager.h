//
//  KHSocketManager.h
//  KHTools
//
//  Created by Kosuke Hata on 12/6/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@protocol KHSocketManagerDelegate <NSObject>

@optional

- (void)socketIODidConnect:(SocketIO *)socket;
- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error;
- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet;
- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet;
- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet;
- (void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet;
- (void)socketIO:(SocketIO *)socket onError:(NSError *)error;

@end

@interface KHSocketManager : NSObject <SocketIODelegate> {
    SocketIO *socketIO;
}

@property (nonatomic, weak) id<KHSocketManagerDelegate> delegate;

+ (KHSocketManager *)sharedManager;
- (void)start;
- (void)disconnect;

- (void) sendMessage:(NSString *)data;
- (void) sendMessage:(NSString *)data withAcknowledge:(SocketIOCallback)function;
- (void) sendJSON:(NSDictionary *)data;
- (void) sendJSON:(NSDictionary *)data withAcknowledge:(SocketIOCallback)function;
- (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data;
- (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data andAcknowledge:(SocketIOCallback)function;


@end
