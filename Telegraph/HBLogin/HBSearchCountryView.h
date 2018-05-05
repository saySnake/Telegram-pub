//
//  HBSearchCountryView.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import <UIKit/UIKit.h>

@class HBSearchCountryView, HBCountry;

@protocol HBSearchCountryViewDelegate <NSObject>

@optional
- (void)searchCountryView:(HBSearchCountryView *)searchCountryView
            selectCountry:(HBCountry *)country;
- (void)searchCountryView:(HBSearchCountryView *)searchCountryView
      scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface HBSearchCountryView : UIView

@property (nonatomic, weak) id<HBSearchCountryViewDelegate>     delegate;
@property (nonatomic, strong) NSArray                           *list;

@end
