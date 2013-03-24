//
//  NameOverlay.m
//  BaoChuanWang
//
//  Created by 于 婧 on 13-3-24.
//
//

#import "NameOverlay.h"

@implementation NameOverlay
@synthesize boundingMapRect;
@synthesize coordinate;
@synthesize rectArray;
@synthesize zoomLevel;
-(id) init {
    self = [super init];
    
    defaultAlpha = 1;
    
    boundingMapRect = MKMapRectWorld;
    boundingMapRect.origin.x += 1048600.0;
    boundingMapRect.origin.y += 1048600.0;
    coordinate = CLLocationCoordinate2DMake(0, 0);
    rectArray = [[NSMutableArray alloc] init];
    idxArray = [[NSMutableArray alloc] init];
    return self;
}
-(CGFloat)getRoadWidth
{
    switch (zoomLevel) {
        case 0:
            return 1;
            break;
            
        default:
            return 10;
    }
}

-(CGRect)getUseableRectForOverlayView:(MKOverlayView *)view fromPoint:(MKMapPoint)mapPoint andSize:(CGSize)tSize withIndex:(int)idx {
//    [self lockForReading];
    for (int i = 0; i < [idxArray count]; i++) {
        if ([[idxArray objectAtIndex:i] intValue] == idx) {
            return [[rectArray objectAtIndex:i] CGRectValue];
        }
    }
    
    int lineHeight = tSize.height;
    MKMapPoint *points = malloc(sizeof(MKMapPoint) * 4);
    points[0] = MKMapPointMake(mapPoint.x - tSize.width - lineHeight, mapPoint.y - lineHeight * 2);
    points[1] = MKMapPointMake(mapPoint.x + lineHeight * 2, mapPoint.y - lineHeight * 2);
    points[2] = MKMapPointMake(mapPoint.x - tSize.width - lineHeight, mapPoint.y + lineHeight);
    points[3] = MKMapPointMake(mapPoint.x + lineHeight * 2, mapPoint.y + lineHeight);
    CGRect rtnRect = CGRectNull;
    BOOL newRect = YES;
    for (int j = 0; j < 4; j++) {
        CGPoint drawPoint = [view pointForMapPoint:points[j]];
        CGRect rect = CGRectMake(drawPoint.x, drawPoint.y, tSize.width, tSize.height);
        newRect = YES;
        for (int k = 0; k < rectArray.count; k++) {
            CGRect existRect = [[rectArray objectAtIndex:k] CGRectValue];
            if (CGRectEqualToRect(existRect, rect)) {
                newRect = NO;
                rtnRect = rect;
                break;
            } else {
                CGRect inRect = CGRectIntersection(existRect, rect);
                if (!CGRectIsNull(inRect)) {
                    //                    rtnRect = CGRectZero;
                    newRect = NO;
                    break;
                }
            }
        }
        
        if (newRect) {
            rtnRect = rect;
        }
        
        if (!CGRectIsNull(rtnRect)) {
            break;
        }
    }
    free(points);
    if (!CGRectIsEmpty(rtnRect) && newRect) {
        [rectArray addObject:[NSValue valueWithCGRect:rtnRect]];
        [idxArray addObject:[NSString stringWithFormat:@"%d", idx]];
    }
//    [self unlockForReading];
    return rtnRect;
}
-(void)dealloc {
//    pthread_rwlock_destroy(&rwLock);
    RELEASE_SAFELY(rectArray);
    RELEASE_SAFELY(idxArray);
    [super dealloc];
}
@end
