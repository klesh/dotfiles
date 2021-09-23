

# download and install latest version

- download from [python for windows](https://www.python.org/downloads/windows/)
- check `Add To Path` path during installation

# setup pip mirror

create `$HOME\pip\pip.ini`
```ini
[global]
#index-url = https://pypi.tuna.tsinghua.edu.cn/simple
index-url = https://mirrors.aliyun.com/pypi/simple
```


# alternative versions and virtualenv

- download alternative versions you need from [python for windows](https://www.python.org/downloads/windows/) (note: not all releases provide binary installer)
- __DO NOT__ check `Add To Path` option during installation
- run `pip install virutalenv`
- run `virtualenv -p $env:LOCALAPPDATA\Programs\Python\PythonXX\python.exe env` to create virtual env for your project
- run `env\Scripts\activate.ps1` on PowerShell to activate the virtualenv
- run `deactivate` when done
