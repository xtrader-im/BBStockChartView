//
//  BaseLayer.m
//  BBChart
//
//  Created by ChenXiaoyu on 15/1/6.
//  Copyright (c) 2015年 ChenXiaoyu. All rights reserved.
//

#import "BaseLayer.h"
#import <UIKit/UIKit.h>

@implementation BaseLayer

-(void)drawAnimated:(BOOL)animated{
    
}
- (void)redrawAnimated:(BOOL)animated{

}
-(void)prepareForDraw{
    
}

+ (CALayer *)layerOfArrowFrom:(CGPoint)from to:(CGPoint)to withFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor andWidth:(CGFloat)width {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    CGFloat height = fabs(from.y - to.y);
    [arrowPath moveToPoint:CGPointMake(from.x - width * 0.5, from.y)];
    [arrowPath addLineToPoint:CGPointMake(from.x - width * 0.5, to.y)];
    [arrowPath addLineToPoint:CGPointMake(to.x + width * 0.3, to.y)];
    [arrowPath addLineToPoint:CGPointMake(to.x + width * 0.5, to.y - height * 0.5)];
    [arrowPath addLineToPoint:CGPointMake(from.x + width * 0.3, from.y)];
    [arrowPath addLineToPoint:CGPointMake(from.x - width * 0.5, from.y)];
    [arrowPath closePath];
    layer.path = arrowPath.CGPath;
    
    layer.opacity = 1.0;
    layer.fillColor = fillColor.CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.lineWidth = 1;
    
    return layer;
}

+ (CALayer *)layerOfRectFrom:(CGPoint)from to:(CGPoint)to withColor:(UIColor*)color andWidth:(CGFloat)width fill:(BOOL)fill {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(from.x - width * 0.5, from.y)];
    [linePath addLineToPoint:CGPointMake(from.x - width * 0.5, to.y)];
    [linePath addLineToPoint:CGPointMake(to.x + width * 0.5, to.y)];
    [linePath addLineToPoint:CGPointMake(to.x + width * 0.5, from.y)];
    [linePath closePath];
    line.path = linePath.CGPath;
    if (fill) {
        line.fillColor = color.CGColor;
    } else {
        line.fillColor = nil;
    }
    
    line.opacity = 1.0;
    line.strokeColor = color.CGColor;
    line.lineWidth = 1;
    return line;
}


+ (CALayer *)layerOfLineFrom:(CGPoint)from to:(CGPoint)to withColor:(UIColor*)color andWidth:(CGFloat)width {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint: from];
    [linePath addLineToPoint:to];
    line.path = linePath.CGPath;
    line.fillColor = nil;
    
    line.opacity = 1.0;
    line.strokeColor = color.CGColor;
    line.lineWidth = width;
    return line;
}
// TODO: when line series is thick, their joint part would leave a small black space, which should be filled
//+ (CALayer *)layerOfConcatLineFrom:(CGPoint)from to:(CGPoint)to withColor:(UIColor*)color andWidth:(CGFloat)width{
//    CAShapeLayer *line = [CAShapeLayer layer];
//    UIBezierPath *linePath = [UIBezierPath bezierPath];
//    [linePath moveToPoint: from];
//    [linePath addLineToPoint:to];
//    line.path = linePath.CGPath;
//    line.fillColor = nil;
//    line.opacity = 1.0;
//    line.strokeColor = color.CGColor;
//    line.lineWidth = width;
//    return line;
//}


+ (CATextLayer *)layerOfText:(NSString *)text withFont:(NSString*)font fontSize:(CGFloat)fontSize andColor:(UIColor *)color{
//    UIFont* f = [UIFont fontWithName:font size:fontSize];
    CATextLayer *ret = [[CATextLayer alloc] init];
    ret.string = text;
    ret.font = (__bridge CFTypeRef)(font);
    ret.fontSize = fontSize;
    ret.foregroundColor = color.CGColor;
    ret.contentsScale = [UIScreen mainScreen].scale;
    return ret;
}
@end
