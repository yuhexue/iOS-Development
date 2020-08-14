### 1，制作开发者证书

开发者证书分为 开发 和 发布 两种，类型为ios Development,iOS Distribution。 平常开发用development证书和BundleID因为要真机调试，上线的时候在换成iOS Distribution。

### 2，关键字：

nonatomic 是非原子的，线程不安全的。使用非原子能得到较好的性能，但不能在多线程环境下使用。
retain，对于实例变量而言，使用 retain 使得属性在赋值后一直到对象被销毁前始终可用。如果实例变量或属性并不是对象类型，而是一个简单类型，如 BOOL、int、id、float，则用 assign 关键字替换 retain 关键字。 这样属性在赋值时不会被持有，这样导致的直接后果是:刚对一个属性赋值后，再访问这个属性，这个属性就变成空了。

atomic和nonatomic用来决定编译器生成的getter和setter是否为原子操作。atomic设置成员变量的@property属性时，默认为atomic，提供多线程安全。在多线程环境下，原子操作是必要的，否则有可能引起错误的结果。加了atomic，setter函数会变成下面这样：

```objective-c
{lock}
if (property != newValue) { 
  [property release]; 
  property = [newValue retain]; 
}
{unlock}
```

retain,copy,assign理解 区别 使用

举个例子:

  NSString *houseOfMM = [[NSString alloc] initWithString:'装梵几的三室两厅']; 

上面一段代码会执行以下两个动作:  

1 在堆上分配一段内存用来存储@' 装梵几的三室两厅 ' ,比如:内存地址为 0X1111 内容为 ' 装梵几的三室两厅' ，  

2 在栈上分配一段内存用来存储 houseForWife ,比如:地址为 0XAAAA 内容自然为 0X1111   

下面分别看下(assign,retain,copy):  

1.assign的情况: NSString * myHouse = [ houseOfMM  assign ];  

此时 myHouse 和 houseOfMM 完全相同,地址都是 0XAAAA ,内容为 0X1111 ,即 myHouse 只是 houseOfMM 的别名,对任何一个操作就等于对另一个操作。因此 retainCount不需要增加.(同进同出，关系好，一把钥匙，给我拿着)  

2.retain的情况： NSString * myHouse = [ houseOfMM  retain ];  

此时 myHouse 的地址不再为 0XAAAA ,可能为 0XAABB ,但是内容依然为 0X1111 .因此 myHouse 和 houseOfMM 都可以管理' 装梵几的三室两厅 '所在的内存。因此 retainCount 需要增加1.（有些独立，各自进出，两把钥匙）  

3.copy的情况： NSString * myHouse = [ houseOfMM  copy ];  

此时会在堆上重新开辟一段内存存放@'装梵几的三室两厅',比如0X1122,内容为@'装梵几的三室两厅',同时会在栈上为myHouse分配空间,比如地址:0XAACC,内容为0X1122,因此retainCount增加1供myHouse来管理0X1122这段内存.(两套@'装梵几的三室两厅'，条件好，分居了，房子一人一套，所以钥匙一人一把。)



什么时候用assign,当然是破房子，简装的房子

基础类型（简单类型，原子类型）：NSInteger,CGPoint,CGFloat,C数据类型（int,float,double,char等）

什么时候用retain

其他NSObject和其子类对象 (大多数)

什么时候用copy

含有可深拷贝的mutable子类的类，如NSArray，NSSet，NSDictionary，NSData的，NSCharacterSet，NSIndexSet，NSString(可深度拷贝的房子)，但是NSMutableArray这样的不可以，Mutable的不能用copy,不然初始化会有问题。切记

### 3.ARC

基于自动释放池的内存管理
Cocoa 引入了自动释放池(autorelease pool)的概念。自动释放池实际是一个对象集合或 对象容器的概念。如果你把所有的对象在创建时，都放到这个池中，则自动释放池被销毁时， 池中的对象都会接收到 release 消息。
要把对象加入到自动释放池中，只需在创建对象的同时调用 autorelease 方法。
NSString ∗string=[[[NSString alloc]initWithString:@”I am a string”] autorelease];



ARC中的strong相当于非ARC中的retain，ARC来了以后多搞一把钥匙就strong了。

