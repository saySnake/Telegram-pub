#import "TGViewController.h"

#import "LegacyComponentsInternal.h"
#import "TGFont.h"
#import "TGImageUtils.h"
#import "Freedom.h"
#import "TGPopoverController.h"

#import "TGNavigationController.h"
#import "TGOverlayControllerWindow.h"

#import <QuartzCore/QuartzCore.h>

#import "TGHacks.h"

#import <set>

static __strong NSTimer *autorotationEnableTimer = nil;
static bool autorotationDisabled = false;

static std::set<int> autorotationLockIds;

@interface TGViewControllerSizeView : UIView {
    CGSize _validSize;
}

@property (nonatomic, copy) void (^sizeChanged)(CGSize size);

@end

@implementation TGViewControllerSizeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _validSize = frame.size;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (!CGSizeEqualToSize(_validSize, frame.size)) {
        _validSize = frame.size;
        if (_sizeChanged) {
            _sizeChanged(frame.size);
        }
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (!CGSizeEqualToSize(_validSize, bounds.size)) {
        _validSize = bounds.size;
        if (_sizeChanged) {
            _sizeChanged(bounds.size);
        }
    }
}

@end

@interface UIViewController ()

- (void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)value;

@end

@implementation TGAutorotationLock

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        static int nextId = 1;
        _lockId = nextId++;
        
        int lockId = _lockId;
        
        if ([NSThread isMainThread])
        {
            autorotationLockIds.insert(lockId);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                autorotationLockIds.insert(lockId);
            });
        }
    }
    return self;
}

- (void)dealloc
{
    int lockId = _lockId;
    
    if ([NSThread isMainThread])
    {
        autorotationLockIds.erase(lockId);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            autorotationLockIds.erase(lockId);
        });
    }
}

@end

@interface TGViewController () <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate>
{
    id<LegacyComponentsContext> _context;
    
    bool _hatTargetNavigationItem;
    
    id<SDisposable> _sizeClassDisposable;
    NSTimeInterval _currentSizeChangeDuration;
}

@property (nonatomic, strong) UIView *viewControllerStatusBarBackgroundView;
@property (nonatomic) UIInterfaceOrientation viewControllerRotatingFromOrientation;

@property (nonatomic, weak) UINavigationItem *targetNavigationItem;
@property (nonatomic, weak) UIViewController *targetNavigationTitleController;

@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) TGAutorotationLock *autorotationLock;

@end

@implementation TGViewController

static id<LegacyComponentsContext> _defaultContext = nil;

+ (void)setDefaultContext:(id<LegacyComponentsContext>)defaultContext {
    _defaultContext = defaultContext;
}

+ (UIFont *)titleFontForStyle:(TGViewControllerStyle)__unused style landscape:(bool)landscape
{
    if (!landscape)
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGBoldSystemFontOfSize(20);
        return font;
    }
    else
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGBoldSystemFontOfSize(17);
        return font;
    }
}

+ (UIFont *)titleTitleFontForStyle:(TGViewControllerStyle)__unused style landscape:(bool)landscape
{
    if (!landscape)
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGBoldSystemFontOfSize(16);
        return font;
    }
    else
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGBoldSystemFontOfSize(15);
        return font;
    }
}

+ (UIFont *)titleSubtitleFontForStyle:(TGViewControllerStyle)__unused style landscape:(bool)landscape
{
    if (!landscape)
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGSystemFontOfSize(13);
        return font;
    }
    else
    {
        static UIFont *font = nil;
        if (font == nil)
            font = TGSystemFontOfSize(13);
        return font;
    }
}

+ (UIColor *)titleTextColorForStyle:(TGViewControllerStyle)style
{
    if (style == TGViewControllerStyleDefault)
    {
        static UIColor *color = nil;
        if (color == nil)
            color = UIColorRGB(0xffffff);
        return color;
    }
    else
    {
        static UIColor *color = nil;
        if (color == nil)
            color = UIColorRGB(0xffffff);
        return color;
    }
}

+ (CGSize)screenSize:(UIDeviceOrientation)orientation
{
    CGSize mainScreenSize = TGScreenSize();
    
    CGSize size = CGSizeZero;
    if (UIDeviceOrientationIsPortrait(orientation))
        size = CGSizeMake(mainScreenSize.width, mainScreenSize.height);
    else
        size = CGSizeMake(mainScreenSize.height, mainScreenSize.width);
    return size;
}

+ (CGSize)screenSizeForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    CGSize mainScreenSize = TGScreenSize();
    
    CGSize size = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation))
        size = CGSizeMake(mainScreenSize.width, mainScreenSize.height);
    else
        size = CGSizeMake(mainScreenSize.height, mainScreenSize.width);
    return size;
}

+ (bool)isWidescreen
{
    static bool isWidescreenInitialized = false;
    static bool isWidescreen = false;
    
    if (!isWidescreenInitialized)
    {
        isWidescreenInitialized = true;
        
        CGSize screenSize = [TGViewController screenSizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
        if (screenSize.width > 321 || screenSize.height > 481)
            isWidescreen = true;
    }
    
    return isWidescreen;
}

+ (bool)hasLargeScreen
{
    static bool value = false;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        CGSize screenSize = [TGViewController screenSizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
        CGFloat side = MAX(screenSize.width, screenSize.height);
        value = side >= 667.0f - FLT_EPSILON;
    });
    
    return value;
}

