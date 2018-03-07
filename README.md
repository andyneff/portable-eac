# EAC Portable

My attempt at writing a portable app, in a git repo with a proper build script

All you do it run:

```bash
build.bat
```

And it will download and extract all the binary files for you. From there, feel
free to use PortableApps.com Launcher Installer

# Requirements

- Docker for Windows

# Arguments

To easily change the versions of the software used, set the following build args

- `7Z_VERSION`
- `INNOUNP_VERSION`
- `EAC_VERSION`
- `LAME_VERSION`
- `OGG_VERSION`
- `AAC_VERSION`
- `MAC_VERSION` - There is something really weird and suspicious going on 
[Monkey's Audio](http://www.monkeysaudio.com/download.html) download page. So
right now it downloads from archive.org. If the version is changes, the URL
probably needs to be changed

Some of the urls download via insecure http. So in these cases, you really need 
to specify the sha512 checksum (using capital letters)

- `EAC_SHA`
- `LAME_SHA`
- `OGG_SHA`
- `AAC_SHA`
- `MAC_SHA`