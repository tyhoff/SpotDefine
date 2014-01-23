/* Headers from private frameworks */

//SBSearchTableViewCell
//sectionHeaderHeight

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

UIReferenceLibraryViewController *controller;

/* Implementation */

%hook UIReferenceLibraryViewController
- (void)_searchWeb:(id)arg1
{
	%orig;
	[self dismissModalViewControllerAnimated:YES];
}
%end

/* hook into Spotlights View Controller */
%hook SBSearchViewController
{
	%orig;

}
- (void)dismiss;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return %orig + 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	BOOL isSpotDefineHeader = NO;
	if (section == 0)
	{
		isSpotDefineHeader = YES;
	}
	if (section != 0)
	{
		section -= 1;
	}

	UIView * header = %orig;

	if (isSpotDefineHeader)
	{
		((SBSearchTableHeaderView *)header).title = @"SPOTDEFINE";
	}
	
	return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	/* when "Define" cell is selected */	
	if (indexPath.row == 0 && indexPath.section == 0)  
	{
		// /* Get the header from the viewcontroller, then get the text from text field */
		SBSearchHeader * header = MSHookIvar<SBSearchHeader *>(self, "_searchHeader");
		NSString * searchText = header.searchField.text;

		/* create an overlay of the Dictionary Controller */
		controller = [[UIReferenceLibraryViewController alloc] initWithTerm:searchText];	
		
		/* present the view */
		[self presentModalViewController:controller animated:YES];

		/* unselect the cell */
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	} 

	/* when any other cell is selected */
	else 
	{
		NSInteger newSection = indexPath.section - 1;
		indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
		%orig;
	}
}



- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	SBSearchTableViewCell * cell;

	/* If it is our define cell, then let's edit it */
	if (indexPath.row == 0 && indexPath.section == 0) 
	{
		NSIndexPath *real = indexPath;

		indexPath = [NSIndexPath indexPathForRow:0 inSection:tableView.numberOfSections - 1];
		cell = %orig;

		indexPath = real;

		/* title of the cell */
		cell.title = @"Search Dictionary";
		[cell setIsLastInSection:YES];
		cell.firstInSection = YES;
		cell.lastInSection = YES;
		[cell updateBottomLine];
	}
	else 
	{
		NSInteger newSection = indexPath.section - 1;

		indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
		
		/* Create all cells the default way */
		cell = %orig;
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		return 48.0;
	}
	else 
	{
		NSInteger newSection = indexPath.section - 1;
		indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
		return %orig;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 0) 
	{
		return 1;
	} 
	else 
	{
		section -= 1;
		return %orig;
	}
}

%end;