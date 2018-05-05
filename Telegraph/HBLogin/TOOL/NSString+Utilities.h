//
//  NSString+Utilities.h
//  newbi
//
//  Created by 张锐 on 2017/8/15.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)


/**
 获取deviceID

 @return deviceID
 */
+ (NSString *)deviceID;


/**
 账号添加****，遮挡中间部分
 
 @return 遮挡完的字符串
 */
- (NSString *)anonymity;


/**
 地址 ***

 @return 遮挡完的字符串
 */
- (NSString *)anonymityAddres;

/**
 MD5
 */
- (NSString *)md5String;

/**
 改变字符串颜色

 @param string 需要改变的string
 @param color 需要改变的color
 @param font 需要改变的font
 @return 改变后的字符串
 */
- (NSAttributedString *)changeString:(NSString *)string
                               color:(UIColor *)color
                                font:(UIFont *)font;

- (NSAttributedString *)changeString:(NSString *)string
                               color:(UIColor *)color
                                font:(UIFont *)font
                             string1:(NSString *)string1
                        string1Color:(UIColor *)string1Color
                         string1Font:(UIFont *)string1Font;

@end
