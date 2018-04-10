#import "TGLocationTrackingButton.h"

@interface TGLocationOptionsView : UIView

@property (nonatomic, copy) void (^mapModeChanged)(NSInteger);
@property (nonatomic, copy) void (^trackModePressed)(void);

- (void)setTrackingMode:(TGLocationTrackingMode)trackingMode animated:(bool)animated;
- (void)setLocationAvailable:(bool)available animated:(bool)animated;
- (void)setMapModeControlHidden:(bool)hidden animated:(bool)animated;

@end
