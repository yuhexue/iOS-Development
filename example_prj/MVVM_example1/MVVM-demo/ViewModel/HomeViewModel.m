//
//  HomeViewModel.m
//  MVVM-demo
//
//处理网络请求，上传或拉取view所需的数据模型
//

#import "HomeViewModel.h"
#import "APIClient.h"
#import "Define.h"
#import "HomeModel.h"

@implementation HomeViewModel

//处理网络获取的数据
- (void)handleDataWithSuccess:(void (^)(NSArray *arr))success failure:(void(^)(NSError *error))failure{
    
    [[APIClient sharedManager] netWorkGetHomePageListWithPageSize:20 pageNum:0 success:^(Response *respone) {
        NSLog(@".......respone.description : %@",respone.description);
        
        if (respone.status==kEnumServerStateSuccess) {
            NSLog(@"请求成功!");
            
            NSMutableArray *tmpArr=[NSMutableArray array];
            for (NSDictionary *subDic in (NSArray *)[respone.data valueForKey:@"results"]) {
                HomeModel *model=[[HomeModel alloc]initWithDic:subDic];
                [tmpArr addObject:model];
            }
            success(tmpArr);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
