//
//  ShipNameOverlayView.m
//  BaoChuanWang
//
//  Created by 于 婧 on 13-1-18.
//
//

#import "ShipNameOverlayView.h"
#import "ShipNameOverlay.h"
#import "ShipAnnotation.h"
@implementation ShipNameOverlayView

-(BOOL)markUsedPosition:(CGPoint)pt {
    int x = pt.x / lineHeight;
    int y = pt.y / lineHeight;
//    if (posDict[[NSString stringWithFormat:@"%d-%d", x, y]] != nil) {
//        return NO;
//    }
    posDict[[NSString stringWithFormat:@"%d-%d", x, y]] = @"1";
    return YES;
}
-(void)markUsedPositionWithArray:(NSArray*)array {
//    for (NSMutableDictionary *shipdict in array) {
//        CLLocationCoordinate2D coord;
//        if (useMap) {
//            coord = [mapUtil getFakeCoordinateWithLatitude:[shipdict[@"lat"] floatValue] andLongitude:[shipdict[@"lon"] floatValue]];
//        } else {
//            coord = CLLocationCoordinate2DMake([shipdict[@"lat"] floatValue], [shipdict[@"lon"] floatValue]);
//        }
//        CGPoint pt = [gmapView convertCoordinate:coord toPointToView:gmapView];
//        [self markUsedPosition:pt];
//    }
}

-(MKMapPoint)getLabelPositionByShipPoint:(MKMapPoint)shipPt withWidth:(CGFloat)width {
    //    static NSInteger viewWidth = gmapView.bounds.size.width;
    //    static int viewHeight = gmapView.bounds.size.height;
    MKMapPoint retPt = MKMapPointMake(0, 0);
    MKMapPoint *points = malloc(sizeof(MKMapPoint) * 4);
//    int w = ((int)(width / lineHeight) * lineHeight);
    points[0] = MKMapPointMake(shipPt.x - width - lineHeight, shipPt.y - lineHeight * 2);
    points[1] = MKMapPointMake(shipPt.x + lineHeight * 2, shipPt.y - lineHeight * 2);
    points[2] = MKMapPointMake(shipPt.x - width - lineHeight, shipPt.y + lineHeight);
    points[3] = MKMapPointMake(shipPt.x + lineHeight * 2, shipPt.y + lineHeight);
    for (int i = 0; i < 4; i++) {
        BOOL useable = YES;
        for (int start = points[i].x / lineHeight, stop = (points[i].x + width) / lineHeight; start < stop; start++) {
            int y = points[i].y / lineHeight;
            if (posDict[[NSString stringWithFormat:@"%d-%d", start, y]] != nil) {
                useable = NO;
                break;
            }
        }
        if (useable) {
            retPt.x = (int)(points[i].x / lineHeight);
            retPt.x *= lineHeight;
            retPt.y = (int)(points[i].y / lineHeight);
            retPt.y *= lineHeight;
            for (int start = points[i].x / lineHeight, stop = (points[i].x + width) / lineHeight; start < stop; start++) {
                int y = points[i].y / lineHeight;
                posDict[[NSString stringWithFormat:@"%d-%d", start, y]] = @"1";
            }
            break;
        }
    }
    free(points);
    return retPt;
}

-(id)initWithAnnotations:(NSArray *)annos andOverlay:(id<MKOverlay>)overlay {
    self = [super initWithOverlay:overlay];
//    annotations = [annos retain];
//    mView = [mapView retain];
//    ptLength = length;
//    mapViewRect = viewRect;
    rectArray = [[NSMutableArray alloc] init];
    posDict = [[NSMutableDictionary alloc] init];
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
        NSLog(@"mapPoints[%d]:%f, %f",i,mapPoints[i].x, mapPoints[i].y);
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

#pragma mark MKOverlayView methods
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {

    return YES;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {


    @try {
        [ApplicationDelegate.drawLock lock];

                    UIGraphicsPushContext(context);
    [[UIColor blackColor] setStroke];
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light"
                                   size:(7.0 * MKRoadWidthAtZoomScale(zoomScale))];
//        float s  = 7.0 * MKRoadWidthAtZoomScale(zoomScale);
//        UIFont *font = [UIFont systemFontOfSize:s];
    for (int i = 0; i < ptLength; i++) {
        MKMapPoint pt = mapPoints[i];
        NSString *t = [nameArray objectAtIndex:i];
//        if ([t isEqualToString:@" 银锦 "] || [t isEqualToString:@" 银鹏 "]) {
//            NSLog(@"--------------------");
//        }
        CGSize size = CGSizeZero;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
            size = [t sizeWithFont:font];
        } else {
            NSAttributedString *s = [[NSAttributedString alloc] initWithString:t];
            size = [s size];
            RELEASE_SAFELY(s);
        }
        
        if (i == 0) {
            lineHeight = size.height;
        }
        
        
            ShipNameOverlay *nameOverlay = (ShipNameOverlay *) self.overlay;
            CGRect rect = [nameOverlay getUseableRectForOverlayView:self fromPoint:pt andSize:size];
            if (!CGRectIsEmpty(rect)) {
//                CGContextRef cc = UIGraphicsGetCurrentContext();
//                CGContextSelectFont(cc, "Helvetica-Bold", 10000000, kCGEncodingMacRoman);
//                CGContextSetTextDrawingMode (cc, kCGTextFill);
//                CGContextSetRGBFillColor(cc, 100.0, 100.0, 100.0, 0.7);
//                //CGContextSetTextMatrix (cc, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), M_PI/2));
//                CGContextShowTextAtPoint(cc, 0, 0, [@"1234500000" cStringUsingEncoding:NSUTF8StringEncoding], 10);
//                CGContextRestoreGState(cc);
                
//                    UIGraphicsPushContext(context);
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
                NSLog(@"draw ship name-----%@,%f,%f,%f,%f", t, rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
//                    UIGraphicsPopContext();
            }
        
        
//                break;
//            }
//        free(points);
//        }
    }
UIGraphicsPopContext();

    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [ApplicationDelegate.drawLock unlock];        
    }
}
#pragma mark -
#pragma mark Memory management
- (void)dealloc {
//    RELEASE_SAFELY(annotations);
    RELEASE_SAFELY(rectArray);
    free(mapPoints);
    RELEASE_SAFELY(nameArray);
    [super dealloc];
}

@end
