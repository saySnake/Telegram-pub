//
//  HTCodeAuthView.h
//  Telegraph
//
//  Created by Jiyu Jiyu on 2018/5/2.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTCodeViewType) {
    AllPhoneGoogleImage = 0,      //全部都有
    OnlyPhone,  //只有手机验证
    OnlyGoogle, //只有google验证
    OnlyImage, //只有图片验证
    BothPhoneGoogle, //手机和google
    BothImageGoogle //图片和google
};

@interface HTCodeAuthView : UIView

//+(instancetype)HTCodeViewWithType:(HTCodeViewType)codeViewType WithFrame:(CGRect)frame;

@property (nonatomic, assign) HTCodeViewType     type;

@end
