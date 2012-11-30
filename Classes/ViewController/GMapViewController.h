//
//  GMapViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class ShipAnnotation;
@class MUtil;
//@class LevelMapData;
//@class ASIHTTPRequest;
@interface GMapViewController : UIViewController<MKMapViewDelegate> {
//    IBOutlet MKMapView *gmapView;
//    LevelMapData* levelData;
//    int currentMap;
    NSArray *meterArray;
    NSArray *feetArray;
    int zoomLevel;
    NSMutableDictionary *typPathDic;
    NSMutableDictionary *typForeDic;
//    ASIHTTPRequest *reloadReq;
//    NSMutableArray *onMapShipIdArray;
//    NSMutableArray *onMapShipDataArray;
    NSArray *normalShipArray;
    NSString *taskUrl;
//    int number;
    BOOL requesting;
    MKNetworkOperation *mkNetOp;
    BOOL useMap;
    BOOL showShipName;
    BOOL showTyphoon;
    MUtil *mapUtil;
//    ShipAnnotation *currentShipAnnotation;
}
@property (nonatomic, retain) IBOutlet MKMapView *gmapView;
//@property (nonatomic, retain) LevelMapData* levelData;
@end
