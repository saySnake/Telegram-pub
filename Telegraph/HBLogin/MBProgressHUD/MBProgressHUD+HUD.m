//
//  MBProgressHUD+HUD.m
//  Market
//
//  Created by Airy on 15/12/24.
//  Copyright © 2015年 Linkstores. All rights reserved.
//

#import "MBProgressHUD+HUD.h"
#import "HBRoundView.h"

@implementation MBProgressHUD (HUD)

+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.detailsLabelText = message;
//    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    
    return hud;
}

+ (MBProgressHUD *)showLoadingToView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HBRoundView *loadingView = [hud customLoadingView];
    hud.customView = loadingView;
    [loadingView beginAnimation];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message
                      toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view
                animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *)view
  afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self showMessage:text
                                    toView:view];
    
    if (icon.length > 0) {
    
        UIImage *image = [UIImage imageNamed:icon];
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:delay];
}

+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *)view
{
    [self show:text
          icon:icon
          view:view
    afterDelay:KHUDDelay];
}

+ (void)showText:(NSString *)text toView:(UIView *)view
{
    [self show:text
          icon:nil
          view:view];
}

+ (void)showError:(NSString *)error
           toView:(UIView *)view
{
    [self show:error
          icon:@"error"
          view:view];
}

+ (void)showSuccess:(NSString *)success
             toView:(UIView *)view
{
    [self show:success
          icon:@"success"
          view:view];
}

- (void)hideHUD:(BOOL)animated
{
    if ([self.customView isKindOfClass:[HBRoundView class]]) {
        HBRoundView *loadingView = (HBRoundView *)self.customView;
        [loadingView endAnimation];
    }
    [self hide:animated];
}

- (HBRoundView *)customLoadingView
{
    HBRoundView *view = [[HBRoundView alloc] init];
    view.frame = CGRectMake(0, 0, 18, 18);
    view.strokeColor = [UIColor whiteColor];
    view.progress = 1;
    return view;
}

@end
