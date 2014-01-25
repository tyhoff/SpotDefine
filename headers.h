/* Headers from private frameworks */

@interface SBSearchHeader
@property(readonly, nonatomic) UITextField *searchField;
@end;

@interface SBSearchViewController : UIViewController
{
	SBSearchHeader *_searchHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
@end

@interface SBSearchTableHeaderView
@property(retain, nonatomic) NSString *title;
@end

@interface SBSearchTableViewCell : UITableViewCell
@property(retain, nonatomic) NSString *title;
@property(nonatomic, getter=isLastInSection) _Bool lastInSection;
@property(nonatomic, getter=isFirstInSection) _Bool firstInSection;
- (void)updateBottomLine;
- (void)setIsLastInSection:(_Bool)arg1;
@end