//
//  HBHttpHelper.h
//  JiyuLogin
//
//  Created by Jiyu Jiyu on 2018/4/22.
//  Copyright © 2018年 com.omygreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HBErrorModel.h"
#import "HBRisk.h"
typedef void (^SuccessBlock)(id responseObject);
//typedef void (^FailureBlock)(NSString *error);
typedef void (^FailureBlock)(HBErrorModel *error);
//typedef void (^RiskSuccessBlock)(HBRisk *riskModel);

@interface HBHttpHelper : NSObject

/**
 risk检验
 @param success success
 @param failure failure
 */
+ (void)riskControlWithParameters:(NSDictionary *)params
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;
//+ (void)riskControlWithParameters:(NSDictionary *)params
//                          success:(RiskSuccessBlock)RiskSuccess
//                          failure:(FailureBlock)failure;


/**
 登录接口
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)loginWithParameters:(id)parameters
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

/**
 图片验证码接口
 
 @param success 成功
 @param failure 失败
 */
+ (void)GetIMgCodeWithSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure;


/**
 二次验证
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)verifyErrorLoginWithParameters:(id)parameters
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

/**
 短信验证码接口
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)sendPhoneCodeWithParameters:(id)parameters
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;

/**
 国家接口
 get 请求
 @param success 成功
 @param failure 失败
 */
+ (void)countriesWithSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/**
 验证短信验证码接口
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)verifyCodeWithParameters:(id)parameters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;

/**
 注册接口
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)registWithParameters:(id)parameters
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/**
 找回密码验证码接口
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)resetVerifyCodeWithParameters:(id)parameters
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;


/**
 找回密码时，验证账户安全信息
 即在进入设置密码页面前,进行手机验证码和googlestr 的验证
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)resetVerifySafeAccountWithParameters:(id)parameters
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

/**
 重置登录密码
 
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)resetPasswordtWithParameters:(id)parameters
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

//原生GET网络请求
//+ (void)getImgCodeWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//
//+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;


@end
