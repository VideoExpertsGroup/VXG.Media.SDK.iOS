#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ONVIFDevice.h"

@protocol ONVIFDeviceManagerDelegate<NSObject>

@optional
- (int) OnONVFDeviceDetected: (ONVIFDevice*_Nonnull)device;

- (int) OnONVFDeviceInfoAuthenticationRequire: (ONVIFDevice*_Nonnull)device;
- (int) OnONVFDeviceInfoStartGathering: (ONVIFDevice*_Nonnull)device;
- (int) OnONVFDeviceInfo: (ONVIFDevice*_Nonnull)device;
- (int) OnONVFDeviceInfoStopGathering: (ONVIFDevice*_Nonnull)device;

@end

@interface ONVIFDeviceManager: NSObject

- (void) open: (id<ONVIFDeviceManagerDelegate>_Nonnull)delegate;
- (void) openWithDelegate: (id<ONVIFDeviceManagerDelegate>_Nonnull)delegate
        andMaxDeviceCount: (int)count;
- (void) close;


- (void) start;
- (void) startWithIP:(NSString*)ip
     andScanInterval:(int)interval;
- (void) stop;

- (int) getInfo: (ONVIFDevice*_Nonnull)device
 withCompletion: (void (^ __nullable)(ONVIFDevice* _Nonnull device)) completion;
@end