ARC：自动引用计数，当编译器选项设置为ARC有效时，无需键入retain和release。

autorelease具体使用：

生成并持有NSAutoreleasePool对象

调用已分配对象的autorelease实例方法

废弃NSAutoreleasePool对象

NSAutoreleasePool *pool = [[NSAutoreleasePool] alloc init];

id obj = [[NSObject alloc] init];

[obj autorelease];

[pool drain];    //等同于[obj release]

 由于程序主循环的NSRunloop对NSAutoreleasePool进行生成，持有和释放，故开发者不一定需要使用NSAutoreleasePool。但在大量产生autorelease对象时，只要不废弃NSAutoreleasePool对象，那么生成的对象就不能释放。典型例子如读入图像数据并改变大小，文件-NSData-UIImage-新UIImage，也会随时间造成大量内存不能及时释放

for(int i = 0;i < images.count;++i)

{

NSAutoreleasePool *pool = [[NSAutoreleasePool] alloc init];

/*

 *读入图像

 *大量产生autorelease对象

 */

[pool drain];    //等同于[obj release]

}

```objective-c
//ARC示范

#import <Foundation/Foundation.h>


@interface SampleClass:NSObject

- (void)sampleMethod;

@end


@implementation SampleClass

- (void)sampleMethod {

  NSLog(@"Hello, World! \n");

}


- (void)dealloc {

 NSLog(@"Object deallocated");

}

@end


int main() {

  /* my first program in Objective-C */

  @autoreleasepool {

   SampleClass *sampleClass = [[SampleClass alloc]init];

   [sampleClass sampleMethod];

   sampleClass = nil;

  }

  return 0;

}

```

### 4.MVC 模式

MVC 模式把应用程序 GUI 代码根据功能拆分为不同的类或组件:
􏰀 “模型”:用于封装应用程序的数据;
􏰀 “视图”:负责显示和编辑数据:
􏰀 “控制器”:负责处理前两者之间的逻辑关系。

### 5.KVO(key-value observer)

它可以使一个对象在属性值发生变化时主动通知另一个对象并触发相应的方法。KVO 是一种绑定技术(Cocoa 还提供另外一种绑定技术:Dynamic bingding)。 它是由被观察的对象主动通知观察者的，并不需要经过一个统一的通知中心，它的执行效率和适用场景要更佳。
实现 KVO步骤:

```objective-c
//1，注册 KVO
[account addObserver:inspector 
forKeyPath:@"name"
options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
context:NULL];

//移除KVO
[account removeObserver:inspector forKeyPath:@"name"];
```

inspector 是account 对象的观察者，关注“name” 属性的变更。
KeyPath 是一个字符串，用于表示某个属性，你可以直接用属性名。如果属性是一个对象，则可为 “account.name”。
options 注明了对该属性的何种状态感兴趣。NSKeyValueObservingOptionNew和NSKeyValueObservingOptionOld 表示变更前后的值。当 name 属性变更时，会将这两个新旧值以 NSDictionary 的方式提交给观察者，观察者可以从 NSDictionary 中以键-值对的方式检索到这两个值。
context 参数用于传递一个对象，该对象(或指针)会在属性变化时通过变更通知传递给观察者(通过 context 参数)。
移除观察者的注册，

//2.接收变更通知
//观察者要想收到对象的属性变更通知，需要实现方法 observeValueForKeyPath，并在其中进行通知的处理。例如:

```objective-c
-(void)observeValueForKeyPath:(NSString ∗)keyPath 
															ofObject:(id)object
															change:(NSDictionary ∗)change 
															context:(void ∗)context

{ 
  NSLog(@"%@",keyPath);
  if ([keyPath isEqual:@"name"]) {
  	NSLog(@"name is changed:%@",
  	[change objectForKey:NSKeyValueChangeNewKey]);
	}else
	[super observeValueForKeyPath:keyPath
															ofObject:object change:change context:context];
}
```

