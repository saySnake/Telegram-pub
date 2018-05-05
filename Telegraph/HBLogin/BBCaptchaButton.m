//
//  BBCaptchaButton.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/24.
//
#import "BBCaptchaButton.h"



@interface BBCaptchaButton ()
/** 控制倒计时的timer */
@property (nonatomic, strong) NSTimer   * timer;
/** 按钮点击事件的回调 */
@property (nonatomic, copy) void (^buttonClickedBlock)(void);
/** 倒计时开始时的回调 */
@property (nonatomic, copy) void (^countDownStartBlock)(void);
/** 倒计时进行中的回调（每秒一次） */
@property (nonatomic, copy) void (^countDownUnderwayBlock)(NSInteger restCountDownNum);
/** 倒计时完成时的回调 */
@property (nonatomic, copy) void (^countDownCompletionBlock)(void);
@end

@implementation BBCaptchaButton {
    /** 倒计时开始值 */
    NSInteger _startCountDownNum;
    /** 剩余倒计时的值 */
    NSInteger _restCountDownNum;
}

/**
 构造方法
 
 @param duration            倒计时时间
 @param buttonClicked       按钮点击事件的回调
 @param countDownStart      倒计时开始时的回调
 @param countDownUnderway   倒计时进行中的回调（每秒一次）
 @param countDownCompletion 倒计时完成时的回调
 @return 倒计时button
 */
- (instancetype)initWithDuration:(NSInteger)duration
                   buttonClicked:(void(^)(void))buttonClicked
                  countDownStart:(void(^)(void))countDownStart
               countDownUnderway:(void(^)(NSInteger restCountDownNum))countDownUnderway
             countDownCompletion:(void(^)(void))countDownCompletion
{
    
    if (self = [super init]) {
        _startCountDownNum            = duration;
        self.buttonClickedBlock       = buttonClicked;
        self.countDownStartBlock      = countDownStart;
        self.countDownUnderwayBlock   = countDownUnderway;
        self.countDownCompletionBlock = countDownCompletion;
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/** 按钮点击 */
- (void)buttonClicked:(BBCaptchaButton *)sender {
    sender.enabled = NO;
    self.buttonClickedBlock();
}

/** 开始倒计时 */
- (void)startCountDown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _restCountDownNum = _startCountDownNum;
    !self.countDownStartBlock ?: self.countDownStartBlock(); // 调用倒计时开始的block
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshButton) userInfo:nil repeats:YES];
}

/** 刷新按钮内容 */
- (void)refreshButton {
    _restCountDownNum --;
    self.countDownUnderwayBlock(_restCountDownNum); // 调用倒计时进行中的回调
    if (_restCountDownNum == 0) {
        [self.timer invalidate];
        self.timer = nil;
        _restCountDownNum = _startCountDownNum;
        !self.countDownCompletionBlock ?: self.countDownCompletionBlock(); // 调用倒计时完成的回调
        self.enabled = YES;
    }
}

/** 结束倒计时 */
- (void)endCountDown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.enabled = YES;
    !self.countDownCompletionBlock ?: self.countDownCompletionBlock();
}


- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        _timer = nil;
    }
    NSLog(@"倒计时按钮已释放");
}
@end


