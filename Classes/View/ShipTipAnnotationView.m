//
//  ShipTipAnnotationView.m
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-18.
//
//
#import "ShipTipAnnotation.h"
#import "ShipTipAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShipTipAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        UITextView *tv = [[UITextView alloc] init];
        [tv setText:((ShipTipAnnotation*)self.annotation)._dispName];
        CGRect rect = CGRectMake(tv.frame.origin.x + 10, tv.frame.origin.y, tv.frame.size.width, tv.frame.size.height);
        tv.frame = rect;
        tv.layer.borderWidth = 1.0f;
        tv.layer.borderColor = [[UIColor grayColor] CGColor];
        [self addSubview:tv];
        RELEASE_SAFELY(tv);
        rect.size.height = rect.size.height + 10;
        self.frame = rect;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    [[UIColor grayColor] setStroke];
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 moveToPoint:CGPointMake(0.0, self.frame.size.height)];
    [path1 addLineToPoint:CGPointMake(15.0, self.frame.size.height - 15.0)];
    path1.lineWidth = 1;
    [path1 stroke];
    RELEASE_SAFELY(path1);
}


@end