+ (bool)hasVeryLargeScreen {
    static bool value = false;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        CGSize screenSize = [TGViewController screenSizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
        CGFloat side = MAX(screenSize.width, screenSize.height);
        value = side >= 736 - FLT_EPSILON;
    });
    
    return value;
}

+ (bool)hasTallScreen {
    static bool value = false;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        CGSize screenSize = [TGViewController screenSizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
        CGFloat side = MAX(screenSize.width, screenSize.height);
        value = side >= 812 - FLT_EPSILON;
    });
    
    return value;
}

+ (void)disableAutorotation
{
    autorotationDisabled = true;
}

+ (void)enableAutorotation
{
    autorotationDisabled = false;
}

+ (void)disableAutorotationFor:(NSTimeInterval)timeInterval
{
    [self disableAutorotationFor:timeInterval reentrant:false];
}

+ (void)disableAutorotationFor:(NSTimeInterval)timeInterval reentrant:(bool)reentrant
{
    if (reentrant && autorotationDisabled)
        return;
    
    autorotationDisabled = true;
    
    if (autorotationEnableTimer != nil)
    {
        if ([autorotationEnableTimer isValid])
        {
            [autorotationEnableTimer invalidate];
        }
        autorotationEnableTimer = nil;
    }
    
    autorotationEnableTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] interval:0 target:self selector:@selector(enableTimerEvent) userInfo:nil repeats:false];
    [[NSRunLoop mainRunLoop] addTimer:autorotationEnableTimer forMode:NSRunLoopCommonModes];
}

+ (bool)autorotationAllowed
{
    return !autorotationDisabled && autorotationLockIds.empty();
}

+ (void)attemptAutorotation
{
    if ([TGViewController autorotationAllowed])
    {
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

+ (void)enableTimerEvent
{
    autorotationDisabled = false;

    [self attemptAutorotation];
    
    autorotationEnableTimer = nil;
}

- (id)initWithNibName:(NSString *)__unused nibNameOrNil bundle:(NSBundle *)__unused nibBundleOrNil {
    return [self initWithContext:_defaultContext];
}

- (id)init {
    return [self initWithContext:_defaultContext];
}

- (id)initWithContext:(id<LegacyComponentsContext>)context {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        [self _commonViewControllerInit:context];
    }
    return self;
}

- (void)_commonViewControllerInit:(id<LegacyComponentsContext>)context
{
    assert(context != nil);
    _context = context;
    
    self.wantsFullScreenLayout = true;
    self.automaticallyManageScrollViewInsets = true;
    self.autoManageStatusBarBackground = true;
    __block bool initializedSizeClass = false;
    _currentSizeClass = UIUserInterfaceSizeClassCompact;
    
    __weak TGViewController *weakSelf = self;
    _sizeClassDisposable = [[_context sizeClassSignal] startWithNext:^(NSNumber *next) {
        __strong TGViewController *strongSelf = weakSelf;
        if (strongSelf != nil) {
            if (strongSelf->_currentSizeClass != [next integerValue]) {
                strongSelf->_currentSizeClass = (UIUserInterfaceSizeClass)[next integerValue];
                if (initializedSizeClass) {
                    [strongSelf updateSizeClass];
                }
            }
        }
    }];
    initializedSizeClass = true;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        [self setAutomaticallyAdjustsScrollViewInsets:false];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerStatusBarWillChangeFrame:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [_sizeClassDisposable dispose];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_associatedPopoverController dismissPopoverAnimated:false];
}

- (NSMutableArray *)associatedWindowStack
{
    if (_associatedWindowStack == nil)
        _associatedWindowStack = [[NSMutableArray alloc] init];
    
    return _associatedWindowStack;
}

- (void)setAssociatedPopoverController:(TGPopoverController *)associatedPopoverController
{
    if (_associatedPopoverController != nil)
        [_associatedPopoverController dismissPopoverAnimated:false];
    
    _associatedPopoverController = associatedPopoverController;
    _associatedPopoverController.delegate = self;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _associatedPopoverController)
    {
        _associatedPopoverController = nil;
    }
}

- (UINavigationController *)navigationController
{
    UIViewController *customParentViewController = _customParentViewController;
    if (customParentViewController.navigationController != nil)
        return customParentViewController.navigationController;
    return [super navigationController];
}

- (bool)shouldIgnoreStatusBarInOrientation:(UIInterfaceOrientation)orientation
{
    if (_currentSizeClass != UIUserInterfaceSizeClassCompact) {
        if ([self.navigationController isKindOfClass:[TGNavigationController class]])
        {
            switch (((TGNavigationController *)self.navigationController).presentationStyle)
            {
                case TGNavigationControllerPresentationStyleRootInPopover:
                case TGNavigationControllerPresentationStyleChildInPopover:
                case TGNavigationControllerPresentationStyleInFormSheet:
                    return true;
                default:
                    break;
            }
        }
    }
    
    if (!TGIsPad() && iosMajorVersion() >= 11)
        return UIInterfaceOrientationIsLandscape(orientation);
    
    return false;
}

