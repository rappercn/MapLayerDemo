//
//  ImageDownloader.m
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-14.
//
//

#import "ImageDownloader.h"

@implementation ImageDownloader
-(MKNetworkOperation*)downloadMapImageFrom:(NSString *)remoteURL toFile:(NSString *)fileName onCompletion:(ImageResponseBlock)compBlock onError:(ImageErrorBlock)errorBlock {
    
    MKNetworkOperation *op = [self operationWithURLString:remoteURL
                                                   params:nil
                                               httpMethod:@"GET"];
    
//    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:fileName
//                                                            append:YES]];
//    NSLog(@"---------%@", remoteURL);
    [op onCompletion:^(MKNetworkOperation *completedOperation) {

//        NSDictionary *response = [completedOperation responseJSON];
//        imageURLBlock(response[@"photos"][@"photo"]);
        if (completedOperation.readonlyResponse.statusCode == 200) {
            [completedOperation.responseData writeToFile:fileName atomically:YES];
        }
        compBlock();
    } onError:^(NSError *error) {
//        NSLog(@"%@",error);
        NSLog(@"error:%@",remoteURL);
        errorBlock(error);
//        errorBlock(error);
    }];
//    [self emptyCache];
    [self enqueueOperation:op];
    
    return op;
}
@end
