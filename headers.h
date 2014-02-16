#define CouriaIdentifier @"com.tyhoff.spotdefine"
#define ExtensionsDirectoryPath @"/Library/Application Support/Couria/Extensions"
#define LocalizationsDirectoryPath @"/Library/Application Support/SpotDefine/Localizations"
#define PreferenceBundlePath @"/Library/PreferenceBundles/Couria.bundle"
#define UserDefaultsPlistPath @"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"
// #define UserDefaultsChangedNotification "com.tyhoff.spotdefine.preferencechanged"
// #define EnabledKey @"Enabled"

#define GET_INT(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).intValue : default)
#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)


/* Headers from private frameworks */

static NSString *SpotDefineLocalizedString(NSString *string);
static BOOL isIpad();
static void dismissDictionary();

@interface SBSearchHeader
@property(readonly, nonatomic) UITextField *searchField;
@end;

@interface SBSearchTableViewCell : UITableViewCell
@property(retain, nonatomic) NSString *title;
@property(nonatomic, getter=isLastInSection) _Bool lastInSection;
@property(nonatomic, getter=isFirstInSection) _Bool firstInSection;
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