//
//  YKUntil.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/17.
//

#import "YKUntil.h"
#define redPacketUrl @"https://www.biyong.info/redpacket.html"

@implementation YKUntil
//是不是红包
+ (BOOL)linkRedPacketText:(NSString *)text
{
    if (text == nil) {
        return NO;
    }
    NSString *lowercaseText = [text lowercaseString];
    if ([lowercaseText rangeOfString:redPacketUrl].location == NSNotFound)
    {
        return NO;
    }
    return YES;
}


//view转换成image (获取对方头像)仅限单聊
+(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
