//
//  MapOverlayView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapOverlayView : MKOverlayView {
    BOOL downloaded;
    int counter;
    MKMapRect prevRect;
}

//@property (nonatomic, strong) MKNetworkOperation *netOperation;
//@property (nonatomic, strong) NSDictionary *metadata;

@end
