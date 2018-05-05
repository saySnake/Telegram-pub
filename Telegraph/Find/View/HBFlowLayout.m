//
//  HBFlowLayout.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBFlowLayout.h"

@implementation HBFlowLayout


-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //proposedContentOffset是没有设置对齐时本应该停下的位置（collectionView落在屏幕左上角的点坐标）
    CGFloat offsetAdjustment = MAXFLOAT;//初始化调整距离为无限大
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);//collectionView落在屏幕中点的x坐标
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);//collectionView落在屏幕的大小
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];//获得落在屏幕的所有cell的属性
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    //调整
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

/** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
static CGFloat const ActiveDistance = 30;
/** 缩放因素: 值越大, item就会越大 */
static CGFloat const ScaleFactor = 0.06;
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    //遍历所有布局属性
    for (UICollectionViewLayoutAttributes* attributes in array) {
        //如果cell在屏幕上则进行缩放
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//距离中点的距离
            CGFloat normalizedDistance = distance / ActiveDistance;
            if (ABS(distance) < ActiveDistance) {
                CGFloat zoom = 1 + ScaleFactor*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