//3.发送变更通知
//NSObject 支持两种属性变更通知，一种是自动变更通知，一种是手动变更通知。一般情况下使用自动变更通知则更为简单。
1.自动变更通知
要使用自动变更通知，需要实现被观察者的 automaticallyNotifiesObserversForKey 方法， 在此方法中明确说明需要使用自动变更通知的属性。对于需要使用自动变更通知的属性，返回 YES，如下代码所示:

```objective-c
- (BOOL) automaticallyNotifiesObserversForKey:(NSString∗)key {
	// 对于属性 name ，使用自动通知
	if ([key isEqualToString:@"name"]) {
		return YES; 
  }
	// 确保调用了父类的 automaticallyNotfiesObserversForKey 方法 
  return [super automaticallyNotifiesObserversForKey:key];
}
```

然后，在 name 属性发生变化的时候通知观察者，比如调用以下语句之一:

```objective-c
subject.name=newName;
[subject setValue:newName forKey:@"name"]; [subject setValue:newName forKeyPath:@"name"];
```

如果属性是集合类型，则可以使用方法 mutableSetValueForKey 来支持以下集合方法导致 的自动变更通知:
􏰀添加:insertObject:InKey:或者 insertObject:AtIndex:
􏰀替换:replaceObject:InKey:或者 replaceObject:AtIndex: 􏰀 删除:removeObjectFromKey:或者 removeObjectAtIndex:

### 6，block

1.块变量声明

```objective-c
int multiplier = 7;
int (^myBlock)(int) = ^(int num) {
	return num ∗ multiplier; 
};
printf ( "%d", myBlock(3));
//变量声明解析
int (^myBlock)(int) = ^(int num) {return num ∗ multiplier; };
```

返回值，块变量，参数表列（多参数用逗号），块定义【初始化块变量】（参数说明【参数类型和参数名】，块体）

返回值类型，如 int、double，如果未显式地声明块的返回值类型，可能会自动从块代

码中推断返回类型(通过 return 语句)。

- 块变量名用括号括住，块变量名前加^符号。

- 􏰀参数类型用括号括住，多个参数以逗号分隔，如果参数列表为 void，而且返回类型依

  靠推断，可以省略参数列表的 void。

- 􏰀等号，将后面的块赋值给前面的块变量(即 myBlock)。

- 块体，同函数体。一旦声明了块，你可以像使用函数一样调用它。

2.行内块

有时候，你不准备重复使用某个块，因此你不必为它想一个名称。那你可以使用行内块而不用声明为块变量。

```objective-c
qsort_b(myCharacters, 3, sizeof(char ∗), 
  ^(const void ∗l, const void ∗r) {
    char ∗left = ∗ (char ∗∗)l;
    char ∗right = ∗ (char ∗∗)r; 
    return strncmp(left, right, 1);
	}
);
```

在 qsort_b 方法调用中，第 4 个参数就是一个匿名的块(行内块)。匿名块跟块变量不同， 它没有变量名，因此你无法重用匿名块。下次调用这个块时，必须把整个块定义的代码再复制 一遍。

3.__block 关键字

块允许访问本地变量。它使得我们在线程间共享变量变得简单，而且，你可以规定一个本地变量是否可以写，这可通过使用__block 关键字，这是一种类似 register、auto 和 static 存储类型修饰符。用__block 修饰的变量，可以在所有同一作用域内的块，以及块复制之间共享数据。在指定作用域内的多个块能同时使用共享变量。__block 变量有两个限制:不能是可变长度的数组，也不能是包含 C99 可变长度数组的结构体。下面显示了__block 变量的使用:

```objective-c
__block int x = 123; // x 是块可写的
void (^printXAndY)(int) = ^(int y) {
  x = x + y;
  printf("%d %d\n", x, y); 
};
printXAndY(456); // 打印出: 579 456 
// x 现在的值是:579
```

下面显示了在块中使用多种类型的变量:

```objective-c
extern NSInteger CounterGlobal; 
static NSInteger CounterStatic; 
{
NSInteger localCounter = 42; 
__block char localCharacter; 
void (^aBlock)(void) = ^(void) {
  ++CounterGlobal; 
  ++CounterStatic; 
  CounterGlobal = localCounter; 
  localCharacter = 'a';
};
  ++localCounter; 
	localCharacter = 'b'; 
	aBlock();
}
```

