#import "YKRedPacketView.h"
#import "TGTextMessageModernViewModel.h"
#import "TGTextMessageBackgroundViewModel.h"
#import "TGModernFlatteningViewModel.h"
#import "TGModernFlatteningView.h"
#import "Masonry.h"

#import "TGModernCollectionCell.h"
#import "TGMessageModernConversationItem.h"
#import <LegacyComponents/LegacyComponents.h>
#import "WSRedPacketView.h"
#import "TGTelegraph.h"

#import <LegacyComponents/TGDataResource.h>


#import <LegacyComponents/TGImageManager.h>

#import <LegacyComponents/UIImage+TG.h>
#import "TGUserInfoCollectionItemView.h"
#import "RedContentVC.h"


#define  YKScreenWidth [UIScreen mainScreen].bounds.size.width
#define YKScale YKScreenWidth/375

#define FUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface YKRedPacketView(){
    
    TGLetteredAvatarView *_avatarView;

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
//        _redProfile.text = @"领取红包";
        _redProfile.textColor = [UIColor whiteColor];
        _redProfile.font = [UIFont systemFontOfSize:10*YKScale];
        //        [_redProfile sizeToFit];
    }
    return _redProfile;
}
-(UILabel *)redSource{
    if (!_redSource) {
        _redSource = [UILabel new];
//        _redSource.text = @"来自冯大爷的红包";
        _redSource.textColor = FUIColorFromRGB(0xbbbbbb);
        _redSource.font = [UIFont systemFontOfSize:11*YKScale];
        //        [_redSource sizeToFit];
    }
    return _redSource;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    TGModernCollectionCell *cell=(TGModernCollectionCell *)self.superview.superview.superview;
    TGMessageModernConversationItem *item=(TGMessageModernConversationItem *)cell.boundItem;
    
    NSString *link=item->_message.text;
    int64_t  fromuid =item->_message.fromUid;
    int64_t toud =item->_message.toUid;
    int64_t cid =item->_message.cid;
    CGPoint currentpoint=[touches.anyObject locationInView:self];
    BOOL ispoint =CGRectContainsPoint(self.bounds,currentpoint);
    if (ispoint ) {
        int clid =TGTelegraphInstance.clientUserId;
//        int clientUserId = TGTelegraphInstance.clientUserId;
        if (toud ==cid) {
            //自己红包
            WSRewardConfig *info = ({
                WSRewardConfig *info   = [[WSRewardConfig alloc] init];
                info.money             = 100.0;
            TGUser *user = [[TGDatabase instance] loadUser:(int32_t)toud];
                [self setAvatarUri:user.photoUrlSmall id:toud info:info];
                info.content = @"恭喜发财，吉祥如意";
                info.userName  = @"小雨同学";
                info;
            });
            
            //实现
            [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
                NSLog(@"取消领取");
            } finishBlock:^(float money) {
                NSLog(@"领取金额：%f",money);
                RedPackType type ;
                self.block(RedPackOutTime);
            }];
        }
        else{
            //别人红包
            TGUser *user = [[TGDatabase instance] loadUser:(int32_t)fromuid];
            WSRewardConfig *info = ({
                WSRewardConfig *info   = [[WSRewardConfig alloc] init];
                info.money         = 100.0;
                TGUserInfoCollectionItemView *item =[[TGUserInfoCollectionItemView alloc]init];
//                info.avatarImage    = [UIImage imageNamed:user.photoUrlSmall];
                info.content = @"恭喜发财，吉祥如意";
                info.userName  = @"小雨同学";
                info;
            });
            //实现
            [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
                NSLog(@"取消领取");
            } finishBlock:^(float money) {
                NSLog(@"领取金额：%f",money);
//                RedPackType type ;
                self.block(RedPackOutTime);
                
                
            }];
        };
    }
}



- (void)setAvatarUri:(NSString *)avatarUri id:(int)Id info:(WSRewardConfig *)info
{
    static UIImage *placeholder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      //!placeholder
                      UIGraphicsBeginImageContextWithOptions(CGSizeMake(64.0f, 64.0f), false, 0.0f);
                      CGContextRef context = UIGraphicsGetCurrentContext();
                      
                      CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                      CGContextFillEllipseInRect(context, CGRectMake(0.0f, 0.0f, 64.0f, 64.0f));
                      CGContextSetStrokeColorWithColor(context, UIColorRGB(0xd9d9d9).CGColor);
                      CGContextSetLineWidth(context, 1.0f);
                      CGContextStrokeEllipseInRect(context, CGRectMake(0.5f, 0.5f, 63.0f, 63.0f));
                      
                      placeholder = UIGraphicsGetImageFromCurrentImageContext();
                      UIGraphicsEndImageContext();
                  });
    
    UIImage *currentPlaceholder = [_avatarView currentImage];
    if (currentPlaceholder == nil)
        currentPlaceholder = placeholder;
    
    if (avatarUri.length == 0)
    {
        TGUser *user =[TGDatabaseInstance() loadUser:Id];
        NSString *firstName =user.firstName;
        NSString *lastName =user.lastName;
        [info._avatarView loadUserPlaceholderWithSize:CGSizeMake(64.0f, 64.0f) uid:490906464 firstName:firstName lastName:lastName placeholder:placeholder];
    }
    else if (!TGStringCompare([_avatarView currentUrl], avatarUri))
    {
        info._avatarView.fadeTransitionDuration = 0.3;
        info._avatarView.contentHints =  TGRemoteImageContentHintLoadFromDiskSynchronously;
        [info._avatarView loadImage:avatarUri filter:@"circle:64x64" placeholder:currentPlaceholder forceFade:NO];
    }
}




@end