- (bool)shouldIgnoreStatusBar
{
    return [self shouldIgnoreStatusBarInOrientation:self.interfaceOrientation];
}

- (bool)shouldIgnoreNavigationBar
{
    if ([self.navigationController isKindOfClass:[TGNavigationController class]])
    {
        switch (((TGNavigationController *)self.navigationController).presentationStyle)
        {
            case TGNavigationControllerPresentationStyleRootInPopover:
                return iosMajorVersion() < 8;
            default:
                break;
        }
    }
    
    return false;
}

- (bool)inPopover
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return false;
    else
    {
        if ([self.navigationController isKindOfClass:[TGNavigationController class]])
        {
            switch (((TGNavigationController *)self.navigationController).presentationStyle)
            {
                case TGNavigationControllerPresentationStyleRootInPopover:
                case TGNavigationControllerPresentationStyleChildInPopover:
                    return true;
                default:
                    break;
            }
        }
        
        return false;
    }
}

- (bool)inFormSheet
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return false;
    else
    {
        if ([self.navigationController isKindOfClass:[TGNavigationController class]])
        {
            switch (((TGNavigationController *)self.navigationController).presentationStyle)
            {
                case TGNavigationControllerPresentationStyleInFormSheet:
                    return true;
                default:
                    break;
            }
        }
        
        return self.modalPresentationStyle == UIModalPresentationFormSheet;
    }
}

- (bool)willCaptureInputShortly
{
    return false;
}

- (UIPopoverController *)popoverController
{
    if ([self.navigationController isKindOfClass:[TGNavigationController class]])
    {
        return ((TGNavigationController *)self.navigationController).parentPopoverController;
    }
    
    return nil;
}

- (void)acquireRotationLock
{
    if (_autorotationLock == nil)
        _autorotationLock = [[TGAutorotationLock alloc] init];
}

- (void)releaseRotationLock
{
    _autorotationLock = nil;
}

- (void)localizationUpdated
{
}

+ (int)preferredAnimationCurve
{
    return iosMajorVersion() >= 7 ? 7 : 0;
}

- (CGSize)referenceViewSizeForOrientation:(UIInterfaceOrientation)orientation
{
    if ([self inFormSheet])
        return CGSizeMake(540.0f, 620.0f);
    else if ([self inPopover])
        return CGSizeMake(320.0f, 528.0f);
    else
        return [TGViewController screenSizeForInterfaceOrientation:orientation];
}

- (UIInterfaceOrientation)currentInterfaceOrientation
{
    if ([self inFormSheet])
        return UIInterfaceOrientationPortrait;
    return (self.view.bounds.size.width >= TGScreenSize().height - FLT_EPSILON) ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    if (self.presentedViewController != nil && ![self.presentedViewController shouldAutorotate])
        return false;
    
    return [TGViewController autorotationAllowed];
}

- (void)loadView
{
    [super loadView];
    
    TGViewControllerSizeView *sizeView = [[TGViewControllerSizeView alloc] initWithFrame:self.view.bounds];
    sizeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    __weak TGViewController *weakSelf = self;
    sizeView.sizeChanged = ^(CGSize size) {
        __strong TGViewController *strongSelf = weakSelf;
        if (strongSelf != nil) {
            [strongSelf layoutControllerForSize:size duration:strongSelf->_currentSizeChangeDuration];
        }
    };
    sizeView.userInteractionEnabled = false;
    sizeView.hidden = true;
    [self.view addSubview:sizeView];
}

