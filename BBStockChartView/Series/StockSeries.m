//
//  StockSeries.m
//  BBChart
//
//  Created by ChenXiaoyu on 15/1/8.
//  Copyright (c) 2015年 ChenXiaoyu. All rights reserved.
//

#import "StockSeries.h"
#import "BBTheme.h"

@implementation StockSeriesPoint

@end
@implementation StockSeries

- (void)addPointOpen:(CGFloat)o close:(CGFloat)c low:(CGFloat)l high:(CGFloat)h{
    StockSeriesPoint * p = [[StockSeriesPoint alloc] init];
    p.open = o;
    p.close = c;
    p.high = h;
    p.low = l;
    [self.data addObject:p];
}


- (void)prepareForDraw{
    self.axisAttached.touchBottom = YES;
    for (StockSeriesPoint* n in self.data) {
        [self.axisAttached addContainingVal:n.high];
        [self.axisAttached addContainingVal:n.low];
    }
    
}

- (void)drawPoint:(NSUInteger)idx animated:(BOOL)animated{
    if (idx >= self.data.count) {
        return;
    }
    
    StockSeriesPoint *point = (StockSeriesPoint *)(self.data[idx]);
    UIColor *color = nil;
    BOOL isFall = point.open > point.close;
    if (isFall) {
        color = [BBTheme theme].fallColor;
    } else {
        color = [BBTheme theme].riseColor;
    }
    
    CGFloat height = self.bounds.size.height;
    
    CGFloat x = idx * self.pointWidth + self.pointWidth / 2;
    CGFloat y1 = height - [self.axisAttached heighForVal:point.high];
    CGFloat y2 = height - [self.axisAttached heighForVal:point.low];
    CGFloat y3 = height - [self.axisAttached heighForVal:isFall ? point.open : point.close];
    CGFloat y4 = height - [self.axisAttached heighForVal:isFall ? point.close : point.open];

    CALayer *lht = [BaseLayer layerOfLineFrom:CGPointZero to:CGPointMake(0, y1-y3) withColor:color andWidth:1 fill:NO];
    lht.position = CGPointMake(x, y3);
    
    CALayer *lhb = [BaseLayer layerOfLineFrom:CGPointZero to:CGPointMake(0, y4-y2) withColor:color andWidth:1 fill:NO];
    lhb.position = CGPointMake(x, y2);
    
    if (isFall) {
        y1 = height - [self.axisAttached heighForVal:point.open];
        y2 = height - [self.axisAttached heighForVal:point.close];
    }else{
        y1 = height - [self.axisAttached heighForVal:point.close];
        y2 = height - [self.axisAttached heighForVal:point.open];
    }
    
    CGFloat ocWidth = 8;
    if (self.pointWidth <= ocWidth+2) {
        ocWidth = self.pointWidth - 2;
    }
    CALayer* oc = [BaseLayer layerOfRectFrom:CGPointZero to:CGPointMake(0, y1-y2) withColor:color andWidth:ocWidth fill:isFall];
    oc.position = CGPointMake(x, y2);
    
    [self addSublayer:lht];
    [self addSublayer:lhb];
    [self addSublayer:oc];
    
    if (animated) {
        CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        ani.fromValue = [NSNumber numberWithFloat:0];
        ani.toValue = [NSNumber numberWithFloat:1.0];
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        ani.duration = 1;
        
        [oc addAnimation:ani forKey:nil];
        [lht addAnimation:ani forKey:nil];
        [lhb addAnimation:ani forKey:nil];
    }
    
}

@end
