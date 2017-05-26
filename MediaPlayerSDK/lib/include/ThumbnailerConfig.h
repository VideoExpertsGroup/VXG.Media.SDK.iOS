//
//  MediaPlayerConfig.h
//  MediaPlayerSDK
//
//  Created by Max on 09/03/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#ifndef MediaPlayerSDK_ThumbnailerConfig_h
#define MediaPlayerSDK_ThumbnailerConfig_h

#import <Foundation/Foundation.h>

@interface ThumbnailerConfig : NSObject

@property (nonatomic) NSString* connectionUrl;
@property (nonatomic) int       connectionNetworkProtocol;  // 0 - udp, 1 - tcp, 2 - http, 3 - https, -1 - AUTO
@property (nonatomic) int       dataReceiveTimeout;
@property (nonatomic) int       numberOfCPUCores;           // <=0 - autodetect, > 0 - will set manually
@property (nonatomic) float     bogoMIPS;                   // BogoMIPS

@property (nonatomic) int       outWidth;                   // default 240
@property (nonatomic) int       outHeight;                  // default 240

@end

#endif
