//
//  HBPhoneAttributionCell.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import <UIKit/UIKit.h>
#import "HBCountry.h"
@interface HBPhoneAttributionCell : UITableViewCell

@property (nonatomic,strong)HBCountry *CoutryMod;

@property (nonatomic,strong)UILabel *coutryLab;//消息类型的 label
@property (nonatomic,strong)UILabel *codeLbel;// 时间的 label

@end
