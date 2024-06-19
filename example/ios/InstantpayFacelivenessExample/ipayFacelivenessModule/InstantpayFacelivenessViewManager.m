#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(InstantpayFacelivenessViewManager, RCTViewManager)

//RCT_EXPORT_VIEW_PROPERTY(color, NSString)

RCT_EXPORT_VIEW_PROPERTY(options, NSString)

RCT_EXPORT_VIEW_PROPERTY(onErrorCallback, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onCancelCallback, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onSuccessCallback, RCTBubblingEventBlock)


@end
