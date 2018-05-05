#ifndef Telegraph_TGCommon_h
#define Telegraph_TGCommon_h

#import <UIKit/UIKit.h>
#import <inttypes.h>

#define TGUseSocial true

#define TG_ENABLE_AUDIO_NOTES true

#define TGAssert(expr) assert(expr)

#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])

#define UIColorFromRGB(x, y, z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

#define TGRestrictedToMainThread {if(![[NSThread currentThread] isMainThread]) TGLog(@"***** Warning: main thread-bound operation is running in background! *****");}

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define HEIGHT_STATUS_BAR (iPhoneX ? 44.f : 20.f)

#define HEIGHT_NAV_BAR 44.0f
// 导航栏高度
#define HEIGHT_NAV_STATUS_BAR (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define HEIGHT_TAB_BAR (iPhoneX ? (49.f+34.f) : 49.f)

static BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}



extern int TGLocalizedStaticVersion;

#define TG_TIMESTAMP_DEFINE(s) CFAbsoluteTime tg_timestamp_##s = CFAbsoluteTimeGetCurrent(); int tg_timestamp_line_##s = __LINE__;
#define TG_TIMESTAMP_MEASURE(s) { CFAbsoluteTime tg_timestamp_current_time = CFAbsoluteTimeGetCurrent(); TGLog(@"%s %d-%d: %f ms", #s, tg_timestamp_line_##s, __LINE__, (tg_timestamp_current_time - tg_timestamp_##s) * 1000.0); tg_timestamp_##s = tg_timestamp_current_time; tg_timestamp_line_##s = __LINE__; }

#ifdef __cplusplus
extern "C" {
#endif
int cpuCoreCount();
bool hasModernCpu();
int deviceMemorySize();
    
void TGSetLocalizationFromFile(NSString *filePath);
NSString *TGLocalized(NSString *s);
    
@class TGLocalization;

TGLocalization *effectiveLocalization();
NSString *currentLocalizationEnglishLanguageName();
TGLocalization *nativeEnglishLocalization();
TGLocalization *currentNativeLocalization();
TGLocalization *currentCustomLocalization();
void setCurrentNativeLocalization(TGLocalization *localization, bool switchIfCustom);
void setCurrentCustomLocalization(TGLocalization *localization);

bool TGObjectCompare(id obj1, id obj2);
bool TGStringCompare(NSString *s1, NSString *s2);
    
NSTimeInterval TGCurrentSystemTime();
    
NSString *TGStringMD5(NSString *string);
    
int iosMajorVersion();
int iosMinorVersion();
    
void printMemoryUsage(NSString *tag);
    
void TGDumpViews(UIView *view, NSString *indent);
    
NSString *TGEncodeText(NSString *string, int key);
    
inline void TGDispatchOnMainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread])
        block();
    else
        dispatch_async(dispatch_get_main_queue(), block);
}

inline void TGDispatchAfter(double delay, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay) * NSEC_PER_SEC)), queue, block);
}
    
void TGLogSetEnabled(bool enabled);
bool TGLogEnabled();
void TGLog(NSString *format, ...);
void TGLogv(NSString *format, va_list args);

void TGLogSynchronize();
NSArray *TGGetLogFilePaths(int count);
NSArray *TGGetPackedLogs();
    
#ifdef __cplusplus
}
#endif

@interface NSNumber (IntegerTypes)

- (int32_t)int32Value;
- (int64_t)int64Value;

@end

#ifdef __LP64__
#   define CGFloor floor
#else
#   define CGFloor floorf
#endif

#ifdef __LP64__
#   define CGRound round
#   define CGCeil ceil
#   define CGPow pow
#   define CGSin sin
#   define CGCos cos
#   define CGSqrt sqrt
#else
#   define CGRound roundf
#   define CGCeil ceilf
#   define CGPow powf
#   define CGSin sinf
#   define CGCos cosf
#   define CGSqrt sqrtf
#endif

#define CGEven(x) ((((int)x) & 1) ? (x + 1) : x)
#define CGOdd(x) ((((int)x) & 1) ? x : (x + 1))

#import "TGTColor.h"

#endif
