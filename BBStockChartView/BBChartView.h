//
//  BBChartView.h
//  BBChart
//
//  Created by ChenXiaoyu on 15/1/5.
//  Copyright (c) 2015年 ChenXiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"
@interface BBChartView : UIView{
    
}

@property (nonatomic) CGFloat scaleFloor;

//when pinch the view, scale it in-time, not after. Default is NO.
@property (nonatomic) BOOL realTimeScale;
@property (nonatomic, assign) BOOL detailEnable;    // default as NO.

- (void)setHeighRatio:(CGFloat)heightRatio forArea:(Area*)area;
- (void)addArea:(Area *)area;

- (void)drawAnimated:(BOOL)animated;
- (void)reset;
- (void)redraw;


@end
