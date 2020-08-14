1，制作开发者证书

开发者证书分为 开发 和 发布 两种，类型为ios Development,iOS Distribution。 平常开发用development证书和BundleID因为要真机调试，上线的时候在换成iOS Distribution。

开发者证书直接找公司要吧。

普通证书，也能真机测试，但是不能上架和发布。

//////////////////////





属性由@property关键字声明，属性用于封装对成员变量的访问

成员变量，属性和方法

nonatomic 关键字的意思是非原子的，意指对属性进行存取操作时是线程不安全的，如果 在多线程环境下，该属性很可能是不同步的，一个线程读取属性值时，另一个属性却修改了属 性值，这样两个线程对同一个属性进行操作的情况下，属性的值是不一致的。我们在属性中使 用 nonatomic 的原因是，该属性不会在多线程环境下使用，使用非原子特性能得到较好的性能。 而在 iOS 编程中，性能始终是程序员首先要考虑的问题。

retain 关键字是我们用得最多的属性修饰符之一，它和属性的内存管理有关。这样在对这个属 性进行赋值操作时，在编译器自动生成(如果你使用了@synthesize 关键字的话)的 Set 方法 代码中，会对实例变量进行 retain 操作。对于 Objective-C 对象类型的实例变量而言，使用 retain 操作使得属性在赋值后一直到对象被销毁之前始终可用。如果实例变量或属性并不是 Objective-C 对象类型，而是一个简单类型，如 BOOL、int、id、float，则用 asign 关键字替换 retain 关键字。 这样，属性在赋值时不会被持有，这样导致的直接后果是:刚对一个属性赋值后，再访问这个 属性，这个属性就变成空了。关于 Objective-C 的内存管理，更多内容会在后面介绍。
属性还可以用 readonly、readwrite 进行修饰，分别用于创建只读的属性和可读可写属性。
属性声明之后，接下来就是在实现文件(.m 文件)中实现属性的 get、set 方法。这些方 法你可以选择自己去实现，也可以让 Objective-C 替你实现，只需要使用@synthesize 或者 @dynamic 编译器指令。


1，消息机制


1.消息的参数 一个没有参数的消息是这样的:
[object methodWithoutParameter];
如果要调用的方法带有参数，则这个消息是这样的:
[object methodWithOneParameter: value];
注意，当方法没有参数时，其方法名后没有冒号。当方法有多个参数时，其方法名如我们 前面所述，会有多个带冒号的参数:
[object methodWithFirstParameter:value1 withSecondParameter:value2];
2.消息的嵌套 当要进行一个嵌套的方法调用时，会使用嵌套消息:
[textView setTextColor:[UIColor whiteColor]];
内层的消息[UIColor whiteColor]首先调用并返回一个 UIColor，然后将这个临时的 UIColor 对象作为外层消息的参数传入。
即第 1 个消息的输出作为第 2 个消息的输入。


3.基于自动释放池的内存管理
Cocoa 引入了自动释放池(autorelease pool)的概念。自动释放池实际是一个对象集合或 对象容器的概念。如果你把所有的对象在创建时，都放到这个池中，则自动释放池被销毁时， 池中的对象都会接收到 release 消息。
要把对象加入到自动释放池中，只需在创建对象的同时调用 autorelease 方法。
例如下面的代码，当对象 string 一创建就被放到了自动释放池里:
NSString ∗string=[[[NSString alloc]initWithString:@”I am a string”] autorelease];


类别/分类（category）和拓展
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
分类中方法的优先级比原来类中的方法高，也就是说，在分类中重写了原来类中的方法，那么分类中的方法会覆盖原来类中的方法
分类中只能声明方法，不能添加属性变量，在运行时分类中的方法与主类中的方法没有区别
通常来讲，分类定义在.h文件中，但也可以定义.m文件中，此时分类的方法就变成私有方法




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


3.2.5 反射机制
Objective-C 也提供了运行时支持——即 Java 所谓的反射机制，这 充分体现了 Objective-C 的动态性特征。
1.获取类信息
2.选择器
选择器实际上是一个方法名称，用@selector 关键字来指定一个选择器，选择器用于查询 对象的某个方法，
3.类的动态创建
4.类的动态加载
5.方法的动态调用



3.3 MVC 模式

MVC 模式把应用程序 GUI 代码根据功能拆分为不同的类或组件:
􏰀 “模型”:用于封装应用程序的数据;
􏰀 “视图”:负责显示和编辑数据:
􏰀 “控制器”:负责处理前两者之间的逻辑关系。

KVO(key-value observer，“键-值”观察)模型是 Cocoa 绑定技术中常用的一种编程模型，
它可以使一个对象在属性值发生变化时主动通知另一个对象并触发相应的方法。

KVO 是一种很有用的绑定技术(Cocoa 还提供另外一种绑定技术:Dynamic bingding)。 而且它是由被观察的对象主动通知观察者的，并不需要经过一个统一的通知中心(如后面章节 介绍的通知技术所述)，它的执行效率和适用场景要更佳。
为了实现 KVO，你需要进行如下操作:
􏰀 注册观察者。所谓观察者即对象状态变化时需要通知的对象。
􏰀 接收变更通知。接收变更通知主要是让观察者实现指定方法，在指定方法中，你可以
接收到对象状态变更的消息，并在方法中进行处理。
􏰀 取消所注册的观察者。观察者处理完状态变更消息之后，需要取消原先的注册状态。


注册 KVO
[account addObserver:inspector 
forKeyPath:@"name"
options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
context:NULL];

