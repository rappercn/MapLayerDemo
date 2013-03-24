//
//  NameOverlayView.m
//  BaoChuanWang
//
//  Created by 于 婧 on 13-3-24.
//
//

#import "NameOverlayView.h"
#import "ShipAnnotation.h"
#import "NameOverlay.h"

@implementation NameOverlayView

-(BOOL) canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale
{
    return YES;
}

-(id)initWithAnnotations:(NSArray *)annos andOverlay:(id<MKOverlay>)overlay {
    self = [super initWithOverlay:overlay];
    //    annotations = [annos retain];
    //    mView = [mapView retain];
    //    ptLength = length;
    //    mapViewRect = viewRect;
//    rectArray = [[NSMutableArray alloc] init];
//    posDict = [[NSMutableDictionary alloc] init];
    ptLength = annos.count;
    mapPoints = malloc(sizeof(MKMapPoint) * ptLength);
    nameArray = [[NSMutableArray alloc] init];
    int realLen = 0;
    for (int i = 0; i < ptLength; i++) {
        if (![[annos objectAtIndex:i] isKindOfClass:[ShipAnnotation class]]) {
            continue;
        }
        realLen++;
        ShipAnnotation *an = [annos objectAtIndex:i];
        mapPoints[i] = MKMapPointForCoordinate(an.coordinate);
//        NSLog(@"mapPoints[%d]:%f, %f",i,mapPoints[i].x, mapPoints[i].y);
        NSString *t = an.shipdict[@"shipnamecn"];
        if (t == nil || t.length == 0) {
            t = an.shipdict[@"shipname"];
            if (t == nil || t.length == 0) {
                t = an.shipdict[@"imo"];
            }
        }
        // 补空格
        [nameArray addObject:[@" " stringByAppendingFormat:@"%@ ", t]];
    }
    ptLength = realLen;
    return self;
}

-(void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{

    [ApplicationDelegate.drawLock lock];
    UIGraphicsPushContext(context);
    CGRect frame = [self rectForMapRect:mapRect];
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, frame);
    
    [[UIColor blackColor] setStroke];
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light"
                                   size:(7.0 * MKRoadWidthAtZoomScale(zoomScale))];
    NameOverlay *nameOverlay = (NameOverlay *) self.overlay;
    NSLog(@"zoom level:%d, road width:%f", nameOverlay.zoomLevel, MKRoadWidthAtZoomScale(zoomScale));
    //        float s  = 7.0 * MKRoadWidthAtZoomScale(zoomScale);
    //        UIFont *font = [UIFont systemFontOfSize:s];
    for (int i = 0; i < ptLength; i++) {
//        CGPoint viewpt = [self pointForMapPoint:mapPoints[i]];
//        if (!CGRectContainsPoint(frame, viewpt)) {
//            continue;
//        }
        MKMapPoint pt = mapPoints[i];
        NSString *t = [nameArray objectAtIndex:i];

        CGSize size = CGSizeZero;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
            size = [t sizeWithFont:font];
//        } else {
//            NSAttributedString *s = [[NSAttributedString alloc] initWithString:t];
//            size = [s size];
//            RELEASE_SAFELY(s);
//        }
        
        if (i == 0) {
            lineHeight = size.height;
        }
        
        

        CGRect rect = [nameOverlay getUseableRectForOverlayView:self fromPoint:pt andSize:size withIndex:i];
        if (!CGRectIsEmpty(rect)) {
            CGContextStrokeRectWithWidth(context, rect, 1.0 * MKRoadWidthAtZoomScale(zoomScale));
            [[UIColor colorWithWhite:1.0 alpha:0.7] setFill];
            CGContextFillRect(context, rect);
            [[UIColor blackColor] setFill];
            //                [t drawInRect:rect withFont:font];
            //                t=@"123";
            //                [t drawInRect:rect withFont:font];
            [t drawAtPoint:CGPointMake(rect.origin.x,rect.origin.y) forWidth:rect.size.width withFont:font lineBreakMode:NSLineBreakByClipping];
            CGPoint center = [self pointForMapPoint:pt];
            CGPoint pt2 = CGPointZero;
            if (center.x < rect.origin.x) {
                pt2 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
            } else {
                pt2 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2);
            }
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddLineToPoint(context, pt2.x, pt2.y);
            CGContextSetLineWidth(context, MKRoadWidthAtZoomScale(zoomScale));
            CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
            CGContextStrokePath(context);
//            NSLog(@"draw ship name-----%@,%f,%f,%f,%f", t, rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
            //                    UIGraphicsPopContext();
        }
    }
    UIGraphicsPopContext();
    [ApplicationDelegate.drawLock unlock];
}

@end
