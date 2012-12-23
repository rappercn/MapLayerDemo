//
//  MUtil.m
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-29.
//
//

#import "MUtil.h"
#import <MapKit/MapKit.h>
#define CLIP(A,B,C)	MIN(MAX(A,B),C)
@implementation MUtil
const double MinLatitude = -85.05112878;
const double MaxLatitude = 85.05112878;
const double MinLongitude = -180;
const double MaxLongitude = 180;
const double _PI = 3.1415926535897932;

-(id) init {
    __IterativeTimes=10;     //迭代次数为10
    __IterativeValue=0;        //迭代初始值
    __B0=0;
    __L0=0;
    __A=6378137;
    __B=6356752.3142451793;
    E=exp(1);
    //扁率
    f =(__A-__B)/__A;
    //第一偏心率
    e= sqrt(1-(__B/__A)*(__B/__A));
    //第二偏心率
    e_= sqrt((__A/__B)*(__A/__B)-1);
    //卯酉圈曲率半径
    NB0=((__A*__A)/__B)/sqrt(1+e_*e_*cos(__B0)*cos(__B0));
    //卯酉圈曲率半径 * cos(标准纬度)
    K=NB0*cos(__B0);
    //墨卡托系统的地图半径
    MapHaltExtend = 20037508.3427892;
    
    return [super init];
}
-(double)Clip:(double)value maxValue:(double)maxValue minValue:(double)minValue {
    
    return MAX(MIN(value, maxValue), minValue);
}
//角度到弧度的转换
-(double)DegreeToRad:(double)degree
//double DegreeToRad(double degree)
{
	return _PI*((double)degree/(double)180);
}

//弧度到角度的转换
-(double)RadToDegree:(double) rad
{
	return (180*rad)/_PI;
}
-(CLLocationCoordinate2D)LatLongToChartMercator:(double) latitude longitude:(double) longitude {
    
    double B = [self DegreeToRad:latitude];
	double L = [self DegreeToRad:longitude];	
	if(L<-_PI||L>_PI||B<-_PI/2||B>_PI/2)
	{
		return CLLocationCoordinate2DMake(0.0, 0.0);
	}
	
    double x=K*(L-__L0);
	double y=K*log(tan(_PI/4+B/2)*pow((1-e*sin(B))/(1+e*sin(B)),e/2));
    return CLLocationCoordinate2DMake(x, y);
}

-(CLLocationCoordinate2D)LatLongToWebMercator:(double) latitude longitude:(double) longitude {
    
    double lat = CLIP(latitude, MinLatitude, MaxLatitude);
    double lon = CLIP(longitude, MinLongitude, MaxLongitude);
    
    double fx = lon * MapHaltExtend;
    double fy = log( tan( (lat + 90) * _PI / 360) )/ _PI;
    
    double x = fx / 180;
    double y = fy * MapHaltExtend;
    return CLLocationCoordinate2DMake(x, y);
}

-(CLLocationCoordinate2D) ChartMercatorToLatLong:(double)dX dY:(double)dY {
    double L =dX/K+__L0;
    double B =__IterativeValue;
    for(int i=0;i<__IterativeTimes;i++)
    {
        B=_PI/2-2*atan(pow(E,(-dY/K))*pow(E,(e/2)*log((1-e*sin(B))/(1+e*sin(B)))));
    }
    
    double x = [self RadToDegree:B];
    double y = [self RadToDegree:L];
    return CLLocationCoordinate2DMake(x, y);
}

//Web墨卡托（球形墨卡托）坐标转换成经纬度
-(CLLocationCoordinate2D) WebMercatorToLatLong:(double)dX dY:(double)dY
//void WebMercatorToLatLong(double dX, double dY,double& latitude, double& longitude)
{
	//	double fx = ( dX + m_dWidth/2.0) / m_dWidth;
	double fy = exp(dY/MapHaltExtend*_PI);
	
	double lat = 180 / _PI * ( 2* atan(fy) -_PI/2 );
	double lon = dX / MapHaltExtend * 180;
    return CLLocationCoordinate2DMake(lat, lon);
}

-(CLLocationCoordinate2D)getFakeCoordinateWithLatitude:(double)lat andLongitude:(double)lon {

	//经纬度对应的ChartMercator坐标
    CLLocationCoordinate2D pt = [self LatLongToChartMercator:lat longitude:lon];
	//WebMercator坐标对应的经纬度
    CLLocationCoordinate2D ret = [self WebMercatorToLatLong:pt.latitude dY:pt.longitude];
    
    return ret;
}

-(CLLocationCoordinate2D)getRealCoordinateWithLatitude:(double)lat andLongitude:(double)lon {
    CLLocationCoordinate2D pt = [self LatLongToWebMercator:lat longitude:lon];
    return [self ChartMercatorToLatLong:pt.latitude dY:pt.longitude];
}

@end