将 inspector 对象注册为 account 对象的观察者，并表明观察者将对名为“name” 的属性变更感兴趣。
forKeyPath 参数“name”注明了需要观察的属性的关键路径 KeyPath。关键路径 KeyPath 实际是一个字符串，
用于表示某个属性，你可以直接用属性名。但如果某属性是一个对象，则 KeyPath 可以用“.”语法的形式表示对象成员，如“account.name”。
options 参数注明了对该属性的何种状态感兴趣。NSKeyValueObservingOptionNew 表示属 性在变更后的新值，NSKeyValueObservingOptionOld 表示属性未改变之前的值。以上例子中的 option 参数设置表明，当 name 属性变更时，会将这两个值以 NSDictionary 的方式(即 change 参数)提交给观察者，观察者可以从 NSDictionary 中以键-值对的方式检索到这两个值。
context 参数用于传递一个对象，该对象(或指针)会在属性变化时通过变更通知传递给 观察者(通过 context 参数)。
移除观察者的注册，使用方法 removeObserver forKeyPath: [subject removeObserver:observer forKeyPath:@"name"];

3.4.2 接收变更通知
观察者要想收到对象的属性变更通知，需要实现方法 observeValueForKeyPath:ofObject:
change:context:，并在其中进行通知的处理。例如:
- (void)observeValueForKeyPath:(NSString ∗)keyPath 
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


3.4.3 发送变更通知
NSObject 支持两种属性变更通知，一种是自动变更通知，一种是手动变更通知。一般情
况下，使用自动变更通知则更为简单，因此我们主要介绍自动变更通知。
1.自动变更通知
要使用自动变更通知，需要实现被观察者的 automaticallyNotifiesObserversForKey 方法， 在此方法中明确说明需要使用自动变更通知的属性。对于需要使用自动变更通知的属性，返回 YES，如下代码所示:
+ (BOOL) automaticallyNotifiesObserversForKey:(NSString∗)key {
// 对于属性 name ，使用自动通知
if ([key isEqualToString:@"name"]) {
return YES; }
// 确保调用了父类的 automaticallyNotfiesObserversForKey 方法 return [super automaticallyNotifiesObserversForKey:key];
}
然后，在 name 属性发生变化的时候通知观察者，比如调用以下语句之一:
subject.name=newName;
[subject setValue:newName forKey:@"name"]; [subject setValue:newName forKeyPath:@"name"];
如果属性是集合类型，则可以使用方法 mutableSetValueForKey 来支持以下集合方法导致 的自动变更通知:
􏰀 添加:insertObject:InKey:或者 insertObject:AtIndex:
􏰀 替换:replaceObject:InKey:或者 replaceObject:AtIndex: 􏰀 删除:removeObjectFromKey:或者 removeObjectAtIndex:
2.手动变更通知
对于手动变更通知，除了需要在 automaticallyNotifiesObserversForKey:方法中将要使用的 手动变更通知返回 NO 外，还需要 在改变值之前调用 willChangeValueForKey:并在更改它之后 调用 didChangeValueForKey:。
为了便于你理解 KVO 模型，我做了一个示例程序，放在光盘“source/第 3 章/TestKVO” 文件夹，它使用了本节所介绍的知识点，可供参考和学习。



块，block

1.块变量声明

int multiplier = 7;
 int (^myBlock)(int) = ^(int num) {

return num ∗ multiplier; 

};

printf ( "%d", myBlock(3));

//变量声明解析

 int (^myBlock)(int) = ^(int num) {return num ∗ multiplier; };

返回值，块变量，参数表列（多参数用逗号），块定义【初始化块变量】（参数说明【参数类型和参数名】，块体）

- 返回值类型，如 int、double，如果未显式地声明块的返回值类型，可能会自动从块代

  码中推断返回类型(通过 return 语句)。

- 􏰀  块变量名用括号括住，块变量名前加^符号。

- 􏰀  参数类型用括号括住，多个参数以逗号分隔，如果参数列表为 void，而且返回类型依

  靠推断，可以省略参数列表的 void。

- 􏰀  等号，将后面的块赋值给前面的块变量(即 myBlock)。

- 块体，同函数体。  一旦声明了块，你可以像使用函数一样调用它。





2.行内块

有时候，你不准备重复使用某个块，因此你不必为它想一个名称。那你可以使用行内块而 不用声明为块变量。
 char ∗myCharacters[3] = { "TomJohn", "George", "Charles Condomine" }; qsort_b(myCharacters, 3, sizeof(char ∗), ^(const void ∗l, const void ∗r) {
char ∗left = ∗ (char ∗∗)l;
char ∗right = ∗ (char ∗∗)r; 
return strncmp(left, right, 1);

});
在 qsort_b 方法调用中，第 4 个参数就是一个匿名的块(行内块)。匿名块跟块变量不同， 它没有变量名，因此你无法重用匿名块。下次调用这个块时，必须把整个块定义的代码再复制 一遍。



3.__block 关键字

块允许访问本地变量。它使得我们在线程间共享变量变得简单，而且，你可以 规定一个本地变量是否可以写，这可通过使用__block 关键字，这是一种类似 register、auto 和 static 存储类型修饰符。



用__block 修饰的变量，可以在所有同一作用域内的块，以及块复制之间共享数据。在指定作用域内的多个块能同时使用共享变量。__block 变量有两个限制:不能是可变长度的数组，也不能是包含 C99 可变长度数组的结构体。下面显示了__block 变量的使用:

__block int x = 123; // x 是块可写的

void (^printXAndY)(int) = ^(int y) {

x = x + y;

printf("%d %d\n", x, y); };

printXAndY(456); // 打印出: 579 456 

// x 现在的值是:579



下面显示了在块中使用多种类型的变量:

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



void*//指向任何类型的指针。





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



















