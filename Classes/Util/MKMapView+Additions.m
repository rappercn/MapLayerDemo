//
//  MKMapView+Additions.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MKMapView+Additions.h"

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

//@interface MKMapView (ZoomLevel)
//- (double)getZoomLevel;
//@end

@implementation MKMapView (Additions)

- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}

//@end
//
//@implementation MKMapView(Additions)
-(UIImageView*)mapLogo {
    UIImageView *imgView = nil;
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UIImageView class]]) {
            imgView = (UIImageView*)subview;
//            [subview removeFromSuperview];
            break;
        }
    }
//    return nil;
    return imgView;
}

@end
