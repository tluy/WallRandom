@echo off
chcp 65001 >nul
echo ====================随机壁纸切换器====================
echo 图片目录：D:\Wallpaper
echo ======================================================
pause

:: 壁纸文件夹
set "WALL_DIR=D:\Wallpaper"

:: 判断文件夹是否存在
if not exist "%WALL_DIR%\" (
    echo 错误：文件夹 D:\Wallpaper 不存在！
    pause
    exit /b
)

:: 获取目录内图片列表，存入临时文件
dir /b "%WALL_DIR%\*.jpg" "%WALL_DIR%\*.jpeg" "%WALL_DIR%\*.png" "%WALL_DIR%\*.bmp" > "%temp%\wall_list.txt"

:: 统计图片行数
for /f %%a in ('findstr /n "^" "%temp%\wall_list.txt"') do set "count=%%a"
if %count%==0 (
    echo D:\Wallpaper 里面没有找到图片(jpg/png/bmp)！
    del "%temp%\wall_list.txt" >nul
    pause
    exit /b
)

:: 随机选一张
set /a "rand_idx=%random%%%count +1"
for /f "skip=%rand_idx% delims=" %%i in (%temp%\wall_list.txt) do (
    set "SELECT_IMG=%WALL_DIR%\%%i"
    goto pick_done
)
:pick_done
del "%temp%\wall_list.txt" >nul

echo 选中图片：%SELECT_IMG%
::写入注册表壁纸路径
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%SELECT_IMG%" /f
::刷新桌面
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

echo.
echo 壁纸设置命令执行完成！
echo 提示：Win11经常无法即时刷新，没变化就注销重登。
echo 企业电脑若有域策略，会强制覆盖壁纸。
pause
