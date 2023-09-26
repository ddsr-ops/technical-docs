# git回滚代码有两种方式
* reset
* revert  

这两种有什么区别呢，假设我们提交了三次commit  
`commit1 -> commit2 -> commit3`

如果我想会滚到commit2，如果用reset的话，那么commit2之后的所有修改都会被丢弃，
也就是把commit2之后的commit全部砍掉了，
revert有点像undo，会把commit2做的操作反做一遍，也就是undo，并且生成一个新的commit，变成  
`commit1 -> commit2 -> commit3 ->commit4`

具体应用在什么场景呢，举个例子，比如我们在调试的时候可能要加一些调试语句，比如system.out，
当调试完毕，我们希望能够移除这些调试语句就可以在调试前提交一次commit，调试完毕后reset到该次commit就行，当然你也可以通过分支来实现，调试完毕把分支删掉即可。

我们的系统在不断的迭代，突然某一天，产品经理说之前已经上线的一个功能不要了，
那么就可以找到该功能对应的commit进行revert，这样既移除对应的功能又能保留后续的新功能。

## Reset
在idea底部工具栏，点击Git工具栏，切换到Log标签页，可以看到本地commit日志和远程commit日志，
在指定commit上右键选择Reset Current Branch to Head就可以以reset的方式回滚到该commit上

选择Hard模式，将会清除本地版本，强制回滚到指定commit状态，但是通过reset是无法进行push操作，
因为本地的版本比远程版本要低，此时可以强制push到远程分支，但是你必须清楚该操作所带来的后果。

## Revert
revert可以将指定的commit所做的修改全部撤销掉，而不影响其他commit的修改，
假设我们有三个文件，分别为file1.txt，file2.txt，file3.txt，现在提交三个commit，三个commit分别为

1. Commit1：向file1.txt中添加内容
2. Commit2：向file2.txt中添加内容
3. Commit3：向file3.txt中添加内容

在idea底部工具栏，点击Git工具栏，切换到Log标签页，可以看到本地commit日志和远程commit日志，
在指定commit上右键选择revert commit就可以以reset的方式回滚到该commit上

现在我们在Commit2：文件2修改这个commit上面右键选择Revert Commit，这时候会弹出提交窗口，
idea会自动提交一次新的commit，commit后我们发现文件2的内容没有了，也就是撤销了commit2修改的内容，
commit后执行push操作就能推送到远程仓库了，因为是生成了新的commit，所以无需force push就能提交到远程仓库，
revert操作会经常碰到代码冲突的情况，这时候就需要手动去解决冲突