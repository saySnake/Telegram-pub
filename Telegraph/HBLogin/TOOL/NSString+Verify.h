//
//  NSString+Verify.h
//  newbi
//
//  Created by 张锐 on 2017/8/22.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)


/**
 验证字母数字
 
 @return 是否匹配规则
 */
- (BOOL)isLetterNumber;
/**
 验证全数字
 
 @return 是否匹配规则
 */
- (BOOL)isValidateNumber;
/**
 验证中国手机号
 
 @return 是否匹配规则
 */
- (BOOL)isValidatePhone;

/**
 验证邮箱
 
 @return 是否匹配规则
 */
- (BOOL)isValidateEmail;
/**
 验证密码
 
 @return 是否匹配规则
 */
- (BOOL)isValidatePwd;
/**
 验证注册密码
 
 @return 是否匹配规则
 */
- (BOOL)isValidateRegisterPwd;

/**
 密码加密MD5
 
 @return string
 */
- (NSString *)appendPwd;

/**
 资金密码密码加密MD5
 
 @return string
 */
- (NSString *)appendFundPwd;

/**
 火币账号安全级别

 @return 级别
 */
- (NSUInteger)pwdScore;

/**
 验证正数或者浮点数

 @return 是否匹配规则
 */
- (BOOL)isPositiveNumber;

/**
 所有币种
 
 @return 是否匹配规则
 */

- (BOOL)isValidateCurrencyAddress;

/**
 币种对应的地址是否有效
 
 @return YES/NO
 */
- (BOOL)isValidateCurrencyAndAddress:(NSString *)address;

/**
 支持的币种
 
 @return 币种
 */
- (NSString *)distinguishCurrency;
/**
 是否支持的币种
 
 @return YES/NO
 */
- (BOOL)isValidateCurrency;

@end
