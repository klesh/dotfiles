

## Add new mimetype

Add file `~/.local/share/mime/packages/markdown.xml`
```
<?xml version="1.0" encoding="utf-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="text/markdown">
      <!--Created automatically by update-mime-database. DO NOT EDIT!-->
      <comment>Markdown document</comment>
      <comment xml:lang="ast">Documentu Markdown</comment>
      <comment xml:lang="bg">Документ — Markdown</comment>
      <comment xml:lang="ca">document Markdown</comment>
      <comment xml:lang="cs">dokument Markdown</comment>
      <comment xml:lang="da">Markdown-dokument</comment>
      <comment xml:lang="de">Markdown-Dokument</comment>
      <comment xml:lang="el">Έγγραφο Markdown</comment>
      <comment xml:lang="en_GB">Markdown document</comment>
      <comment xml:lang="es">documento Markdown</comment>
      <comment xml:lang="eu">Markdown dokumentua</comment>
      <comment xml:lang="fi">Markdown-asiakirja</comment>
      <comment xml:lang="fr">document Markdown</comment>
      <comment xml:lang="ga">cáipéis Markdown</comment>
      <comment xml:lang="gl">documento de Markdown</comment>
      <comment xml:lang="he">מסמך Markdown</comment>
      <comment xml:lang="hr">Markdown dokument</comment>
      <comment xml:lang="hu">Markdown dokumentum</comment>
      <comment xml:lang="ia">Documento Markdown</comment>
      <comment xml:lang="id">Dokumen markdown</comment>
      <comment xml:lang="it">Documento Markdown</comment>
      <comment xml:lang="ja">Markdown </comment>
      <comment xml:lang="kk">Markdown құжаты</comment>
      <comment xml:lang="ko">마크다운 문서</comment>
      <comment xml:lang="lv">Markdown dokuments</comment>
      <comment xml:lang="nl">Markdown document</comment>
      <comment xml:lang="oc">document Markdown</comment>
      <comment xml:lang="pl">Dokument Markdown</comment>
      <comment xml:lang="pt">documento Markdown</comment>
      <comment xml:lang="pt_BR">Documento Markdown</comment>
      <comment xml:lang="ru">Документ Markdown</comment>
      <comment xml:lang="sk">Dokument Markdown</comment>
      <comment xml:lang="sl">Dokument Markdown</comment>
      <comment xml:lang="sr">Маркдаун документ</comment>
      <comment xml:lang="sv">Markdown-dokument</comment>
      <comment xml:lang="tr">Markdown belgesi</comment>
      <comment xml:lang="uk">документ Markdown</comment>
      <comment xml:lang="zh_CN">Markdown 文档</comment>
      <comment xml:lang="zh_TW">Markdown 文件</comment>
      <sub-class-of type="text/plain"/>
      <glob pattern="*.md"/>
      <glob pattern="*.mkd"/>
      <glob pattern="*.markdown"/>
      <alias type="text/x-markdown"/>
    </mime-type>
</mime-info>
```
Run command
```
update-mime-database ~/.local/share/mime
```

## Install `mimetype` command

[File-MimeInfo-0.32 - Determine file types - metacpan.org](https://metacpan.org/dist/File-MimeInfo) is required for `xdg-open` to pick up user mimetype

Run following command
```
xdg-mime query filetype path/to/some.md
```
Show see following
```
text/markdown
```


## Create .desktop file

Add `Typora.deskto` to `~/.local/share/applications/Typora.desktop`
```
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
NoDisplay=true
Exec=/home/klesh/Programs/Typora-linux-x64/Typora %u
Name=Typora
Comment=Markdown Editor
MimeType=text/markdown;text/x-markdown
```

## Set `Typora` as default `md` program

Edit `~/.config/mimeapps.list` add following line
```
[Added Associations]
text/x-markdown=Typora.desktop
```
