//
//  HBCodeScan.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/2.
//

#import <UIKit/UIKit.h>

@interface HBCodeScan : UIControl
@property (nonatomic, copy) void (^resultHandler)(NSString *result);

@property (nonatomic, copy) void (^denyHandler)();

//扫描精度 AVCaptureSessionPreset
@property (nonatomic, copy) NSString *presetLevel;

@property (nonatomic, readonly) NSString *result;

+ (instancetype)scanViewWithResultHandler:(void (^)(NSString *result))resultHandler;

//扫描图片中的二维码 iOS8以上才支持
+ (NSString *)scanQRCodeInPicture:(UIImage *)image;

- (BOOL)startScan;

- (void)stopScan;

@end
