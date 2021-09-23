# 第一步 安装 platform tools

用于安装 apk，以及调整权限，特别是需要使用 davx 同步 opentask

## Linux

有包，直接安装


## Windows

1. 下载 [android platform tools](https://developer.android.com/studio/releases/platform-tools)
2. 解压至某个目录
3. 将该目录添加至系统 PATH


## 启用 USB 调用

1. 开启开发者模式。(小米：my device / all specs / tap miui version until prompt for developer mode)
2. 启动 adb 服务器 `adb start-server`， 此时手机联上电脑应提示接受连接，选接受。
3. 查看设备 `adb devices` 应能看到设备

# 第二步 安装手机 apps

- [Nextcloud](https://f-droid.org/en/packages/com.nextcloud.client/)
- [OpenTask](https://f-droid.org/en/packages/org.dmfs.tasks/)
- [DAVx](https://f-droid.org/en/packages/at.bitfire.davdroid/)

安装命令： 

```sh
user@pcname:~$ adb install <name>.apk
```

# 第三步 配置

## Nextcloud

1. 登录帐号
2. 进入 settings / more / Sync calendar & contacts
3. 点击之后会激活 DAVx 进行设定

## DAVx

1. 打开手机 Settings / Apps / Permissions / Autostart 给 DAVx 自启权限
2. (小米，Android 版本10)执行以下 adb 命令开启读写 OpenTasks 的权限

```sh
user@pcname:~$ adb -d shell 
phonename:/ $ pm grant at.bitfire.davdroid org.dmfs.permission.READ_TASKS
phonename:/ $ pm grant at.bitfire.davdroid org.dmfs.permission.WRITE_TASKS
phonename:/ $ exit
```



