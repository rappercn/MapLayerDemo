//
//  MUtil.h
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-29.
//
//



@interface MUtil : NSObject {
    
    int __IterativeTimes;
    double __IterativeValue;
    double __B0;
    double __L0;
    double __A;
    double __B;
    double E;
    //扁率
    double f;
    //第一偏心率
    double e;
    //第二偏心率
    double e_;
    //卯酉圈曲率半径
    double NB0;
    //卯酉圈曲率半径 * cos(标准纬度)
    double K;
    //墨卡托系统的地图半径
    double MapHaltExtend;
    
}

-(id)init;
-(CLLocationCoordinate2D)getFakeCoordinateWithLatitude:(double)lat andLongitude:(double)lon;
-(CLLocationCoordinate2D)getRealCoordinateWithLatitude:(double)lat andLongitude:(double)lon;
@end