- (void)viewDidLoad
{
    if (_autoManageStatusBarBackground && [self preferredStatusBarStyle] == UIStatusBarStyleDefault && ![self shouldIgnoreStatusBar])
    {
        _viewControllerStatusBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        _viewControllerStatusBarBackgroundView.userInteractionEnabled = false;
        _viewControllerStatusBarBackgroundView.layer.zPosition = 1000;
        _viewControllerStatusBarBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _viewControllerStatusBarBackgroundView.backgroundColor = [UIColor blackColor];
        if (iosMajorVersion() < 7)
            [self.view addSubview:_viewControllerStatusBarBackgroundView];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    _viewControllerIsAnimatingAppearanceTransition = true;
    _viewControllerIsAppearing = true;
    //_viewControllerHasEverAppeared = true;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && iosMajorVersion() < 7)
    {
        CGSize size = CGSizeMake(320, 491);
        self.contentSizeForViewInPopover = size;
    }
    
    if ([self.navigationController isKindOfClass:[TGNavigationController class]])
        [(TGNavigationController *)self.navigationController setupNavigationBarForController:self animated:animated];
    
    [self _updateControllerInsetForOrientation:self.interfaceOrientation force:false notify:true];
    
    [self adjustToInterfaceOrientation:self.interfaceOrientation];
    
    [super viewWillAppear:animated];
    
    if (self.customAppearanceMethodsForwarding) {
        for (UIViewController *controller in self.childViewControllers) {
            [controller viewWillAppear:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _viewControllerIsAppearing = false;
    _viewControllerIsAnimatingAppearanceTransition = false;
    _viewControllerHasEverAppeared = true;
    
    [super viewDidAppear:animated];
    
    if (self.customAppearanceMethodsForwarding) {
        for (UIViewController *controller in self.childViewControllers) {
            [controller viewDidAppear:animated];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    _viewControllerIsDisappearing = true;
    _viewControllerIsAnimatingAppearanceTransition = true;
    
    [super viewWillDisappear:animated];
    
    if (self.customAppearanceMethodsForwarding) {
        for (UIViewController *controller in self.childViewControllers) {
            [controller viewWillDisappear:animated];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    _viewControllerIsDisappearing = false;
    _viewControllerIsAnimatingAppearanceTransition = false;
    
    [super viewDidDisappear:animated];
    
    if (self.customAppearanceMethodsForwarding) {
        for (UIViewController *controller in self.childViewControllers) {
            [controller viewDidDisappear:animated];
        }
    }
}

- (void)_adjustControllerInsetForRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    float additionalKeyboardHeight = [self _keyboardAdditionalDeltaHeightWhenRotatingFrom:_viewControllerRotatingFromOrientation toOrientation:toInterfaceOrientation];
    
    CGFloat statusBarHeight = [TGHacks statusBarHeightForOrientation:toInterfaceOrientation];
    [self _updateControllerInsetForOrientation:toInterfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:[self _currentKeyboardHeight:toInterfaceOrientation] + additionalKeyboardHeight force:false notify:true];
}

- (UIEdgeInsets)controllerInsetForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIEdgeInsets safeAreaInset = _context.safeAreaInset;
    CGFloat statusBarHeight = safeAreaInset.top > FLT_EPSILON ? safeAreaInset.top : [TGHacks statusBarHeightForOrientation:orientation];
    CGFloat keyboardHeight = [self _currentKeyboardHeight:orientation];
    
    CGFloat navigationBarHeight = ([self navigationBarShouldBeHidden] || [self shouldIgnoreNavigationBar]) ? 0 : [self navigationBarHeightForInterfaceOrientation:orientation];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(([self shouldIgnoreStatusBarInOrientation:orientation] ? 0.0f : statusBarHeight) + navigationBarHeight, 0, 0, 0);
    
    edgeInset.left += _parentInsets.left;
    edgeInset.top += _parentInsets.top;
    edgeInset.right += _parentInsets.right;
    edgeInset.bottom += _parentInsets.bottom;
    
    if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        edgeInset.bottom += [self tabBarHeight:UIInterfaceOrientationIsLandscape(orientation)];
    
    if (!_ignoreKeyboardWhenAdjustingScrollViewInsets)
        edgeInset.bottom = MAX(edgeInset.bottom, keyboardHeight);
    
    edgeInset.bottom += safeAreaInset.bottom;
    
    edgeInset.left += _explicitTableInset.left;
    edgeInset.right += _explicitTableInset.right;
    edgeInset.top += _explicitTableInset.top;
    edgeInset.bottom += _explicitTableInset.bottom;
    
    return edgeInset;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{   
    _viewControllerIsChangingInterfaceOrientation = true;
    _viewControllerRotatingFromOrientation = self.interfaceOrientation;
    _currentSizeChangeDuration = duration;
    
    if (_adjustControllerInsetWhenStartingRotation)
        [self _adjustControllerInsetForRotationToInterfaceOrientation:toInterfaceOrientation];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustToInterfaceOrientation:toInterfaceOrientation];
    
    if (!_adjustControllerInsetWhenStartingRotation)
        [self _adjustControllerInsetForRotationToInterfaceOrientation:toInterfaceOrientation];
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //TGLegacyLog(@"Did rotate");
    _viewControllerIsChangingInterfaceOrientation = false;
    _currentSizeChangeDuration = 0.0;
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (CGFloat)_currentKeyboardHeight:(UIInterfaceOrientation)orientation
{
    if ([self inPopover])
        return 0.0f;
    
    if ([self isViewLoaded] && !_viewControllerHasEverAppeared && ([self findFirstResponder:self.view] == nil && ![self willCaptureInputShortly]))
        return 0.0f;
    
    if ([TGHacks isKeyboardVisible])
        return [TGHacks keyboardHeightForOrientation:orientation];
    
    return 0.0f;
}

- (float)_keyboardAdditionalDeltaHeightWhenRotatingFrom:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation
{
    if ([TGHacks isKeyboardVisible])
    {
        if (UIInterfaceOrientationIsPortrait(fromOrientation) != UIInterfaceOrientationIsPortrait(toOrientation))
        {
        }
    }
    
    return 0.0f;
}

+ (void)disableUserInteractionFor:(NSTimeInterval)timeInterval {
    [[LegacyComponentsGlobals provider] disableUserInteractionFor:timeInterval];
}

- (CGFloat)_currentStatusBarHeight
{
    if (_context.safeAreaInset.top > FLT_EPSILON)
        return _context.safeAreaInset.top;
    
    CGRect statusBarFrame = [[LegacyComponentsGlobals provider] statusBarFrame];
    CGFloat minStatusBarHeight = [self prefersStatusBarHidden] ? 0.0f : 20.0f;
    CGFloat statusBarHeight = MAX(minStatusBarHeight, MIN(statusBarFrame.size.width, statusBarFrame.size.height));
    return MIN(40.0f, statusBarHeight + _additionalStatusBarHeight);
}

- (void)viewControllerStatusBarWillChangeFrame:(NSNotification *)notification
{
    if (!_viewControllerIsChangingInterfaceOrientation)
    {
        CGRect statusBarFrame = [[[notification userInfo] objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
        CGFloat minStatusBarHeight = [self prefersStatusBarHidden] ? 0.0f : 20.0f;
        CGFloat statusBarHeight = MAX(minStatusBarHeight, MIN(statusBarFrame.size.width, statusBarFrame.size.height));
        statusBarHeight = MIN(40.0f, statusBarHeight + _additionalStatusBarHeight);
        
        CGFloat keyboardHeight = [self _currentKeyboardHeight:self.interfaceOrientation];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
        {
            [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
        } completion:nil];
    }
}

- (UIView *)findFirstResponder:(UIView *)view
{
    if ([view isFirstResponder])
        return view;
    
    for (UIView *subview in view.subviews)
    {
        UIView *result = [self findFirstResponder:subview];
        if (result != nil)
            return result;
    }
    
    return nil;
}

- (void)viewControllerKeyboardWillChangeFrame:(NSNotification *)notification
{
    if (!_viewControllerIsChangingInterfaceOrientation && ![self inPopover])
    {
        CGFloat statusBarHeight = [self _currentStatusBarHeight];
        
        CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardHeight = MIN(keyboardFrame.size.height, keyboardFrame.size.width);
        double duration = ([[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
        
        if ([self isViewLoaded] && !_viewControllerHasEverAppeared && ([self findFirstResponder:self.view] == nil && ![self willCaptureInputShortly]))
        {
            
        }
        else if (_viewControllerIsAnimatingAppearanceTransition || !_viewControllerHasEverAppeared)
        {
            [UIView performWithoutAnimation:^
            {
                [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
            }];
        }
        else
        {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
            {
                [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
            } completion:nil];
        }
    }
}

- (void)viewControllerKeyboardWillHide:(NSNotification *)notification
{
    if (!_viewControllerIsChangingInterfaceOrientation && ![self inPopover])
    {
        CGFloat statusBarHeight = [self _currentStatusBarHeight];
        
        float keyboardHeight = 0.0f;
        double duration = ([[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
        
        if ([self isViewLoaded] && !_viewControllerHasEverAppeared && [self findFirstResponder:self.view] == nil && ![self willCaptureInputShortly])
        {
            
        }
        else if (_viewControllerIsAnimatingAppearanceTransition || !_viewControllerHasEverAppeared)
        {
            [UIView performWithoutAnimation:^
            {
                [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
            }];
        }
        else
        {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
            {
                [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
            } completion:nil];
        }
    }
}

#pragma mark -

- (void)adjustNavigationItem:(UIInterfaceOrientation)__unused orientation
{
}

#pragma mark -

- (UIBarStyle)requiredNavigationBarStyle
{
    return UIBarStyleDefault;
}

- (bool)navigationBarHasAction
{
    return false;
}

- (void)navigationBarAction
{
}

- (void)navigationBarSwipeDownAction
{
}

- (bool)statusBarShouldBeHidden
{
    return false;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (![_context rootCallStatusBarHidden])
        return UIStatusBarStyleLightContent;
    else
        return UIStatusBarStyleDefault;
}

- (void)setNeedsStatusBarAppearanceUpdate
{
    if (iosMajorVersion() < 7)
        return;
    
    [super setNeedsStatusBarAppearanceUpdate];
    
    if (iosMajorVersion() < 8)
        return;
    
    if (self.isViewLoaded) {
        UIWindow *lastWindow = [[LegacyComponentsGlobals provider] applicationWindows].lastObject;
        if (lastWindow != self.view.window && [lastWindow isKindOfClass:[TGOverlayControllerWindow class]])
        {
            [[LegacyComponentsGlobals provider] forceStatusBarAppearanceUpdate];
        }
    }
}

- (void)adjustToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [self adjustNavigationItem:orientation];
}

- (void)setExplicitTableInset:(UIEdgeInsets)explicitTableInset
{
    [self setExplicitTableInset:explicitTableInset scrollIndicatorInset:_explicitScrollIndicatorInset];
}

- (void)setExplicitScrollIndicatorInset:(UIEdgeInsets)explicitScrollIndicatorInset
{
    [self setExplicitTableInset:_explicitTableInset scrollIndicatorInset:explicitScrollIndicatorInset];
}

- (void)setAdditionalNavigationBarHeight:(CGFloat)additionalNavigationBarHeight
{
    _additionalNavigationBarHeight = additionalNavigationBarHeight;
    
    CGFloat statusBarHeight = [self _currentStatusBarHeight];
    CGFloat keyboardHeight = [self _currentKeyboardHeight:self.interfaceOrientation];
    
    [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
}

- (void)setAdditionalStatusBarHeight:(CGFloat)additionalStatusBarHeight
{
    _additionalStatusBarHeight = additionalStatusBarHeight;
    
    CGFloat statusBarHeight = [self _currentStatusBarHeight];
    CGFloat keyboardHeight = [self _currentKeyboardHeight:self.interfaceOrientation];
    
    [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
}

- (void)setExplicitTableInset:(UIEdgeInsets)explicitTableInset scrollIndicatorInset:(UIEdgeInsets)scrollIndicatorInset
{
    _explicitTableInset = explicitTableInset;
    _explicitScrollIndicatorInset = scrollIndicatorInset;
    
    CGFloat statusBarHeight = [self _currentStatusBarHeight];
    CGFloat keyboardHeight = [self _currentKeyboardHeight:self.interfaceOrientation];
    
    [self _updateControllerInsetForOrientation:self.interfaceOrientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:false notify:true];
}

- (bool)_updateControllerInset:(bool)force
{
    return [self _updateControllerInsetForOrientation:self.interfaceOrientation force:force notify:true];
}

- (bool)_updateControllerInsetForOrientation:(UIInterfaceOrientation)orientation force:(bool)force notify:(bool)notify
{
    CGFloat statusBarHeight = [self _currentStatusBarHeight];
    CGFloat keyboardHeight = [self _currentKeyboardHeight:self.interfaceOrientation];
    
    return [self _updateControllerInsetForOrientation:orientation statusBarHeight:statusBarHeight keyboardHeight:keyboardHeight force:(bool)force notify:notify];
}

- (CGFloat)navigationBarHeightForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    static CGFloat portraitHeight = 44.0f;
    static CGFloat landscapeHeight = 32.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        CGSize screenSize = TGScreenSize();
        CGFloat widescreenWidth = MAX(screenSize.width, screenSize.height);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && ABS(widescreenWidth - 736) > FLT_EPSILON)
        {
            portraitHeight = 44.0f;
            landscapeHeight = 32.0f;
        }
        else
        {
            portraitHeight = 44.0f;
            landscapeHeight = 44.0f;
        }
    });
    
    return (UIInterfaceOrientationIsPortrait(orientation) ? portraitHeight : landscapeHeight) + _additionalNavigationBarHeight;
}

- (CGFloat)tabBarHeight:(bool)landscape
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return iosMajorVersion() >= 11 ? (landscape ? 32.0f : 49.0f) : 49.0f;
    else
        return 56.0f;
}

- (UIEdgeInsets)calculatedSafeAreaInset
{
    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
    if (self.view.frame.size.width > self.view.frame.size.height)
        orientation = UIInterfaceOrientationLandscapeLeft;
    
    return [TGViewController safeAreaInsetForOrientation:orientation];
}

+ (UIEdgeInsets)safeAreaInsetForOrientation:(UIInterfaceOrientation)orientation
{
    if (TGIsPad() || (int)TGScreenSize().height != 812)
        return UIEdgeInsetsZero;
        
    switch (orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return UIEdgeInsetsMake(0.0f, 44.0f, 21.0f, 44.0f);
            
        
        default:
            return UIEdgeInsetsMake(44.0f, 0.0f, 34.0f, 0.0f);
    }
}

- (bool)_updateControllerInsetForOrientation:(UIInterfaceOrientation)orientation statusBarHeight:(CGFloat)statusBarHeight keyboardHeight:(CGFloat)keyboardHeight force:(bool)force notify:(bool)notify
{
    UIEdgeInsets safeAreaInset = [TGViewController safeAreaInsetForOrientation:orientation];
    CGFloat navigationBarHeight = ([self navigationBarShouldBeHidden] || [self shouldIgnoreNavigationBar]) ? 0 : [self navigationBarHeightForInterfaceOrientation:orientation];
    
    statusBarHeight = safeAreaInset.top > FLT_EPSILON ? safeAreaInset.top : statusBarHeight;
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(([self shouldIgnoreStatusBarInOrientation:orientation] ? 0.0f : statusBarHeight) + navigationBarHeight, 0, 0, 0);
    
    edgeInset.left += _parentInsets.left;
    edgeInset.top += _parentInsets.top;
    edgeInset.right += _parentInsets.right;
    edgeInset.bottom += _parentInsets.bottom;
    
    if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        edgeInset.bottom += [self tabBarHeight:UIInterfaceOrientationIsLandscape(orientation)];
    
    if (!_ignoreKeyboardWhenAdjustingScrollViewInsets)
        edgeInset.bottom = MAX(edgeInset.bottom, keyboardHeight);
    
    edgeInset.bottom += safeAreaInset.bottom;
    
    UIEdgeInsets previousInset = _controllerInset;
    UIEdgeInsets previousCleanInset = _controllerCleanInset;
    UIEdgeInsets previousIndicatorInset = _controllerScrollInset;
    
    UIEdgeInsets scrollEdgeInset = edgeInset;
    scrollEdgeInset.left += _explicitScrollIndicatorInset.left;
    scrollEdgeInset.right += _explicitScrollIndicatorInset.right + safeAreaInset.right;
    scrollEdgeInset.top += _explicitScrollIndicatorInset.top;
    scrollEdgeInset.bottom += _explicitScrollIndicatorInset.bottom;
    
    UIEdgeInsets cleanInset = edgeInset;
    
    edgeInset.left += _explicitTableInset.left;
    edgeInset.right += _explicitTableInset.right;
    edgeInset.top += _explicitTableInset.top;
    edgeInset.bottom += _explicitTableInset.bottom;
    
    if (force || !UIEdgeInsetsEqualToEdgeInsets(previousInset, edgeInset) || !UIEdgeInsetsEqualToEdgeInsets(previousIndicatorInset, scrollEdgeInset) || !UIEdgeInsetsEqualToEdgeInsets(previousCleanInset, cleanInset))
    {
        _controllerInset = edgeInset;
        _controllerCleanInset = cleanInset;
        _controllerScrollInset = scrollEdgeInset;
        _controllerSafeAreaInset = safeAreaInset;
        _controllerStatusBarHeight = statusBarHeight;
        
        if (notify)
            [self controllerInsetUpdated:previousInset];
        
        return true;
    }
    
    return false;
}

- (void)_autoAdjustInsetsForScrollView:(UIScrollView *)scrollView previousInset:(UIEdgeInsets)previousInset
{
    CGPoint contentOffset = scrollView.contentOffset;
    
    UIEdgeInsets finalInset = self.controllerInset;
    
    scrollView.contentInset = finalInset;
    scrollView.scrollIndicatorInsets = self.controllerScrollInset;

    if (!UIEdgeInsetsEqualToEdgeInsets(previousInset, UIEdgeInsetsZero))
    {
        CGFloat maxOffset = scrollView.contentSize.height - (scrollView.frame.size.height - finalInset.bottom);
        
        if (![self shouldAdjustScrollViewInsetsForInversedLayout])
            contentOffset.y += previousInset.top - finalInset.top;
        
        contentOffset.y = MAX(-finalInset.top, MIN(contentOffset.y, maxOffset));
        [scrollView setContentOffset:contentOffset animated:false];
    }
    else if (contentOffset.y < finalInset.top)
    {
        contentOffset.y = -finalInset.top;
        [scrollView setContentOffset:contentOffset animated:false];
    }
}

- (bool)shouldAdjustScrollViewInsetsForInversedLayout
{
    return false;
}

- (void)controllerInsetUpdated:(UIEdgeInsets)previousInset
{
    if (self.isViewLoaded)
    {
        if (_automaticallyManageScrollViewInsets)
        {
            if (_scrollViewsForAutomaticInsetsAdjustment != nil)
            {
                for (UIScrollView *scrollView in _scrollViewsForAutomaticInsetsAdjustment)
                {
                    [self _autoAdjustInsetsForScrollView:scrollView previousInset:previousInset];
                }
            }
            else
            {
                for (UIView *view in self.view.subviews)
                {
                    if ([view isKindOfClass:[UIScrollView class]])
                    {
                        [self _autoAdjustInsetsForScrollView:(UIScrollView *)view previousInset:previousInset];
                        
                        break;
                    }
                }
            }
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return false;
}

- (void)setNavigationBarHidden:(bool)navigationBarHidden animated:(BOOL)animated
{
    [self setNavigationBarHidden:navigationBarHidden withAnimation:animated ? TGViewControllerNavigationBarAnimationSlide : TGViewControllerNavigationBarAnimationNone];
}

- (void)setNavigationBarHidden:(bool)navigationBarHidden withAnimation:(TGViewControllerNavigationBarAnimation)animation
{
    [self setNavigationBarHidden:navigationBarHidden withAnimation:animation duration:0.3f];
}

- (void)setNavigationBarHidden:(bool)navigationBarHidden withAnimation:(TGViewControllerNavigationBarAnimation)animation duration:(NSTimeInterval)duration
{
    if (navigationBarHidden != self.navigationController.navigationBarHidden || navigationBarHidden != self.navigationBarShouldBeHidden)
    {
        self.navigationBarShouldBeHidden = navigationBarHidden;
        
        if (animation == TGViewControllerNavigationBarAnimationFade)
        {
            if (navigationBarHidden != self.navigationController.navigationBarHidden)
            {
                if (!navigationBarHidden)
                {
                    [self.navigationController setNavigationBarHidden:false animated:false];
                    self.navigationController.navigationBar.alpha = 0.0f;
                }
                [UIView animateWithDuration:duration animations:^
                {
                    self.navigationController.navigationBar.alpha = navigationBarHidden ? 0.0f : 1.0f;
                } completion:^(BOOL finished)
                {
                    if (finished)
                    {
                        if (navigationBarHidden)
                        {
                            self.navigationController.navigationBar.alpha = 1.0f;
                            [self.navigationController setNavigationBarHidden:true animated:false];
                        }
                    }
                }];
            }
        }
        else if (animation == TGViewControllerNavigationBarAnimationSlideFar)
        {
            if (navigationBarHidden != self.navigationController.navigationBarHidden)
            {
                CGFloat barHeight = [self navigationBarHeightForInterfaceOrientation:self.interfaceOrientation];
                CGFloat statusBarHeight = [TGHacks statusBarHeightForOrientation:self.interfaceOrientation];
                if ([self shouldIgnoreStatusBarInOrientation:self.interfaceOrientation])
                    statusBarHeight = 0.0f;
                
                CGSize screenSize = [TGViewController screenSizeForInterfaceOrientation:self.interfaceOrientation];
                
                if (!navigationBarHidden)
                {
                    [self.navigationController setNavigationBarHidden:false animated:false];
                    self.navigationController.navigationBar.frame = CGRectMake(0, -barHeight, screenSize.width, barHeight);
                }
                
                [UIView animateWithDuration:duration delay:0 options:0 animations:^
                {
                    if (navigationBarHidden)
                    {
                        self.navigationController.navigationBar.alpha = 0.0f;
                        self.navigationController.navigationBar.frame = CGRectMake(0, -barHeight, screenSize.width, barHeight);
                    }
                    else
                    {
                        self.navigationController.navigationBar.frame = CGRectMake(0, statusBarHeight, screenSize.width, barHeight);
                    }
                } completion:^(BOOL finished)
                {
                    if (navigationBarHidden)
                        self.navigationController.navigationBar.alpha = 1.0f;
                    if (finished)
                    {
                        if (navigationBarHidden)
                            [self.navigationController setNavigationBarHidden:true animated:false];
                    }
                }];
            }
        }
        else
        {
            [self.navigationController setNavigationBarHidden:navigationBarHidden animated:animation == TGViewControllerNavigationBarAnimationSlide];
        }
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
        {
            [self _updateControllerInset:false];
        } completion:nil];
    }
}

- (CGFloat)statusBarBackgroundAlpha
{
    return _viewControllerStatusBarBackgroundView.alpha;
}

- (UIView *)statusBarBackgroundView
{
    return _viewControllerStatusBarBackgroundView;
}

- (void)setStatusBarBackgroundAlpha:(float)alpha
{
    _viewControllerStatusBarBackgroundView.alpha = alpha;
}

- (void)setTargetNavigationItem:(UINavigationItem *)targetNavigationItem titleController:(UIViewController *)titleController
{
    bool updated = _targetNavigationItem != targetNavigationItem || _targetNavigationTitleController != titleController;
    _targetNavigationItem = targetNavigationItem;
    _targetNavigationTitleController = titleController;
    _hatTargetNavigationItem = true;
    
    if (targetNavigationItem != nil && updated)
    {
        [[self _currentNavigationItem] setLeftBarButtonItem:_leftBarButtonItem animated:false];
        [[self _currentNavigationItem] setRightBarButtonItem:_rightBarButtonItem animated:false];
        [[self _currentNavigationItem] setTitle:_titleText];
        [[self _currentTitleController] setTitle:_titleText];
        [[self _currentNavigationItem] setTitleView:_titleView];
    }
}

- (UINavigationItem *)_currentNavigationItem
{
    return _hatTargetNavigationItem ? _targetNavigationItem : self.navigationItem;
}

- (UIViewController *)_currentTitleController
{
    return _hatTargetNavigationItem ? _targetNavigationTitleController : self;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setLeftBarButtonItem:leftBarButtonItem animated:false];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated
{
    _leftBarButtonItem = leftBarButtonItem;
    [[self _currentNavigationItem] setLeftBarButtonItem:leftBarButtonItem animated:animated];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setRightBarButtonItem:rightBarButtonItem animated:false];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated
{
    _rightBarButtonItem = rightBarButtonItem;
    [[self _currentNavigationItem] setRightBarButtonItem:rightBarButtonItem animated:animated];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [[self _currentNavigationItem] setTitle:titleText];
    [[self _currentTitleController] setTitle:titleText];
}

- (void)setTitleView:(UIView *)titleView
{
    _titleView = titleView;
    [[self _currentNavigationItem] setTitleView:titleView];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return false;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)())completion
{
    if (TGIsPad() && iosMajorVersion() >= 7)
        viewControllerToPresent.preferredContentSize = [self.navigationController preferredContentSize];
    
    if ([viewControllerToPresent isKindOfClass:[TGNavigationController class]])
    {
        TGNavigationController *navController = (TGNavigationController *)self.navigationController;
        if (navController.showCallStatusBar)
            [(TGNavigationController *)viewControllerToPresent setShowCallStatusBar:true];
    }
    
    if (iosMajorVersion() >= 8 && self.presentedViewController != nil && [self.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self presentViewController:viewControllerToPresent animated:flag completion:completion];
        });
    }
    else
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)updateSizeClass {
    [self _updateControllerInset:true];
    
    if (_associatedPopoverController != nil) {
        [_associatedPopoverController dismissPopoverAnimated:false];
        
        if ([_associatedPopoverController.contentViewController isKindOfClass:[TGNavigationController class]]) {
            TGNavigationController *contentViewController = (TGNavigationController *)_associatedPopoverController.contentViewController;
            if (contentViewController.detachFromPresentingControllerInCompactMode) {
                NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                [viewControllers addObjectsFromArray:contentViewController.viewControllers];
                [self.navigationController setViewControllers:viewControllers animated:false];
            }
        }
        
        _associatedPopoverController = nil;
    }
}

- (void)layoutControllerForSize:(CGSize)__unused size duration:(NSTimeInterval)__unused duration {
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    if (self.externalPreviewActionItems != nil)
        return self.externalPreviewActionItems();
    
    return [super previewActionItems];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return !self.customAppearanceMethodsForwarding;
}

- (void)removeFromParentViewController {
    if (_customRemoveFromParentViewController) {
        _customRemoveFromParentViewController();
    }
    [super removeFromParentViewController];
}

@end

@interface UINavigationController (DelegateAutomaticDismissKeyboard)

@end

@implementation UINavigationController (DelegateAutomaticDismissKeyboard)

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return [self.topViewController disablesAutomaticKeyboardDismissal];
}

@end
