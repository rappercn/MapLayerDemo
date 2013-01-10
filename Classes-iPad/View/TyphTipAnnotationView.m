//
//  TyphTipAnnotationView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TyphTipAnnotationView.h"
#import "TyphTipAnnotation.h"

@implementation TyphTipAnnotationView
@synthesize zoomLevel;
-(void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {

        self.frame = CGRectMake(0, 0, 150, 30);
        self.centerOffset = CGPointMake(self.frame.size.width / 2 - 11, -3);
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void) drawRect:(CGRect)rect {
    
    TyphTipAnnotation *anno = (TyphTipAnnotation*) self.annotation;
    if (anno.typhoonName != nil) {
//        NSLog(@"%@-----",anno.typhoonName);
        UIBezierPath *tipRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(27.0, 0.0, 75 + anno.typhoonName.length * 9, 15.0) cornerRadius:2];
        tipRect.lineWidth = 1;
        [[UIColor grayColor] setStroke];
        [[UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.3] setFill];
        [tipRect fill];
        [tipRect stroke];
        
        [[UIColor blackColor] set];
        [[NSString stringWithFormat:@" %@ %@", anno.typhoonName, anno.timeString] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
        //        [[@" " stringByAppendingString:typhoonTime] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
        
        [[UIColor grayColor] setStroke];
        UIBezierPath *line = [[UIBezierPath alloc] init];
        [line moveToPoint:CGPointMake(11.5, 18.0)];
        [line addLineToPoint:CGPointMake(27.0, 8.0)];
        line.lineWidth = 1;
        [line stroke];
        
        UIImage *icon = [UIImage imageNamed:@"typhoon.png"];
        [icon drawAtPoint:CGPointMake(0.0, 7.0)];
        RELEASE_SAFELY(icon);
//        [icon release];
    } else {
        //        CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, 30);
        //        self.frame = newRect;
        //        self.centerOffset = CGPointMake(46, -3);
        UIBezierPath *tipRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(27.0, 0.0, 80.0, 15.0) cornerRadius:2];
        tipRect.lineWidth = 1;
        [[UIColor grayColor] setStroke];
        [[UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.3] setFill];
        [tipRect fill];
        [tipRect stroke];
        
        [[UIColor blackColor] set];
        [[@" " stringByAppendingString:anno.timeString] drawInRect:tipRect.bounds withFont:[UIFont systemFontOfSize:11.0]];
        
        [[UIColor grayColor] setStroke];
        UIBezierPath *line = [[UIBezierPath alloc] init];
        [line moveToPoint:CGPointMake(10, 18)];
        [line addLineToPoint:CGPointMake(27, 8)];
        line.lineWidth = 1;
        [line stroke];
        RELEASE_SAFELY(line);
        //        NSLog(@"show tips-------");
        //    } else {
        //        NSLog(@"hide tips");
    }
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
