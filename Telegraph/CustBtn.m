//
//  CustBtn.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/8.
//

#import "CustBtn.h"
#define Radio 0.7


@implementation CustBtn


- (instancetype)init
{
    self =[super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textAlignment =1;
        
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
         CGFloat W = contentRect.size.width;
         CGFloat H = 20;
         CGFloat y = contentRect.size.height - H;
         return CGRectMake(0, y, W, H);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat w =contentRect.size.width;
    CGFloat h =contentRect.size.height -20;
    return CGRectMake(0, 0, w, h);
}


@end
