//
//  CustAlertView.h
//  MemberLoan
//
//  Created by 张玮 on 2017/1/9.
//  Copyright © 2017年 张玮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClicked)(NSInteger index);
typedef void(^rejectButtonClicked)(NSString *text);//驳回时的驳回按钮响应
typedef void(^approveButtonClicked)(NSString *text);//同意并转发时的发送按钮响应

@interface CustAlertView : UIImageView
@property(nonatomic,copy)ButtonClicked itemClicked;
@property(nonatomic,copy)rejectButtonClicked rejectClicked;
@property(nonatomic,copy)approveButtonClicked approveClicked;


/** 创建普通弹框 */
+(CustAlertView *)creatWithMainButton:(NSString *)mainButton OptionButton:(NSString *)optionButton Title:(NSString *)title Content:(NSString *)content;
/** 创建驳回时的弹框 */
+(CustAlertView *)creatRejectAlert;
/** 创建同意时的弹框 */
+(CustAlertView *)creatApproveAlertWithContent:(NSString *)content;
/** 创建无网的提示框 */
+(CustAlertView *)creatNoNetworkAlert;

+(CustAlertView *)creatPayAlertView;

-(void)showAlertInViewController:(UIWindow *)vc;

- (void)showAlerViewWithVC:(UIViewController *)viewController;

-(void)dismissAlert;


@end
