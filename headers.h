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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (id)tableView:(id)arg1 viewForHeaderInSection:(long long)arg2;
- (_Bool)_shouldDisplayImagesForDomain:(unsigned int)arg1;
@end

@interface SBSearchTableHeaderView
@property(retain, nonatomic) NSString *title;
@end

@interface SBSearchTableViewCell : UITableViewCell
@property(retain, nonatomic) NSString *title;
@property(nonatomic, getter=isLastInSection) _Bool lastInSection;
@property(nonatomic, getter=isFirstInSection) _Bool firstInSection;
@property(nonatomic) _Bool shouldKnockoutImage; // @synthesize shouldKnockoutImage=_shouldKnockoutImage;
@property(nonatomic, getter=hasRoundedImage) _Bool hasRoundedImage; // @synthesize hasRoundedImage=_hasRoundedImage;
@property(retain, nonatomic) NSOperation *fetchImageOperation; // @synthesize fetchImageOperation=_fetchImageOperation;
@property(nonatomic, getter=hasImage) _Bool hasImage; // @synthesize hasImage=_hasImage;
@property(nonatomic, getter=isStarred) _Bool starred; // @synthesize starred=_starred;
@property(nonatomic, getter=isBadged) _Bool badged; // @synthesize badged=_badged;
- (void)updateBottomLine;
- (void)setIsLastInSection:(_Bool)arg1;
@end