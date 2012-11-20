//
//  Util.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "ShipData.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
//#define INTERFACE_URL2 @"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm="
//#define INTERFACE_URL @"http://218.241.183.164:7949/ShipDBCAppServer/PhoneShipWebService?fm="

@implementation Util

+ (ShipData*)parseShipDataString:(NSString *)strLine
{
    ShipData* data = [[ShipData alloc] init];
    // FeildAlias:,船名,船舶编号,mmsi,imo,呼号,纬度,经度,纬度（前次定位）,经度（前次定位）,时间（前次定位）,平均速度,最后距离,船向,速度,时间,y坐标,x坐标
    //Row[7]:,远怡湖,1426,372251000,9325037,3EHV,"29°7'48.12""N","123°30'0.0""E",,,,12.7,3.00E-04,3,12.7,2012-5-17 4:58,3371411,13747957
    NSArray* split = [strLine componentsSeparatedByString:@","];
    if (split.count != 18) {
        return nil;
    }
    
    data.shipName = [split objectAtIndex:1];
    data.mobileId = [split objectAtIndex:2];
    data.mmsi = [split objectAtIndex:3];
    data.imo = [split objectAtIndex:4];
    data.callSign = [split objectAtIndex:5];
    
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:@"(\\d*)°(\\d*)'(\\d*)\\.(\\d*)\\\"\\\"(N|S)\\\""
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    __block float lat = 0;
    NSString *checkString = [split objectAtIndex:6];
    [regex enumerateMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        float second = [[checkString substringWithRange:[match rangeAtIndex:3]] floatValue] * 100;
        second += [[checkString substringWithRange:[match rangeAtIndex:4]] floatValue];
        second /= 100;
        float min = [[checkString substringWithRange:[match rangeAtIndex:2]] floatValue] + second / 60;
        lat = [[checkString substringWithRange:[match rangeAtIndex:1]] floatValue] + min / 60;
        NSString* we = [checkString substringWithRange:[match rangeAtIndex:5]];
        if ([we isEqualToString:@"S"]) {
            lat *= -1;
        }
    }];
    
    regex = [NSRegularExpression         
             regularExpressionWithPattern:@"(\\d*)°(\\d*)'(\\d*)\\.(\\d*)\\\"\\\"(W|E)\\\""
             options:NSRegularExpressionCaseInsensitive
             error:&error];
    __block float lon = 0;
    checkString = [split objectAtIndex:7];
    [regex enumerateMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        float second = [[checkString substringWithRange:[match rangeAtIndex:3]] floatValue] * 100;
        second += [[checkString substringWithRange:[match rangeAtIndex:4]] floatValue];
        second /= 100;
        float min = [[checkString substringWithRange:[match rangeAtIndex:2]] floatValue] + second / 60;
        lon = [[checkString substringWithRange:[match rangeAtIndex:1]] floatValue] + min / 60;
        NSString* we = [checkString substringWithRange:[match rangeAtIndex:5]];
        if ([we isEqualToString:@"W"]) {
            lon *= -1;
        }
    }];
    data.fLat = lat;
    data.fLon = lon;
    data.coor =  CLLocationCoordinate2DMake(lat, lon);
    data.latitude = [split objectAtIndex:6];
    data.longitude = [split objectAtIndex:7];
    data.latEx = [split objectAtIndex:8];
    data.lonEx = [split objectAtIndex:9];
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm z"];
//    NSDate *dateFromString = [[NSDate alloc] init];
//    dateFromString = [dateFormatter dateFromString:[split objectAtIndex:10]];
//    TIME ZONE !!!!!!!!!!!!!
    data.gpsTimeEx = [dateFormatter dateFromString:[[split objectAtIndex:10] stringByAppendingString:@" GMT"]];
    data.averageSpeed = [[split objectAtIndex:11] floatValue];
    data.distanceMoved = [[split objectAtIndex:12] intValue];
    data.direction = [[split objectAtIndex:13] floatValue];
    data.speed = [[split objectAtIndex:14] floatValue];
    data.gpsTime = [dateFormatter dateFromString:[[split objectAtIndex:15] stringByAppendingString:@" GMT"]];
    data.lat = [[split objectAtIndex:16] intValue];
    data.lon = [[split objectAtIndex:17] intValue];
    
    return data;
}

