//
//  MapOverlayView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface MapOverlayView : MKOverlayView {
    BOOL downloaded;
    int counter;
    MKMapRect prevRect;
    BOOL drawBg;
}

//@property (nonatomic, strong) MKNetworkOperation *netOperation;
//@property (nonatomic, strong) NSDictionary *metadata;

@end
