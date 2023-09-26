```shell
// 删除本地分支
git branch -d localBranchName

// 删除远程分支
git push origin --delete remoteBranchName
```

```
error: unable to push to unqualified destination: remoteBranchName The destination refspec neither matches an existing ref on the remote nor begins with refs/, and we are unable to guess a prefix based on the source ref. error: failed to push some refs to 'git@repository_name'
```

If this thing occurred, it indicates the remote branch has been deleted by others, Using `git fetch -p` to synchronize branches.