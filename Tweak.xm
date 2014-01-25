#import "headers.h"

#define GET_INT(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).intValue : default)
#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)

UIReferenceLibraryViewController *controller;
bool enabled;
bool placeAtTop;
int language;


static NSString* searchDictionaryString();

/* if Search Web clicked, close the dictionary view */
%hook UIReferenceLibraryViewController
- (void)_searchWeb:(id)arg1
{
	%orig;
	[self dismissModalViewControllerAnimated:NO];
}
%end

/* hook into Spotlights View Controller */
%hook SBSearchViewController

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
	else
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
		cell.title = searchDictionaryString();
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
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

static NSString* searchDictionaryString()
{
	switch (language)
	{
		/* English */
		case 0:
			return @"Search Dictionary";
			break;

		/* Italian */
		case 1:
			return @"Cerca sul Dizionario";
			break;

		/* German */
		case 2:
			return @"Wörterbuch-Suche";
			break;

		/* Korean */
		case 3:
			return @"사전 검색";
			break;
	}
	return @"Search Dictionary";
}

/* called when a change to the preferences has been made */
static void LoadSettings()
{
  	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"];
  	enabled = GET_BOOL(@"enabled", YES);
  	placeAtTop = GET_BOOL(@"placeAtTop", YES);
  	language = GET_INT(@"language", 0);
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