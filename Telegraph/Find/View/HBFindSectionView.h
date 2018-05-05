//
//  HBFindSectionView.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import <UIKit/UIKit.h>

@interface HBFindSectionView : UIView
@property(nonatomic,strong) UILabel *namelab;
@property(nonatomic,strong) UILabel *txtlab;

-(void)setTitle:(NSString *)title more:(NSString *)more;
@end
