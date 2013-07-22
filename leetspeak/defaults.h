//
//  defaults.h
//  leetspeak
//
//  Created by Philip Schneider on 13.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#ifndef leetspeak_defaults_h
#define leetspeak_defaults_h


#define     APP_STORE_ID    @"584092014"

#ifdef DEBUG

#   define DLogFuncName()           NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
#   define DLog(fmt, ...)           NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define DLogBounds(uiview)		DLog(@"Frame of %@ -> x=%f y=%f w=%f h=%f",[uiview class ], uiview.bounds.origin.x, uiview.bounds.origin.y, uiview.bounds.size.width, uiview.bounds.size.height);
#   define DLogFrame(uiview)        NSLog(@"%s [Line %d] Frame of %@ -> x=%f y=%f w=%f h=%f",__PRETTY_FUNCTION__, __LINE__ ,  [uiview class ], uiview.frame.origin.x, uiview.frame.origin.y, uiview.frame.size.width, uiview.frame.size.height);
#   define DLogSize(CGSize)         NSLog(@"%s [Line %d] Size -> w=%f h=%f",__PRETTY_FUNCTION__, __LINE__ ,  CGSize.width, CGSize.height);
#   define DLogFrameWT(uiview)      DLog(@"Frame of %@ -> x=%f y=%f w=%f h=%f",[uiview.text substringToIndex:20], uiview.frame.origin.x, uiview.frame.origin.y, uiview.frame.size.width, uiview.frame.size.height);
#   define DLogRect(CGRect)         DLog(@"Frame of x=%f y=%f w=%f h=%f", CGRect.origin.x,CGRect.origin.y, CGRect.size.width, CGRect.size.height);
#   define DLogFont(UITextLabel)	NSLog(@"%s [Line %d] Font of %@ -> Font = %@, Color = %@, LineHeight = %f, Size = %f",__PRETTY_FUNCTION__, __LINE__ , [UITextLabel class], UITextLabel.font, UITextLabel.textColor , UITextLabel.font.lineHeight, UITextLabel.font.pointSize );
#   define DLogRetainCount(object)  DLog(@"Retain Count Of %@ = %d", object, [object retainCount]);
#   define DLogObj(object)          DLog(@"OBJECT [%@] = %@", [object class], object.description);
#   define DLogPoint(CGPoint)       NSLog(@"%s [Line %d] Point -> x=%f y=%f",__PRETTY_FUNCTION__, __LINE__ ,  CGPoint.x, CGPoint.y);
#   define DLogIndexPath(NSIndexPath) NSLog(@"%s [Line %d] IndexPath -> row=%d section=%d",__PRETTY_FUNCTION__, __LINE__ ,  NSIndexPath.row, NSIndexPath.section);


#define DEBUGVERSION                UILabel * debugVersionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.window.frame.size.width-40, self.window.frame.size.height-20, 50, 20)] autorelease];\
debugVersionLabel.backgroundColor = [UIColor clearColor];\
debugVersionLabel.font = [UIFont boldSystemFontOfSize:10];\
debugVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildMercurialIDLocale"];\
debugVersionLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
[self.window addSubview:debugVersionLabel];

#define DEBUGDATE                   UILabel * debugDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.window.frame.size.width/2), self.window.frame.size.height-20, 80, 20)] autorelease];\
debugDateLabel.backgroundColor = [UIColor clearColor];\
debugDateLabel.font = [UIFont boldSystemFontOfSize:10];\
debugDateLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"];\
debugDateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugDateLabel.textAlignment = UITextAlignmentCenter;\
[self.window addSubview:debugDateLabel];


#define DEBUGSYSTEM                   UILabel * debugSystemLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.window.frame.size.width/4), self.window.frame.size.height-20, 60, 20)] autorelease];\
debugSystemLabel.backgroundColor = [UIColor clearColor];\
debugSystemLabel.font = [UIFont boldSystemFontOfSize:10];\
debugSystemLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];\
debugSystemLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugSystemLabel.textAlignment = UITextAlignmentLeft;\
[self.window addSubview:debugSystemLabel];


#define DEBUGIOS                   UILabel * debugIOS = [[[UILabel alloc] initWithFrame:CGRectMake(self.window.frame.size.width-(self.window.frame.size.width/4), self.window.frame.size.height-20, 50, 20)] autorelease];\
debugIOS.backgroundColor = [UIColor clearColor];\
debugIOS.font = [UIFont boldSystemFontOfSize:10];\
debugIOS.text = [NSString stringWithFormat:@"iOS %@",SYSTEM_VERSION];\
debugIOS.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugIOS.textAlignment = UITextAlignmentLeft;\
[self.window addSubview:debugIOS];


#define DEBUMEMWARNING                   UILabel * debugMemWarningLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.window.frame.size.width/2)-50, 0, 100, 20)] autorelease];\
debugMemWarningLabel.backgroundColor = [UIColor clearColor];\
debugMemWarningLabel.font = [UIFont boldSystemFontOfSize:10];\
debugMemWarningLabel.text = @"MEMORY WARNING";\
debugMemWarningLabel.textColor = [UIColor redColor];\
debugMemWarningLabel.textAlignment = UITextAlignmentCenter;\
[self.window addSubview:debugMemWarningLabel];