+ (NSString*)getDocumentPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docPath = [paths objectAtIndex:0];
    return docPath;
}





















+(void)loginWithUser:(NSString *)name passwd:(NSString *)passwd onComp:(APIResponseBlock)compBlock {
//    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
//    [param setObject:name forKey:@"param_opercode"];
//    [param setObject:passwd forKey:@"param_operpwd"];
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"login&param_opercode=%@&param_operpwd=%@", name, passwd];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        //        errorBlock(error);
    }];
//    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
//    if (jsonString) {
//        NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//        return jsonDictionary;
//    }
//    return nil;
}

+(NSDictionary*)getSearchRecByKeyInShipBaseInfo:(NSString *)keystr start_ship:(NSString *) start_ship end_ship:(NSString *) end_ship shipType:(NSString *) shipType{
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
    [param setObject:keystr forKey:@"param_keystr"];
    [param setObject:start_ship forKey:@"param_start_ship"];
    [param setObject:end_ship forKey:@"param_end_ship"];
    [param setObject:shipType forKey:@"param_type"];
    NSString *url = [NSString stringWithFormat:@"%@getSearchRecByKeyInShipBaseInfo",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
}

+(NSDictionary*)getAisShipFullInfoByShipId:(NSString *)listshipid {
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [param setObject:listshipid forKey:@"param_shipid"];
    NSString *url = [NSString stringWithFormat:@"%@getAisShipFullInfoByShipId",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
} 
+(void)getFleetShipWithShipIds:(NSString *)idString onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getFleetShipFullInfoByShipList&param_listshipid=%@",idString];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
}
+(void)getAttentionShipWithOperid:(NSString *)operid onComp:(APIResponseBlock) compBlock {
//     NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
//    [param setObject:userId forKey:@"param_operid"];
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getAttentionShip&param_operid=%@",operid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
//    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
//    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    return jsonDictionary;
}

+(void)getSearchRecByKeyInFleetWithOperid:(NSString *)operid key:(NSString *)key onComp:(APIResponseBlock)compBlock{
//    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
//    [param setObject:userId forKey:@"param_operid"];
//    [param setObject:key forKey:@"param_key"];
//    [param setObject:start forKey:@"param_start"];
//    [param setObject:end forKey:@"param_end"];
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getSearchRecByKeyInFleet&param_operid=%@&param_key=%@&param_start=1&param_end=99",operid,key];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
        
    }];
//    NSString *url = [NSString stringWithFormat:@"%@getSearchRecByKeyInFleet",INTERFACE_URL];
//    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
//    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    return jsonDictionary;
}

