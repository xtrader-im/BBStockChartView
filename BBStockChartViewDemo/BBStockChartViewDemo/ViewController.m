//
//  ViewController.m
//  BBStockChartViewDemo
//
//  Created by ChenXiaoyu on 15/3/26.
//  Copyright (c) 2015年 ChenXiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "BBStockChart.h"

#define Float(a) (((NSNumber*)a).floatValue)
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init with any size, autolayout
    _chartView = [[BBChartView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.height, self.view.frame.size.width - 10)];
    [self.view addSubview:_chartView];
    // a sample data file stored in data.json
    [self loadData];
    
    // if you want to clear the data
    //[_chartView reset];
    
    //ChartView add area, area add series
    Area* areaup = [[Area alloc] init];
    //set delegate for axis's data provider
    areaup.bottomAxis.labelProvider = self;
    areaup.bottomAxis.designHeight = self.view.bounds.size.width * 0.7;
    areaup.leftAxis.designWidth = self.view.bounds.size.height;
    
    Area* areadown = [[Area alloc] init];
    areadown.bottomAxis.designHeight = self.view.bounds.size.width * 0.3;
    areadown.leftAxis.designWidth = self.view.bounds.size.height;
    areadown.bottomAxis.labelProvider = self;
    
    BarSeries* bar = [[BarSeries alloc] init];
    StockSeries* stock = [[StockSeries alloc] init];
    LineSeries* line = [[LineSeries alloc] init];
    line.color = [UIColor yellowColor];
    line.width = 1.5;
    
    LineSeries* line2 = [[LineSeries alloc] init];
    line2.color = [UIColor grayColor];
    [areaup addSeries:stock];
    [areadown addSeries:bar];
    [areaup addSeries:line];
    [areaup addSeries:line2];
    
    for (NSArray* arr in _chartData) {
        [bar addPoint:Float(arr[1]) rise:arr[2] < arr[5]];
        [stock addPointOpen:Float(arr[2]) close:Float(arr[5]) low:Float(arr[4]) high:Float(arr[3])];
        [line addPoint: (Float(arr[2]) + Float(arr[5]))/2 - 300];
        [line2 addPoint:(Float(arr[4]) + Float(arr[3]))/2];
    }
    [self.chartView addArea:areaup];
    [self.chartView addArea:areadown];
    // two area's height ratio
    [self.chartView setHeighRatio:0.3 forArea:areadown];
    
    // set any color you like
    [BBTheme theme].barBorderColor = [UIColor clearColor];
    [BBTheme theme].xAxisFontSize = 11;
    [BBTheme theme].axisColor = [UIColor colorWithWhite:1 alpha:0.6];
    
    // begin to show the view animated
    [self.chartView drawAnimated:YES];
}

- (void)loadData{
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
    NSError* err = nil;
    _chartData = (NSArray*)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
}

#pragma mark - AxisDataProvider

- (NSString *)axisX:(AxisX *)x textForIdx:(NSUInteger)idx {
    NSString* ret = nil;
    
    // Too much labels would make them overlapping
    if (idx % 15 == 0) {
        NSDate* curDate = [NSDate date];
        NSDate* date = nil;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // idx - 90, is meaningless for your data.
        [dateComponents setDay:idx-90];
        formatter.dateFormat =  @"MM/dd HH:00";;
        date = [calendar dateByAddingComponents:dateComponents toDate:curDate options:0];
        ret = [formatter stringFromDate:date];
    }
    
    return ret;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