block可以在任何时候执行。

标识符 ^

用途：

定义BLOCK变量

利用block封装代码

Block访问外部变量

1）Block内部可以访问外部变量；

2）默认情况下，Block内部不能修改外部的局部变量

3）给局部变量加上__block关键字，则这个局部变量可以在block内部进行修改。

利用typedef定义block类型(和指向函数的指针很像)



xcode工程目录：

.plist //用于定义应用信息，如程序图标，程序包名称，语言类型和版本,bundle identifier

.pch //预编译头文件，包含一些常用的头文件，节省整个项目的编译时间

.xib //interface builder创建的二进制文件

资源文件//如图片，音视频

源代码//.h .m

framework框架

沙盒机制：应用程序对文件系统的访问限制在一个安全范围内，具体细节略





多线程和并行编程

GCD+dispatch queue



//我们在实现单例时候都会使用synchronized或者dispatch_once方法

//dispatch_once方法的性能要明显优于synchronized方法

static id obj = nil;

+(instancetype)shareInstance

{

  @synchronized(self) {

​    if (!obj) {

​      obj = [[SingletonObj alloc] init];

​    }

  }

  return obj;

}





static id obj = nil;

+(instancetype)shareInstance

{

  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{

​    obj = [[SingletonObj alloc] init];

  });

  return obj;

}





Protocol（协议）

（一）简介

1.Protocol：用来声明方法（不能声明成员变量），不能写实现。

2.只要某个类遵守了这个协议，就拥有了这个协议中的所有方法声明。

3.只要父类遵守了某个协议，那么子类也遵守。

4.Protocol声明的方法可以让任何类去实现，protocol就是协议。

5.OC不能继承多个类（单继承）但是能够遵守多个协议。继承(:)，遵守协议（< >）

6.基协议：<NSObject>是基协议，是最根本最基本的协议，其中声明了很多最基本的方法。

7.协议可以遵守协议，一个协议遵守了另一个协议，就可以拥有另一份协议中的方法声明。

```objective-c
//<myProtocol.h>创建协议
#import <Foundation/Foundation.h>
@protocol myProtocol <NSObject>
@required
-(void)print;
@end

//遵守协议，引入
#import <Foundation/Foundation.h>
#import <myProtocol.h>
//继承类，遵守协议
@interface Person: NSObject <myProtocol>
@end

//完成协议中声明的方法的实现

#import <Person.h>

@implement Person

-(void)print{

NSLog(@"hello");

}

@end



//测试
#import <Foundation/Foundation.h>
#import <myProtocol.h>
#import <Person.h>

int main(int argc,const char * argv[])
{
  Person *p = [[Person alloc]init];
  [p print];
  return 0;
}
```

1.协议的定义

@protocol 协议名称 <NSObject>

//方法声明列表

@end;

2.如何遵守协议

（1）类遵守协议

@protocol 类名：父类名 <协议名称1，协议名称2>

@end

（2）协议遵守协议

@protocol 协议名称 <其他协议名称>

@end;

3.协议方法声明中的关键字

（1）required （默认）要求实现，若没有实现则警告但不报错

（2）Optional 不要求实现

4.定义变量时遵守协议的限制

类名<协议名称> *变量名  NSObject<.Myprotocol> *obj;

Id <协议名称> 变量名  id <.Myprotocol> obj1;

5.Property中声明的属性也可以做遵守协议的限制

@property (nonatomic ,strong ) 类名<协议名称> *属性名；

@property (nonatomic ,strong ) id<协议名称> 属性名；

6.补充知识：协议本身写在.h头文件中，但也可以定义在任何地方。当这个协议只有这个类使用遵守时，一般把协议写在这个类里边，当这个协议需要多个类去实现时，就写在外边单独的文件中。







id类似于C中的void *，任意类型。

所有权修饰符：

__strong 默认，强引用，超出对象时释放

__weak

其他知识：

cocoaPods的安装和使用：

查看和更换镜像源：

gem sources --remove https://rubygems.org/

gem sources --add https://gems.ruby-china.com/

gem sources -l

安装：等待时间较长

sudo gem install -n /usr/local/bin cocoapods   

安装本地库：

pod setup



