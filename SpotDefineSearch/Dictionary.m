#import <Foundation/Foundation.h>
#import <SearchLoader/TLLibrary.h>

#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)
#define URL_SCHEME @"http://spotdefine:"

@interface TLDictionaryDatastore : NSObject <SPSearchDatastore>
@end

@implementation TLDictionaryDatastore
- (void)performQuery:(SDSearchQuery *)query withResultsPipe:(SDSearchQuery *)results {
	NSString *searchString = [query searchString];
	NSMutableArray *searchResults = [NSMutableArray array];

	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"];
	bool autoCorrectEnabeld = GET_BOOL(@"AutoCorrectEnabled", YES);
	int limit = [[prefs objectForKey:@"MaxResults"] intValue] ?: 1;


	if (autoCorrectEnabeld)
	{
		/* check if the word exists in the local iOS dictionary */
		if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:searchString])
		{
			/* it exists and set that as the only cell */
			SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
			NSString *url = [NSString stringWithFormat:@"%@%@", URL_SCHEME, searchString];
			[result setUrl:url];
			[result setTitle:searchString];
			[searchResults addObject:result];
		}
		else
		{
			/* it doesn't exist and lets get some suggestions from autocorrect */
			UITextChecker *checker = [[UITextChecker alloc] init];
			NSRange checkRange = NSMakeRange(0, searchString.length);
			NSArray *corrections = [checker guessesForWordRange:checkRange inString:searchString language:@"en_US"];

			for (int idx = 0; idx < corrections.count && idx < limit; idx++) {
				
				NSString *word = [corrections objectAtIndex:idx];

				SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
				NSString *url = [NSString stringWithFormat:@"%@%@", URL_SCHEME, word];
				[result setUrl:url];
				[result setTitle:word];
				[result setSummary:@"AutoCorrection"];

				[searchResults addObject:result];
			}
		}
	}
	else 
	{
		/* it exists and set that as the only cell */
		SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
		NSString *url = [NSString stringWithFormat:@"%@%@", URL_SCHEME, searchString];
		[result setUrl:url];
		[result setTitle:searchString];
		[searchResults addObject:result];
	}

	

	TLCommitResults(searchResults, TLDomain(@"com.tyhoff.SpotDefine", @"SpotDefineSearch"), results);

	[results queryFinishedWithError:nil];	
}

- (NSArray *)searchDomains {
	return [NSArray arrayWithObject:[NSNumber numberWithInteger:TLDomain(@"com.tyhoff.SpotDefine", @"SpotDefineSearch")]];
}

- (NSString *)displayIdentifierForDomain:(NSInteger)domain {
	return @"com.tyhoff.SpotDefine";
}

@end
