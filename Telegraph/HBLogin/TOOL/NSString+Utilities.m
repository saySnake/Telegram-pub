//
//  NSString+Utilities.m
//  newbi
//
//  Created by 张锐 on 2017/8/15.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "NSString+Utilities.h"
#import "NSString+Verify.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "KeychainTool.h"

@implementation NSString (Utilities)

+ (NSString *)deviceID
{
    NSString *UUIDString = [KeychainTool keychainQuery:@"UUIDString"];

    if (UUIDString.length == 0) {
        UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [KeychainTool keychainSave:@"UUIDString"
                              data:UUIDString];
    }
    return [UUIDString lowercaseString];
}

- (NSString *)anonymity
{
    NSString *str = self;
    if ([str isValidateEmail]) {
        NSRange range = [str rangeOfString:@"@"];
        NSString *str1 = [str substringWithRange:NSMakeRange(0, range.location)];
        NSUInteger len = 3;
        if (str1.length > len) {
            NSString *str2 = [str substringWithRange:NSMakeRange(range.location,  str.length - range.location)];
            NSString *str3 = [str1 substringWithRange:NSMakeRange(0, len)];
            NSString *str4 = [str1 substringWithRange:NSMakeRange(len, str1.length - len)];
            NSMutableString *strM = [NSMutableString stringWithString:str3];
            NSInteger num = 0;
            for (int i = 0; i < str4.length; i++) {
                num++;
                if (num >4) {
                }else{
                   [strM appendString:@"*"];
                }
            }
            [strM appendString:str2];
            return strM;
        } else {
            return str;
        }
    } else {
        if (str.length > 7) {
            NSString *str1 = [str substringWithRange:NSMakeRange(0, 3)];
            NSString *str2 = [str substringWithRange:NSMakeRange(str.length - 4, 4)];
            NSString *str3 = [str substringWithRange:NSMakeRange(3, str.length - 3 - 4)];
            NSMutableString *strM = [NSMutableString stringWithString:str1];
            NSInteger num = 0;
            for (int i = 0; i < str3.length; i++) {
                num++;
                if (num >4) {
                }else{
                    [strM appendString:@"*"];
                }
            }
            [strM appendString:str2];
            return strM;
        } else {
            return str;
        }
    }
}

- (NSString *)anonymityAddres
{
    NSString *string = self;
    if (string.length > 10) {
        
        NSMutableString *stringM = [NSMutableString string];
        [stringM appendString:[string substringToIndex:5]];
        [stringM appendString:@"****"];
        [stringM appendString:[string substringFromIndex:string.length - 5]];
        return stringM;
        
    } else {
        return string;
    }
}

#pragma mark - MD5
- (NSString *)md5String
{
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5,
                   [self UTF8String],
                   (CC_LONG) [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    
    NSMutableString *mutableString = @"".mutableCopy;
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [mutableString appendFormat:@"%02x", digest[i]];
    }
    return mutableString;
}

- (NSAttributedString *)changeString:(NSString *)string
                               color:(UIColor *)color
                                font:(UIFont *)font
{
    
    NSRange range = [self rangeOfString:string];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:range];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    return attributedStr;
}

- (NSAttributedString *)changeString:(NSString *)string
                               color:(UIColor *)color
                                font:(UIFont *)font
                             string1:(NSString *)string1
                        string1Color:(UIColor *)string1Color
                         string1Font:(UIFont *)string1Font
{
    NSRange range = [self rangeOfString:string];
    NSRange range1 = [self rangeOfString:string1];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:range];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:string1Font
                          range:range1];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:string1Color
                          range:range1];
    return AttributedStr;
}


@end
