//
//  HBKeyBoardView.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/13.
//

#import "TGStickerKeyboardView.h"

typedef NS_ENUM(NSInteger, ICChatBoxItem){
    ICChatBoxItemCamera                     =   0,   // Camera （相机）
    ICChatBoxItemAlbum                      =   1,   // Album（相册）
    ICChatBoxItemVideo                      =   2,   // Video（视频）
    ICChatBoxItemRedPackage                 =   3,   //RedPackage(红包)
    ICChatBoxItemPerson                     =   4,   //Person(联系人)
    ICChatBoxItemLocation                   =   5,   //Location(位置)
    ICChatBoxItemDoc                        =   6    // pdf(文件)
};
@class HBKeyBoardView;
@protocol HBKeyBoardViewDelegate<NSObject>

/**
 *  点击更多的类型
 *
 *  @param chatBoxMoreView ICChatBoxMoreView
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(HBKeyBoardView *)chatBoxMoreView didSelectItem:(ICChatBoxItem)itemType;

@end

@interface HBKeyBoardView : TGStickerKeyboardView

@property (nonatomic, weak) id<HBKeyBoardViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;

@end
