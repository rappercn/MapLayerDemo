//
//  SearchShipController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchShipViewController : UITableViewController <UISearchBarDelegate> {

    UISearchDisplayController *searchDisplayController;
//    UISearchDisplayController *searchBar;
//    NSArray *allItems;
    NSMutableArray *searchResults;
    NSMutableArray *myfav;
    NSArray *searchType;
    NSInteger currentPage; 
    NSInteger rowsPerPage ;
    NSInteger searchTypeIdx;
    NSString *inputShipName;
 //   UIActivityIndicatorView *loadingAni;  
   // NSMutableArray *myfavByPage; 
    Boolean isNeedPage;
}

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
//@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchBar;
//@property (nonatomic, copy) NSArray *allItems;
@property (nonatomic, copy) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *myfav;
//@property (nonatomic, retain) NSMutableArray *myfavByPage;
@property (nonatomic, retain) NSArray *searchType;
@property (nonatomic, retain) NSString *inputShipName;
- (void)saveContext:(NSManagedObjectContext*) managedObjectContext;
@end
