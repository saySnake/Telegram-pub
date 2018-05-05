//
//  HBTextUtil.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBTextUtil.h"

@implementation HBTextUtil
+ (CGSize)getTxtSize:(NSString *)txt font:(UIFont *)font
{
    CGSize size = [txt sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize;
}

+(CGSize)getTextHeight:(NSString *)content font:(UIFont *)font width:(CGFloat)aWidth maxHeight:(CGFloat)maxHeight
{
    CGSize size = CGSizeZero;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size =[content boundingRectWithSize:CGSizeMake(aWidth, maxHeight) // 用于计算文本绘制时占据的矩形块
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  // 文本绘制时的附加选项
                             attributes:attribute        // 文字的属性
                                context:nil].size;
    
    if (size.width > aWidth) {
        size.width = aWidth;
    }
    
    return size;
}

@end
