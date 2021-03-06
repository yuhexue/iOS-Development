## Xcode使用技巧:

#### 快捷键：

command + N 新建文件 
command + delete 删除一行 
command + Z 撤销上一步操作 
command + / 注释 
command + ] 或者 [ 前后缩进 
command + option + ] 或者 [ 一行代码上下移动 
command + control + 上下方向键 .h .m 文件切换 
command + 左右方向键 光标移动到行头或行尾 
command + control + 左右方向键 后退和前进 
command + R 运行 
command + B 编译 
command + shift + k clean缓存 
shift + 上下⽅方向键 选中代码 
command + , 打开偏好设置 
command + shift + o 弹出快速查找文件窗口 
command + shift + 0 打开官方文档窗口，键入代码中的某个关键字，文档提供了一些额外的资源和示例工程。也可以在变量、类或者方法名上执行Option+双击名称操作，从而更方便地跳转至文档。在类或者方法名上执行Option + Left点击操作使用内联帮助可帮开发者快速学习类或代码片段的用法。
command+control+e统一修改某一方法内某一变量名
command+shift+control+a查看代码作者

###### 查找和替换：

查找可以command + shift + o，或者某个文件内control+F，或者工程左栏的🔍。替换可以在🔍栏里面把find改为replace，然后筛选时可以选择contains或match。

###### 增量编译和全量编译：

全量编译是对整个工程文件编译，增量编译是对修改过的代码进行编译。xcode工程的第一次编译是全量编译，之后是增量编译。之后也可以了解使用一些插件来提升编译速度。

###### 打日志

可以使用 LogModuleDefine.h 定义的便捷宏定义来打日志，无需 import 这个头文件。Log_Error(module, format, ...) 
Log_Debug(module, format, ...) 
Log_Info(module, format, ...) 
Log_Warn(module, format, ...) 
Log_Verbose(module, format, ...)
Log_Fatal(module, format, ...) 

###### 捞日志

捞日志地址：http://www.raft.run/page/LogReportManager.html

使用方法
APPID qinglian
路径 默认为空
UID 就是我们账户系统的 uid

#### 调试工具LLDB：LLVM Debugger

LLDB是Xcode集成的调试器。常用指令:
**help**列出所有的命令列表
**print\po命令**打印，p输出的是基本类型，po输出的是Objective-C对象，调试器会输出这个object的description信息。
**expression命令**(expr)简写是e，可用expression来声明新的变量，也可以改变已有变量的值。这个指令可以动态的执行表达式，同时打印出结果。常用来动态修改变量的值。
**call命令**除了动态修改变量的值，xcode还支持动态调用函数，可以在不增加代码，不重新编译的情况下动态调用一个方法。

```objective-c
call [tipView removeFromSuperview]
```

**image**用于寻址
**breakpoint list**可以查看所有断点，简写 br li
**bt命令**打印当前栈帧信息

##### 用LLDB调试UI：

Xcode提供的3D view hierarchy debugger支持我们看到现在屏幕效果是怎样的，也支持我们打印出某个view的内存地址。有了内存地址，LLDB就能做一切的事情了，因为LLDB能够根据内存地址知道现在在这个地址下存储的数据类型。比如:

```objective-c
(lldb) po 0x7fea5c455ba0
<UIImageView: 0x7fea5c455ba0; frame = (0 0; 414 65); opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <CALayer: 0x600003819b80>>
```

这个内存地址下，存着一个UIImageView类型的数据，我们可以拿这个内存地址当做这个对象来操作，例如：

```objective-c
(lldb) po [0x7fea5c455ba0 image]
<_UIResizableImage: 0x600000fd34f0> size {375, 55} orientation 0 scale 3.000000
```

 或者为了方便，我们可以赋值到一个临时变量

```objective-c
(lldb) e UIImageView* $tmp = (id)0x7fea5c455ba0
(lldb) po $tmp
<UIImageView: 0x7fea5c455ba0; frame = (0 0; 414 65); opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <CALayer: 0x600003819b80>>

(lldb) 
```

当改完某个view的属性了，我们总想看看效果是怎么样的，因为在LLDB中改view的属性，并不会触发setNeedsLayout，所以UI并不会更新。我们可以手动更新来看看效果:

```objective-c
(lldb) e (void)[CATransaction flush]
(lldb) 
```

#### 断点调试：

![](/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/1569502370_22_w3716_h1978.png)

接下来介绍几个断点具体的使用场景：
**条件断点：**
1.选中断点右键Edit BreakPoint
2.点击Add Action，选中Debugger Command
3.输入需要执行的LLDB命令
4.勾选 Automatically continue after evaluating actions，勾选后，程序执行完相应的LLDB命令后，会继续运行程序。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/截屏2020-08-15 下午5.04.01.png" style="zoom:50%;" />

条件：在Conditon处填BOOL语句。
断点忽略：对前几次调用不敢兴趣
action：类型很多，有调试命令、apple script、shell script等。
**异常断点**
当创建异常断点后，会显示一个名为`All Exceptions`的断点，这一般称为全局断点。当程序抛出异常时会触发异常断点，并且大部分常见错误会被断点定位到对应的代码行，很方便调试。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/1569550135_37_w1586_h480.png" style="zoom:33%;" />

**符号断点**
符号断点（Symbolic Breakpoint）是全局断点，可以针对某一个方法（函数）设置断点。开发者可以很方便地创建一个符号断点，如下图：

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/1569550640_52_w918_h344.png" style="zoom:50%;" />

**Watch断点**
当变量发生改变的时候触发。在Xcode的watch窗口-> 右键需要watch的变量 -> watch “XXX”。
watch断点对于要跟踪某个变量或者某个状态的变化是非常有用的，可以方便的跟踪哪些地方改变了变量的值。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/1569550995_13_w1860_h682.png" style="zoom:33%;" />

## **UI调试**

UI调试可以使用Xcode自带的调试工具Debug View Hierarchy，如图。该工具支持UI视图层级和控件信息的可视化，然后搭配LLDB指令来修改控件信息，动态调试UI。

![](/Users/max/GithubRepositories/iOS-Develpoment/img/xcode/1569576462_77_w1528_h166.png)

```objective-c
(lldb) e self.webView.hidden = YES
(BOOL) $2 = YES
(lldb) e (void) [CATransaction flush]
```

另外，这里介绍一款更高效的UI调试工具：Lookin[点此下载](https://lookin.work/get/) 
Lookin软件安装完毕后，我们需要把Lookin的iOS Framework嵌入到我们的iOS项目中。使用CocoaPods方式嵌入较为简单，步骤如下：
1，在Podfile 中添加以下内容：

```objective-c
pod 'LookinServer', :configurations => ['Debug']
```

这里指定了只有在 Debug 模式下才能使用 Lookin。
2，运行 pod install 或 pod update LookinServer。

#### Plus:

查看控件信息可以使用p和po命令，也可以使用expr命令修改控件属性，如内容、大小等，这样可以不重启程序就能看到界面变化。
注：有一个叫injectionPlugin的xcode插件，它能够在改变代码后不重启APP即可让改变生效。

###### 总结：

​		使用xcode内置的Debug View Hierarchy和LLDB，可以满足UI和变量改变的动态调试需求。之后也可使用Lookin和injectionPlugin等插件，在修改代码时减少编译次数，尽量动态调试。
​		对于初学者，先熟悉xcode内置工具的使用，特别是LLDB指令。然后才是学习第三方插件的使用，以进一步提升效率。



###### 附录1：LLDB常用指令🌰

待完善





