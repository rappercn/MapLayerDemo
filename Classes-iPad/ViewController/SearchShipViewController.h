
//#import <Foundation/Foundation.h>

@interface SearchShipViewController : UITableViewController <UISearchBarDelegate> {

    UISearchDisplayController *searchDisplayController;
//    UISearchDisplayController *searchBar;
//    NSArray *allItems;
    NSMutableArray *searchResults;
    NSMutableArray *localArray;
//    NSArray *searchType;
    NSInteger currentPage;
//    NSInteger rowsPerPage ;
    NSInteger searchTypeIdx;
    NSString *searchKey;
    BOOL searchFinish;
 //   UIActivityIndicatorView *loadingAni;  
   // NSMutableArray *myfavByPage; 
//    Boolean isNeedPage;
}

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
//@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchBar;
//@property (nonatomic, copy) NSArray *allItems;
//@property (nonatomic, copy) NSMutableArray *searchResults;
//@property (nonatomic, retain) NSMutableArray *myfav;
//@property (nonatomic, retain) NSMutableArray *myfavByPage;
//@property (nonatomic, retain) NSArray *searchType;
//@property (nonatomic, retain) NSString *inputShipName;
//- (void)saveContext:(NSManagedObjectContext*) managedObjectContext;
@end
