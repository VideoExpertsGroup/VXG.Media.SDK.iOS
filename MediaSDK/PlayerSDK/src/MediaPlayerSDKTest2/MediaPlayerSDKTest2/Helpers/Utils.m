//
//  Utils.m
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import "Utils.h"

@implementation Utils

+(NSString*)formatTimeInterval:(CGFloat)seconds isLeft:(BOOL)isLeft {
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%d:%0.2d", h, m];
    else        [format appendFormat:@"%d", m];
    [format appendFormat:@":%0.2d", s];
    
    return format;
}

+(NSString*)getTempFilePath:(NSString*)name
               withTimedDir:(BOOL)isTimedDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (isTimedDir) {
        NSError *error;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMdd_HHmmss_SSS"];
        NSString *timedir = [dateFormatter stringFromDate:[NSDate date]];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:timedir];
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:name];
    return filePath;
}

+ (void) enterLoginAndPassword:(UIViewController*)controller
                     withTitle:(NSString*)title
                   withMessage:(NSString*)message
                     withLogin:(NSString*)login
                  withPassword:(NSString*)password
                withCompletion:(void (^ __nullable)(NSString* login, NSString* password)) completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = login;
        textField.placeholder = @"login";
        textField.secureTextEntry = NO;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = password;
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Current password %@", [[alertController textFields][0] text]);
        completion([[alertController textFields][0] text], [[alertController textFields][1] text]);
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (void) selectFrom:(UIViewController*)controller
          withTitle:(NSString*)title
        withMessage:(NSString*)message
          withArray:(NSMutableArray<NSString*>*)array
     withCompletion:(void (^ __nullable)(NSString* value)) completion {
    if (array == nil || array.count <= 0) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    for (int i = 0; i < array.count; i++) {
        UIAlertAction *valueAction = [UIAlertAction actionWithTitle:[array objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action.title);
        }];
        [alertController addAction:valueAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
