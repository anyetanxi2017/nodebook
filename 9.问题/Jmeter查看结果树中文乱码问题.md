```
方案一：找到bin目录下的jmeter.properties文件进行编辑直接修改sampleresult.default.encoding=UTF-8。（记住去掉#，不要还是注释状态哦）

方案二：动态修改（这种方法方便些，蜗牛推荐）

 step1：指定请求节点下，新建后置控制器"BeanShell PostProcessor"

step2：其脚本框中输入：prev.setDataEncoding("UTF-8");

 step3：保存

方案一亲测有效

作者：小侯童鞋
链接：https://www.jianshu.com/p/60e89ea254e5
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```
