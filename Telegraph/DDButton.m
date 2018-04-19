//
//  DDButton.m
//  DDBuyMedicine
//
//  Created by 柳文杰 on 15/3/16.
//  Copyright (c) 2015年 柳文杰. All rights reserved.
//

#import "DDButton.h"


@interface DDButton()
@end
@implementation DDButton
-(instancetype)initWithImageFrame:(CGRect)iframe{
    _imgFrame=iframe;
    if (self=[super init]) {

    }
    return self;
}
-(instancetype)initWithTitleFrame:(CGRect)tframe{
    _titFrame=tframe;
    if (self=[super init]) {
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.numberOfLines=0;

    }
    return self;

}
-(instancetype)initWithImageFrame:(CGRect)iframe withTitleFrame:(CGRect)tframe{
    _titFrame=tframe;
    _imgFrame=iframe;
    if (self=[super init]) {
        self.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=kFontNormal;
        self.titleLabel.numberOfLines=0;
    }
    return self;
    
}
-(instancetype)initWithStyle:(DDButtonSubviewLayoutStyle)style{
    if (self=[super init]) {
        self.subviewLayoutStyle=style;
    }
    return self;
}
-(void)setImageViewSize:(CGSize)imageViewSize{
    _imageViewSize=imageViewSize;
}
-(void)setSubviewLayoutStyle:(NSInteger)subviewLayoutStyle{
    _subviewLayoutStyle=subviewLayoutStyle;
}
-(void)setImageInsets:(UIEdgeInsets)imageInsets{
    _imageInsets=imageInsets;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment=self.textAlignment;
    self.titleLabel.numberOfLines=0;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    switch (_subviewLayoutStyle) {
//        case DDButtonSubviewLayoutStyleHorizontal:
//        {
//           
//        }
//            break;
//        case DDButtonSubviewLayoutStyleHorizontalReverse:{
//            
//        }
//            break;
//        case DDButtonSubviewLayoutStyleVertical:{
//            
//        }
//            break;
//        case DDButtonSubviewLayoutStyleVerticalReverse:{
//            
//        }
//            break;
//    }
    return _imgFrame;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return _titFrame;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    //CGSize size=[title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    //_titFrame.size.width=size.width+20;
    [super setTitle:title forState:state];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
}

-(void)startAnimation{
    
}
-(void)stopAnimation{
    
}
@end






