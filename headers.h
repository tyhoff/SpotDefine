#import <SearchLoader/TLLibrary.h>

#define GET_INT(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).intValue : default)
#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)

#define SpotDefineIdentifier @"com.tyhoff.spotdefine"
#define LocalizationsDirectoryPath @"/Library/Application Support/SpotDefine/Localizations"
#define UserDefaultsPlistPath @"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"

static NSString *SpotDefineLocalizedString(NSString *string);
static BOOL isIpad();
static void dismissDictionary(bool animated);

/* Headers from private frameworks */

@interface SBSearchHeader
@property(readonly, nonatomic) UITextField *searchField;
@end;

@interface SBSearchTableViewCell : UITableViewCell
@property(retain, nonatomic) NSString *title;
- (void)setIsLastInSection:(_Bool)arg1;
@end

@interface SBSearchViewController : UIViewController
{
    SBSearchHeader *_searchHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (id)tableView:(id)arg1 viewForHeaderInSection:(long long)arg2;
- (void)tableView:(UITableView *)tableView presentDictionaryWithTerm:(NSString *)term nearCell:(SBSearchTableViewCell *)cell;
- (void)dismiss;
@end

@interface SBSearchTableHeaderView
@property(retain, nonatomic) NSString *title;
@end

@interface SBUIController
- (_Bool)_activateAppSwitcherFromSide:(int)arg1;
@end

@interface SBSearchModel
- (id)launchingURLForResult:(SPSearchResult *)result withDisplayIdentifier:(NSString *)identifier andSection:(SPSearchResultSection *)section;
@end

@interface SBWorkspace
- (void)workspace:(id)arg1 applicationDidStartLaunching:(id)arg2;
@end

@interface SpringBoard (URLCore)
- (void)_openURLCore:(id)arg1 display:(id)arg2 animating:(_Bool)arg3 sender:(id)arg4 additionalActivationFlags:(id)arg5 activationHandler:(id)arg6;
@end