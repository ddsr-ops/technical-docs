Switching branches is something you'll need to do often in Git.

To do this, you can use the git checkout command.

# How to create a new branch in Git
To create a new branch in Git, you use the git checkout command and pass the -b flag with a name.

This will create a new branch off of the current branch. The new branch's history will start at the current place of the branch you "branched off of."

Assuming you are currently on a branch called master:

```
(master)$ git checkout -b my-feature
Switched to a new branch 'my-feature'
(my-feature)$
```
Here you can see a new branch created called my-feature which was branched off of master.

# How to switch to an existing branch in Git
To switch to an existing branch, you can use git checkout again (without the -b flag) and pass the name of the branch you want to switch to:

```
(my-feature)$ git checkout master
Switched to branch 'master'
(master)$
```
There is also a handy shortcut for returning to the previous branch you were on by passing -  to git checkout instead of a branch name:
```
(my-feature)$ git checkout -
Switched to branch 'master'
(master)$ git checkout -
Switched to branch 'my-feature'
(my-feature)$
```

# How to checkout a specific commit
To checkout or switch to a specific commit, you can also use git checkout and pass the SHA of the commit instead of a branch name.

After all, branches are really just pointers and trackers of specific commits in the Git history.

## How to find a commit SHA
One way to find the SHA of a commit is to view the Git log.

You can view the log by using the git log command:

```
(my-feature)$ git log
commit 94ab1fe28727b7f8b683a0084e00a9ec808d6d39 (HEAD -> my-feature, master)
Author: John Mosesman <johnmosesman@gmail.com>
Date:   Mon Apr 12 10:31:11 2021 -0500

    This is the second commmit message.

commit 035a128d2e66eb9fe3032036b3415e60c728f692 (blah)
Author: John Mosesman <johnmosesman@gmail.com>
Date:   Mon Apr 12 10:31:05 2021 -0500

    This is the first commmit message.
```

On the first line of each commit after the word commit is a long string of characters and numbers: 94ab1fe28727...

This is called the SHA. A SHA is a unique identifier that is generated for each commit.

To checkout a specific commit, you just need to pass the commit's SHA as the parameter to git checkout:

```
(my-feature)$ git checkout 035a128d2e66eb9fe3032036b3415e60c728f692
Note: switching to '035a128d2e66eb9fe3032036b3415e60c728f692'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 035a128 a
((HEAD detached at 035a128))$
```

> Note: You generally only need to use the first few characters of the SHA¡ªas the first four or five characters of the string are most likely unique across the project.

## What is a detached HEAD state?
The result of checking out a specific commit puts you in a "detached HEAD state."

From the documentation:

> [a detached HEAD state] means simply that HEAD refers to a specific commit, as opposed to referring to a named branch

Basically, the HEAD (one of Git's internal pointers that tracks where you are in the Git history) has diverted from the known branches, and so changes from this point would form a new pathway in the Git history.

Git wants to make sure that that is what you are intending, so it gives you a "free space" of sorts to experiment¡ªas described by the output:

```
You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.
```
From this position you have two options:

* Experiment and then throw away your changes by returning to your previous branch
Work from here and start a new branch from this point
* You can use the git switch - command to undo any changes you make and return to your previous branch.

**If you instead want to keep your changes and continue from here, you can use git switch -c <new-branch-name> to create a new branch from this point.**

# Conclusion
The git checkout command is a useful and multi-purpose command.

You can use it to create new branches, checkout a branch, checkout specific commits, and more.