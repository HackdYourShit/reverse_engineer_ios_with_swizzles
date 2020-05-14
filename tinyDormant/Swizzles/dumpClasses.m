#include "swizzleHelper.h"

@implementation NSObject (YDClassDumper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSLog(@"🍭 Started Class introspection...");
        Class *classes = objc_copyClassList(NULL);

        for(Class *cursor = classes; *cursor != nil; cursor++)
        {
            NSString *foundClass = [[NSString alloc] initWithCString:(class_getName(*cursor)) encoding:NSUTF8StringEncoding];

            NSLog(@"\t🍭[*]%@", foundClass);
//            if([foundClass containsString:@dumpClassSearchStr]){
//                NSLog(@"\t🍭[*]%@", foundClass);
//            }
        }
    });
}
@end