#elif DEBUGFELDTEST


#define DEBUGVERSION                UILabel * debugVersionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.window.frame.size.width-40, self.window.frame.size.height-20, 50, 20)] autorelease];\
debugVersionLabel.backgroundColor = [UIColor clearColor];\
debugVersionLabel.font = [UIFont boldSystemFontOfSize:10];\
debugVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildMercurialIDLocale"];\
debugVersionLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
[self.window addSubview:debugVersionLabel];

#define DEBUGDATE                   UILabel * debugDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.window.frame.size.width/2), self.window.frame.size.height-20, 80, 20)] autorelease];\
debugDateLabel.backgroundColor = [UIColor clearColor];\
debugDateLabel.font = [UIFont boldSystemFontOfSize:10];\
debugDateLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"];\
debugDateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugDateLabel.textAlignment = UITextAlignmentCenter;\
[self.window addSubview:debugDateLabel];


#define DEBUGSYSTEM                   UILabel * debugSystemLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.window.frame.size.width/4), self.window.frame.size.height-20, 60, 20)] autorelease];\
debugSystemLabel.backgroundColor = [UIColor clearColor];\
debugSystemLabel.font = [UIFont boldSystemFontOfSize:10];\
debugSystemLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];\
debugSystemLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugSystemLabel.textAlignment = UITextAlignmentLeft;\
[self.window addSubview:debugSystemLabel];

#define DEBUMEMWARNING



#define DEBUGIOS                   UILabel * debugIOS = [[[UILabel alloc] initWithFrame:CGRectMake(self.window.frame.size.width-(self.window.frame.size.width/4), self.window.frame.size.height-20, 50, 20)] autorelease];\
debugIOS.backgroundColor = [UIColor clearColor];\
debugIOS.font = [UIFont boldSystemFontOfSize:10];\
debugIOS.text = [NSString stringWithFormat:@"iOS %@",SYSTEM_VERSION];\
debugIOS.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];\
debugIOS.textAlignment = UITextAlignmentLeft;\
[self.window addSubview:debugIOS];


#   define DLogFuncName()    //       NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
#   define DLog(fmt, ...)
#   define DLogBounds(uiview)
#   define DLogFrame(uiview)
#   define DLogSize(CGSize)
#   define DLogFrameWT(uiview)
#   define DLogRect(CGRect)
#   define DLogFont(UITextLabel)
#   define DLogRetainCount(object)
#   define DLogObj(object)
#   define DLogPoint(CGPoint)
#   define DLogIndexPath(NSIndexPath)

#else

#   define DLogFuncName()
#   define DLog(fmt, ...)
#   define DLogBounds(uiview)
#   define DLogFrame(uiview)
#   define DLogSize(CGSize)
#   define DLogFrameWT(uiview)
#   define DLogRect(CGRect)
#   define DLogFont(UITextLabel)
#   define DLogRetainCount(object)
#   define DLogObj(object)
#   define DLogPoint(CGPoint)
#   define DLogIndexPath(NSIndexPath)

#define DEBUGVERSION
#define DEBUGDATE
#define DEBUGSYSTEM
#define DEBUGIOS
#define DEBUMEMWARNING

#endif

#define IS_LANDSCAPE    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define IS_PORTRAIT     UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define IS_SIMULATOR    (TARGET_IPHONE_SIMULATOR)

#define IS_IPAD         UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
#define IS_IPHONE       UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IOS6         ([[[UIView alloc] init] respondsToSelector:@selector(constraints)])

#define APPDELEGATE     ((PSAppDelegate*)[[UIApplication sharedApplication] delegate])

#define APP_BACKGROUND_COLOR                [[UIColor alloc]initWithRed: 0.129412 green: 0.129412 blue: 0.129412 alpha: 1]
#define APP_SCREENSAVER_TIMER               60
#define APP_ERROR_DURATION_TIMERINTERVAL    1.0

// USERDEFAULTS

#define USERDEFAULTS_APP_FIRST_START    @"AppIsntVirgin"

#define USERDEFAULTS_CLIPOARD_INPUT     @"IgnoreClipboardForInput"
#define USERDEFAULTS_CLIPOARD_OUTPUT    @"IgnoreClipboardForOutput"

#define USERDEFAULTS_LEET_STRENGTH          @"LeetStrength"
#define USERDEFAULTS_LEET_STRENGTH_CHANGES  @"LeetStrengthChanged"

#define NOTIFICATION_SCREENSAVER_STARTED    @"notificationScreenSaverStarted"

/// SIZES 
#define BUTTON_WIDTH    40
#define BUTTON_HEIGHT   40

#define SLIDER_HEIGHT   24


#define INPUT_WIDTH_IPAD      601

#define INPUT_HEIGHT_IPAD_MAX_P     260
#define INPUT_HEIGHT_IPAD_MAX_L     150

#define INPUT_HEIGHT_IPAD_MIN_P     200
#define INPUT_HEIGHT_IPAD_MIN_L     75

#define INPUT_WIDTH_IPHONE    320

#define INPUT_HEIGHT_IPHONE5_MAX  188
#define INPUT_HEIGHT_IPHONE5_MIN  120

#define INPUT_HEIGHT_IPHONE_MAX  140
#define INPUT_HEIGHT_IPHONE_MIN  96


#endif
