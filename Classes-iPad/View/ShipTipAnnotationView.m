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
        
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:11.0]];
        [label setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
        [label setText:[NSString stringWithFormat:@" %@ ", ((ShipTipAnnotation*)self.annotation)._dispName]];
        [label sizeToFit];
//        CGSize size = label.text sizeWithFont:
        CGRect rect = CGRectMake(10.0, 0.0, label.frame.size.width, label.frame.size.height);
        label.frame = rect;
        label.layer.borderWidth = 1.0f;
        label.layer.borderColor = [[UIColor grayColor] CGColor];
        [self addSubview:label];
        RELEASE_SAFELY(label);
//        rect.size.height = rect.size.height + 10;
        self.frame = CGRectMake(0, 0, rect.size.width + rect.origin.x, rect.size.height + rect.origin.y + 10);
        self.centerOffset = CGPointMake(self.frame.size.width / 2, -self.frame.size.height / 2);
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
