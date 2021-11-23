//
//  Utils.h
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+(NSString*)formatTimeInterval:(CGFloat)seconds isLeft:(BOOL)isLeft;
+(NSString*)getTempFilePath:(NSString*)name
               withTimedDir:(BOOL)isTimedDir;

+(void)enterLoginAndPassword:(UIViewController*)controller
                   withTitle:(NSString*)title
                 withMessage:(NSString*)message
                   withLogin:(NSString*)login
                withPassword:(NSString*)password
              withCompletion:(void (^ __nullable)(NSString* login, NSString* password)) completion;
+(void)selectFrom:(UIViewController*)controller
        withTitle:(NSString*)title
      withMessage:(NSString*)message
        withArray:(NSMutableArray<NSString*>*)array
   withCompletion:(void (^ __nullable)(NSString* value)) completion;

@end

NS_ASSUME_NONNULL_END
