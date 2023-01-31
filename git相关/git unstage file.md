# git unstage file

* git rm --cached <filePath> does not unstage a file, it actually stages the removal of the file(s) from the repo (assuming it was already committed before) but leaves the file in your working tree (leaving you with an untracked file).

* git reset -- <filePath> will unstage any staged changes for the given file(s).

> That said, if you used git rm --cached on a new file that is staged, it would basically look like you had just unstaged it since it had never been committed before.