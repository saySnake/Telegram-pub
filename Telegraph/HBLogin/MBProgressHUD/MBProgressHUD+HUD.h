//
//  MBProgressHUD+HUD.h
//  Market
//
//  Created by Airy on 15/12/24.
//  Copyright © 2015年 Linkstores. All rights reserved.
//

#import "MBProgressHUD.h"

#define KHUDDelay   1.5

@interface MBProgressHUD (HUD)

+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view;

+ (MBProgressHUD *)showLoadingToView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *)view
  afterDelay:(NSTimeInterval)delay;

+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *)view;

+ (void)showText:(NSString *)text
          toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success
             toView:(UIView *)view;

+ (void)showError:(NSString *)error
           toView:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
- (void)hideHUD:(BOOL)animated;

@end
