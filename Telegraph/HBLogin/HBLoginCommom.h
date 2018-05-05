//
//  HBLoginCommom.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//
#import <Foundation/Foundation.h>
#ifndef HBLoginCommom_h
#define HBLoginCommom_h

/** RISK 类型 */
typedef NS_ENUM(NSInteger, RiskType)
{
    /** 注册 */
    Risk_Register = 1,
    /** 登录 */
    Risk_Login,
    /** 找回密码 */
    Risk_FindPassWord,
};
/** Device 类型 */
typedef NS_ENUM(NSInteger, Deveice)
{
    /** PC */
    Deveice_PC = 1,
    /** Mobile */
    Deveice_Mobile,
    /** APP */
    Deveice_APP,
    /** Other */
    Deveice_Other,
};

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define WIDTHRation (kScreenWidth/375)
#define HeightRation (kScreenHeight/667)
#define kNavgationbarHeight 64
#define kTabBarHeight 49
#define kStatuesHeight 20
#define ISIpX  ([UIScreen mainScreen].bounds.size.height == 812 ?  1 : 0)
#define IpXAdd  ([UIScreen mainScreen].bounds.size.height == 812 ?  24 : 0)


#define iphoneXBottomHeight (ISIpX ?  34 : 0)

#define iPhone5_HEIGHT                  568

#define WeakSelf(self)                  __weak __typeof(&*self) weakSelf = self;
#define StrongSelf(self)                __strong __typeof(&*weakSelf) strongSelf = weakSelf;

#define HBColor_alpha(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define HBColor(r, g, b)            HBColor_alpha(r, g, b, 1.0)

#import "createLbaelButView.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+HUD.h"
#import "UIImage+Utilities.h"
#import "YYModel.h"
#import "UILabel+Utilities.h"
#import "NSString+Verify.h"
#import "NSString+Utilities.h"
#import "Masonry.h"
#import "BaseNoNavViewController.h"
#import "HBHttpHelper.h"
#import "HBLanguageTool.h"
#import "HttpCode.h"
#import "HBModel.h"
//#import <thirdparty/AFNetworking/AFNetworking.h>
//#import "thirdparty/AFNetworking/AFNetworking.h"

//#import <AFNetworking.h>


#endif /* HBLoginCommom_h */
