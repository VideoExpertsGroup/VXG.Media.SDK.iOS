//
//  CalendarView.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, CalendarViewStyles) {
    CALENDARVIEW_STYLE_DEFAULT = 0,
    CALENDARVIEW_STYLE_1,
};

typedef NS_OPTIONS(int, CalendarViewModes) {
    CALENDARVIEW_MODE_DEFAULT = 1 << 0,
    CALENDARVIEW_MODE_SINGLEROW = 1 << 1,
    CALENDARVIEW_MODE_SINGLE_SELECTION = 1 << 2,
};

typedef NS_OPTIONS(int, CalendarViewControls) {
    CALENDARVIEW_CONTROL_NAVIGATION = 1 << 0,
    CALENDARVIEW_CONTROL_NAVIGATION_PREVMONTH = 1 << 1,
    CALENDARVIEW_CONTROL_NAVIGATION_NEXTMONTH = 1 << 2,
    CALENDARVIEW_CONTROL_NAVIGATION_TITLE = 1 << 3,
    CALENDARVIEW_CONTROL_NAVIGATION_CLOSE = 1 << 4,
    CALENDARVIEW_CONTROL_TIME = 1 << 5
};

// config for calendar view
@interface CalendarViewConfig : NSObject

// style
+ (void)setStyle:(CalendarViewStyles)newValue;
+ (CalendarViewStyles)getStyle;

// styles, default:
@property (nonatomic) CalendarViewStyles styles;
// controls visibility, default:
@property (nonatomic) CalendarViewControls controls;
// calendar modes, default:
@property (nonatomic) CalendarViewModes modes;

// Appearance settings:
@property (copy, nonatomic) UIFont *navigationTitleTextFont;
@property (copy, nonatomic) UIColor *navigationTitleTextColor;
@property (copy, nonatomic) UIColor *navigationPrevColor;
@property (copy, nonatomic) UIColor *navigationNextColor;
@property (copy, nonatomic) UIColor *navigationCloseColor;
@property (copy, nonatomic) UIFont *weekHeaderTextFont;
@property (copy, nonatomic) UIColor *weekHeaderTextColor;
@property (copy, nonatomic) UIFont *weekHeaderWeekendTextFont;
@property (copy, nonatomic) UIColor *weekHeaderWeekendTextColor;
@property (copy, nonatomic) UIFont *componentTextFont;
@property (copy, nonatomic) UIFont *boldComponentTextFont;
@property (copy, nonatomic) UIColor *componentTextColor;
@property (copy, nonatomic) UIColor *eventComponentTextColor;
@property (copy, nonatomic) UIColor *otherMonthComponentTextColor;
@property (copy, nonatomic) UIFont *selectedComponentTextFont;
@property (copy, nonatomic) UIColor *selectedComponentTextColor;
@property (copy, nonatomic) UIColor *selectedComponentEventColor;
@property (copy, nonatomic) UIColor *selectedComponentBackgroundColor;
@property (copy, nonatomic) UIFont *timeTextFont;
@property (copy, nonatomic) UIColor *timeTextColor;
@property (copy, nonatomic) NSString *timeDateFormat;
@property (assign, nonatomic) CGFloat timeTrackWidth;
@property (copy, nonatomic) UIColor *timeTrackColor;
@property (copy, nonatomic) UIColor *timeThumbColor;
@property (assign, nonatomic) CGFloat timeThumbWidth;
@property (copy, nonatomic) UIImage *timeThumbImage;

@property (copy, nonatomic) UIColor *eventColor;
@property (copy, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) BOOL boldPrimaryComponentText;

// UI interaction
@property (assign, nonatomic) BOOL showEvents;
@property (assign, nonatomic) BOOL enableSelectionInteraction;
@property (assign, nonatomic) BOOL showMonthsOnlyWithEventsOrSelections;
@property (assign, nonatomic) BOOL showLoadingOnStart;

// UI sizes
@property (assign, nonatomic) CGFloat sizesNavigationPanelTop;
@property (assign, nonatomic) CGFloat sizesNavigationPanelHeight;
@property (assign, nonatomic) CGFloat sizesSingleRowContentPanelHeight;
@property (assign, nonatomic) CGFloat sizesTimeBarPanelHeight;

