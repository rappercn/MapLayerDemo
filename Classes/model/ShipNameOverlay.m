//
//  MapTileOverlay.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipNameOverlay.h"

@implementation ShipNameOverlay
//@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize rectArray;
-(id) initWithMapRect:(MKMapRect)mapRect {
    self = [super init];
    boundingMapRect = mapRect;
    pthread_rwlock_init(&rwLock, NULL);
    rectArray = [[NSMutableArray alloc] init];
    return self;
}
-(CGRect)getUseableRectForOverlayView:(MKOverlayView *)view fromPoint:(MKMapPoint)mapPoint andSize:(CGSize)tSize {
    [self lockForReading];
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
    }
    [self unlockForReading];
    return rtnRect;
}
- (void)lockForReading
{
    pthread_rwlock_rdlock(&rwLock);
}

- (void)unlockForReading
{
    pthread_rwlock_unlock(&rwLock);
}
- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}
-(void)dealloc {
    pthread_rwlock_destroy(&rwLock);
    RELEASE_SAFELY(rectArray);
    [super dealloc];
}
@end
