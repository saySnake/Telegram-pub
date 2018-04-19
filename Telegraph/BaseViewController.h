//
//  BaseViewController.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/19.
//

#import <UIKit/UIKit.h>
#import "CustNavBar.h"

#import "BaseViewController.h"

/**
 模态弹出控制器时的标志
 */
extern void *const isModelPresent;
/**
 导航栏按钮样式
 */
typedef NS_ENUM(NSInteger, NavBarBtnStyle) {
    NavBarBtnStyleDone, //完成
    NavBarBtnStyleEdit, //编辑
    NavBarBtnStyleSave, //保存
    NavBarBtnStyleCancle,   //取消
    NavBarBtnStyleSure, //确定
    NavBarBtnStyleApplyAdmin,   //申请管理员
    NavBarBtnStylePublicNotice, //发布公告
    NavBarBtnStyleNextStep, //下一步
    NavBarBtnStyleAdd,  //添加
    NavBarBtnStyleSend, //发送
    NavBarBtnStyleInvitate, //邀请
    NavBarBtnStyleNone, //none
    NavBarBtnStyleSearch,   //搜索
    NavBarBtnStyleSort, //排班
    NavBarBtnStyleClear,    //清除
    NavBarBtnStyleContactAdmin, //联系管理员
    NavBarBtnStyleApplyRelease, //申请发布
    NavBarBtnStyleApplyColumn,   /**< 申请专栏 */
    NavBarBtnStyleMyColumn,      /**< 我的专栏 */
    NavBarBtnStyleAlbum, //相册
    NavBarBtnStylePost, //发起 (投票)
    NavBarBtnStyleDelete,  /**< 删除 */
    NavBarBtnStyleModify,  /**< 修改 */
};
@interface BaseViewController : UIViewController
/**
 导航栏
 */
@property(nonatomic,strong)CustNavBar *navBar;
/**
 导航栏右边按钮
 */
@property(nonatomic,strong,readonly)UIButton *rightBtn;
/**
 导航栏左边按钮
 */
@property(nonatomic,strong,readonly)UIButton *leftBtn;

@property (nonatomic, strong) void (^viewDidLoadAppear)();
@property (nonatomic, strong) void (^viewDidDispose)();

//@property (nonatomic) BOOL isOpenTapCloseKeyBoard;
/**
 导航栏左边按钮的hidden
 */
@property (nonatomic) BOOL leftBackItemHiden;
/**
 初始化一个导航栏
 */
-(void)setNavBarVisible:(NSString *)title;
/**
 给已有导航栏设置右边按钮的图片
 */

-(void)setRightBtnImage:(NSString *)image;
/**
 给已有导航栏设置右边按钮的样式
 目前自定义了集中常用的
 如果没有则自行扩展
 */

-(void)setRightBtnStyle:(NavBarBtnStyle)style;

/**
 给已有导航栏设置左边按钮的图片
 */
-(void)setLeftBtnImage:(NSString *)image;
/**
 给已有导航栏设置左边按钮的样式
 目前自定义了集中常用的
 如果没有则自行扩展
 */
-(void)setLeftBtnStyle:(NavBarBtnStyle)style;

/**
 给已有的导航栏设置标题
 */
-(void)setNavBarTitle:(NSString *)title;



/**
 自定义导航栏返回和最右边按钮点击事件
 如果保持pop或dismiss 需要在重写时调用super
 */
-(void)navBarButtonClick:(NSInteger )idx;
/**
 自定义导航栏标题点击事件
 */
-(void)navBarTitleClick:(UIButton *)button;

/**
 当没有数据时显示在空白页面上的标签
 */
-(void)showNotData:(NSString *)label;
/**
 移除没有数据的标签
 */
-(void)removeNotData;

/**
 显示一个普通的YJAlertView,没有事件回调
 */
-(void)showYJAlert:(NSString *)msg;
/**
 显示一个用户没有审核过自定义YJAlertView
 */
-(void)showUnAuthAlert;

/**
 显示一个普通的UIAlertView,没有事件回调
 */
void showNormalAlert(NSString *msg);

/**
 所有职称
 */

NSArray *allJobTitle();
/**
 push 到小秘书
 */
-(void)pushXiaoMiShu;


@end
