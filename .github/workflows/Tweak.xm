#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString * const kSuiteName = @"com.yourname.homebarurl";
static NSString * const kURLKey = @"targetURL";

@interface UIView (HomeBarURL)
- (void)homeBar_handleTap;
@end

%hook UIView

- (void)didMoveToWindow {
    %orig;
    
    // 只匹配系统原生小白条视图，全局只绑定一次手势
    if (self.window && [NSStringFromClass(self.class) containsString:@"HomeIndicator"]) {
        static const char kGestureAddedKey;
        if (!objc_getAssociatedObject(self, &kGestureAddedKey)) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(homeBar_handleTap)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView = NO; // 不干扰上滑/切换App等原生手势
            self.userInteractionEnabled = YES;
            [self addGestureRecognizer:tap];
            
            objc_setAssociatedObject(self, &kGestureAddedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)homeBar_handleTap {
    // 实时读取设置，修改后无需重启
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
    NSString *urlString = [defaults stringForKey:kURLKey];
    
    // 默认兜底地址
    if (!urlString || urlString.length == 0) {
        urlString = @"https://www.example.com";
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%end
