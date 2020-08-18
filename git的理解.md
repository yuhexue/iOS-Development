## sourceTree和git命令

#### 关键词：

分支，拉取，抓取，贮藏，应用贮藏，处理冲突，推送，合并，变基

#### 新建分支：

选择某个分支节点，新建分支，更改，提交，推送到远端。

#### head:

头指针，表示当前分支所处的位置。

#### 工作区和暂存区：

Add,commit,push

文件从工作区add到暂存区，暂存区commit到本地分支，本地分支push到远端。git add命令实际上就是把要提交的所有修改放到暂存区，然后，执行git commit就可以一次性把暂存区的所有修改提交到分支。

#### 拉取和抓取的区别：

拉取时有个选项：立即提交合并的改动，这个会将拉到的东西直接合并提交，也就是拉取+提交

抓取：抓取所有远端更新，用于查看有多少拉取。抓取是主动check

#### 贮藏和应用贮藏：

在某个分支节点处，把一些更改存起来，把存货加进来。git stash

#### 提交回滚：

对该节点所做的变更全部撤销，并作为一次新的提交。

#### 重置提交：

- 使用场景：已commit甚至已推送的时候，发现有新的拉取，需要merge（可能还有冲突）。

- 步骤：选择要重置到哪个分支节点，右键reset develop to this commit
- 合并模式：
  - 软合并：保留工作副本的改动，且保留commit记录，所以会多产生一次commit记录。
  - 混合合并：保留工作副本的改动，且删除commit记录，能够减少节点记录。
  - 强制合并：丢弃当前工作区的更改，相当于将工作区重置成该分支节点。注意推送是将当前本地分支节点推到远端对应的分支，由于已经重置，相当于空推送。

一般主要使用混合合并

#### 重置文件或区块：

工作区：文件修改但未提交（add），可以使用批量重置文件或放弃区块（文件局部重置）

#### 重置文件和移除的区别：

移除：意思是将该文件删除，就像你新增一个文件一样。移除时发现误删还是可以重置的。

#### 合并：

合并也就是两个节点的东西，合并成一个新的节点。
在sourceTree，切到master，拉取最新的master，切回dev，将master合到dev，这样的话本地的dev就是最新的了，还需要将dev推上去，最简单的就是将dev推到master分支。但是实际协作开发，需要审批和权限。

#### 变基：

如果推送的时候有新的拉取，在进行拉取时可以勾选变基，这样可以减少一些节点记录。

#### 合并或变基的使用场景：

他人开发且提交历史较长的分支，适合合并，这样可以保留整个提交历史。
自己临时开发且提交历史时间线较短的分支，适合变基，这样可以优化提交历史。

#### 解决冲突的方式：

- 我的版本：对应的是首先合并到分支的版本。
- 他人的版本：对应的是后合入的版本
- 手动（第三方）：使用代码对比工具进行手动合入

#### 注意：

1，不要强制变基，强制push等操作，也不要设置sourceTree的强制。

2，如果你在提交之前，有未拉取的代码，这个时候先拉取完之后再commit。否则经过上面的操作，会把别人提交的代码回退过去。



### 如何减少merge节点：

本地出现merge节点的原因是本地分支和远端分支代码不同步，未及时把远端代码更新到本地分支。通常在commit时，一定要先拉取远端代码到本地，这样可避免产生merge节点。但在某些场景下还是会出现这种情况。针对节点混乱和额外的merge节点问题，总结如下：

#### 场景一：

在开发过程中其他同事提交了代码，导致本地代码落后于库上代码，这时如果拉取并提交推送，本地就会产生merge节点。如图：

![](/Users/max/GithubRepositories/iOS-Develpoment/img/1554038667_78.png)

日常的提交都会遇到这种情况，养成良好的习惯：
1.先把本地的改动，保存起来，本地仓库就没有任何变化，是纯净的。
2.这时把库上代码拉下来，由于本地是纯净的，所以这一步只是拉取最新代码，不会有其他情况出现。
3.把刚刚保存的代码还原到本地，如果出现冲突，就解决冲突，没有的话就直接提交然后推送到远程分支。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038728_37.png" style="zoom: 33%;" />

#### 场景二：

当你准备提交代码并推送到远程时，其他同事正在推送。这时你的推送会失败，在本地产生了一次commit节点。如图：（有拉取，有commit）

**解决办法：**
1.在本地的提交记录中，选择重置这一次的提交，这一次的代码变化会出现在本地暂存区。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038775_77.png" style="zoom: 33%;" />

合并模式有三种：软合并、混合合并、强行合并。通常选混合合并。<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038805_35.png" style="zoom:33%;" />

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038826_100.png" style="zoom:33%;" />

代码出现在了暂存区，接下来就回到了场景一，只需按照上述步骤，就可以避免一次merge节点了。

#### 场景三：

有一个小模块，产生了多个本地commit，想把这些commit作为一个完整的模块推送到远程分支。但是期间，其他同事往远程分支推送了代码。如图：

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038858_17.png" style="zoom:33%;" />

**解决办法：rebase，变基。**

1.更新代码的时候，选择变基。第一个框表示采用merge的方式来更新，这样会产生merge节点。因此选最后一项。

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038881_88.png" style="zoom:33%;" />

2.如果有冲突，就解决冲突，没有的话就提交推送远程分支。

#### merge和rebase的区别：

##### 现状：

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038904_71.png" style="zoom:33%;" />



merge:

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038920_90.png" style="zoom:33%;" />

rebase:

<img src="/Users/max/GithubRepositories/iOS-Develpoment/img/1554038936_39.png" style="zoom:33%;" />

#### commit规范：

build：主要目的是修改项目构建系统(例如 glup，webpack，rollup 的配置等)的提交
ci：主要目的是修改项目继续集成流程(例如 Travis，Jenkins，GitLab CI，Circle等)的提交
docs：文档更新
**feat**：新增功能
**fix**：bug 修复
perf：性能优化
**refactor**：重构代码(既没有新增功能，也没有修复 bug)
style：不影响程序逻辑的代码修改(修改空白字符，补全缺失的分号等)
test：新增测试用例或是更新现有测试
revert：回滚某个更早之前的提交
chore：不属于以上类型的其他类型



