//
//  APIEngine.h
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-17.
//
//

@interface APIEngine : MKNetworkEngine

typedef void (^APIResponseBlock)(NSObject *responseData);
typedef void (^APIErrorBlock)(NSError* error);
-(MKNetworkOperation*) requestDataFrom:(NSString*)remoteURL onCompletion:(APIResponseBlock)compBlock onError:(APIErrorBlock)errorBlock;
@end
