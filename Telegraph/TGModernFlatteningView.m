#import "TGModernFlatteningView.h"

#import <QuartzCore/QuartzCore.h>

#import "TGModernFlatteningViewModel.h"

#import "YKRedPacketView.h"

@interface TGModernFlatteningViewLayer : CALayer

@end

@implementation TGModernFlatteningViewLayer

- (id<CAAction>)actionForKey:(NSString *)event
{
    if ([event isEqualToString:@"contents"])
    {
        return nil;
    }
    return [super actionForKey:event];
}

@end

@interface TGModernFlatteningView ()

@property (nonatomic, strong) NSString *viewIdentifier;
@property (nonatomic, strong) NSString *viewStateIdentifier;

@end

@implementation TGModernFlatteningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = nil;
        self.opaque = false;
    }
    return self;
}

+ (Class)layerClass
{
    return [TGModernFlatteningViewLayer class];
}

- (void)willBecomeRecycled
{
    self.layer.contents = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.specialUserInteraction) {
        UIView *result = nil;
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[TGModernFlatteningView class]]) {
                result = [view hitTest:[self convertPoint:point toView:view] withEvent:event];
            }
            else if ([view isKindOfClass:[YKRedPacketView class]]){
                CGPoint child =[self convertPoint:point toView:self];
                NSLog(@"这是红包view");
                return view;
            }
            else if (view.tag == 0xbeef) {
                result = view;
                break;
            }
        }
        
        if (result.tag == 0xbeef && CGRectContainsPoint([self convertRect:result.bounds fromView:result], point))
            return result;
        
        return nil;
    }
    
    return [super hitTest:point withEvent:event];
}

@end
