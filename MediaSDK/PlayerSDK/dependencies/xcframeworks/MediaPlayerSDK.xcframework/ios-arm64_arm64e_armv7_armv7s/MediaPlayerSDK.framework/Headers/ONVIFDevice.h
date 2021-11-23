#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ONVIFDevice;
typedef NS_ENUM(int, ONVIFDeviceState) {
    ONVIFDEVICE_STATE_INFO_GATHERING = 0x00000000,
    ONVIFDEVICE_STATE_INFO_GATHERED  = 0x00000001
};

@protocol ONVIFDeviceDelegate<NSObject>

@required
- (int) OnONVFDeviceStateChanged: (ONVIFDevice*_Nonnull)device
                       withState: (ONVIFDeviceState)state
                       andStatus: (int)status;

@end


@interface ONVIFDeviceBasicInfo: NSObject

@property (nonatomic) int type;
@property (nonatomic) NSString* endpointReference;

@property (nonatomic) int https;
@property (nonatomic) int port;
@property (nonatomic) NSString* host;
@property (nonatomic) NSString* url;
    
@end


@interface ONVIFDeviceInfo: NSObject

@property (nonatomic) NSString* manufacturer;
@property (nonatomic) NSString* model;
@property (nonatomic) NSString* firmwareVersion;
@property (nonatomic) NSString* serialNumber;
@property (nonatomic) NSString* hardwareId;

@end

@interface ONVIFDeviceProfile: NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* token;
@property (nonatomic) NSString* stream_url;

@end

@interface ONVIFDevice: NSObject

// Auth info
@property (nonatomic) NSString* username;
@property (nonatomic) NSString* password;

@property (nonatomic) NSString* localIP;

// infos
@property (nonatomic) ONVIFDeviceBasicInfo* basicInfo;
@property (nonatomic) ONVIFDeviceInfo* deviceInfo;

// profiles info
@property (nonatomic) ONVIFDeviceProfile* currentProfile;
@property (nonatomic) NSMutableArray<ONVIFDeviceProfile*>* profiles;

@property (nonatomic) ONVIFDeviceState state;

-(id<ONVIFDeviceDelegate>_Nullable) getDeleagte;
-(void) setDeleagte:(id<ONVIFDeviceDelegate>_Nullable)delegate;

-(void) clearAll;
-(NSString*) getFullStreamUrlFor:(NSString*)url;

-(void) close;

@end
