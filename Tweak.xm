#import "headers.h"

UIReferenceLibraryViewController *controller;
UIPopoverController *popover;
bool searchDictionaryCellEnabled;
bool spotDefineNow;
bool dictionaryShowing;

/* 
 * This listens for Spotlight actions that will open a URL. If it is coming from SpotDefine
 * then this will set a boolean spotDefineNow to YES. When the UITableView "didSelectRow..."
 * happens, then it will look for that boolean and perform the necessary action if it is YES.
 */
%hook SBSearchModel
- (id)launchingURLForResult:(SPSearchResult *)result withDisplayIdentifier:(NSString *)identifier andSection:(SPSearchResultSection *)section
{
    if ([identifier isEqualToString:@"com.tyhoff.SpotDefine"])
    {
        spotDefineNow = YES;
        return nil;
    }

    return %orig;
}
%end

/* If app switcher shows, close out of dictionary window */
%hook SBUIController
- (_Bool)_activateAppSwitcherFromSide:(int)arg1
{
    dismissDictionary(NO);
	return %orig;
}
%end

/* 
 * If another app is being open (Search Web from Dictionary or by 
 * clicking notification), close out of Dictionary 
 */
%hook SBWorkspace
- (void)workspace:(id)arg1 applicationDidStartLaunching:(id)arg2 
{ 
    %orig;
    dismissDictionary(NO);
}
%end



%hook SBSearchViewController

/* 
 * If spotlight is trying to close, close the dictionary first, then close Spotlight
 * with the next home button click 
 */
- (void)dismiss 
{
    if (dictionaryShowing)
    {
        dismissDictionary(YES);
    }
    else
    {
    	%orig;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	SBSearchTableViewCell *cell = (SBSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (searchDictionaryCellEnabled && indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1)
    {
        /* Get the header from the viewcontroller, then get the text from text field */
        SBSearchHeader * header = MSHookIvar<SBSearchHeader *>(self, "_searchHeader");
        NSString * searchText = header.searchField.text;

        /* create an overlay of the Dictionary Controller */
        [self tableView:tableView presentDictionaryWithTerm:searchText nearCell:cell];

        /* deselect the cell */
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    %orig;

	if (spotDefineNow) 
	{
		/* create an overlay of the Dictionary Controller */
		[self tableView:tableView presentDictionaryWithTerm:cell.title nearCell:cell];

		/* unselect the cell */
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

        /* reset boolean */
        spotDefineNow = NO;
		return;
	}
}

%new
- (void)tableView:(UITableView *)tableView presentDictionaryWithTerm:(NSString *)term 
		nearCell:(SBSearchTableViewCell *)cell
{
	controller = [[UIReferenceLibraryViewController alloc] initWithTerm:term];

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

    dictionaryShowing = YES;
}

static void dismissDictionary(bool animated)
{
	if (isIpad()) 
    {
        [popover dismissPopoverAnimated:NO];
    }
    else
    {
        [controller dismissModalViewControllerAnimated:animated];
    }

    dictionaryShowing = NO;
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
  	searchDictionaryCellEnabled = GET_BOOL(@"FixedSearchDictionaryCell", NO);
}

/* called when a change to the preferences has been made */
static void ChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  	LoadSettings();
}


/* constructor of tweak */
%ctor
{
    dictionaryShowing = NO;
    spotDefineNow = NO;
	/* subsribe to preference changed notification */
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, ChangeNotification, CFSTR("com.tyhoff.spotdefine.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  	LoadSettings();
}