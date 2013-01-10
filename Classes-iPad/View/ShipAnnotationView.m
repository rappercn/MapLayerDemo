//
//  CustomAnnotationView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipAnnotationView.h"
#import "ShipAnnotation.h"
#import "ShipModelView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ShipAnnotationView
@synthesize arrayIndex;
-(void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
//    ShipAnnotation *anno = (ShipAnnotation*)annotation;
    for (UIView *view in self.subviews) {
//        ShipModelView *shipview = (ShipModelView*)view;
//        NSLog(@"%@",anno.shipdict);
//        [shipview setShipdict:anno.shipdict];
//        shipview.shipdict = anno.shipdict;
        [view removeFromSuperview];
//        [view setNeedsDisplay];
    }
    ShipAnnotation *anno = (ShipAnnotation*)annotation;
    ShipModelView *shipView = [[ShipModelView alloc] initWithShipDictionary:anno.shipdict];
    shipView.backgroundColor = [UIColor clearColor];
    [self addSubview:shipView];
    RELEASE_SAFELY(shipView)
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation 
        reuseIdentifier:(NSString *)reuseIdentifier
{  
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];  
    if (self) {  
//        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
        ShipAnnotation *anno = (ShipAnnotation*)annotation;
        ShipModelView *shipView = [[ShipModelView alloc] initWithShipDictionary:anno.shipdict];
//        shipView.center = CGPointMake(0, 0);
//        [shipView rotateView:degree];
        shipView.backgroundColor = [UIColor clearColor];
//        self.layer.anchorPoint = CGPointMake(15, 15);
        
//        CATransform3D currentTransform = shipView.layer.transform;
//        CATransform3D rotated = CATransform3DRotate(currentTransform, 90 * M_PI / 180, 0., 0., 1.);
//        shipView.layer.transform = rotated;
        
//        CGPoint pt = self.layer.anchorPoint;
//        NSLog(@"%f, %f", pt.x, pt.y);
//        [imageView setImage:[UIImage imageNamed:@"pin.png"]];  
        [self addSubview:shipView];
        [shipView release];
    }  
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        //Add your custom view to self...
        UIImageView *iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus.png"]];
        iview.frame = CGRectMake(self.frame.origin.x - 5, self.frame.origin.y - 5, 40, 40);
//        UIView *tmpView = [[UIView alloc] initWithFrame:self.frame];
//        iview.backgroundColor = [UIColor redColor];
        [self.superview addSubview:iview];
        RELEASE_SAFELY(iview);
    }
    else
    {
        //Remove your custom view...
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    ShipAnnotation *anno = self.annotation;
    anno.selected = selected;
}

//-(void)drawRect:(CGRect)rect {
//    
////    CATransform3D currentTransform = self.layer.transform;
////    CATransform3D rotated = CATransform3DRotate(currentTransform, 60 * M_PI / 180, 0.0, 0.0, 1.0);
////    self.layer.transform = rotated;
//    
//    ShipAnnotation *anno = (ShipAnnotation*)self.annotation;
//    NSDictionary *shipdata = anno.shipDic;
//    if ([shipdata objectForKey:@"lastupdate"]) {
//        [[UIColor greenColor] setFill];
//    } else {
//        [[UIColor grayColor] setFill];
//    }
//    [[UIColor blackColor] setStroke];
//    UIBezierPath *path1 = [[UIBezierPath alloc] init];
////    CGFloat degrees = 60 * M_PI / 180;
//    CGAffineTransform rot = CGAffineTransformMakeRotation(60 * M_PI / 180);
//    [path1 applyTransform:rot];
//    if ([shipdata objectForKey:@"speed"]) {
//        [path1 moveToPoint:CGPointMake(15.0, 7.0)];
//        [path1 addLineToPoint:CGPointMake(23.0, 15.0)];
//        [path1 addLineToPoint:CGPointMake(15.0, 23.0)];
//        [path1 addLineToPoint:CGPointMake(7.0, 15.0)];
//        [path1 closePath];
//    } else {
//        [path1 moveToPoint:CGPointMake(20, 15)];
//        [path1 addLineToPoint:CGPointMake(15, 12)];
//        [path1 addLineToPoint:CGPointMake(8, 12)];
//        [path1 addLineToPoint:CGPointMake(10, 15)];
//        [path1 addLineToPoint:CGPointMake(8, 18)];
//        [path1 addLineToPoint:CGPointMake(15, 18)];
//        [path1 closePath];
//        [path1 moveToPoint:CGPointMake(15, 15)];
//        [path1 addLineToPoint:CGPointMake(30, 15)];
//    }
//    path1.lineWidth = 1;
//    [path1 fill];
//    [path1 stroke];
//    [[UIColor blackColor] setFill];
//    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(14, 14, 2, 2)];
//    [circle fill];
//    
////    currentTransform = self.layer.transform;
////    rotated = CATransform3DRotate(currentTransform, 60 * M_PI / 180, 0.0, 0.0, 1.0);
////    self.layer.transform = rotated;
//}
- (void)dealloc  
{
    for (UIView *view in self.superview.subviews) {
        [view removeFromSuperview];
    }
    [super dealloc];
}
@end
