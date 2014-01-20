#import "headers.h"

/* hook into Spotlights View Controller */
%hook SBSearchViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/* when "Define" cell is selected */	
	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1)  
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		// /* Get the header from the viewcontroller, then get the text from text field */
		SBSearchHeader * header = MSHookIvar<SBSearchHeader *>(self, "_searchHeader");
		NSString * searchText = header.searchField.text;

		// /* create URL with search term */
		// /* TODO: Set a preference for definitions */
		NSString * stringURL = [NSString stringWithFormat:@"https://www.google.com/search?q=define+%@&ie=UTF-8", searchText];

		/* open Safari to search for definition */
		NSURL *url = [NSURL URLWithString:stringURL];
		[[UIApplication sharedApplication] openURL:url];
	} 

	/* when any other cell is selected */
	else 
	{
		%orig;
	}
}



- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/* Create all cells the default way */
	SBSearchTableViewCell * cell = %orig;

	/* If it is our define cell, then let's edit it */
	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1) 
	{
		cell.title = @"Search for Definition";
	}

	return cell;
}


- (long long)tableView:(UITableView *)tableView numberOfRowsInSection:(long long)section {
	%log;

	/* Instead of 2 rows in last section, make it 3 so we can have room for "Define" */
	if (section == tableView.numberOfSections - 1) 
	{
		return 3;
	}

	return %orig;
}

%end;
