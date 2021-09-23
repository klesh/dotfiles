1. 下载 powershell 最新版并安装
2. 设置执行策略：`Set-ExecutionPolicy RemoteSigned`
3. 启用开发者模式(不需要 administrator 也能建软链)
4. 执行安装脚本：setup\oh-my-posh.ps1 setup\vim.ps1
5. 设置 profile: `New-Item -ItemType SymbolicLink -Target $profile -Path profile.ps1`
6. 设置 utf8 (gpg 才能正确有处理中文):
    1. 设置
    2. 区域 - 右上其它日期时间和区域设置
    3. 更改日期时间或数字格式
    4. 管理 - 更改系统区域设置
    5. Beta: 使用 Unicode UTF-8 提供全球语言支持
