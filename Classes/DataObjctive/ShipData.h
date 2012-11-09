//
//  ShipData.h
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ShipDetailFocused.h"

@interface ShipData : NSObject {
    NSString*   shipName;       // 船名
    NSString*   mobileId;       // 船舶编号
    NSString*   mmsi;           // mmsi
    NSString*   imo;            // imo
    NSString*   callSign;       // 呼号
    NSString*   latitude;       // 纬度
    NSString*   longitude;      // 经度
    float       fLat;   // float latitude    give up
    float       fLon;   // float longitude   give up
    NSString*   latEx;          // 纬度（前次定位）
    NSString*   lonEx;          // 经度（前次定位）
    NSString*     gpsTimeEx;      // 时间（前次定位）
    float       averageSpeed;   // 平均速度
    int         distanceMoved;  // 最后距离
    float       direction;      // 船向
    float       speed;          // 速度
    //NSDate*     gpsTime;        // 时间
    NSString*     gpsTime;        // 时间
    float         lat;            // 纬度
    float         lon;            // 经度
    
    //add
    NSString * shipFlag;
    NSString * shipType;
    float  shipLength;
    float  shipWidth;
    float  draft;
    CLLocationCoordinate2D coor;
}

@property (nonatomic, retain) NSString*   shipName;
@property (nonatomic, retain) NSString*    mobileId;
@property (nonatomic, retain) NSString*    mmsi;
@property (nonatomic, retain) NSString*    imo;
@property (nonatomic, retain) NSString*   callSign;
@property (nonatomic, retain) NSString*   latitude;
@property (nonatomic, retain) NSString*   longitude;
@property (nonatomic, assign) float     fLat;
@property (nonatomic, assign) float     fLon;
@property (nonatomic, retain) NSString*   latEx;
@property (nonatomic, retain) NSString*   lonEx;
@property (nonatomic, retain) NSString*     gpsTimeEx;
@property (nonatomic, assign) float       averageSpeed;
@property (nonatomic, assign) int         distanceMoved;
@property (nonatomic, assign) float       direction;
@property (nonatomic, assign) float       speed;
@property (nonatomic, retain) NSString*     gpsTime;
@property (nonatomic, assign) float         lat;
@property (nonatomic, assign) float         lon;
@property (nonatomic, assign) CLLocationCoordinate2D coor;

@property (nonatomic, retain) NSString * shipFlag;
@property (nonatomic, retain) NSString * shipType;
@property (nonatomic, assign) float  shipLength;
@property (nonatomic, assign) float  shipWidth;
@property (nonatomic, assign) float  draft;
-(ShipData *)transferFromShipDetailFocusedToShipData:(ShipDetailFocused *)shipDetail;
-(ShipDetailFocused *)transferFromShipDataToShipDetailFocused:(ShipData *)shipDetail;
-(ShipData *)transferFromDictionaryToShipData:(NSDictionary *)returnDictionary;

@end
