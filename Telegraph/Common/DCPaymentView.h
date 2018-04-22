//
//  DCPaymentView.h
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentView : UIView

@property (nonatomic, copy) NSString *title, *detail;
@property (nonatomic, copy) NSString * amount;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

- (void)show;
- (void)show:(UIViewController *)viewController;
@end

