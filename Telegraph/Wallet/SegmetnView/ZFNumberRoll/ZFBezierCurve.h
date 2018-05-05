//
//  ZFBezierCurve.h
//  LefenStore1.0
//
//  Created by Young on 16/3/14.
//  Copyright © 2016年 lefen58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    float x;
    float y;
} Point2D;

@interface ZFBezierCurve : NSObject

Point2D PointOnCubicBezier(Point2D* cp, float t);

@end
