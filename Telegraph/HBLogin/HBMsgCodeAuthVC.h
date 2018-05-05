//
//  HBMsgCodeAuthVC.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/24.
//

#import <UIKit/UIKit.h>

@interface HBMsgCodeAuthVC : BaseNoNavViewController

//@property (nonatomic ,strong)NSMutableDictionary *parameters;//用于接受外部字典,方便重新获取验证码
@property (nonatomic, copy) NSString        *account;
@property (nonatomic, copy) NSString        *countryCode;


@end
