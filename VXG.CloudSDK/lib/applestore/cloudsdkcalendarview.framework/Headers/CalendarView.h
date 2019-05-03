//
//  CalendarView.h
//

#import <UIKit/UIKit.h>

@protocol CalendarViewDelegate<NSObject>

@optional
- (void) calendarDateDidTap:(NSDate*)date;
- (void) calendarDateComponentsDidTap:(NSDateComponents*)comps;

- (void) calendarSelectedDateDidTap:(NSDate*)date;
- (void) calendarSelectedDateComponentsDidTap:(NSDateComponents*)comps;

- (void) calendarCloseDidTap;

@end


typedef NS_OPTIONS(int, CalendarViewControls)
{
    CALENDARVIEW_CONTROL_CLOSE  = 1 << 0,
    CALENDARVIEW_CONTROL_ALL    = CALENDARVIEW_CONTROL_CLOSE
};

// config for sdk view
@interface CalendarViewConfig : NSObject

@property (nonatomic) CalendarViewControls controls; // visible controls, default: CONTROL_ALL

// copy
+ (CalendarViewConfig*) makeCopy:(CalendarViewConfig*) src;

@end

@interface CalendarView : UIView

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

// config
-(CalendarViewConfig*) getConfig;
-(void) applyConfig;

-(void) setDelegate:(id<CalendarViewDelegate>) delegate;
-(id<CalendarViewDelegate>) getDelegate;

- (void) addSelectedDate:(NSDate*)date;
- (void) addSelectedDateAsString:(NSString*)date;

- (void) removeSelectedDate:(NSDate*)date;
- (void) removeSelectedDateAsString:(NSString*)date;

- (void) removeAllSelectedDates;

- (void) toNextMonth;
- (void) toPreviousMonth;
- (void) toMonth:(NSUInteger)month year:(NSUInteger)year;
- (void) toDate:(NSString*)date;

- (void) updateView;

@end
