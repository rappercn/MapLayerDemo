//
//  shipModelView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipModelView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShipModelView
//-(void)setShipdict:(NSDictionary *)shipDictionary {
//    [shipdict release];
//    shipdict = [[NSMutableDictionary alloc] initWithDictionary:shipDictionary];
//}
-(id)initWithShipDictionary:(NSDictionary *)shipDictionary {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
//    shipdict = [[NSMutableDictionary alloc] initWithDictionary:shipDictionary];
    shipdict = shipDictionary;
    return self;
}
-(void)drawRect:(CGRect)rect {
//    NSLog(@"drawrect called.");
//    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *dateString = [shipdict objectForKey:@"gpstime"];
    NSDate *date = [Util getNSDateFromDateString:dateString];
    NSDate *now = [NSDate date];
    NSInteger interval = [now timeIntervalSinceDate:date];
    if (interval < 3600 * 24) {
        [[UIColor greenColor] setFill];
    } else {
        [[UIColor grayColor] setFill];
    }
    [[UIColor blackColor] setStroke];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    if ([[shipdict objectForKey:@"speed"] floatValue] <= 0) {
        [path1 moveToPoint:CGPointMake(15.0, 10.0)];
        [path1 addLineToPoint:CGPointMake(20.0, 15.0)];
        [path1 addLineToPoint:CGPointMake(15.0, 20.0)];
        [path1 addLineToPoint:CGPointMake(10.0, 15.0)];
        [path1 closePath];
    } else {
        [path1 moveToPoint:CGPointMake(20, 15)];
        [path1 addLineToPoint:CGPointMake(15, 12)];
        [path1 addLineToPoint:CGPointMake(8, 12)];
        [path1 addLineToPoint:CGPointMake(10, 15)];
        [path1 addLineToPoint:CGPointMake(8, 18)];
        [path1 addLineToPoint:CGPointMake(15, 18)];
        [path1 closePath];
        [path1 moveToPoint:CGPointMake(15, 15)];
        [path1 addLineToPoint:CGPointMake(30, 15)];
    }
    path1.lineWidth = 1;
    [path1 fill];
    [path1 stroke];
    [[UIColor blackColor] setFill];
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(14, 14, 2, 2)];
    [circle fill];
    
    float dir = [[shipdict objectForKey:@"direction"] floatValue] - 90;
    CATransform3D currentTransform = self.layer.transform;
    CATransform3D rotated = CATransform3DRotate(currentTransform, dir * M_PI / 180, 0.0, 0.0, 1.0);
//    currentArc = dir - currentArc;
    self.layer.transform = rotated;
}
@end
