//
//  NameOverlayView.h
//  BaoChuanWang
//
//  Created by 于 婧 on 13-3-24.
//
//

@interface NameOverlayView : MKOverlayView {
//    MKMapView *mView;
    int ptLength;
    MKMapPoint *mapPoints;
    NSMutableArray *nameArray;
//    NSMutableDictionary *posDict;
    int lineHeight;
//    NSMutableArray *rectArray;
}
-(id)initWithAnnotations:(NSArray *)annos andOverlay:(id<MKOverlay>)overlay;
@end
