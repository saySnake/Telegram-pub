//
//  YJActionSheet.h
//  DrLink_IOS
//
//  Created by liuwenjie on 15/7/2.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionSheetClicked)(NSInteger index);

@class YJActionSheet;

@protocol YJActionSheetDelegate<NSObject>

@optional

-(void)actionSheet:(YJActionSheet *)actionSheet clickedBtnAtIndex:(NSInteger)buttonIndex;

@end

@interface YJActionSheet : UIView
{
    NSMutableArray *_buttons;
    UIView *_actionView;
}

@property (nonatomic, weak) id<YJActionSheetDelegate> yjDelegate;

@property (nonatomic, copy) ActionSheetClicked block;

@property (nonatomic, copy) NSString *actionTitle;

-(instancetype)initWithTitle:(NSString *)title
                    delegate:(id<YJActionSheetDelegate>)delegate
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles;

-(instancetype)initWithLiteActionBtns:(NSArray *)buttons
                         clickedIndex:(ActionSheetClicked)block;


-(void)show;

@end
