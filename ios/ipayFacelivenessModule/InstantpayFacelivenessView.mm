/*
#import "InstantpayFacelivenessView.h"

#import <react/renderer/components/InstantpayFacelivenessViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/InstantpayFacelivenessViewSpec/EventEmitters.h>
#import <react/renderer/components/InstantpayFacelivenessViewSpec/Props.h>
#import <react/renderer/components/InstantpayFacelivenessViewSpec/RCTComponentViewHelpers.h>

#if __has_include("React/RCTFabricComponentsPlugins.h")
#import "React/RCTFabricComponentsPlugins.h"
#elif __has_include("RCTFabricComponentsPlugins.h")
#import "RCTFabricComponentsPlugins.h"
#endif

// add this swift bridging header as a dependency
//#import "<PRODUCT_MODULE_NAME-Swift.h>" change PRODUCT_MODULE_NAME as per project
#if __has_include("InstantpayFaceliveness-Swift.h")
#import "InstantpayFaceliveness-Swift.h"
#elif __has_include("InstantpayFaceliveness/InstantpayFaceliveness-Swift.h")
#import "InstantpayFaceliveness/InstantpayFaceliveness-Swift.h"
//Add more swift bridging header as per project
#endif

using namespace facebook::react;

@interface InstantpayFacelivenessView () <RCTInstantpayFacelivenessViewViewProtocol>

@end

@implementation InstantpayFacelivenessView {
    //UIView * _view;
    InstantpayFacelivenessViewManager * _viewManager; //Added Swift Class
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<InstantpayFacelivenessViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const InstantpayFacelivenessViewProps>();
        _props = defaultProps;

        //_view = [[UIView alloc] init];
        _viewManager = [[InstantpayFacelivenessViewManager alloc] init]; //Init Swift Class
        
        //self.contentView = _view;
        self.contentView = [_viewManager getView]; //Add Swift Class to view
        
        _viewManager.responseCallback = ^(NSString* actionType, NSDictionary<NSString *, id>* eventData) {
            [self handleSubmit:actionType eventData:eventData];
        };
    }

    return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<InstantpayFacelivenessViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<InstantpayFacelivenessViewProps const>(props);
    
    //Commented coz swift class using
    //if (oldViewProps.color != newViewProps.color) {
    //    NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
    //    [_view setBackgroundColor:[self hexStringToColor:colorToConvert]];
    //}
    
    if(oldViewProps.options != newViewProps.options) {
        NSString* newOptions = [[NSString alloc] initWithUTF8String: newViewProps.options.c_str()];

        [_viewManager updateOptionsWithNewOptions:newOptions]; // updating options property
    }

    // if(oldViewProps.options != newViewProps.options) {
    //     NSMutableArray<NSNumber*>* newOptions = [[NSMutableArray alloc] init];

    //     // parsing options values to NSMutableArray<NSNumber*>*
    //     for (double option : newViewProps.options) {
    //         [newOptions addObject:@(option)];
    //     }

    //     [_manager updateOptionsWithNewOptions:newOptions]; // updating options
    // }
    
    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> InstantpayFacelivenessViewCls(void)
{
    return InstantpayFacelivenessView.class;
}

// - hexStringToColor:(NSString *)stringToConvert
// {
//     NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
//     NSScanner *stringScanner = [NSScanner scannerWithString:noHashString];

//     unsigned hex;
//     if (![stringScanner scanHexInt:&hex]) return nil;
//     int r = (hex >> 16) & 0xFF;
//     int g = (hex >> 8) & 0xFF;
//     int b = (hex) & 0xFF;

//     return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
// }

- (void)handleSubmit:(NSString*)actionType eventData:(NSDictionary<NSString *, id> *)eventData
{
    if(!_eventEmitter) {
        return;
    }
    
    if([actionType  isEqual: @"CANCELED"]){
        //React side onCancelCallback fn but here OnCancelCallback
        InstantpayFacelivenessViewEventEmitter::OnCancelCallback cancelEvent = {
            .message = [eventData[@"message"] UTF8String]
        };
        
        std::dynamic_pointer_cast<const InstantpayFacelivenessViewEventEmitter>(self->_eventEmitter)->onCancelCallback(cancelEvent);
    }
    else if([actionType  isEqual: @"ERRORED"]){
        //React side onErrorCallback fn but here OnErrorCallback
        InstantpayFacelivenessViewEventEmitter::OnErrorCallback errorEvent = {
            .errorMessage = [eventData[@"errorMessage"] UTF8String],
            .errorCause = [eventData[@"errorCause"] UTF8String],
            .recoverySuggestion = [eventData[@"recoverySuggestion"] UTF8String],
        };
        
        std::dynamic_pointer_cast<const InstantpayFacelivenessViewEventEmitter>(self->_eventEmitter)->onErrorCallback(errorEvent);
    }
    else if([actionType  isEqual: @"SUCCESS"]){
        //React side onSuccessCallback fn but here OnSuccessCallback
        InstantpayFacelivenessViewEventEmitter::OnSuccessCallback successEvent = {
            .sessionId = [eventData[@"sessionId"] UTF8String]
        };
        
        std::dynamic_pointer_cast<const InstantpayFacelivenessViewEventEmitter>(self->_eventEmitter)->onSuccessCallback(successEvent);
    }
    
}
@end
*/
