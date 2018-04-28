#import "GohashMobilePlugin.h"
#import <gohash_mobile/gohash_mobile-Swift.h>

@implementation GohashMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGohashMobilePlugin registerWithRegistrar:registrar];
}
@end