// copy
+ (CalendarViewConfig*) makeCopy:(CalendarViewConfig*) src;

@end

typedef NS_ENUM(int, CalendarEventFilterType) {
    CALENDAR_EVENT_FILTER_TYPE_EXCLUDE_RECORDS = 0,
    CALENDAR_EVENT_FILTER_TYPE_INCLUDE_RECORDS = 1,
};

@interface CalendarItem : NSObject
@property (nonatomic) NSDateComponents* value;
@property (nonatomic) UIColor *color; // nil if not needed
@property (nonatomic) UIFont *font; // nil if not needed
@end

@interface CalendarEventFilterItem : NSObject
@property (nonatomic) NSString* source; // token here
@property (nonatomic) CalendarEventFilterType type;
@property (nonatomic) NSString* setOfTypes;
@property (nonatomic) NSNumber* camid;
@property (nonatomic) long long start;
@property (nonatomic) long long end;
@end

@protocol CalendarViewDelegate<NSObject>

@optional
- (void) calendarDateDidTap:(NSDate*)date;
- (void) calendarDateComponentsDidTap:(NSDateComponents*)comps;

- (void) calendarSelectedDateDidTap:(NSDate*)date;
- (void) calendarSelectedDateComponentsDidTap:(NSDateComponents*)comps;

- (void) calendarCloseDidTap;

- (void) calendarTimeValueChanged:(long long)value;
@end

@protocol CalendarDataSourceDelegate<NSObject>

@optional
- (int) OnCalendarGetSelectedDatesCount;
- (CalendarItem*) OnCalendarGetSelectedDateByIndex:(int) index;
- (int) OnCalendarGetEventsCount;
- (CalendarItem*) OnCalendarGetEventByIndex:(int) index;

@end

@interface CalendarView : UIView

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

// set init instance callback
+ (void) setWillInitInstanceCallback:(void (^)(CalendarView* calendar, CalendarViewStyles* style, CalendarViewConfig* config)) callback;
+ (void) setDidInitInstanceCallback:(void (^)(CalendarView* calendar, CalendarViewConfig* config)) callback;

// config
- (CalendarViewConfig*) getConfig;
- (void) applyConfig;

// data source, if not set - used internal based on setSource
- (void) setDataSourceDelegate: (id<CalendarDataSourceDelegate>) source;
- (id<CalendarDataSourceDelegate>) getDataSourceDelegate;

- (void) setDelegate:(id<CalendarViewDelegate>) delegate;
- (id<CalendarViewDelegate>) getDelegate;

- (void) setTimezone:(nullable NSString*) timeZone;

// default token for get event data
- (int) setEventSourceWithFilter:(NSArray<CalendarEventFilterItem*>*)filters; // if nil, for all cameras all event types from current time

// selection
- (NSArray<NSDateComponents*>*) getSelectedDates;

- (void) addSelectedDate:(NSDate*)date;
- (void) addSelectedDateAsString:(NSString*)date;
- (void) addSelectedDateAsComponents:(NSDateComponents*)date;
- (void) removeSelectedDate:(NSDate*)date;
- (void) removeSelectedDateAsString:(NSString*)date;
- (void) removeAllSelectedDates;

// events
- (NSArray<NSDateComponents*>*) getEventDates;

- (void) addEventDate:(NSDate*)date;
- (void) addEventDateAsString:(NSString*)date;
- (void) addEventDateAsComponents:(NSDateComponents*)date;
- (void) removeEventDate:(NSDate*)date;
- (void) removeEventDateAsString:(NSString*)date;
- (void) removeAllEventDates;

// time
- (void) setTime:(long long)time; // time in range [0,24h], in seconds
- (long long) getTime;
- (NSString*) getTimeAsString:(nullable NSString*)format;

// operations
- (void) toNextMonth;
- (void) toPreviousMonth;
- (void) toMonth:(NSUInteger)month year:(NSUInteger)year;
- (void) toDate:(nonnull NSDate*)date;
- (void) toDateAsString:(nonnull NSString*)date;

- (void) updateView;

- (void)showLoading:(BOOL)show;

// cleanup
-(void) clean;

+(NSString*) getVersion;

@end
