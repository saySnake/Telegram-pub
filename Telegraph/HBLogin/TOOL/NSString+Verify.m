//
//  NSString+Verify.m
//  newbi
//
//  Created by 张锐 on 2017/8/22.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "NSString+Verify.h"
#import "NSString+Utilities.h"
//#import "HBConfig.h"

@implementation NSString (Verify)



- (BOOL)isLetterNumber
{
    return [self searchEvaluateWithRegex:@"^[A-Za-z0-9]+$"];
}

- (BOOL)isValidatePhone
{
    return [self evaluateWithRegex:@"^1\\d{10}$"];
}

- (BOOL)isValidateNumber
{
    return [self evaluateWithRegex:@"^[0-9]\\d*$"];
}

- (BOOL)isValidateEmail
{
    return [self evaluateWithRegex:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"];
}

- (BOOL)isValidatePwd
{
    return self.length > 0;
}

- (BOOL)isValidateRegisterPwd
{
    return [self evaluateWithRegex:@"^[0-9a-zA-Z]{8,20}$"];
}

- (NSString *)appendPwd
{
    NSString *newPassword = [NSString stringWithFormat:@"%@hello, moto", self];
    return [newPassword md5String];
}

- (NSString *)appendFundPwd
{
    NSString *newPassword = [NSString stringWithFormat:@"%@Nicholasjj", self];
    return [newPassword md5String];
}

- (NSUInteger)pwdScore
{
    NSString *str = self;
    NSUInteger ret = 0;
    
    if (str.length > 20) {
        return ret;
    }
    
    if (str.length < 8) {
        return ret;
    }
    
    if ([str searchEvaluateWithRegex:@"^[0-9]\\d*$"]) {
        return ret;
    }
    
    if ([str searchEvaluateWithRegex:@"^[0-9]+$"]) {
        return ret;
    }
    
    if ([str searchEvaluateWithRegex:@"^[A-Z]+$"]) {
        return ret;
    }
    
    if ([str searchEvaluateWithRegex:@"^[a-z]+$"]) {
        return ret;
    }
    
    if (str.length >= 8) {
        ret = 3;
    }
    
    if (str.length >= 10) {
        ret += 1;
    }
    
    if ([str searchEvaluateWithRegex:@"[0-9]+"]) {
        ret += 1;
    }
    
    if ([str searchEvaluateWithRegex:@"[A-Z]+"]) {
        ret += 1;
    }
    
    if ([str searchEvaluateWithRegex:@"[a-z]+"]) {
        ret += 1;
    }
    
    if ([str searchEvaluateWithRegex:@"[!@#$%^&*?_~-£(,)]+"]) {
        ret += 1;
    }
    
    return ret;
}

- (BOOL)isPositiveNumber
{
    return [self searchEvaluateWithRegex:@"^\\d*\\.?\\d+$"];
}

//- (BOOL)isValidateCurrencyAddress
//{
//    BOOL isAddress = NO;
//    NSDictionary * currencry = [HBConfig currencyPatternDict];
//    for (NSString * str in [currencry allValues]) {
//        if ([self searchEvaluateWithRegex:str]) {
//            isAddress = YES;
//            break;
//        }
//    }
//    return isAddress;
//}

//+ (NSDictionary *)currencyRegexDict
//{
//    return [HBConfig currencyPatternDict];
//}

//- (BOOL)isValidateCurrencyAndAddress:(NSString *)address
//{
//    NSString *regex = [NSString currencyRegexDict][self];
//    if (regex.length > 0) {
//        return [address searchEvaluateWithRegex:regex];
//    } else {
//        return NO;
//    }
//}
- (BOOL)isValidateCurrency
{
    NSString *currency = [self distinguishCurrency];
    if (currency.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

//- (NSString *)distinguishCurrency
//{
//    NSString *currency = @"";
//    NSArray *list = [NSString currencyList];
//    for (NSString *str in list) {
//        if ([self isEqualToString:str]) {
//            currency = str;
//            break;
//        }
//    }
//    return currency;
//}

//+ (NSArray *)currencyList
//{
//    NSMutableArray *arrayM = [NSMutableArray array];
//    NSArray *list = [HBConfig queryConfig].currencyList;
//    for (HBCurrency *c in list) {
//        [arrayM addObject:c.currency];
//    }
//    return arrayM;
//}

- (BOOL)searchEvaluateWithRegex:(NSString *)regex
{
    NSRange range = [self rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)evaluateWithRegex:(NSString *)regex
{
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexPredicate evaluateWithObject:self];
}

@end
