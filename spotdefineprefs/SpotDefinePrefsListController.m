//
//  SpotDefinePrefsListController.m
//  SpotDefinePrefs
//
//  Created by Tyler H on 16.02.2014.
//  Copyright (c) 2014 Tyler H. All rights reserved.
//

#import "SpotDefinePrefsListController.h"

@implementation SpotDefinePrefsListController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"SpotDefinePrefs" target:self];
	}
    
	return _specifiers;
}

- (void)cydia {

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/com.tyhoff.spotdefine"]];
    }
}

- (void)donate {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=tyhoffman1%40gmail%2ecom&lc=US&item_name=tyhoff%20tweaks&currency_code=USD"]];
}

- (void)source {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/tyhoff/spotdefine"]];   
}
@end
