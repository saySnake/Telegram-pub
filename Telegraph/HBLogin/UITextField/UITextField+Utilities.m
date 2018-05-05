//
//  UITextField+Utilities.m
//  newbi
//
//  Created by 张锐 on 2017/9/1.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "UITextField+Utilities.h"
//#import "HBConfig.h"
//#import "HBCurrency.h"

@implementation UITextField (Utilities)

- (void)setPlaceholder:(NSString *)placeholder
      placeholderColor:(UIColor *)placeholderColor
              fontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
//    style.minimumLineHeight = self.bounds.size.height / 2;
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : style}];
}

- (void)setPlaceholderColor:(UIColor *)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

//- (BOOL)text:(NSString *)text
//    shouldChangeCharactersInRange:(NSRange)range
//    replacementString:(NSString *)string
//    currency:(NSString *)currency
//{
//    if (string.length == 0) {
//        return YES;
//    }
//    if (text.length == 1) {
//        if ([text isEqualToString:@"0"]) {
//            if (string.length > 0) {
//                if (![string isEqualToString:@"."]) {
//                    return NO;
//                }
//            }
//        }
//    } else if (text.length > 1) {
//        NSRange zeroRange = [text rangeOfString:@"."];
//        if (zeroRange.location != NSNotFound) {
//            if ([string isEqualToString:@"."]) {
//                return NO;
//            } else {
//                if (zeroRange.location > range.location) {
//                    if (range.location == 0 &&
//                        range.length == 0) {
//                        if ([string isEqualToString:@"0"]) {
//                            return NO;
//                        } else {
//                            return YES;
//                        }
//                    } else {
//                        return YES;
//                    }
//                }
//                if (range.location == 0 &&
//                    range.length == 0) {
//                    if ([text isEqualToString:@"0"]) {
//                        return NO;
//                    }
//                    return YES;
//                } else {
//                    NSUInteger textLength = text.length;
//                    NSUInteger length = [self lengthWithCurrency:currency];
//                    NSUInteger subLength = (textLength - zeroRange.location);
//                    if (subLength > length) {
//                        return NO;
//                    }
//                }
//            }
//        }
//    } else {
//        if ([string isEqualToString:@"."]) {
//            return NO;
//        }
//    }
//    return YES;
//}

//- (NSUInteger)lengthWithCurrency:(NSString *)currency
//{
//    NSUInteger length = 100;
//    NSArray *list = [HBConfig queryConfig].currencyList;
//    for (HBCurrency *c in list) {
//        if ([c.currency isEqualToString:currency]) {
//            length = [c.precision integerValue];
//            break;
//        }
//    }
//    return length;
//}

@end
