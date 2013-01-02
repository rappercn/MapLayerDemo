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
@end
