//
//  HBScanPayViewController.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/2.
//

#import "BaseViewController.h"

@interface HBScanPayViewController : UIViewController
@property (nonatomic, copy) NSString * result;

@property (nonatomic, copy) void(^logBillBlock)(NSString *);

@property (nonatomic, weak) UIViewController *lastViewController;
@end
