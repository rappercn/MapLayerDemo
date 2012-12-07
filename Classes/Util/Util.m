//
//  Util.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


//#define INTERFACE_URL2 @"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm="
//#define INTERFACE_URL @"http://218.241.183.164:7949/ShipDBCAppServer/PhoneShipWebService?fm="

@implementation Util

+ (NSString*)getDocumentPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docPath = [paths objectAtIndex:0];
    return docPath;
}

+(void)loginWithUser:(NSString *)name passwd:(NSString *)passwd onComp:(APIResponseBlock)compBlock {

    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"login&param_opercode=%@&param_operpwd=%@", name, passwd];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];

}

+(void)getSearchRecByKeyInShipBaseInfo:(NSString *) operid keystr:(NSString *)keystr start_ship:(NSString *) start_ship end_ship:(NSString *) end_ship shipType:(NSString *) shipType onComp:(APIResponseBlock)compBlock {
    
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getSearchRecByKeyInShipBaseInfo&param_operid=%@&param_keystr=%@&param_start_ship=%@&param_end_ship=%@&param_type=%@",operid, keystr, start_ship,end_ship,shipType];
      NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
  
   // NSString *test = @"http://www.baidu.com";
    NSURL *st = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:gbk]];
   // NSString *result = [NSString stringWithContentsOfURL:st encoding:gbk error:nil];
    NSString *result = [st absoluteString];
    [ApplicationDelegate.apiEngine requestDataFrom:result onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
}

+(void)getFleetShipWithShipIds:(NSString *)idString onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getFleetShipFullInfoByShipList&param_listshipid=%@",idString];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
}

+(void)getAttentionShipFullInfo:(NSString *)userId onComp:(APIResponseBlock)compBlock{
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getAttentionShipFullInfo&param_operid=%@",userId];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
}

+(void)getAttentionShipWithOperid:(NSString *)operid onComp:(APIResponseBlock) compBlock {
//     NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
//    [param setObject:userId forKey:@"param_operid"];
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getAttentionShipFullInfo&param_operid=%@",operid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
}

+(void)getSearchRecByKeyInFleetWithOperid:(NSString *)operid key:(NSString *)key onComp:(APIResponseBlock)compBlock{

    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getSearchRecByKeyInFleet&param_operid=%@&param_key=%@&param_start=1&param_end=99",operid,key];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
}


+(void)getCompanyGroups:(NSString *)userId onComp:(APIResponseBlock)compBlock{
    
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getCompanyGroups&param_operid=%@", userId];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
    
}

+(void)getMobilesInfoWithOperId:(NSString *)operid groupId:(NSString *) groupId onComp:(APIResponseBlock)compBlock{
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getMobilesInfo&param_operid=%@&param_groupid=%@", operid,groupId];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
}

+(void)addAttentionShip:(NSString *)operid shipId:(NSString *) shipId onComp:(APIResponseBlock)compBlock{
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"addAttentionShip&param_operid=%@&param_shipid=%@", operid,shipId];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
    
}

+(void)delAttentionShip:(NSString *)operid shipId:(NSString *) shipId onComp:(APIResponseBlock)compBlock{
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"delAttentionShip&param_operid=%@&param_shipid=%@", operid,shipId];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
    
}

+ (NSString*)getCachePath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [paths objectAtIndex:0];
    return cachePath;
}
+(NSString*)getCachePath:(NSString *)p{
    NSString* cpath = [[self getCachePath] stringByAppendingFormat:@"/%@",p];
    BOOL isDir = NO;
    BOOL exists = NO;
    exists = [[NSFileManager defaultManager] fileExistsAtPath:cpath isDirectory:&isDir];
    if (!exists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cpath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return cpath;
}

+(void)getTyphoonsIdOnComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingString:@"getTyphoonsId"];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
}
+(void)getTyphoonLastForecastById:(NSString *)tid onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getTyphoonLatestForecast&param_typhid=%@",tid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
}
+(void)getTyphoonPathById:(NSString *)tid onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getTyphoonPath&param_typhid=%@",tid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
}
+(NSDate*)getNSDateFromDateString:(NSString *)dateString {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS ±HHMM"];
    
    NSDate *dateFromString = [[[NSDate alloc] init] autorelease];
    dateFromString = [dateFormatter dateFromString:dateString];
    RELEASE_SAFELY(dateFormatter);
    return dateFromString;
}
+(NetworkStatus)checkNetworkReachability {
    Reachability *r = [[Reachability alloc] init];
    NetworkStatus netStatus = [r currentReachabilityStatus];
    return netStatus;
}
@end

