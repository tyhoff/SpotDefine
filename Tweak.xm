#import "headers.h"

UIReferenceLibraryViewController *controller;
UIPopoverController *popover;
bool searchDictionaryCellEnabled;

/* if Search Web clicked, close the dictionary view */
%hook UIReferenceLibraryViewController
- (void)_searchWeb:(id)arg1
{
	%orig;
    if (isIpad()) 
    {
        [popover dismissPopoverAnimated:NO];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
%end

/* hook into Spotlights View Controller */
%hook SBSearchViewController
- (void)dismiss 
{
    if (isIpad())
    {
        [popover dismissPopoverAnimated:NO];
    }
    %orig;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UIView * header = [self tableView:tableView viewForHeaderInSection:indexPath.section];
	NSString * headerTitle = ((SBSearchTableHeaderView *)header).title;
	SBSearchTableViewCell *cell = (SBSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

	if ([headerTitle isEqualToString:@"DICTIONARY"]) 
	{
		// /* create an overlay of the Dictionary Controller */
		controller = [[UIReferenceLibraryViewController alloc] initWithTerm:cell.title];	
		
		/* present the view */
        if (isIpad()) 
        {
            popover = [[UIPopoverController alloc]
                                       initWithContentViewController:controller];

            popover.popoverContentSize=CGSizeMake(400.0, 500.0);

            [popover presentPopoverFromRect:cell.frame inView:tableView
                permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        else
        {
            [self presentModalViewController:controller animated:YES];
        }

		/* unselect the cell */
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}



	if (searchDictionaryCellEnabled && indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1)
	{
		// /* Get the header from the viewcontroller, then get the text from text field */
		SBSearchHeader * header = MSHookIvar<SBSearchHeader *>(self, "_searchHeader");
		NSString * searchText = header.searchField.text;

		// /* create an overlay of the Dictionary Controller */
		controller = [[UIReferenceLibraryViewController alloc] initWithTerm:searchText];	
		
		/* present the view */
        if (isIpad()) 
        {
            popover = [[UIPopoverController alloc]
                                       initWithContentViewController:controller];

            popover.popoverContentSize=CGSizeMake(400.0, 500.0);

            [popover presentPopoverFromRect:cell.frame inView:tableView
                permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        else
        {
            [self presentModalViewController:controller animated:YES];
        }

		/* unselect the cell */
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}

	%orig;
}


- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (searchDictionaryCellEnabled)
	{
		/* Create all cells the default way */
	  	SBSearchTableViewCell * cell = %orig;
	
	  	if (indexPath.row == 1 && indexPath.section == tableView.numberOfSections - 1) 
	  	{
	    	[cell setIsLastInSection:NO];
	  	}

	  	/* If it is our define cell, then let's edit it */
	  	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1) 
	  	{
	    	cell.title = SpotDefineLocalizedString(@"Search Dictionary");
	    	[cell setIsLastInSection:YES];
	  	}
	
	  	return cell;
	}
	
	return %orig;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (searchDictionaryCellEnabled)
	{
		if (section == tableView.numberOfSections - 1) 
		{
			return %orig + 1;
		}
	}

	return %orig;
}

%end;

static BOOL isIpad()
{
    UIDevice *device = [UIDevice currentDevice];
    return (device.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

static NSString *SpotDefineLocalizedString(NSString *string)
{
    return [[NSBundle bundleWithPath:LocalizationsDirectoryPath]localizedStringForKey:string value:string table:nil];
}


/* called when a change to the preferences has been made */
static void LoadSettings()
{
  	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"];
  	searchDictionaryCellEnabled = GET_BOOL(@"FixedSearchDictionaryCell", YES);
}

/* called when a change to the preferences has been made */
static void ChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  	LoadSettings();
}


/* constructor of tweak */
%ctor
{
	/* subsribe to preference changed notification */
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, ChangeNotification, CFSTR("com.tyhoff.spotdefine.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  	LoadSettings();
}