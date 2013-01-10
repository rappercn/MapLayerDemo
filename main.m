//#import <UIKit/UIKit.h>
//#import "MapLayerDemoAppDelegate.h"

int main(int argc, char *argv[])
{
    //    @autoreleasepool {
    //        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MapLayerDemoAppDelegate class]));
    //    }
    @autoreleasepool {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }else{
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
}