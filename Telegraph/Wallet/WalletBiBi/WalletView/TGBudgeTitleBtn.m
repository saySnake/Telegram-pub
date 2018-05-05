//
//  TGBudgeTitleBtn.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/1.
//

#import "TGBudgeTitleBtn.h"

@implementation TGBudgeTitleBtn


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.width - 7.5;
    return CGRectMake(0, 0, w, self.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = self.width - 25;
    return CGRectMake(x, (self.height-4.5)/2, 7.5, 4.5);
}


@end
