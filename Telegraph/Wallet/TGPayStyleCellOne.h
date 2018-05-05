//
//  TGPayStyleCell.h
//  Telegraph
//
//  Created by 张玮 on 2018/5/3.
//

#import <UIKit/UIKit.h>

@interface TGPayStyleCellOne : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *coin;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *frozen;
@property (weak, nonatomic) IBOutlet UILabel *frozenCount;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;

@end
