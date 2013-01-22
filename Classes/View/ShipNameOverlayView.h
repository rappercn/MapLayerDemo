//
//  ShipNameOverlayView.h
//  BaoChuanWang
//
//  Created by 于 婧 on 13-1-18.
//
//


@interface ShipNameOverlayView : MKOverlayView {
//    NSArray *annotations;
    MKMapView *mView;
    int ptLength;
    MKMapPoint *mapPoints;
    NSMutableArray *nameArray;
    NSMutableDictionary *posDict;
    int lineHeight;
    NSMutableArray *rectArray;
}
-(id)initWithAnnotations:(NSArray*)annos andOverlay:(id<MKOverlay>)overlay;
@end
