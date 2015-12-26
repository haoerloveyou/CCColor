#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Cephei/HBPreferences.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAboutListController.h>

@interface CCColorPrefsListController: HBAboutListController{
}
@end

@implementation CCColorPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CCColorPrefs" target:self] retain];
	}
	return _specifiers;
}

+ (UIColor *)hb_tintColor {
     return [UIColor colorWithRed: 155.0/255.0 green: 75.0/255.0 blue: 235.0/255.0 alpha: 1.0];
}

-(void) killSpringBoard {
	system("/usr/bin/killall -9 SpringBoard");
}

- (void)viewWillAppear:(BOOL)animated
{
	[self clearCache];
	[self reload];
	[super viewWillAppear:animated];
}
@end


@interface CCColorCreditsListController: HBAboutListController {
}
@end

@implementation CCColorCreditsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Credits" target:self] retain];
         }
        return _specifiers;
}

@end

// vim:ft=objc
