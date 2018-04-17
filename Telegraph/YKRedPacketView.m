#import "YKRedPacketView.h"
#import "TGTextMessageModernViewModel.h"
#import "TGTextMessageBackgroundViewModel.h"
#import "TGModernFlatteningViewModel.h"
#import "TGModernFlatteningView.h"
#import "Masonry.h"
#define  YKScreenWidth [UIScreen mainScreen].bounds.size.width
#define YKScale YKScreenWidth/375

#define FUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface YKRedPacketView(){
    
}

@end
@implementation YKRedPacketView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview];
        
    }
    return  self;
}
-(void)addSubview{
    [self addSubview:self.backgroundView];
    [self addSubview:self.redTitle];
    [self addSubview:self.redProfile];
    [self addSubview:self.redSource];
    [self setupUI];
}
-(void)setupUI{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.redTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25*YKScale);
        make.left.equalTo(self).offset(62*YKScale);
        make.right.equalTo(self).offset(-20*YKScale);
    }];
    [self.redProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50*YKScale);
        make.left.equalTo(self).offset(62*YKScale);
        make.right.equalTo(self).offset(-20*YKScale);
    }];
    [self.redSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3*YKScale);
        make.left.equalTo(self).offset(16*YKScale);
        
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //完成了masonry布局
}
-(UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIImageView new];
        _backgroundView.image = [UIImage imageNamed:@"红包背景"];
        _backgroundView.layer.cornerRadius = 8;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}
-(UILabel *)redTitle{
    if (!_redTitle) {
        _redTitle = [UILabel new];
        _redTitle.text = @"恭喜发财 大吉大利";
        _redTitle.textColor = [UIColor whiteColor];
        _redTitle.font = [UIFont systemFontOfSize:17*YKScale];
        //        [_redTitle sizeToFit];
    }
    return _redTitle;
}
-(UILabel *)redProfile{
    if (!_redProfile) {
        _redProfile = [UILabel new];
        
        _redProfile.text = @"领取红包";
        _redProfile.textColor = [UIColor whiteColor];
        _redProfile.font = [UIFont systemFontOfSize:10*YKScale];
        //        [_redProfile sizeToFit];
    }
    return _redProfile;
}
-(UILabel *)redSource{
    if (!_redSource) {
        _redSource = [UILabel new];
        
        _redSource.text = @"来自冯大爷的红包";
        _redSource.textColor = FUIColorFromRGB(0xbbbbbb);
        _redSource.font = [UIFont systemFontOfSize:11*YKScale];
        //        [_redSource sizeToFit];
    }
    return _redSource;
}




@end
