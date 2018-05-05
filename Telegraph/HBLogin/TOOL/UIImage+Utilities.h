//
//  UIImage+Utilities.h
//  iOTNews
//
//  Created by Airy on 15/5/8.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

#pragma mark - resizable

+ (UIImage *)resizableImage:(NSString *)name;

#pragma mark - Color
- (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size;

/**
 *  图片透明度
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha;

/**
 *  图片圆角
 */
+ (id)createRoundedRectImage:(UIImage *)image
                        size:(CGSize)size
                      radius:(NSInteger)r;


/**
 *  返回一张密码输入框网格图片
 *
 *  @param gridCount 网格数
 *  @param gridLineColor 网格线颜色
 *  @param gridLineWidth 网格线宽度
 *
 *  @return 网格图片
 */
+ (instancetype)passwordInputGridImageWithGridCount:(NSInteger)gridCount
                                      gridLineColor:(UIColor *)gridLineColor
                                      gridLineWidth:(CGFloat)gridLineWidth;

/**
 *  返回一张指定size的指定颜色的圆形拉伸保护的纯色图片
 */
+ (instancetype)circleAndStretchableImageWithColor:(UIColor *)color
                                              size:(CGSize)size;

/**
 *  生成地址二维码图片
 
 地址码分享图片，包含以下内容：
 “推荐使用火币钱包扫码”
 “BTC地址码”
 “0.123 BTC”
 
 “136***2331”
 “0x2866d60912cb3029921d8bdc989ab83e490f726c”
  + “火币钱包”
 */

/**
 生成地址二维码图片

 @param codeImage   二维码
 @param logoImage   LOGO
 @param title       页面提示
 @param qrCodeName  二维码名称
 @param amount      数额
 @param currency    币种
 @param phone       账号信息
 @param addr        地址
 @param appName     appName
 @return 图片
 */
+ (UIImage *)createQrCodeImage:(UIImage *)codeImage
                     logoImage:(UIImage *)logoImage
                         title:(NSString *)title
                    qrCodeName:(NSString *)qrCodeName
                        amount:(NSString *)amount
                      currency:(NSString *)currency
                         phone:(NSString *)phone
                          addr:(NSString *)addr
                       appName:(NSString *)appName;

@end
