//
//  HBMoreViewItem.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/16.
//

#import <UIKit/UIKit.h>

@interface HBMoreViewItem : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建一个ICChatBoxMoreViewItem
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 *
 *  @return item
 */
+ (HBMoreViewItem *)createChatBoxMoreItemWithTitle:(NSString *)title
                                                imageName:(NSString *)imageName;

@end