使用：可以通过命令行或cocoaPods App的方式创建和编写podfile文件，以加载第三方库至工程

命令行：进入工程目录，创建pod init 打开open Podfile 编写文件 pod install 加载第三方库

App:打开CocoaPodsApp -> File -> New Podfile from Xcode Project。找到你的项目目录，选种TestCocoaPodsApp.xcodeproj，单击Open。编写文件，install一下，等待第三方库加载至工程。打开工程的workspace文件，注意不是proj文件，import第三方库进行使用。

教程链接：https://www.jianshu.com/p/559d8a685125更加深入学习待研究。



XCode里遇到 #import file not found，可能是xcode设置里没有配置查找头文件位置

使用xcode查看真机文件https://www.jianshu.com/p/8990de756d28

xcode主题设置：xcode->preference  



mac快捷键



Ctrl+A：到行首（达到Home键的效果）

Ctrl+E：到行尾（达到End键的效果）

Ctrl+N：到下一行

Ctrl+P：到上一行

Ctrl+K：从光标处开始删除，知道行尾

fn键+左方向键是HOME

fn键+右方向键是END

fn+上方向键是page up

fn+下方向键是page down

command+alt+esc强制退出

文件夹的复制使用拷贝操作而非复制或替身

command+alt+4 区域截图

command+alt+3 全屏截图



命令行：

cd是进入文件夹

open是打开文件显示在可视化界面上



//代码规范，注意文件头和函数的功能与参数说明

//

// MLCGCDTimer.h

// VideoCall

//

// Created by cirolong on 2019/6/19.

// Copyright © 2019 tencent. All rights reserved.

//

\#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLCGCDTimer : NSObject

/**

 启动一个timer

 @param timeInterval  时间间隔

 @param queue      timer将被放入的队列，也就是最终callback执行的队列，传入nil将自动放到一个串行队列中

 @param repeats     是否重复执行

 @param callback    时间间隔到点时执行的block回调

 */

 



 派生类需要重写init方法，id关键字用于指定任意对象，是对象。

 nil代表对象为空，NULL代表指针为空

 //instancetype代表实例类型，比id更准确的写法



委托对象，它包含实现协议的调用对象的引用。

一个例子如下所示 - 

\#import <Foundation/Foundation.h>

@protocol PrintProtocolDelegate

\- (void)processCompleted;



@interface PrintClass :NSObject {

  id delegate;

}



\- (void) printDetails;

\- (void) setDelegate:(id)newDelegate;

@end



@implementation PrintClass

\- (void)printDetails {

  NSLog(@"Printing Details");

  [delegate processCompleted];

}



\- (void) setDelegate:(id)newDelegate {

  delegate = newDelegate;

}



@end



@interface SampleClass:NSObject<PrintProtocolDelegate>

\- (void)startAction;



@end



@implementation SampleClass

\- (void)startAction {

  PrintClass *printClass = [[PrintClass alloc]init];

  [printClass setDelegate:self];

  [printClass printDetails];

}



-(void)processCompleted {

  NSLog(@"Printing Process Completed");

}



@end



int main(int argc, const char * argv[]) {

  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  SampleClass *sampleClass = [[SampleClass alloc]init];

  [sampleClass startAction];

  [pool drain];

  return 0;

}

在上面的例子中，已经看到了如何调用和执行委托方法。 它以startAction开始，当进程完成，就会调用委托方法processCompleted以使操作完成。

在任何iOS或Mac应用程序中，如果没有代理，将永远不会实现程序。 因此，要是了解委托的用法。 委托对象应使用unsafe_unretained属性类型以避免内存泄漏。





4，类别/分类（category）和拓展
类别是另一种为现有类添加新行为的方法。不同于子类，类别实际上是 Objective-C 的一 种动态行为，它利用了运行时分配机制。因此，类别甚至不需要拥有原类的源代码。此外，类 别不能向现有的类中添加实例变量。
要声明一个类别，你需要使用类声明时使用的@interface 关键字，如:
@interface NSString(NumberConvenience) 
-(NSNumber∗)lengthAsNumber;
@end

