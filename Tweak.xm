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

- (_Bool)_shouldDisplayImagesForDomain:(unsigned int)arg1
{
	%log;
	return %orig;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (enabled) 
	{
		if (placeAtTop)
		{
			return %orig + 1;
		}
		else 
		{
			return %orig;
		}
	}

	return %orig;
	
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (enabled) 
	{
		if (placeAtTop) {
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
	}

	return %orig;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (enabled) 
	{
		if (placeAtTop) 
		{
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
			else 
			{
				NSInteger newSection = indexPath.section - 1;
				indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
				%orig;
			}
		}
		else 
		{
			if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1) 
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
			else
			{
				%orig;
			}
		}
	}
	else
	{
		%orig;
	}
}



- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

	if (enabled) 
	{
		if (placeAtTop)
		{
			SBSearchTableViewCell * cell;
			/* If it is our define cell, then let's edit it */
			if (indexPath.row == 0 && indexPath.section == 0) 
			{
				
				cell = [tableView dequeueReusableCellWithIdentifier:@"SBSearchTableViewCell"];
			    if (!cell)
			    {
			    	NSIndexPath *real = indexPath;

					indexPath = [NSIndexPath indexPathForRow:0 inSection:tableView.numberOfSections - 1];
					cell = %orig;

					indexPath = real;
			    }

			    //     cell = [[SBSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectContactCell"];

				/* set up the cell */
				cell.hasRoundedImage = NO;
				cell.hasImage = NO;
				cell.starred = NO;
				cell.badged = NO;
				cell.fetchImageOperation = nil;
				cell.shouldKnockoutImage = YES;
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
		else 
		{
		 	/* Create all cells the default way */
		  	SBSearchTableViewCell * cell = %orig;
		
		  	/* If it is our define cell, then let's edit it */
		  	if (indexPath.row == 2 && indexPath.section == tableView.numberOfSections - 1) 
		  	{
		    	cell.title = searchDictionaryString();
		  	}
		
		  	return cell;
		}
	}
	else 
	{
		return %orig;
	}	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (enabled) 
	{
		if (placeAtTop) 
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
		else 
		{
			return %orig;
		}
	}
	else 
	{
		return %orig;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (enabled)
	{
		if (placeAtTop) 
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
		else
		{
			if (section == tableView.numberOfSections - 1) 
			{
				return 3;
			}
			else
			{
				return %orig;
			}
		}
	}
	else
	{
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

		/* Dutch */
		case 4:
			return @"Woordenboek raadplegen";
			break;

		/* Spanish */
		case 5:
			return @"Buscar en Diccionario";
			break;

		/* French */
		case 6:
			return @"Rechercher dans le Dictionnaire";
			break;

		/* Japanese */
		case 7:
			return @"辞書を検索";
			break;

		case 8:
			return @"查找解释";
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