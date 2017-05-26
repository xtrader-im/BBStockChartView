//
//  BarSeries.m
//  BBChart
//
//  Created by ChenXiaoyu on 15/1/5.
//  Copyright (c) 2015年 ChenXiaoyu. All rights reserved.
//

#import "BarSeries.h"
#import "BBTheme.h"

@interface BarSeries ()

@property (nonatomic, strong) NSMutableArray<NSNumber *>  *riseOrFall;

@end

@implementation BarSeries

-(instancetype)init{
    self = [super init];
    if (self) {
        _riseOrFall = [NSMutableArray array];
    }
    return self;
}
- (void)addPoint:(float)p rise:(BOOL)isRise {
    [self.data addObject:[NSNumber numberWithFloat:p]];
    [self.riseOrFall addObject:@(isRise)];
}

- (void)drawPoint:(NSUInteger)idx animated:(BOOL)animated{
    if (idx >= self.data.count) {
        return;
    }
    CALayer* l = [[CALayer alloc] init];
    if (self.riseOrFall[idx].boolValue) {
        l.backgroundColor = UIColor.clearColor.CGColor;
        l.borderColor = [BBTheme theme].riseColor.CGColor;
    } else {
        l.backgroundColor = [BBTheme theme].fallColor.CGColor;
        l.borderColor = [BBTheme theme].fallColor.CGColor;
    }
    
    l.borderWidth = 1;
    l.anchorPoint = CGPointMake(0, 1);
    CGFloat h =[self.axisAttached heighForVal:((NSNumber*)self.data[idx]).floatValue];
//    NSLog(@"draw val:%.1f atH:%f",((NSNumber*)self.data[idx]).floatValue, h);
    l.bounds = CGRectMake(0, 0, self.pointWidth-2, h);
    l.position = CGPointMake(idx * self.pointWidth, self.bounds.size.height);
    [self addSublayer:l];
    
    if (animated) {
        CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        ani.fromValue = [NSNumber numberWithFloat:0];
        ani.toValue = [NSNumber numberWithFloat:1.0];
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        ani.duration = 1;
        [l addAnimation:ani forKey:nil];

    }
//    NSLog(@"Bar draw point:%d", idx);
    
}

- (void)prepareForDraw{
    self.axisAttached.touchBottom = NO;
    for (NSNumber* n in self.data) {
        [self.axisAttached addContainingVal:n.floatValue];
    }
    
}

//- (void)drawAnimated:(BOOL)animated{
//    
//    for (int i = 0; i < self.data.count; ++i) {
//        [self drawPoint:i animated:animated];
//    }
//}
//
//- (void)redrawAnimated:(BOOL)animated{
//    self.sublayers = nil;
//    [self drawAnimated:animated];
//}


@end
