//
//  HBCodeScan.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/2.
//

#import "HBCodeScan.h"
#import <AVFoundation/AVFoundation.h>

@interface HBCodeScan()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
@end

@implementation HBCodeScan
{
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    
    dispatch_queue_t _sessionQueue;
}


+ (instancetype)scanViewWithResultHandler:(void (^)(NSString *))resultHandler
{
    HBCodeScan *scanView = [[HBCodeScan alloc] init];
    [scanView setResultHandler:resultHandler];
    return scanView;
}

+ (NSString *)scanQRCodeInPicture:(UIImage *)image
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:ciImage];
    CIQRCodeFeature *feature = features.firstObject;
    return feature.messageString;
}

- (void)commonInit
{
    _captureSession = [[AVCaptureSession alloc] init];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.layer addSublayer:_previewLayer];
    
    _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

//只会在IB中执行, 不影响实际运行
- (void)prepareForInterfaceBuilder
{
    //    UIImage *image = [UIImage imageNamed:@"QR_Code.jpg"
    //                                inBundle:[NSBundle bundleForClass:[self class]]
    //           compatibleWithTraitCollection:self.traitCollection];
    //    self.layer.contents = (id)image.CGImage;
    self.backgroundColor = [UIColor orangeColor];
}

- (void)layoutSubviews
{
    _previewLayer.frame = self.bounds;
}

- (BOOL)startScan
{
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"请在设置-隐私-相机中允许访问相机。"
                                   delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input) {
        return NO;
    }
    
    if (![_captureSession canAddInput:input]) {   //容错处理 防止startScan 被多次调用
        [_captureSession removeInput:_input];
        [_captureSession removeOutput:_output];
    }
    _input = input;
    [_captureSession addInput:_input];
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:_output];
    
    //output 和 input 都添加到session中才可以获取avaliableType
    for (NSString *type in [_output availableMetadataObjectTypes]) {
        if (type == AVMetadataObjectTypeQRCode) {  //可以直接比较地址
            [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        }
    }
    //在主线程中回调
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if (self.presetLevel) {
        _captureSession.sessionPreset = self.presetLevel;
    }
    
    dispatch_async(_sessionQueue, ^{
        [_captureSession  startRunning];
    });
    
    return YES;
}

- (void)stopScan
{
    dispatch_async(_sessionQueue, ^{
        [_captureSession stopRunning];
        [_captureSession removeInput:_input];
        [_captureSession removeOutput:_output];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count]) {
        
        [_captureSession stopRunning];
        [_captureSession removeInput:_input];
        [_captureSession removeOutput:_output];
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        _result = metadataObj.stringValue;
        if (_resultHandler) {
            _resultHandler(_result);
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else {
        _result = nil;
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_denyHandler) {
        _denyHandler();
    }
}

@end
