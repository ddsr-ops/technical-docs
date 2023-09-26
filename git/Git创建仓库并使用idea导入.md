### Create a new repo in GitHub website
   * Don't add a README file
   * Don't select add .gitignore
   * Don't Choose a license
> why do nothing, that's not to create a new branch. If did one of above actions, a master branch would be created. The empty master branch must be checked out , then develop based on the checked-out branch before pushing changed commits. If you create another branch, where there is no relationship between the branch you created and the empty master branch. They can not be merged, because they are not from the same ancestor branch. 

### Click a `Create`

### Import code from Intellij
1. open the terminal pane
2. git remote add origin https://github.com/ddsr-ops/flink-1.17-chase.git
3. git branch -M main
4. git push -u origin main