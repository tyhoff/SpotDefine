/*%%%%%
%% Dictionary.m
%% Dictionary Search Bundle
%% by tyhoff
%%
%%*/

/*
Copyright (c) 2009, KennyTM~
All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of the KennyTM~ nor the names of its contributors may be
   used to endorse or promote products derived from this software without
   specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Foundation/Foundation.h>
#import <SearchLoader/TLLibrary.h>

#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)

@interface TLDictionaryDatastore : NSObject <SPSearchDatastore>
@end

@implementation TLDictionaryDatastore
- (void)performQuery:(SDSearchQuery *)query withResultsPipe:(SDSearchQuery *)results {
	NSString *searchString = [query searchString];
	NSMutableArray *searchResults = [NSMutableArray array];

	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.tyhoff.spotdefine.plist"];
	bool autoCorrectEnabeld = GET_BOOL(@"AutoCorrectEnabled", YES);
	int limit = [[prefs objectForKey:@"MaxResults"] intValue] ?: 3;

	/* check if the word exists in the local iOS dictionary */
	if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:searchString])
	{
		/* it exists and set that as the only cell */
		SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
		[result setTitle:searchString];
		[searchResults addObject:result];
	}
	else
	{
 		if (autoCorrectEnabeld) {
			
			/* it doesn't exist and lets get some suggestions from autocorrect */
			UITextChecker *checker = [[UITextChecker alloc] init];
			NSRange checkRange = NSMakeRange(0, searchString.length);
			NSArray *corrections = [checker guessesForWordRange:checkRange inString:searchString language:@"en_US"];

			for (int idx = 0; idx < corrections.count && idx < limit; idx++) {
				
				NSString *word = [corrections objectAtIndex:idx];

				/* if the autocorrect word exists in the local dictionary */
				// if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:word])
				// {
					SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
					[result setTitle:word];
					[result setSummary:@"AutoCorrection"];

					[searchResults addObject:result];
				// }
			}
		}
	}

	TLCommitResults(searchResults, TLDomain(@"com.apple.DictionaryServices", @"DictionarySearch"), results);

	[results queryFinishedWithError:nil];	
}

- (NSArray *)searchDomains {
	return [NSArray arrayWithObject:[NSNumber numberWithInteger:TLDomain(@"com.apple.DictionaryServices", @"DictionarySearch")]];
}

- (NSString *)displayIdentifierForDomain:(NSInteger)domain {
	return @"com.apple.DictionaryServices";
}

@end
