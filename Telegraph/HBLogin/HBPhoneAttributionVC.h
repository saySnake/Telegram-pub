//
//  HBPhoneAttributionVC.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import <UIKit/UIKit.h>

@class HBPhoneAttributionVC, HBCountry;

@protocol HBPhoneAttributionVCDelegate <NSObject>

@optional
- (void)phoneAttributionVC:(HBPhoneAttributionVC *)phoneAttributionVC selectCountry:(HBCountry *)country;

@end


@interface HBPhoneAttributionVC : UIViewController

@property (nonatomic, weak) id<HBPhoneAttributionVCDelegate> delegate;

@end
