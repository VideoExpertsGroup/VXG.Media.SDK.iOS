#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HLSStream : NSObject

@property (nonatomic) NSString* URL;
@property (nonatomic) NSString* ID;
@property (nonatomic) NSString* BANDWIDTH;
@property (nonatomic) NSString* CODECS;
@property (nonatomic) NSString* RESOLUTION;
@property (nonatomic) NSString* WIDTH;

@end

@interface M3U8 : NSObject

- (NSMutableArray*) getChannelsList; // return list of HLSStreams objects

- (BOOL) getDataSynchroAndParse: (NSString*)url;

@end