+(NSDictionary*)getCompanyGroups:(NSString *)userId{
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
    [param setObject:userId forKey:@"param_operid"];
    NSString *url = [NSString stringWithFormat:@"%@getCompanyGroups",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
}

+(NSDictionary*)getMobilesInfo:(NSString *)userId groupId:(NSString *) groupId {
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
    [param setObject:userId forKey:@"param_operid"];
    [param setObject:groupId forKey:@"param_groupid"];
    NSString *url = [NSString stringWithFormat:@"%@getMobilesInfo",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
}

+(NSDictionary*)addAttentionShip:(NSString *)userId shipId:(NSString *) shipId {
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [param setObject:userId forKey:@"param_operid"];
    [param setObject:shipId forKey:@"param_shipid"];
    NSString *url = [NSString stringWithFormat:@"%@addAttentionShip",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
}

+(NSDictionary*)delAttentionShip:(NSString *)userId shipId:(NSString *) shipId {
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [param setObject:userId forKey:@"param_operid"];
    [param setObject:shipId forKey:@"param_shipid"];
    NSString *url = [NSString stringWithFormat:@"%@delAttentionShip",INTERFACE_URL];
    NSString* jsonString = [Util getHttpData:url dataDictionary:param];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return jsonDictionary;
}


+(NSString*)getHttpData:(NSString *)url dataDictionary:(NSDictionary *)dic {
    
    NSString *_t = [url stringByAppendingString:@"&&"];
    for (NSString *key in dic.allKeys) {
        _t = [_t stringByAppendingFormat:@"%@=%@&&", key, [dic objectForKey:key]];
    }
    NSString *urlString = [_t substringWithRange:NSMakeRange(0,(_t.length-@"&&".length))];
    
   // url = @"http://www.baidu.com";
    NSURL *_url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:_url];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setPersistentConnectionTimeoutSeconds:60];
    [request startSynchronous];
    NSError *error = [request error];
//    NSData *ret;
    if (error || request.responseStatusCode != 200)
    {
//        //self.listDataString = [request responseString];
//        ret = [request responseData];
//        //NSString *contentStr = [[NSString alloc] initWithData:listData encoding:4];
//    }
//    else
//    {
//        NSLog(@"%@",error.userInfo);
//        NSString *errText = @"连接服务器时发生错误";
////        if (request.responseStatusCode != 200) {
////            errText = @"";
////        }
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" 
//                                                       message:errText 
//                                                      delegate:nil 
//                                             cancelButtonTitle:@"确定" 
//                                             otherButtonTitles:nil,nil];
//       // alert.delegate = self;
//        [alert show];
//        [alert release];	

        NSLog(@"reload error,response is nil !!");
        return nil;
    }
    NSString *json = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    [request release];
    return  json;
    
}

-(NSString *)postHttpData:(NSString *)url dataDictionary:(NSDictionary *)dic {
    
    NSURL *_url = [NSURL URLWithString:url];
    
    //获取md5密码
    //    NSString *md5Str = [self getMd5String:@"chinaacciphone" domain:@"@chinaacc.com" passwd:@"123456" memberlevel:@"iphone" pkeyName:@"eiiskdui"];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:_url];
    for (NSString *key in dic.allKeys) {
        [request setPostValue:[dic objectForKey:key] forKey:key];
    }
    [request startSynchronous];
    
    NSError *error = [request error];
    NSData *ret;
    if (!error)
    {
        
        //self.listDataString = [request responseString];
        ret = [request responseData];
    }
    else
    {
        NSLog(@"reload erro,listString is nil !!");
    }
    NSString *json = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    [request release];
    return  json;
    
}




/***************************
 split
 
 */





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
+ (NSString*)getMapNameByMapId:(NSString*)mapId
{
    if (mapId.intValue == MAP_OSM) {
        return @"OpenStreetMap";
    } else if (mapId.intValue == MAP_GOOGLE) {
        return @"Google";
    } else if (mapId.intValue == MAP_CUSTOM) {
        return @"海图";
    }
    return nil;
}





+(void)getTyphoonsIdOnComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingString:@"getTyphoonsId"];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
//    NSString* jstr = [self getHttpData:url dataDictionary:nil];
//    NSDictionary *jdic = [jstr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    return [jdic objectForKey:@"return"];
}
+(void)getTyphoonLastForecastById:(NSString *)tid onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getTyphoonLatestForecast&param_typhid=%@",tid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
//    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
//    [param setObject:tid forKey:@"param_typhid"];
//    NSString* jstr = [self getHttpData:url dataDictionary:param];
//    NSDictionary *jdic = [jstr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    return [jdic objectForKey:@"return"];
}
+(void)getTyphoonPathById:(NSString *)tid onComp:(APIResponseBlock)compBlock {
    NSString *url = [INTERFACE_URL stringByAppendingFormat:@"getTyphoonPath&param_typhid=%@",tid];
    [ApplicationDelegate.apiEngine requestDataFrom:url onCompletion:^(NSObject *responseData) {
        compBlock(responseData);
    } onError:^(NSError *error) {
//        errorBlock(error);
    }];
//    NSMutableDictionary *param = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
//    [param setObject:tid forKey:@"param_typhid"];
//    NSString* jstr = [self getHttpData:url dataDictionary:param];
//    NSDictionary *jdic = [jstr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    return [jdic objectForKey:@"return"];
}
+(NSDate*)getNSDateFromDateString:(NSString *)dateString {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS ±HHMM"];
    
    NSDate *dateFromString = [[[NSDate alloc] init] autorelease];
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return dateFromString;
}

@end

