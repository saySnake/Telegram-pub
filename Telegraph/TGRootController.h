#import <LegacyComponents/LegacyComponents.h>

#import <SSignalKit/SSignalKit.h>

@class TGDialogListController;
@class TGContactsController;
@class TGAccountSettingsController;
@class TGRecentCallsController;
@class TGMainTabsController;
@class TGCallStatusBarView;
@class TGVolumeBarView;
@class TGAnotherViewController; //1
@class HBFindViewController;


@interface TGRootController : TGViewController

@property (nonatomic, strong, readonly) TGMainTabsController *mainTabsController;
@property (nonatomic, strong, readonly) TGDialogListController *dialogListController;
@property (nonatomic, strong, readonly) TGContactsController *contactsController;
@property (nonatomic, strong) TGAccountSettingsController *accountSettingsController;
@property (nonatomic, strong, readonly) TGRecentCallsController *callsController;
@property (nonatomic, strong, readonly) TGCallStatusBarView *callStatusBarView;
@property (nonatomic, strong, readonly) TGVolumeBarView *volumeBarView;




@property (nonatomic, strong, readonly) TGAnotherViewController *anotherBarView;//2

@property (nonatomic, strong, readonly) HBFindViewController *findViewController;//2


- (SSignal *)sizeClass;
- (bool)isSplitView;
- (bool)isSlideOver;
- (CGRect)applicationBounds;

- (bool)callStatusBarHidden;

- (void)pushContentController:(UIViewController *)contentController;
- (void)replaceContentController:(UIViewController *)contentController;
- (void)popToContentController:(UIViewController *)contentController;
- (void)clearContentControllers;
- (NSArray *)viewControllers;

- (void)resetControllers;

- (void)localizationUpdated;

- (bool)isRTL;

@end
