#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ThumbnailerConfig.h"

typedef enum _ThumbnailerState
{
    ThumbnailerOpening  = 0,
    ThumbnailerOpened   = 1,
    ThumbnailerClosing  = 2,
    ThumbnailerClosed   = 3
    
} ThumbnailerState;

@interface Thumbnailer : NSObject

- (NSCondition*) Open: (ThumbnailerConfig*)config;
- (void) Close;

- (ThumbnailerConfig*) getConfig;

- (ThumbnailerState) getState;
- (NSString*) getInfo;

// Get thumbnail RGBA32
// Parameters:
// buffer        - in/out: allocated buffer for thumbnail
// buffer_size   -     in: allocated before buffer size,
// width, height -    out: real image sizes
// bytes_per_row -    out: image bytes ber row
//
// Return: image buffer size in bytes
- (int) getFrame: (void*)buffer
     buffer_size: (int32_t)buffer_size
           width: (int32_t*)width
          height: (int32_t*)height
   bytes_per_row: (int32_t*)bytes_per_row;

@end














