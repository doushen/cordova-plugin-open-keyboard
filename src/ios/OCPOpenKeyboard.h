#import <Cordova/CDV.h>

@interface OCPOpenKeyboard : CDVPlugin{

    @protected
    BOOL _hideFormAccessoryBar;

}

@property (readwrite, assign) BOOL hideFormAccessoryBar;

//Description:键盘初始化
- (void) init:(CDVInvokedUrlCommand*)command;

@end