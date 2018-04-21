//
//  RedListViewCell.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import <UIKit/UIKit.h>
#import "ReceRedModel.h"

@interface RedListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic)  ReceRedModel *model;

@end
