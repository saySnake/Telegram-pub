//
//  TGPayStyleCell.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import <UIKit/UIKit.h>
#import "PayStyleModel.h"


@interface TGPayStyleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameCoin;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *flozen;
@property (strong, nonatomic)  PayStyleModel *model;

@end
