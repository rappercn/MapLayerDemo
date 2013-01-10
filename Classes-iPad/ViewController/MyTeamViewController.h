
#import "SectionHeaderView.h"
@interface MyTeamViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate> {
    IBOutlet UITableView* shipListTableView;
//    NSMutableArray* myFav;
    int openSectionIndex;
    BOOL flag[100];
    
//    SectionHeaderView* sectionArray[100];
//    NSArray* favArray;
//    NSMutableArray* teamArray;
    NSMutableDictionary *sectionHeaders;
//    NSInteger prevSectionIndex;
    NSArray *groupArray;
    NSMutableDictionary *groupDetail;
//    SectionHeaderView *prevSection;
}

@property (nonatomic, retain) IBOutlet UITableView* shipListTableView;
//@property (nonatomic, retain) NSMutableArray* myFav;
//@property (nonatomic, assign) int openSectionIndex;

@end
