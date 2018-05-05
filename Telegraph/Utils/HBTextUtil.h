//
//  HBTextUtil.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import <Foundation/Foundation.h>

@interface HBTextUtil : NSObject
+ (CGSize)getTxtSize:(NSString *)txt font:(UIFont *)font;
+(CGSize)getTextHeight:(NSString *)content font:(UIFont *)font width:(CGFloat)aWidth maxHeight:(CGFloat)maxHeight;
@end
