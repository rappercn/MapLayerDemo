//
//  ImageDownloader.h
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-14.
//
//

@interface ImageDownloader : MKNetworkEngine

typedef void (^ImageResponseBlock)();
typedef void (^ImageErrorBlock)(NSError* error);
-(MKNetworkOperation*) downloadMapImageFrom:(NSString*)remoteURL toFile:(NSString*)fileName onCompletion:(ImageResponseBlock)compBlock onError:(ImageErrorBlock)errorBlock;
@end
