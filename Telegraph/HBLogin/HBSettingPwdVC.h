//
//  HBSettingPwdVC.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/26.
//

#import <UIKit/UIKit.h>

@interface HBSettingPwdVC : BaseNoNavViewController

/** 账号 */
@property (nonatomic, copy) NSString        *account;
/** 验证码 */
@property (nonatomic, copy) NSString        *captcha;
/** 国家代码 */
@property (nonatomic, copy) NSString        *countryCode;
//验证码
@property (nonatomic, copy) NSString        *code;


//@property (nonatomic, assign) AuthType      type;
//@property (nonatomic, assign) BOOL          isRegister;



@end
