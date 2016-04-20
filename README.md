

## iOS 获取 iPod 音乐库歌曲文件信息并拷贝文件到个人的 App 中 

最近有需要从 iOS 系统的音乐库里面拷贝歌曲到 APP 的 `Documents` 目录下进行共享使用，于是总结一下使用的方法。其中使用了 **MPMediaQuery** 来获得音乐文件的信息，比如歌手、专辑名、专辑封面、时长、 ASSetURL 地址等，然后通过 `ASSetURL` 地址使用 **AVAssetExportSession** 导出其数据。

详细请查看代码，或阅读我的博客文章 - [iOS 获取 iPod 音乐库歌曲文件信息并拷贝文件到个人的 App 中](http://www.vanbein.com/posts/ios高级/2016/04/20/Read-Music-Item-From-iPod.html)

