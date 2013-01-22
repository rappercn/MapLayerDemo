//
//  GMapViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@class ShipAnnotation;
@class MUtil;

@interface GMapViewController : UIViewController<MKMapViewDelegate> {
    NSArray *meterArray;
    NSArray *feetArray;
    int zoomLevel;
    NSMutableDictionary *typPathDic;
    NSMutableDictionary *typForeDic;
    NSArray *normalShipArray;
//    NSString *taskUrl;
//    BOOL requesting;
    MKNetworkOperation *mkNetOp;
    BOOL useMap;
    BOOL showShipName;
    BOOL showTyphoon;
    MUtil *mapUtil;
    BOOL doingAddTyphoonTip;
    int showtype;
    UISegmentedControl *segmentedControl;
    NSMutableDictionary *posDict;
    UIView *shipNameView;
//    ShipAnnotation *currentShipAnnotation;
}
@property (nonatomic, retain) IBOutlet MKMapView *gmapView;
@end
