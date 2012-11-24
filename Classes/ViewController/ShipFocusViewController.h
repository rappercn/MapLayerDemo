//
//  SearchShipController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipFocusViewController : UITableViewController <UISearchBarDelegate> {

    IBOutlet UISearchDisplayController *searchController;
    NSMutableArray *searchResults;
//    NSArray *searchType;
}

//@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
//@property (nonatomic, copy) NSMutableArray *searchResults;
//@property (nonatomic, retain) NSArray *searchType;
//
//@property(nonatomic ,retain)NSArray *myFocusArray;
@end
