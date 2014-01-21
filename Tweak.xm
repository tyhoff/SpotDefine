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
@end

@interface SBSearchTableViewCell
@property(retain, nonatomic) NSString *title;
@end


/* Implementation */

/* hook into Spotlights View Controller */
%hook SBSearchViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	/* when "Define" cell is selected */	
	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1)  
	{
		// /* Get the header from the viewcontroller, then get the text from text field */
		SBSearchHeader * header = MSHookIvar<SBSearchHeader *>(self, "_searchHeader");
		NSString * searchText = header.searchField.text;

		/* create an overlay of the Dictionary Controller */
		UIReferenceLibraryViewController *controller = [[UIReferenceLibraryViewController alloc] initWithTerm:searchText];	
		
		/* present the view */
		[self presentViewController:controller animated:YES completion:NULL];

		/* unselect the cell */
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	} 

	/* when any other cell is selected */
	else 
	{
		/* perform the original action */
		%orig;
	}
}



- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/* Create all cells the default way */
	SBSearchTableViewCell * cell = %orig;

	/* If it is our define cell, then let's edit it */
	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1) 
	{
		/* title of the cell */
		cell.title = @"Search for Definition";
	}

	return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	/* Instead of 2 rows in last section, make it 3 so we can have room for "Define" */
	if (section == tableView.numberOfSections - 1) 
	{
		/* return the original count (2) + 1 */
		return %orig + 1;
	}

	/* if not the last section, return the original number */
	return %orig;
}

%end;