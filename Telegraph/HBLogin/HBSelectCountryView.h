//
//  HBSelectCountryView.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/20.
//

#import <UIKit/UIKit.h>

@class HBSelectCountryView;

@protocol HBSelectCountryViewDelegate <NSObject>

@optional
- (void)selectCountryView:(HBSelectCountryView *)selectCountryView
            selectCountry:(NSString *)country;

@end

@interface HBSelectCountryView : UIView

@property (nonatomic, weak) id<HBSelectCountryViewDelegate> delegate;
@property (nonatomic, copy) NSString                        *country;

@end
