#import "TGBackdropView.h"

#import "LegacyComponentsInternal.h"

@implementation TGBackdropView


#pragma  -- 修改
+ (TGBackdropView *)viewWithLightNavigationBarStyle
{
    TGBackdropView *view = [[TGBackdropView alloc] init];
    view.backgroundColor = UIColorRGBA(0xf7f7f7, 1.0f);
    return view;
}

@end
