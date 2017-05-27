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

@interface StockSeries ()

@property (nonatomic, strong) CALayer   *focusLineX;
@property (nonatomic, strong) CALayer   *focusLineY;
@property (nonatomic, strong) CATextLayer   *priceLabel;
@property (nonatomic, strong) CALayer   *priceBackgroundLayer;

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

- (NSUInteger)indexOfPoint:(CGPoint)point drawLine:(BOOL)drawLine {
    CGFloat fidx = floor((point.x - self.pointWidth / 2) / self.pointWidth);
    fidx = fidx < 0 ? 0 : fidx;
    NSUInteger idx = (NSUInteger)fidx;
    
    if (self.focusLineX) {
        [self.focusLineX removeFromSuperlayer];
        self.focusLineX = nil;
    }
    
    if (self.focusLineY) {
        [self.focusLineY removeFromSuperlayer];
        self.focusLineY = nil;
    }
    
    if (self.priceLabel) {
        [self.priceLabel removeFromSuperlayer];
        self.priceLabel = nil;
    }
    
    if (self.priceBackgroundLayer) {
        [self.priceBackgroundLayer removeFromSuperlayer];
        self.priceBackgroundLayer = nil;
    }
    
    if (drawLine) {
        CGFloat x = idx * self.pointWidth + self.pointWidth / 2;
        CGFloat y = point.y;
        self.focusLineX = [BaseLayer layerOfLineFrom:CGPointMake(0, 0) to:CGPointMake(0, self.bounds.size.height + 0.5) withColor:UIColor.whiteColor andWidth:0.5];
        self.focusLineX.position = CGPointMake(x, 0.5);
        [self addSublayer:self.focusLineX];
        
        self.focusLineY = [BaseLayer layerOfLineFrom:CGPointMake(0, 0) to:CGPointMake(self.bounds.size.width + 2, 0) withColor:UIColor.whiteColor andWidth:0.5];
        self.focusLineY.position = CGPointMake(-2, y);
        [self addSublayer:self.focusLineY];
        
        self.priceBackgroundLayer = [BaseLayer layerOfRectFrom:CGPointZero to:CGPointMake(0, 20) withColor:[UIColor.whiteColor colorWithAlphaComponent:0.3] andWidth:48 fill:YES];
        self.priceBackgroundLayer.position = CGPointMake(-26, y - 10);
        [self addSublayer:self.priceBackgroundLayer];
        
        self.priceLabel = [BaseLayer layerOfText:[NSString stringWithFormat:@"%.1f", [self.axisAttached valForHeigth:self.bounds.size.height - y]] withFont:[BBTheme theme].fontName fontSize:[BBTheme theme].yAxisFontSize andColor:[BBTheme theme].axisColor];
        self.priceLabel.alignmentMode = kCAAlignmentRight;
        self.priceLabel.bounds = CGRectMake(0, 0, 45, 20);
        self.priceLabel.position = CGPointMake(-34, y + 4);
        [self addSublayer:self.priceLabel];
    }
    
    return idx;
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

    CALayer *lht = [BaseLayer layerOfLineFrom:CGPointZero to:CGPointMake(0, y1-y3) withColor:color andWidth:1];
    lht.position = CGPointMake(x, y3);
    
    CALayer *lhb = [BaseLayer layerOfLineFrom:CGPointZero to:CGPointMake(0, y4-y2) withColor:color andWidth:1];
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
