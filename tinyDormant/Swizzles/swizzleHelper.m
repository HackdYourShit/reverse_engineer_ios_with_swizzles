#import "swizzleHelper.h"

@implementation SwizzleHelper: NSObject

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (void) swapMethods {
    
    BOOL didAddMethod = class_addMethod(targetClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        NSLog(@"🍭 didAddMethod: %@ && Class: %@", NSStringFromSelector(originalSelector), NSStringFromClass(targetClass));
        
        class_replaceMethod(targetClass,
                            replacementSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        NSLog(@"🍭 Method swap: %@", NSStringFromSelector(originalSelector));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id) initWithTargets: (const char *)target
              Original:(SEL)orig
               Swizzle:(SEL)swiz {
    NSLog(@"🍭Swizzle setup started...");
    self = [super init];
    if (self) {
        targetClass = objc_getClass(target);
        
        if (targetClass == NULL) {
            NSLog(@"\t🍭Stopped swizzle. Could not find %s class", target);
            return NULL;
        }
        targetSuperClass = class_getSuperclass(targetClass);
        originalSelector = orig;
        replacementSelector = swiz;
        originalMethod = class_getInstanceMethod(targetClass, originalSelector);
        swizzledMethod = class_getInstanceMethod(targetClass, replacementSelector);
        
        if (originalMethod == NULL || swizzledMethod == NULL) {
                NSLog(@"🍭\tStopped swizzle. originalMethod:  %p swizzledMethod: %p \n", originalMethod, swizzledMethod);
                return NULL;
        }
        
        [self swapMethods];
    }
    return self;
}
@end
