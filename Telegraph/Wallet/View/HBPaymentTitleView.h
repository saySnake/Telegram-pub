//
//  HBPaymentTitleView.h
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import <UIKit/UIKit.h>

@interface HBPaymentTitleView : UIView

+(instancetype)defaultTitleView;
@property(nonatomic,copy)NSString  * _Nonnull title;
@property(nonatomic,assign,getter=isPayment)BOOL payment;
@end
