#import "OCPOpenKeyboard.h"
#import <Cordova/CDVAvailability.h>
#import <objc/runtime.h>

@interface OCPOpenKeyboard () <UIScrollViewDelegate>

@property (nonatomic, readwrite, assign) BOOL keyboardIsVisible;

@end

@implementation OCPOpenKeyboard
//Description:键盘初始化
- (void)init:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSDictionary* options = [command argumentAtIndex:0 withDefault:nil];
    BOOL isDebug = [options[@"debug"]  isEqualToString:@"true"];

    if(isDebug){
        NSLog(@"键盘初始化...");
        NSLog(@"options: %@", options);
    }


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    self.webView.scrollView.delegate = self;

    NSString* setting = @"HideKeyboardFormAccessoryBar";
    if ([self settingForKey:setting]) {
        self.hideFormAccessoryBar = [(NSNumber*)[self settingForKey:setting] boolValue];
    }


    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"success": @"init success"}];
    //[result setKeepCallbackAsBool:true];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)keyboardWillShow:(NSNotification *)notif {

    [self.commandDelegate evalJs:
     [NSString stringWithFormat:@"cordova.fireWindowEvent('keyboardWillShow', { 'keyboardHeight': %f })",[self _keyboardHeight:notif]]
     ];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self.commandDelegate evalJs:@"cordova.fireWindowEvent('keyboardWillHide')"];
}

- (void)keyboardDidShow:(NSNotification *)notif {

    [self.commandDelegate evalJs:
     [NSString stringWithFormat:@"cordova.fireWindowEvent('keyboardDidShow', { 'keyboardHeight': %f })",[self _keyboardHeight:notif]]
     ];
}

- (void)keyboardDidHide:(NSNotification *)notif {

    [self.commandDelegate evalJs:@"cordova.fireWindowEvent('keyboardDidHide')"];

}

- (void)keyboardWillChangeFrame:(NSNotification *)notif {
     [self.commandDelegate evalJs:
        [NSString stringWithFormat:@"cordova.fireWindowEvent('keyboardHeightWillChange', { 'keyboardHeight': %f })",[self _keyboardHeight:notif]]
     ];
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}

- (id)settingForKey:(NSString*)key{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}


- (BOOL)hideFormAccessoryBar
{
    return _hideFormAccessoryBar;
}

static IMP UIOriginalImp;
static IMP WKOriginalImp;

- (void)setHideFormAccessoryBar:(BOOL)ahideFormAccessoryBar
{
    if (ahideFormAccessoryBar == _hideFormAccessoryBar) {
        return;
    }

    Method UIMethod = class_getInstanceMethod(NSClassFromString(@"UIWebBrowserView"), @selector(inputAccessoryView));
    Method WKMethod = class_getInstanceMethod(NSClassFromString(@"WKContentView"), @selector(inputAccessoryView));

    if (ahideFormAccessoryBar) {
        UIOriginalImp = method_getImplementation(UIMethod);
        WKOriginalImp = method_getImplementation(WKMethod);

        IMP newImp = imp_implementationWithBlock(^(id _s) {
            return nil;
        });

        method_setImplementation(UIMethod, newImp);
        method_setImplementation(WKMethod, newImp);
    } else {
        method_setImplementation(UIMethod, UIOriginalImp);
        method_setImplementation(WKMethod, WKOriginalImp);
    }

    _hideFormAccessoryBar = ahideFormAccessoryBar;
}

- (float)_keyboardHeight:(NSNotification *)notif{
    NSDictionary *userInfo = notif.userInfo;

    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.viewController.view convertRect:endFrameValue.CGRectValue fromView:nil];

    CGFloat height = keyboardEndFrame.size.height;
    return height;
}
@end
