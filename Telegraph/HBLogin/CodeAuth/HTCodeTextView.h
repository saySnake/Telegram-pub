//
//  HTCodeTextView.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/5/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTCodeTextType) {
    PhoneType = 0,      //全部都有
    GoogleType,  //只有手机验证
    ImageType, //只有google验证
};



@interface HTCodeTextView : UIView

@property (nonatomic, assign) HTCodeTextType   type;
@property (nonatomic, strong) UITextField  *textField;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendBut;
@property (nonatomic, strong) UIImageView *imgView;


@end
