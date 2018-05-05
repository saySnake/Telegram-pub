//
//  HttpCode.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/28.
//

#ifndef HttpCode_h
#define HttpCode_h

/**
 *  网络请求错误  HBLocalizedString(@"network_error")
 */
#define HBHttpMsg_network_error          @"网络异常，请检查网络设置"



/**
 *  取消任务
 */
#define HBHttpMsg_cancel_network         @"网络请求取消"

/**
 *  登录
 */
#define LOGIN     @"LOGIN"
/**
 *  注册
 */
#define REGISTER     @"REGISTER"
/**
 *  找回密码
 */
#define RESET_PASSWORD     @"RESET_PASSWORD"

/**
 * token 过期
 */
#define HBHttp_error_token_overdue          3009

/**
 * token 未授权
 */
#define HBHttpCode_unauthorized             10001

/**
 * token 接口不可用
 */
#define HBHttpCode_close                    4444

/**
 *  网络请求错误
 */
#define HBHttpCode_networkError             9999

/**
 *  取消任务
 */
#define HBHttpCode_cancelNetwork            (-999)


/****************************************** Account 账号 **********************************************/

/**
 *  登录超时，请重新登录
 */
#define HBHttp_error_login_deviece         (3009)

/**
 *  验证图片验证码
 */
#define HBHttp_error_buth_code              (-8)
/**
 *  图片验证码错误
 */
#define HBHttp_error_img_code               10039
/**
 *  账号密码错误
 */
#define HBHttp_error_passerror              10013
/**
 *  邮箱已注册
 */
#define HBHttp_error_email_existed          10061
/**
 *  手机已注册
 */
#define HBHttp_error_phone_existed          10051
/**
 *  验证码错误
 */
#define HBHttp_error_register_captcha       (-3)
/**
 *  输入GA验证码
 */
#define HBHttp_error_login_ga               (10080)

/**
 *  二次验证的错误码
 */
#define HBHttp_error_login_verficy          (10070)

/**
 *  token过期
 */
#define HBHttp_error_login_token            (10210)


/**
 *  参数错误
 */
#define HBHttp_error_params                 502




/****************************************** 安全密码 **********************************************/
/**
 *  验证码校验失败
 */
#define HBHttp_error_fund_auth_code             (3040)
/**
 *  验证码过期
 */
#define HBHttp_error_fund_auth_overdue          (3043)
/**
 *  非常用设备
 */
#define HBHttp_error_no_availability_device     (3070)



#endif /* HttpCode_h */


/*
 
 mobile_error.-1=账户名或登录密码不正确，请重新输入
 mobile_error.-2=密码错误
 mobile_error.-3=验证码错误
 mobile_error.-4=您还没有登录，请登录
 mobile_error.-5=请输入谷歌登录GA
 mobile_error.-6=谷歌登录GA错误
 mobile_error.-7=登录超时，请重新登录
 mobile_error.-8=需要验证码
 mobile_error.-9=该账号已在其他移动终端上登录
 mobile_error.-10=您还没有登录，请登录
 mobile_error.-11=验证码发送已超限
 mobile_error.-12=手机号码错误
 mobile_error.-13=邮箱地址错误
 mobile_error.-14=邮箱地址已存在
 mobile_error.-15=手机号已存在
 mobile_error.-16=密码过于简单
 mobile_error.-17=账户被锁定，无法登录
 mobile_error.-18=无效的语言
 mobile_error.-19=请求参数不正确
 mobile_error.10000=认证等级为空或不存在
 #mobile_error.10001=认证信息有误
 mobile_error.10001=承诺未勾选
 mobile_error.10002=证件类型错误
 mobile_error.10003=姓名或卡号为空
 mobile_error.10004=身份证号错误
 mobile_error.10005=用户id错误
 mobile_error.10006=证件号已存在
 mobile_error.10007=认证失败
 mobile_error.10008=证件有效期错误
 mobile_error.10009=证件照片错误
 mobile_error.10010=密钥为空错误
 mobile_error.10011=时间戳为空错误
 mobile_error.10012=验证错误
 mobile_error.10013=图片上传错误
 mobile_error.10014=证件号码包含非法字符
 mobile_error.10015=您提交的次数过多，24小时内已被禁止认证
 mobile_error.10016=您的C1认证操作已经被禁止
 mobile_error.10017=您的C1认证操作已通过
 mobile_error.10018=您提交的信息匹配有误，请重新提交正确信息
 mobile_error.10019=验证失败，您的姓名与证件号码不匹配，请重新进行更改
 mobile_error.10021=当前版本不支持实名认证，请更新版本后提交实名认证

#endif /* HttpCode_h */
