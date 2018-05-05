//
//  HBFindAvatarScrollView.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBFindAvatarScrollView.h"

@implementation HBFindAvatarScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
    }
    
    return self;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 32, 32)];
        _mainImageView.contentMode = UIViewContentModeScaleToFill;
        _mainImageView.layer.cornerRadius = 17;
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.userInteractionEnabled = YES;
        
    }
    return _mainImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
