@interface SBSearchHeader
@property(readonly, nonatomic) UITextField *searchField;
@end;

@interface SBSearchViewController : UIViewController
{
	SBSearchHeader *_searchHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (long long)tableView:(UITableView *)tableView numberOfRowsInSection:(long long)section;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SBSearchTableViewCell
@property(retain, nonatomic) NSString *title;
@end