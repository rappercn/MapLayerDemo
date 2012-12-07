//
//  Util.h
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#define INTERFACE_URL @"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm="
#define API_SERVER @"218.241.183.164"
#define INTERFACE_URL @"http://218.241.183.164:7949/ShipDBCAppServer/PhoneShipWebService?fm="
#define MAP_SERVER @"map.ctrack.com.cn"
#define MAP_SERVER_URL @"http://map.ctrack.com.cn"
@class Reachability;

@interface Util : NSObject

+ (NSString*)getDocumentPath;
//+ (NSString *)getServiceDataByJson:(NSString *) url;
+ (void)loginWithUser:(NSString *)name passwd:(NSString*) passwd onComp:(APIResponseBlock)compBlock;
+(void)getSearchRecByKeyInShipBaseInfo:(NSString *)operid keystr:(NSString *)keystr start_ship:(NSString *) start_ship end_ship:(NSString *) end_ship shipType:(NSString *) shipType onComp:(APIResponseBlock)compBlock ;
//+(NSDictionary*)getAisShipFullInfoByShipId:(NSString *)listshipid;
+(void)getAttentionShipWithOperid:(NSString *)operid onComp:(APIResponseBlock)compBlock;
+(void)getFleetShipWithShipIds:(NSString*)idString onComp:(APIResponseBlock)compBlock;
+(void)getSearchRecByKeyInFleetWithOperid:(NSString *)operid key:(NSString *) key onComp:(APIResponseBlock)compBlock;

+(void)getCompanyGroups:(NSString *)userId onComp:(APIResponseBlock)compBlock;
+(void)getMobilesInfoWithOperId:(NSString *)operid groupId:(NSString *) groupId onComp:(APIResponseBlock)compBlock;
+(void)addAttentionShip:(NSString *)operid shipId:(NSString *) shipId onComp:(APIResponseBlock)compBlock;
+(void)delAttentionShip:(NSString *)operid shipId:(NSString *) shipId onComp:(APIResponseBlock)compBlock;
+(void)getAttentionShipFullInfo:(NSString *)userId onComp:(APIResponseBlock)compBlock;

+ (NSString*)getCachePath;
+ (NSString*)getCachePath:(NSString*)p;
//+ (NSString*)getMapNameByMapId:(NSString*)mapId;
//+ (NSDictionary*)login:(NSString *)name passwd:(NSString*) passwd;
+ (void)getTyphoonsIdOnComp:(APIResponseBlock)compBlock;
+ (void)getTyphoonLastForecastById:(NSString*)tid onComp:(APIResponseBlock)compBlock;
+ (void)getTyphoonPathById:(NSString*)tid onComp:(APIResponseBlock)compBlock;
+(NSDate*)getNSDateFromDateString:(NSString*)dateString;
+(NetworkStatus)checkNetworkReachability;
@end