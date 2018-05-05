//
//  UILabel+Utilities.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/20.
//

#import "UILabel+Utilities.h"

@implementation UILabel (Utilities)

- (CGSize)textSize
{
    return [self sizeWithText:self.text
                         font:self.font
                         size:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (CGFloat)textHeightWithWidth:(CGFloat)width
{
    return [self sizeWithText:self.text
                         font:self.font
                         size:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGFloat)textWidthWithHeight:(CGFloat)height
{
    return [self sizeWithText:self.text
                         font:self.font
                         size:CGSizeMake(MAXFLOAT, height)].width;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    return [text boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

@end
