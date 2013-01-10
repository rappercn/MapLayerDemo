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

    @try {
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //        NSDictionary *response = [completedOperation responseJSON];
            //        imageURLBlock(response[@"photos"][@"photo"]);
            if (completedOperation.readonlyResponse.statusCode == 200) {
                [completedOperation.responseData writeToFile:fileName atomically:YES];
            }
            compBlock();
        } onError:^(NSError *error) {
            //        NSLog(@"%@",error);
            if ([fileName hasSuffix:@".png"]) {
                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"shipng.png"]);
                [imageData writeToFile:fileName atomically:YES];
            } else {
                if (error.code == 404) {
                    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"null.jpg"]);
                    [imageData writeToFile:fileName atomically:YES];
                }
                NSLog(@"---------");
            }
            //        NSLog(@"error:%@");
            errorBlock(error);
            //        errorBlock(error);
        }];
        //    [self emptyCache];
        [self enqueueOperation:op];
        return op;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
@end
