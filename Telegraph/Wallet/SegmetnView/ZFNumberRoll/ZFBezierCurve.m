//
//  ZFBezierCurve.m
//  LefenStore1.0
//
//  Created by Young on 16/3/14.
//  Copyright © 2016年 lefen58.com. All rights reserved.
//

#import "ZFBezierCurve.h"

@implementation ZFBezierCurve

Point2D PointOnCubicBezier( Point2D* cp, float t ) {
    //    x = (1-t)^3 *x0 + 3*t*(1-t)^2 *x1 + 3*t^2*(1-t) *x2 + t^3 *x3
    //    y = (1-t)^3 *y0 + 3*t*(1-t)^2 *y1 + 3*t^2*(1-t) *y2 + t^3 *y3
    float   ax, bx, cx;
    float   ay, by, cy;
    float   tSquared, tCubed;
    Point2D result;
    
    /*計算多項式係數*/
    
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
    
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
    
    /*計算位於參數值t的曲線點*/
    
    tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
    
    return result;
}


@end
