//
//  UILabel+Utilities.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/20.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utilities)

- (CGSize)textSize;
//根据宽高获取对应高宽
- (CGFloat)textWidthWithHeight:(CGFloat)height;
- (CGFloat)textHeightWithWidth:(CGFloat)width;

@end
