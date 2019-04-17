
#import "RNJmDeviceWifiActivator.h"
#import <TuyaSmartHomeKit/TuyaSmartKit.h>
#import <objc/runtime.h>
@interface RNJmDeviceWifiActivator()<TuyaSmartActivatorDelegate>
@property(nonatomic, copy) RCTPromiseResolveBlock resolveBlock;
@property(nonatomic, copy) RCTPromiseRejectBlock rejectBlock;

@end
@implementation RNJmDeviceWifiActivator


RCT_EXPORT_MODULE(RNJmDeviceWifiActivator)
#pragma mark - EZ/AP配网
RCT_EXPORT_METHOD(startConfigWiFi:(NSString *)status ssid:(NSString *)ssid password:(NSString *)password token:(NSString *)token
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    self.resolveBlock = resolve;
    self.rejectBlock = reject;
    [TuyaSmartActivator sharedInstance].delegate = self;
    if([status isEqualToString:@"EZ"]){
        [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeEZ ssid:ssid password:password token:token timeout:100];
    }else if ([status isEqualToString:@"AP"]){
        [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeAP ssid:ssid password:password token:token timeout:100];
    }else if ([status isEqualToString:@"Zigbee"]){
        [[TuyaSmartActivator sharedInstance] startConfigWiFiWithToken:token timeout:100];
    }
}
#pragma mark - Zigbee配网开始
RCT_EXPORT_METHOD(startConfigZigbeeWiFiWithToken:(NSString *)token
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    self.resolveBlock = resolve;
    self.rejectBlock = reject;
    [TuyaSmartActivator sharedInstance].delegate = self;
    [[TuyaSmartActivator sharedInstance] startConfigWiFiWithToken:token timeout:100];
}
#pragma mark - Zigbee子设备配网开始
RCT_EXPORT_METHOD(startConfigZigbeeChildWiFiWithDeviceId:(NSString *)deviceId
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    self.resolveBlock = resolve;
    self.rejectBlock = reject;
    [TuyaSmartActivator sharedInstance].delegate = self;
    [[TuyaSmartActivator sharedInstance] activeSubDeviceWithGwId:deviceId timeout:100];
}
#pragma mark - Zigbee子设备停止配网
RCT_EXPORT_METHOD(stopConfigZigbeeChildWiFiWithDeviceId:(NSString *)deviceId
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [TuyaSmartActivator sharedInstance].delegate = nil;
    [[TuyaSmartActivator sharedInstance] stopActiveSubDeviceWithGwId:deviceId];
}
#pragma mark - 停止配网
RCT_EXPORT_METHOD(stopConfigWifi)
{
    [TuyaSmartActivator sharedInstance].delegate = nil;
    [[TuyaSmartActivator sharedInstance] stopConfigWiFi];
    
}
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
#pragma mark - TuyaSmartActivatorDelegate
- (void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {
    
    if (!error && deviceModel) {
        self.resolveBlock([self dicFromObject:deviceModel]);
    }
    if (error) {
        self.rejectBlock(@"400", @"配网失败",error);
    }
}

//模型转字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}
@end

