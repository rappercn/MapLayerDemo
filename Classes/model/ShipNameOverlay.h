//
//  ShipNameOverlay.h
//  BaoChuanWang
//
//  Created by 于 婧 on 13-1-18.
//
//

#import <pthread.h>

@interface ShipNameOverlay : NSObject <MKOverlay> {
    MKMapRect boundingMapRect;
    pthread_rwlock_t rwLock;
//    CLLocationCoordinate2D coordinate;
}
-(id) initWithMapRect:(MKMapRect)mapRect;
@property (readonly) NSMutableArray *rectArray;
- (void)lockForReading;
- (void)unlockForReading;
-(CGRect)getUseableRectForOverlayView:(MKOverlayView*)view fromPoint:(MKMapPoint)mapPoint andSize:(CGSize)tSize;
@end
