#define  CSDK_LOG_LEVEL_NONE	0
#define  CSDK_LOG_LEVEL_ERROR	1
#define  CSDK_LOG_LEVEL_WARNING 2
#define  CSDK_LOG_LEVEL_INFO	3
#define  CSDK_LOG_LEVEL_DEBUG	4
#define  CSDK_LOG_LEVEL_LOG		5
#define  CSDK_LOG_LEVEL_FIXME	6
#define  CSDK_LOG_LEVEL_TRACE	7
#define  CSDK_LOG_LEVEL_MEMDUMP	9
#define  CSDK_LOG_LEVEL_COUNT	10

#define CSDK_LOG_LEVEL			CSDK_LOG_LEVEL_LOG

extern int CSDK_LogLevel;

#define CSDK_LOG(level, fmt, ...)           \
    if (level <= CSDK_LogLevel)             \
    {                                       \
        NSLog(@"%@: %@", [[self class] description], [NSString stringWithFormat:fmt, ##__VA_ARGS__]);     \
    }                                       \

@interface ParamsPair: NSObject

@property (assign) NSString *first;
@property (strong) NSObject *second;

-(id) init: (NSString *) first second : (NSObject *) second;

@end


@interface CloudHelpers : NSObject
+(long long)  currentTimestampUTC;
+(long long)  parseUTCtime: (NSString*) time;
+(NSString*)  formatTime: (long long) utc;
+(NSString*)  formatTimeHHMMSS:(long long)utc;
+(NSString *) encodeURLParam: (NSString *)param;
+(NSString*)  prepareHttpGetQuery:(NSArray *)pParams;
+(NSString*) formatTime_forMediaFileUploading: (long long) utc;
+(NSString*) formatTimeWithSSS:(long long)utc;
+(long long) cameraIdByToken: (NSString*) token;
@end
