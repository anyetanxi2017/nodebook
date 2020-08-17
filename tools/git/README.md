

[toc]

# 学习文章

​      \- [git学习](https://www.cnblogs.com/qianqiannian/category/899203.html)    

​      \- [Git概述](https://blog.csdn.net/u012702547/article/details/78730693)    

​      \- [Git中的各种后悔药](https://blog.csdn.net/u012702547/article/details/78888971)    

​      \- [Git分支管理](https://blog.csdn.net/u012702547/article/details/78950202)    

​      \- [Git关联远程仓库](https://blog.csdn.net/u012702547/article/details/78954832)    

​      \- [Git标签管理](https://blog.csdn.net/u012702547/article/details/78969183)    

​      \- [Git学习资料]()https://blog.csdn.net/u012702547/article/details/78971096    

# 分支

## 查看分支

```
git branch 不带参数：列出本地已经存在的分支，并且在当前分支的前面用"*"标记
git branch -r 查看远程版本库分支列表
git branch -a 查看所有分支列表，包括本地和远程
git branch -vv 可以查看本地分支对应的远程分支
```

## 创建分支

```
git checkout -b master 创建并切换
git branch dev 　创建名为dev的分支，创建分支时需要是最新的环境，创建分支但依然停留在当前分支
```

## 提交分支

```
git push --set-upstream origin 客户端互聊原理实现
```

## 切换分支

```
git checkout master 将分支切换到master
```

## 删除分支

删除本地分支

```
git branch -d dev 删除dev分支 如果在分支中有一些未merge的提交，那么会删除分支失败，此时可以使用
git branch -D dev：强制删除dev分支
```

删除远程分支

```
git push origin --delete dev20181018
```

## 修改分支名称

```
git branch -m old_branch new_branch # Rename branch locally
git push origin :old_branch # Delete the old branch
git push --set-upstream origin new_branch # Push the new branch, set local branch to track the new remote
```

# 恢复历史版本

```
git clone ....
git log --pretty=oneline  查看所有版本ID
git reset --hard 需要恢复的版本ID   就可以恢复到指定版本了.
```



# 获取远程分支

```
git fetch
git merge
```

# 提交git

```
git add ./
git commit -m 'info'
git push
```



#  上传本地文件到github    

```
创建远程仓库 https://github.com/anyetanxi2017/spring-learn.git
git init
git add ./
git commit -m 'create'
git remote add origin https://github.com/anyetanxi2017/spring-learn.git
git push -u origin master
```



