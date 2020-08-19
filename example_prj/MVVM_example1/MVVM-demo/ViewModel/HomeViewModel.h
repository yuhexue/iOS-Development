//
//  HomeViewModel.h
//  MVVM-demo
//

//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

//处理网络获取的数据
- (void)handleDataWithSuccess:(void (^)(NSArray *arr))success
                      failure:(void(^)(NSError *error))failure;

@end
