#include "swizzleHelper.h"

@implementation NSObject (YDSwizzleWKNavDelAuthChallenge)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(webView:didReceiveAuthenticationChallenge:completionHandler:);
        SEL swiz= @selector(YDHappywebView:didReceiveAuthenticationChallenge:completionHandler:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"WKWebView" Original:orig Swizzle:swiz];
    });
}

- (void)YDHappywebView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    
    NSLog(@"🍭Proceed given to challenge from host: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

@end
