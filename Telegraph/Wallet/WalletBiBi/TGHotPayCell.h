//
//  TGHotPayCell.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import <UIKit/UIKit.h>
#import "PayListModel.h"
@interface TGHotPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (nonatomic,strong)PayListModel *model;
@end
