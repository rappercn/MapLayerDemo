//
//  Util.h
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#define INTERFACE_URL @"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm="
#define INTERFACE_URL @"http://218.241.183.164:7949/ShipDBCAppServer/PhoneShipWebService?fm="
@class ShipData;
@class ASIHTTPRequest;

@interface Util : NSObject {
    ASIHTTPRequest *asynRequest;
    id<NSObject> delegate;
    SEL callback;
}


+ (ShipData*)parseShipDataString:(NSString*)dataString;
+ (NSString*)getDocumentPath;
+ (NSString*)getMapNameByMapId:(NSString*)mapId;
+ (NSString *)getServiceDataByJson:(NSString *) url;
+ (void)loginWithUser:(NSString *)name passwd:(NSString*) passwd onComp:(APIResponseBlock)compBlock;
+(NSDictionary*)getSearchRecByKeyInShipBaseInfo:(NSString *)keystr start_ship:(NSString *) start_ship end_ship:(NSString *) end_ship shipType:(NSString *) shipType;
+(NSDictionary*)getAisShipFullInfoByShipId:(NSString *)listshipid;
+(void)getAttentionShipWithOperid:(NSString *)operid onComp:(APIResponseBlock)compBlock;
+(void)getSearchRecByKeyInFleetWithOperid:(NSString *)operid key:(NSString *) key onComp:(APIResponseBlock)compBlock;
+(NSDictionary*)getCompanyGroups:(NSString *)userId;
+(NSDictionary*)getMobilesInfo:(NSString *)userId groupId:(NSString *) groupId ;
+(NSDictionary*)addAttentionShip:(NSString *)userId shipId:(NSString *) shipId;
+(NSDictionary*)delAttentionShip:(NSString *)userId shipId:(NSString *) shipId;



+ (NSString*)getCachePath;
+ (NSString*)getCachePath:(NSString*)p;
+ (NSString*)getMapNameByMapId:(NSString*)mapId;
+ (NSString*)getHttpData:(NSString *)url dataDictionary:(NSDictionary *)dic;
+ (NSDictionary*)login:(NSString *)name passwd:(NSString*) passwd;
+ (void)getTyphoonsIdOnComp:(APIResponseBlock)compBlock;
+ (void)getTyphoonLastForecastById:(NSString*)tid OnComp:(APIResponseBlock)compBlock;
+ (void)getTyphoonPathById:(NSString*)tid OnComp:(APIResponseBlock)compBlock;
//- (ASIHTTPRequest*)asynShipsFromPoint:(CLLocationCoordinate2D)pt0 toPoint:(CLLocationCoordinate2D)pt1 withCallback:(SEL)method andParent:(id)parent;
//- (ASIHTTPRequest*)asynHttpData:(NSString *)url dataDictionary:(NSDictionary *)dic;
//+ (ASIHTTPRequest*)asynHttpData:(NSString *)url dataDictionary:(NSDictionary *)dic callback:(SEL)method parent:(id)parent;
+(NSDate*)getNSDateFromDateString:(NSString*)dateString;


@end