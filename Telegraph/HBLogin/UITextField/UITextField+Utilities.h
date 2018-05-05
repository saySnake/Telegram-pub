//
//  UITextField+Utilities.h
//  newbi
//
//  Created by 张锐 on 2017/9/1.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utilities)

- (void)setPlaceholderColor:(UIColor *)color;

- (void)setPlaceholder:(NSString *)placeholder
      placeholderColor:(UIColor *)placeholderColor
              fontSize:(CGFloat)fontSize;

- (BOOL)text:(NSString *)text
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string
        currency:(NSString *)currency;

@end
