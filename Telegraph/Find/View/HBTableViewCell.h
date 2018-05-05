//
//  HBTableViewCell.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import <UIKit/UIKit.h>
@interface HBTableViewCell : UITableViewCell
{
    UILabel     *sepTop;//分割线
    UILabel     *sepBottom;//短
    UILabel     *sepBottom2;//长
    UIImageView *_arrow;//箭头
}

/**
 *  设置分割线是否显示
 *
 *  @param first  顶部分割线
 *  @param middle 底部短分割线
 *  @param last   底部长分割线
 */
- (void)setSeparator:(BOOL)first middle:(BOOL)middle last:(BOOL)last;
/**
 *  设置右侧箭头是否显示
 *
 *  @param arrow 详情箭头
 */
- (void)setArrow:(BOOL)arrow;


@end
