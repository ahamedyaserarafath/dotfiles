Automatically merge the changes from other group project to existing project without affecting any changes made locally
ex:
```
git clone git@github.com:ahamedyaserarafath/dotfiles.git
cd dotfiles
git checkout -b branch_name origin/branch_name
git remote add remote_repo git@github.com:remote_repo/dotfiles.git
git fetch remote_repo
git merge remote_repo/branch_name
git push
```

Below one will hard fetch from irrspective of the changes made in the current repo
ex:
```
git clone git@github.com:ahamedyaserarafath/dotfiles.git
cd dotfiles
git checkout -b branch_name origin/branch_name
git remote add remote_repo git@github.com:remote_repo/dotfiles.git
git fetch remote_repo
git reset --hard remote_repo/branch_name
git push
```
