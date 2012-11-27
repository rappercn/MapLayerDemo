//
//  APIEngine.m
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-17.
//
//

#import "APIEngine.h"

@implementation APIEngine
-(MKNetworkOperation*)requestDataFrom:(NSString *)remoteURL onCompletion:(APIResponseBlock)compBlock onError:(APIErrorBlock)errorBlock {
    
    MKNetworkOperation *op = [self operationWithURLString:remoteURL
                                                   params:nil
                                               httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        //        NSDictionary *response = [completedOperation responseJSON];
        //        imageURLBlock(response[@"photos"][@"photo"]);
        if (completedOperation.readonlyResponse.statusCode == 200 && completedOperation.responseString.length > 5) {
            if (completedOperation.responseJSON[@"return"] != nil) {
                compBlock(completedOperation.responseJSON[@"return"]);
            } else {
                compBlock(completedOperation.responseJSON);
            }
        } else {
            compBlock(nil);
        }
    } onError:^(NSError *error) {
        
        NSLog(@"requestdata failed.");
        compBlock(nil);
        //        errorBlock(error);
        
    }];
    
    @try {
        [self enqueueOperation:op forceReload:YES];
    }
    @catch (NSException *exception) {
        op = nil;
    }
    @finally {
        return op;
    }
}
@end
