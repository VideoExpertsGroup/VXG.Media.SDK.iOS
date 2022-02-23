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

#define CSDK_LOG_TAG(level, TAG, fmt, ...)  \
    if (level <= CSDK_LogLevel)             \
    {                                       \
        NSLog(@"%@: %@", TAG, [NSString stringWithFormat:fmt, ##__VA_ARGS__]);     \
    }                                       \

#define CSDK_LOG(level, fmt, ...)           \
    if (level <= CSDK_LogLevel)             \
    {                                       \
        NSLog(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__]);     \
    }                                       \

@interface ParamsPair: NSObject

@property (assign) NSString *first;
@property (strong) NSObject *second;

-(id) init: (NSString *) first second : (NSObject *) second;

@end

@interface CloudLock : NSObject
    - (void) wait;
    - (void) signal;
@end

@interface CloudHelpers : NSObject
+(long long) currentTimestampUTC;
+(long long) parseUTCtime: (NSString*) time;
+(NSString*) formatTime: (long long)utc;
+(NSString*) formatTime: (long long)utc withFormat:(NSString *)format withTimezone:(NSString *)zone;
+(NSString*) formatTimeHHMMSS:(long long)utc;
+(NSString*) formatTimeHHMM_AMPM:(long long)utc;
+(NSString*) formatTimeHHMM_AMPM:(long long)utc withTimezone:(NSString *)zone;
+(NSString*) formatTime_AMPM:(long long)utc withFormat:(NSString *)format withTimezone:(NSString *)zone;
+(NSString*) encodeURLParam: (NSString *)param;
+(NSString*) prepareHttpGetQuery:(NSArray *)pParams;
+(NSString*) formatTime_forMediaFileUploading: (long long) utc;
+(NSString*) formatTimeWithSSS:(long long)utc;
+(NSDate*) convertTimeIntoDate:(NSString*)time withFormat:(NSString *)format withTimezone:(NSTimeZone*)zone;

+(NSDictionary*) parseToken: (NSString*)source
        withDefaultProtocol: (NSString*) defaultProtocol
            withDefaultPort: (int) defaultPort
             withResultSVCP: (NSString**) presultSvcp
   withResultIsPathIncluded: (Boolean*) pisPathIncluded
          withLastErrorCode: (int*) plastErrorCode
        withLastErrorString: (NSString**) plastErrorString;

+(long long) cameraIdByToken: (NSString*) token;

+(void) runOnMainQueue:(void (^)(void)) block;

@end

typedef void (^ CloudTickerCallbackVoid)(void);
typedef void (^ CloudTickerCallbackLongLong)(long long);

@interface CloudTicker: NSObject

-(void) start:(CloudTickerCallbackVoid)callback; // Default tickrate: 5 sec.
-(void) start:(int64_t)tickRateInMs withCallbck:(CloudTickerCallbackVoid)callback;
-(void) startWitDelay:(int64_t)delayInMs withTickRate:(int64_t)tickRateInMs withCallbck:(CloudTickerCallbackVoid)callback;
-(void) cancel;
-(void) stop;

@end
