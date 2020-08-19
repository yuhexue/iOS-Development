## MVC与MVVM：

MVC设计模式将应用中的对象分为3种角色：model, view, controller.该模式不仅定义了对象在应用中的角色，也定义了对象之间的相互交流方式。简单理解就是Model持有数据，views呈现用户交互界面，controller作为views和model的中间协调者。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/MVVM/MVC.png" style="zoom:50%;" />

**Model Objects**将具体的数据进行封装，并且定义逻辑和控制数据的处理。例如：model对象可能代表游戏中的角色，或者地址簿中的联系人，模型对象能够与其他对象有一对一或者一对多的关系。当应用被启动之后，应用中大多数持久化的数据都应该属于model对象，因为模型对象代表着与具体问题相关的知识和专家，它们能够被相似的问题进行重用。

**View Objects**代表用户能够看到的view。view对象最主要的目的是显示model对象的数据并响应用户交互。**而且view跟model解耦，不关联，这样view和model都能被复用**。

**Controller Objects**充当view objects和model objects的中介者，协调view和model的所有交互。

但在实际的开发过程中，使用MVC模式往往会导致controller过于庞大，所以新增了一个模块叫viewModel，由viewModel来引用model。 MVVM的架构图如下：
![](/Users/max/GithubRepositories/iOS-Develpoment/img/MVVM/MVVM.png)可以看到viewModel作为view和model的中间协调者。viewModel是一个非常好的地方来处理用户的输入验证逻辑，或者处理model对象中数据的格式化，并将相应的呈现逻辑告诉view，或者发起网络请求，以及其他类型的代码，但是记住一点，viewModel不能够引用view，换句话说，在viewModel中不应该导入UIKit框架进行任何UI相关的操作。

使用MVVM模式会增加一点代码量，但是减少了代码的复杂性，所以是值得使用MVVM模式的。

## MVVM 模式

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/MVVM/MVVM-Concept.png" style="zoom:33%;" />

###### View

尽量通过自定义视图来实现 UI 的复用，但不要参杂更新数据等业务逻辑。因为有了 ViewModel 后，UI 组件的更能更加纯粹，只是用于显示界面而已。UI 所以来的数据都交由 ViewModel 维护。

View 持有 ViewModel，并负责将 View 属性绑定到 ViewModel 的数据上。

TableView 的 DataSource 由 ViewModel 产生。View 向 ViewModel 要数据，View 内部不会处理数据。

###### ViewController

VC 只需创建 TableView，并将 TableViewModel 绑定到 TableView 上。传统 MVC 的设计模式导致 ViewController 很重，过去 VC 承载的大量业务逻辑将会被挪到 ViewModel 中。ViewController 之间的跳转需要通过 URL 路由来解耦。

###### Model 

网络请求协议定好后，就可以先实现数据层的 Model（包括数据的编包解包）。

Model 里包含很多字段，不同场景的 UI 一般只会用到一部分字段，也就是 ViewModel 所承载的字段。

由于一个 Model 对象可能被多个业务下的 ViewModel 持有，建议 Model 的属性都是 `readonly` 的，防止外部篡改数据，避免多线程问题。可以声明接口来修改 Model 数据，内部做线程安全保护。

###### ViewModel

ViewModel 提供了 View 展示 UI 所需的所有数据，并负责调用业务逻辑 Service（如请求后台数据，数据处理等），还持有 Model。

从网络层拿到 Model 后，还需要转成 ViewModel 才能使用。Model 数据变化也需要及时同步到 ViewModel 上，可考虑使用 RAC 完成数据绑定。将 Model 传入 ViewModel 后，ViewModel 会持有 Model。

ViewModel 需要遵循的几个规则：
不能包含任何 UI 代码，不能 import UIKit
所有属性都为 readonly
ViewModel 复用的前提是其 View 被复用
如果 View 有 subview，也可以有对应的 sub-viewmodel
不是所有 View 都必须有 ViewModel，控制好最小粒度
如果 ViewModel 之间需要通讯，切层级较远，建议使用抛通知的方式解耦。

###### Service层

ViewModel 负责调用业务 Service 接口。一些简单非通用逻辑可以写在 ViewModel 里，独立且较重的业务逻辑、可复用的脚手架都需要封装起来供 ViewModel 调用。

Service 也是单元测试的重点。关于业务 Service 的一些规范：

1. 业务 Service 对外暴露的接口可能会有数据拉取、写入、处理等操作，也可能会有通知显示红点等纯业务逻辑。
2. 业务 Service 类放在各自的业务目录下，不要求单独创建 Service 文件夹，但文件类命名上以 "Service" 为后缀。
3. 业务 Service 类的负责人为负责该业务的人，如果其他人需要向其中添加代码，也需要负责 CR 和后期维护。责任田可以看项目演变而调整，但一定要有负责人，避免一个文件大家随便改的局面。
4. 如果一个 Service 涉及到多条网络协议请求，可以将每条协议对应的网络请求和数据库操作接口封装成 DataManager 类。Service 作为上层封装来调用 DataManager。

###### 数据层 & 网络层

负责本地数据库的读写，网络请求，处理回包。

#### **一句话描述**：

**view**：init->setUpView（包括布局）->控件的初始化(new)->数据加载/显示（这一步绑定VM）->重写控件的方法（此步option）
**viewController**：viewDidLoad->setUpView->数据绑定->数据传值（代理回调）
**viewModel**：会引用自己的view所需要的model（数据交互）
**model**：一般是数据定义（包括后台的裸数据）

注意⚠️：为了避免ViewController太重，还可以把TableView的DataSource和Delegate抽离

#### Talk is cheap, show me the code：

[🌰MVVM_example1](./example_prj/MVVM_example1)
[🌰MVVM_example2](./example_prj/MVVM_example2)

###### 实践🌰：注册路由和内部跳转

```objective-c
//RASetLadyTrialViewController.m
@implementation RASetLadyTrialViewController

/**
注册url
*/
+ (void)load
{
    id handlerBlock = [JLRRouteHandler handlerBlockForTargetClass:[RASetLadyTrialViewController class]
                                                       completion:^BOOL (RASetLadyTrialViewController *viewController) {
        BOOL animated = [viewController.parameters[@"animated"] boolValue];
        viewController.hidesBottomBarWhenPushed = YES; //非必须
        [[ApplicationUtil navigationViewController] pushViewController:viewController animated:animated];
        return YES;
    }];
    //注册一个被调用的公共路由名
    [[JLRoutes globalRoutes] addRoute:@"/girlQuestion" handler:handlerBlock];
}

#pragma mark - JLRRouteHandlerTarget
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters
{
    NSString *routeUrl = @"page/GirlQuestion";  //三端约定的真正路由名
    
    if (self = [self initWithUrl:routeUrl query:nil])
    {
        self.parameters = parameters;
    }
    return self;
}

@end
  

//RAMatchBothLikeViewController.m
/**
内部跳转
*/  
- (void)clickSetTrialBtn:(id)action
{    
    NSString *urlString = [NSString stringWithFormat:@"/girlQuestion?animated=true"];
    [JLRoutesHelper.sharedInstance routeURL:[NSURL URLWithString:urlString] withParameters:nil callback:^(id  _Nonnull result) {
        //callback(result);
    }];
}  
```

**Tips**:[依赖注入的相关概念](https://www.zhihu.com/question/32108444)



**更多补充待完善**…