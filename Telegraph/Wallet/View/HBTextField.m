//
//  HBTextField.m
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import "HBTextField.h"

@implementation HBTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGRect)textRectForBounds:(CGRect)bounds {

return CGRectInset( bounds , 10 , 0 );
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    return CGRectInset( bounds , 10 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect rect = bounds;
    rect.size.width -= 25;
    return CGRectInset( rect , 10 , 0 );
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    
    
    [UIColorRGB(179) setFill];
    //    [[self placeholder] drawInRect:rect withFont:GetFont(16.0)];
    [super drawPlaceholderInRect:rect];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super clearButtonRectForBounds:bounds];
    rect.origin.x -= 5;
    return rect;
}

@end
