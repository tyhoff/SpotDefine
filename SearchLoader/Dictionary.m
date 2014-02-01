/*%%%%%
%% Calculator.m
%% Spotlight+ Calculator Search Bundle
%% by theiostream
%%
%% Modified version of KennyTM's Calculator.searchBundle for iOS 5+
%%*/

/*
calculator.m ... Spotlight Calculator for iPhoneSimulator 3.0 (beta)
 
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


/* 

- (id)initWithTerm:(NSString *)term
+ (BOOL)dictionaryHasDefinitionForTerm:(NSString *)term
UIReferenceLibraryViewController

UITextChecker *checker = [[UITextChecker alloc] init];
  
NSRange checkRange = NSMakeRange(0, self.txView.text.length);

NSRange misspelledRange = [checker rangeOfMisspelledWordInString:self.txView.text 
                                                         range:checkRange
                                                    startingAt:checkRange.location
                                                          wrap:NO 
                                                      language:@"en_US"];

NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:self.txView.text language:@"en_US"];

self.txView.text = [self.txView.text stringByReplacingCharactersInRange:misspelledRange 
                                                           withString:[arrGuessed objectAtIndex:0]];



*/ 

#import <Foundation/Foundation.h>
#import <SearchLoader/TLLibrary.h>

@interface TLDictionaryDatastore : NSObject <SPSearchDatastore>
@end

@implementation TLDictionaryDatastore
- (void)performQuery:(SDSearchQuery *)query withResultsPipe:(SDSearchQuery *)results {
	NSString *searchString = [query searchString];
	NSMutableArray *searchResults = [NSMutableArray array];


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
		/* it doesn't exist and lets get some suggestions from autocorrect */
		UITextChecker *checker = [[UITextChecker alloc] init];
		NSRange checkRange = NSMakeRange(0, searchString.length);
		NSArray *corrections = [checker guessesForWordRange:checkRange inString:searchString language:@"en_US"];

		for (int idx = 0; idx < corrections.count && idx < 5; idx++) {
			
			NSString *word = [corrections objectAtIndex:idx];

			/* if the autocorrect word exists in the local dictionary */
			if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:word])
			{
				SPSearchResult *result = [[[SPSearchResult alloc] init] autorelease];
				[result setTitle:word];
				[result setSummary:@"AutoCorrection"];

				[searchResults addObject:result];
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