NSString 的类名加上其后的圆括号，表明这是一个对现有类 NSString 的补充或扩充。圆 括号说明扩充方式为通过类别扩充而非通过继承来扩充。

此外，由于类别不能扩充实例变量这一限制，类别的声明中不会出现用于声明实例变量的 {}符号。
类别主要是定义对现有类的扩充方法，因此类别的实现中(.m 文件)就需要对这些新方 法一一进行实现:
@implementation NSString(NumberConvenience) -(NSNumber∗)lengthAsNumber{
...
} @end


1、适用范围
     当你已经封装好了一个类（也可能是系统类、第三方库），不想在改动这个类了，可是随着程序功能的增加需要在类中增加一个方法，这时我们不必修改主类，只需要给你原来的类增加一个分类。
     将一个大型的类拆分成不同的分类，在不同分类中实现类别声明的方法，这样可以将一个类的实现写到多个.m文件中，方便管理和协同开发。
     分类中的方法可以只声明，不实现，所以在协议不支持可选方法的时候（协议现在已经支持可选方法），通常把分类作为非正式协议使用。
2、语法格式
     文件中的语法：
复制代码
1 @interface 主类类名（分类类名）
2 //不可以定义成员属性
3 @end
4 
5 @implementation 主类类名（分类类名）
6 
7 @end

 文件名通常为：主类名+分类名

     调用方法时，只需要向主类引用发送消息即可

3、注意事项
分类中方法的优先级比原来类中的方法高。分类中只能声明方法，不能添加属性变量。



二、扩展

1、适用范围
     扩展是分类的一种特殊形式。

2、语法格式
     @interface 主类类名（）
     @end
     扩展通常定义在主类.m文件中，扩展中声明的方法直接在主类的.m文件中实现。

3、注意事项
扩展中可以声明实例变量，可以声明属性
因为扩展通常定义在主类的.m文件中，所以扩展声明的方法和属性通常是私有的
4、分类和扩展的区别
     分类是不可以声明实例变量，通常是公开的，文件名是：主类名+分类名.h
     扩展是可以声明实例变量，是私有的，文件名为：主类名_扩展标识.h，在主类的.m文件中#import该头文件

     二、对比Category(分类) 与 Extension(扩展)
     /********************extension*************************/
     extension看起来很像一个匿名的category，但是extension和category却几乎是完全不同的两样东西。
    
     extension在编译期间进行决议，它是类的一部分。在编译期，和.h文件中的@interface 和 @implementation文件一起形成一个完整的类。
    
     extension一般用来隐藏一个类的私有信息，你必须有这个类的源码，才能添加一个extension。所以，你无法为一个系统的类或者只暴露.h文件的类添加extension。
    
     /********************category*************************/
     category则完全不一样，它是在运行期决议的。
     extension可以为类添加实例变量，而category是不能为类添加实例变量的 PS: 可以添加属性。(因为在运行期，对象的内存布局已经确定，如果添加实例变量，就会影响类的内部布局)

Objective-C 的协议等同于 Java 中接口的概念。
@protocol NSCopying -(id)copyWithZone: (NSZone∗)zone; ...
@end
协议看起来就像类别的声明，还是一堆方法声明的集合。但@protocol 关键字的出现说明 了这是一份正式协议。协议中的方法可以有选择地由类实现。对于需要实现的方法，使 用@required 关键字修饰，对于可选择性地实现的方法，使用@optional 关键字修饰，比如:
@protocol TheProtocol @required -(void)firstMethod; -(void)secondMethod; @optional -(void)thirdMethod; @end
这个协议规定，第 1、2 个方法是必须实现的，而第 3 个方法可以实现，但不要求一定实现。 如果一个类要采用(或实现)这个协议，则需要在@interface 中这样声明:
@interface MyClass:NSobject<TheProtocol>
除了正式协议外，我们也可以采用非正式协议。非正式协议不需要采用@protocol 关键字
声明，但需要创建一个类别，例如 MyCategory:
@interface NSObject(MyCategory) -(void)doSomething;
...
@end





@class关键字的作用：

解决oc里面相互引用的问题。OC中在相互导入的时候编译是不通过的。我们这时可以在.h文件用@Class先声明下，再在.m文件中导入需要的类。













 

























