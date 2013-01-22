//
//  MKMapView+Additions.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface MKMapView(Additions)
-(UIImageView*)mapLogo;
- (double)getZoomLevel;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                zoomLevel:(NSUInteger)zoomLevel
                animated:(BOOL)animated;
@end
