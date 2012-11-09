//
//  TyphPtAnnotationView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TyphoonPointAnnotationView.h"
#import "TyphoonPointAnnotation.h"
#define PT_RADIUS 3.5
@implementation TyphoonPointAnnotationView
//@synthesize zoomLevel;
-(void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.frame = CGRectMake(0.0, 0.0, PT_RADIUS * 2, PT_RADIUS * 2);
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

-(void) drawRect:(CGRect)rect {

    TyphoonPointAnnotation *anno = (TyphoonPointAnnotation*) self.annotation;
//    self.backgroundColor = [UIColor clearColor];
//    if (anno.typhoonName != nil) {
////        CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, 100 + anno.typhoonName.length * 9, 30);
////        self.frame = newRect;
////        self.centerOffset = CGPointMake(newRect.size.width / 2 - 4, -3);
//        
//        UIBezierPath *tipRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(27.0, 0.0, 80 + anno.typhoonName.length * 9, 15.0) cornerRadius:2];
//        tipRect.lineWidth = 1;
//        [[UIColor grayColor] setStroke];
//        [[UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.3] setFill];
//        [tipRect fill];
//        [tipRect stroke];
//        
//        [[UIColor blackColor] set];
//        [[NSString stringWithFormat:@" %@ %@", anno.typhoonName, anno.timeString] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
////        [[@" " stringByAppendingString:typhoonTime] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
//        
//        [[UIColor grayColor] setStroke];
//        UIBezierPath *line = [[UIBezierPath alloc] init];
//        [line moveToPoint:CGPointMake(10, 18)];
//        [line addLineToPoint:CGPointMake(27, 8)];
//        line.lineWidth = 1;
//        [line stroke];
//        
//        UIImage *icon = [UIImage imageNamed:@"typhoon.png"];
//        [icon drawAtPoint:CGPointMake(0.0, 7.0)];
//        [icon release];
//    } else if (zoomLevel >= 3) {
////        CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, 30);
////        self.frame = newRect;
////        self.centerOffset = CGPointMake(46, -3);
//        UIBezierPath *tipRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(27.0, 0.0, 80.0, 15.0) cornerRadius:2];
//        tipRect.lineWidth = 1;
//        [[UIColor grayColor] setStroke];
//        [[UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.3] setFill];
//        [tipRect fill];
//        [tipRect stroke];
//        
//        [[UIColor blackColor] set];
//        [[@" " stringByAppendingString:anno.timeString] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
//        
//        [[UIColor grayColor] setStroke];
//        UIBezierPath *line = [[UIBezierPath alloc] init];
//        [line moveToPoint:CGPointMake(10, 18)];
//        [line addLineToPoint:CGPointMake(27, 8)];
//        line.lineWidth = 1;
//        [line stroke];
////        NSLog(@"show tips-------");
////    } else {
////        NSLog(@"hide tips");
//    }
    
    UIColor *color;
    if (anno.typhoonSpeed < 17.2) {
        color = [UIColor colorWithRed:0x80 green:0xff blue:0.0 alpha:1.0];
    } else if (anno.typhoonSpeed < 24.5) {
        color = [UIColor colorWithRed:0x80 green:0x80 blue:0.0 alpha:1.0];
    } else if (anno.typhoonSpeed < 32.7) {
        color = [UIColor colorWithRed:0x80 green:0.0 blue:0.0 alpha:1.0];
    } else if (anno.typhoonSpeed < 41.5) {
        color = [UIColor colorWithRed:0xff green:0xff blue:0.0 alpha:1.0];
    } else if (anno.typhoonSpeed < 51) {
        color = [UIColor colorWithRed:0xff green:0x80 blue:0.0 alpha:1.0];
    } else {
        color = [UIColor colorWithRed:0xff green:0.0 blue:0.0 alpha:1.0];
    }
    [color setFill];
    [[UIColor grayColor] setStroke];
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    circle.lineWidth = 1;
    [circle fill];
    [circle stroke];
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    if(selected)
//    {
//        //Add your custom view to self...
//        UIView *tmpView = [[UIView alloc] initWithFrame:self.frame];
//        tmpView.backgroundColor = [UIColor redColor];
//        [self.superview addSubview:tmpView];
//    }
//    else
//    {
//        //Remove your custom view...
//    }
//}
@end
