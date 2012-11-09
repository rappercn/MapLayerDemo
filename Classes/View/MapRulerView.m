//
//  MapRulerView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapRulerView.h"

@implementation MapRulerView
@synthesize mksText, briText, rulerWidth;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.tag = 1;
    [self addSubview:label];
    [label release];
    return self;
}
-(void)drawRect:(CGRect)rect
{
//    NSLog(@"map ruler drawrect");
//    [[UIColor blackColor] setFill];
    [[UIColor blackColor] setStroke];
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 moveToPoint:CGPointMake(1, 13)];
    [path1 addLineToPoint:CGPointMake(1, 17)];
    [path1 addLineToPoint:CGPointMake(rulerWidth, 17)];
    [path1 addLineToPoint:CGPointMake(rulerWidth, 13)];
    path1.lineWidth = 2;
//    [path1 fill];
    [path1 stroke];
    
    UILabel *label = (UILabel*) [self viewWithTag:1];
    label.text = mksText;
    if (rulerWidth < 60) {
        label.frame = CGRectMake(0, 0, 60, 15);
    } else {
        label.frame = CGRectMake(0, 0, rulerWidth, 15);
    }
}

@end
