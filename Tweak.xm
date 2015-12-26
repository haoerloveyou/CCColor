#import <UIKit/UIKit.h>



#define kCCColorSettings @"/var/mobile/Library/Preferences/com.cabralcole.cccolor.plist"

static NSMutableDictionary *settings;
void refreshPrefs()
{
		if(kCFCoreFoundationVersionNumber > 900.00){ // iOS 8.0

			[settings release];
			CFStringRef appID2 = CFSTR("com.cabralcole.cccolor");
			CFArrayRef keyList = CFPreferencesCopyKeyList(appID2, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if(keyList)
			{
				settings = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, appID2, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
				CFRelease(keyList);
			} else
			{
				settings = nil;
			}
		}
		else
		{
			[settings release];
			settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kCCColorSettings stringByExpandingTildeInPath]]; //Load settings the old way.
	}
}

static void killSpringBoard() {
	system("/usr/bin/killall -9 SpringBoard");
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
refreshPrefs();
}

%group main


/*
 dP""b8  dP"Yb  88b 88 888888 88""Yb  dP"Yb  88          dP""b8 888888 88b 88 888888 888888 88""Yb 
dP   `" dP   Yb 88Yb88   88   88__dP dP   Yb 88         dP   `" 88__   88Yb88   88   88__   88__dP 
Yb      Yb   dP 88 Y88   88   88"Yb  Yb   dP 88  .o     Yb      88""   88 Y88   88   88""   88"Yb  
 YboodP  YbodP  88  Y8   88   88  Yb  YbodP  88ood8      YboodP 888888 88  Y8   88   888888 88  Yb 
*/


%hook SBControlCenterContentContainerView


- (void)controlCenterWillPresent {

    if(settings != nil && ([settings count] != 0) && [[settings objectForKey:@"enabled"] boolValue]) {
    	%orig;
    	UIColor *backgroundColor =  MSHookIvar<UIColor *>(self,"_backgroundColor");
        [self setBackgroundColor:[self colorFromHex:[settings objectForKey:@"aColor"]]];
    }
    %orig;
}

%new
-(UIColor *)colorFromHex:(NSString *)hexString
{
    unsigned rgbValue = 0;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if (hexString) {
    NSArray *getAlpha = [hexString componentsSeparatedByString:@":"];

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

   return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:[[getAlpha objectAtIndex:1] floatValue]];

    }
	else return [UIColor whiteColor];
}
%end

%end

    %ctor {
	@autoreleasepool {
				settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kCCColorSettings stringByExpandingTildeInPath]];
				CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.cabralcole.cccolor/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
				refreshPrefs();
		%init(main);
	}
}
