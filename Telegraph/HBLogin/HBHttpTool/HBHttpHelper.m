//
//  HBHttpHelper.m
//  JiyuLogin
//
//  Created by Jiyu Jiyu on 2018/4/22.
//  Copyright © 2018年 com.omygreen. All rights reserved.
//

#import "HBHttpHelper.h"
#import "HBErrorModel.h"
#import "HBHttpHandle.h"

#define riskControlUrl @"https://uc-cn.huobi.com/uc/open/risk/control"
#define getImgCodeUrl @"https://uc-cn.huobi.com/uc/open/captcha_code/send"
#define getPhoneCodeUrl @"https://uc-cn.huobi.com/uc/open/sms_code/send"
#define HBLoginUrl  @"https://uc-cn.huobi.com/uc/open/login"
#define verifyErrorLoginUrl @"https://uc-cn.huobi.com/uc/open/2fa/login"
#define getCountriesUrl @"https://uc-cn.huobi.com/uc/open/country/list"
#define verifyCodeUrl @"https://uc-cn.huobi.com/uc/open/register_code/verify"
#define HBRegisterUrl  @"https://uc-cn.huobi.com/uc/open/register"
#define resetVerifyCodeUrl  @"https://uc-cn.huobi.com/uc/open/login_password_reset/account_verify"
#define resetVerifySafeUrl @"https://uc-cn.huobi.com/uc/open/login_password_reset/security_verify"
#define resetPasswordUrl @"https://uc-cn.huobi.com/uc/open/login_password/reset"

NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 10;

@implementation HBHttpHelper


//+ (void)riskControlWithParameters:(NSDictionary *)params
//                          success:(RiskSuccessBlock)RiskSuccess
//                          failure:(FailureBlock)failure{
//    [self PostWithURL:riskControlUrl Params:params success:^(id responseObject) {
//        //NSData 转NSString
//        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        HBRisk *riskModel = [HBRisk yy_modelWithJSON:result];
//        if (RiskSuccess) {
//            RiskSuccess(riskModel);
//        }
//    } failure:failure];
//}
+ (void)riskControlWithParameters:(NSDictionary *)params
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure
{
    [self PostWithURL:riskControlUrl Params:params success:success failure:failure];
}
+ (void)loginWithParameters:(id)parameters
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure{
//    [self PostWithURL:HBLoginUrl Params:parameters success:success failure:failure];
    [self PostWithURL:HBLoginUrl Params:parameters success:^(id responseObject) {
        if (success) {
            success(responseObject[@"ticket"]);
        }
    } failure:failure];
}
+ (void)verifyErrorLoginWithParameters:(id)parameters
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure{
    [self PostWithURL:verifyErrorLoginUrl Params:parameters success:^(id responseObject) {
        
        if (success) {
            success(responseObject[@"ticket"]);
        }
    } failure:failure];
}
+ (void)sendPhoneCodeWithParameters:(id)parameters
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure{
    [self PostWithURL:getPhoneCodeUrl Params:parameters success:success failure:failure];
}
//获取图片
+ (void)GetIMgCodeWithSuccess:(SuccessBlock)success
                      failure:(FailureBlock)failure{
    [self getImgCodeWithURL:getImgCodeUrl Params:nil success:success failure:failure];
}
//获取国家列表
+ (void)countriesWithSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    [self GetWithURL:getCountriesUrl Params:nil success:success failure:failure];
    
}
//验证手机验证码
+ (void)verifyCodeWithParameters:(id)parameters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure{
    [self PostWithURL:verifyCodeUrl Params:parameters success:success failure:failure];
}
//注册接口
+ (void)registWithParameters:(id)parameters
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    [self PostWithURL:HBRegisterUrl Params:parameters success:success failure:failure];
}
//请求 重置密码 验证码类型接口
+ (void)resetVerifyCodeWithParameters:(id)parameters
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure{
    [self PostWithURL:resetVerifyCodeUrl Params:parameters success:success failure:failure];
}
//对重置密码前的手机验证码安全验证
+ (void)resetVerifySafeAccountWithParameters:(id)parameters
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure{
    [self PostWithURL:resetVerifySafeUrl Params:parameters success:success failure:failure];
}
+ (void)resetPasswordtWithParameters:(id)parameters
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure{
    
    [self PostWithURL:resetPasswordUrl Params:parameters success:success failure:failure];
}
//原生POST请求
+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    //将字典转化为json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //设置参数
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    /*
     若session的创建方式为NSURLSession* session = [NSURLSession sharedSession]，则不管session执行的线程为主线程还是子线程，block中的代码执行线程均为任意选择的子线程。*/
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",obj);
//            if (success) {
//                success(obj[@"data"]);
//            }
//            NSData *data = [[NSData alloc] initWithBase64EncodedString:dict[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealWithSuccessRespone:obj success:success failure:failure];
            });
            
            
        }else{
            //            NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
            //
            //            if (httpResponse.statusCode != 0) {
            //
            //                NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
            //                failure(ResponseStr);
            //
            //            } else {
            //                NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
            //                failure(ErrorCode);
            //            }
//            if (failure) {
//                HBErrorModel *m = [HBErrorModel yy_modelWithJSON:error.userInfo];
//                failure(m);
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealFailureWithError:error failure:failure];
            });
            
        }
    }];
    [task resume];
}
+ (void)GetWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    //NSURLSession 只有异步请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //// block 在子线程中执行
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealWithSuccessRespone:dict success:success failure:failure];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealFailureWithError:error failure:failure];
            });
            
        }
        
    }];
    
    [task resume];
}

//原生GET  获取图片 网络请求
+ (void)getImgCodeWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    //NSURLSession 只有异步请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //// block 在子线程中执行
        
        
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dealWithSuccessRespone:dict success:^(id responseObject) {
                        
                        NSData *data = [[NSData alloc] initWithBase64EncodedString:responseObject[@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        UIImage *image = [UIImage imageWithData:data];
                        //回到主线程 赋值image
//                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (success) {
                                success(image);
                            }
//                        });
                    } failure:failure];
                });
                
                
                
            }else{
//                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
//
//                if (httpResponse.statusCode != 0) {
//
//                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
//                    failure(ResponseStr);
//
//                } else {
//                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
//                    failure(ErrorCode);
//                }
                
//                if (failure) {
//                    HBErrorModel *m = [HBErrorModel yy_modelWithJSON:error.userInfo];
//                    failure(m);
//                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dealFailureWithError:error failure:failure];
                });
               
            }
        
    }];
    
    [task resume];
}


#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];
    NSMutableString *result = [NSMutableString string];
    
    for (NSString *key in allkeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
        [result appendString:string];
    }
    return result;
}

#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
            
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
}
#pragma mark 对应回调数据的处理
+(void)dealWithSuccessRespone:(id)obj success:(SuccessBlock)success failure:(FailureBlock)failure{
    /*
     {
     //#define HBHttp_error_login_verficy          (10070)
     code = 10070;
     data =     {
     token = 54df8f42fef44d90a40c7067037a0a96;
     type = 1;
     };
     message = 10070;
     success = 0;
     }*/
    /////=======================   对于返回的数据分析
    NSInteger ret = -1;
    if ([obj objectForKey:@"code"]) {
        ret = [obj[@"code"] integerValue];
    }
    if (ret == 200) {
        //                [self successObj:obj task:task];
        if (success) {
            success(obj[@"data"]);
        }
    } else if (ret == HBHttp_error_token_overdue || ret == HBHttpCode_unauthorized) {
        //                if (failure) {
        //                    NSError *error = [self error:nil task:task obj:obj];
        //                    [self failureError:error];
        //                    failure(error);
        //                }
        if (failure) {
            HBErrorModel *m = [HBErrorModel yy_modelWithJSON:obj];;
            failure(m);
        }
    } else {
        //                if (failure) {
        //                    NSError *error = [self error:nil task:task obj:obj];
        //                    [self failureError:error];
        //                    failure(error);
        //                }
        if (failure) {
            //此时error=nil  应该对reponse 和  data  处理
            //                    NSLog(@"error.userInfo========== %@",error.userInfo);
            //                    NSError *error = [self error:nil task:(NSURLSessionDataTask *)task obj:response];
            //                    NSError *error = [HBHttpHelper error:nil task:(NSURLSessionDataTask *)task obj:response];
            //                    NSLog(@"data  to  obj ==========%@",obj);
            //                    NSLog(@"response==========%@",response);
            //                    NSLog(@"error==========%@",error);
            //暂时仅仅用到error的message,code,data[@"type"],
            HBErrorModel *m = [HBErrorModel yy_modelWithJSON:obj];
            failure(m);
        }
    }
    if (ret == HBHttpCode_close) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:obj[@"msg"]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:nil, nil]
         show];
    }
}
+(void)dealFailureWithError:(NSError *)error failure:(FailureBlock)failure{
    NSInteger responseStatusCode = 0;
    NSInteger code = HBHttpCode_networkError;
    NSString *msg = HBHttpMsg_network_error;
    NSInteger statusCode = error.code;
    if (-999 == statusCode) {
        msg = HBHttpMsg_network_error;
        code = HBHttpCode_cancelNetwork;
    }
    NSDictionary *userInfo = @{@"statusCode" : [NSString stringWithFormat:@"%zd", statusCode],
                               @"code" : [NSString stringWithFormat:@"%zd", code],
//                               @"url" : url,
                               @"message" : msg,
//                               @"HTTPMethod" : HTTPMethod,
//                               @"HTTPBody" : parameters,
//                               @"HTTPHeader" : header,
                               @"desc" : error.debugDescription,
                               @"responseStatusCode" : @(responseStatusCode)};
    NSError *err = [NSError errorWithDomain:NSURLErrorDomain
                                       code:code
                                   userInfo:userInfo];
    HBErrorModel *m = [HBErrorModel yy_modelWithJSON:err.userInfo];
    if (failure) {
        failure(m);
    }
}
@end
