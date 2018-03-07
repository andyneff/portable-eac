FROM microsoft/windowsservercore:1709 AS sevenz

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG 7Z_VERSION=18.01
RUN $url = \"https://downloads.sourceforge.net/project/sevenzip/7-Zip/$env:7Z_VERSION/7z$($env:7Z_VERSION -replace '\.','')-x64.msi\"; \
    # https://stackoverflow.com/a/28333370/4166604. STUPID WINDOWS!!!! > : O
    # Only download.sourceforge.net and sourceforge.net have this limitation,
    # the rest of the mirrors that I tested work as expected. You CHOULD
    # download from http://download.sourceforge.net, but this is hardly safe
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11; \
    echo "Downloading 7z..."; \
    (New-Object System.Net.WebClient).DownloadFile($url, \"7z.msi\"); \
    echo "Installing 7z..."; \
    Start-Process msiexec.exe -ArgumentList '/i', 7z.msi, '/quiet' -NoNewWindow -Wait; \
    Remove-Item -Force 7z.msi
# Files in C:\Program Files\7-Zip

FROM microsoft/windowsservercore:1709 AS innounp

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

COPY --from=sevenz ["C:\\\\Program Files\\\\7-Zip", "C:\\\\7z"]

ARG INNOUNP_VERSION=0.46
RUN $url = \"https://downloads.sourceforge.net/project/innounp/innounp/innounp%20$env:INNOUNP_VERSION/innounp$($env:INNOUNP_VERSION -replace '\.','').rar\"; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11; \
    (New-Object System.Net.WebClient).DownloadFile($url, \"innounp.rar\"); \
    c:\7z\7z.exe x innounp.rar; \
    Remove-Item -Force innounp.rar
# File in c:\innounp.exe

FROM microsoft/windowsservercore:1709 AS eac

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

COPY --from=sevenz ["C:\\\\Program Files\\\\7-Zip", "C:\\\\7z"]

ARG EAC_VERSION=1.3
# Use sha, since this is an http download
ARG EAC_SHA=2EB30132E8ABD7B4CF628E2AE6465BBA9F4059F868A688DA395AA467F3009FAC0E6E4B337F73C3B344083231CBBABF959C9FD3E0D24794C0D22F7215ED358503 
RUN $url = \"http://www.exactaudiocopy.de/eac-$env:EAC_VERSION.exe\"; \
    (New-Object System.Net.WebClient).DownloadFile($url, 'eac.exe'); \
    if ((Get-FileHash eac.exe -Algorithm sha512).Hash -ne $Env:EAC_SHA) { \
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
        exit 1; \
    }; \
    c:\7z\7z.exe x -aoa -oc:\eac eac.exe; \
    Remove-Item -Recurse -Force 'C:\eac\$PLUGINSDIR'; \
    Remove-Item -Force eac.exe
# Files in C:\eac

FROM microsoft/windowsservercore:1709 AS lame

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG LAME_VERSION=3.100
ARG LAME_SHA=102F2F3ABB155040AAFDBD269C6728B0CC8F18C12B1C6C52866BB1F7683226B2E23C3235D86E5448EDCD790B9993C0FD1613B0FA1CCECF87934AD217B56F33F2
RUN $url = \"http://www.rarewares.org/files/mp3/lame$env:LAME_VERSION-64.zip\"; \
    (New-Object System.Net.WebClient).DownloadFile($url, 'lame.zip'); \
    if ((Get-FileHash lame.zip -Algorithm sha512).Hash -ne $Env:LAME_SHA) { \
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
        exit 1; \
    }; \
    $ProgressPreference = 'SilentlyContinue'; \
    Expand-Archive -Path lame.zip -DestinationPath C:\ltemp -Force; \
    mkdir C:\lame > $null; \
    Move-Item C:\ltemp\doc\html\* C:\lame\; \
    Move-Item C:\ltemp\lame* C:\lame\; \
    Remove-Item -Force C:\lame\Makefile.*; \
    Remove-Item -Force lame.zip; \
    Remove-Item -Force -Recurse C:\ltemp
# Files in C:\lame


FROM microsoft/windowsservercore:1709 AS ogg

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG OGG_VERSION=2.88-1.3.5-x64
ARG OGG_SHA=DFD580D43E9CC86B9DD8372B99E6380ECA7195F1D37E13BF51E5A179D658A42032CB4BA972ABA224EA38D896289958CD3A61D6CB6699CC1B739E9A11CBED5EED
RUN $url = \"http://www.rarewares.org/files/ogg/oggenc${env:OGG_VERSION}.zip\"; \
    (New-Object System.Net.WebClient).DownloadFile($url, 'ogg.zip'); \
    if ((Get-FileHash ogg.zip -Algorithm sha512).Hash -ne $Env:OGG_SHA) { \
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
        exit 1; \
    }; \
    $ProgressPreference = 'SilentlyContinue'; \
    Expand-Archive -Path ogg.zip -DestinationPath C:\ogg -Force; \
    Remove-Item -Force ogg.zip
# Files in C:\ogg

FROM microsoft/windowsservercore:1709 AS aac

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG AAC_VERSION=1.28
ARG AAC_SHA=8DE13E1C882718895AA9A4872D160FB8FA53C70F05B44AECD7FB63F3A98F6B0EC8F23549BE1C10CB2FD53C56DE41A17D196853AF30BE015EF302F91AC647C991
RUN $url = \"http://www.rarewares.org/files/aac/faac-${env:AAC_VERSION}-mod.zip\"; \
    (New-Object System.Net.WebClient).DownloadFile($url, 'aac.zip'); \
    if ((Get-FileHash aac.zip -Algorithm sha512).Hash -ne $Env:AAC_SHA) { \
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
        exit 1; \
    }; \
    $ProgressPreference = 'SilentlyContinue'; \
    Expand-Archive -Path aac.zip -DestinationPath C:\aac -Force; \
    Remove-Item -Force aac.zip
# Files in C:\aac

FROM microsoft/windowsservercore:1709 AS mac

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

COPY --from=innounp ["C:\\\\innounp.exe", "C:\\\\"]

ARG MAC_VERSION=4.33
ARG MAC_SHA=ff7e28adf4a3377a7a277482923d3bf0e40d2836265e2808377771e34ce3841d27869a90900bf0ec76c8cde2148570542209e1501cf178d658c788381a452cd2 
# RUN $url = \"http://monkeysaudio.com/files/MAC_$($env:MAC_VERSION -replace '\.','')_x64.exe\"; \
RUN $url = \"https://web.archive.org/web/20180201033327/http://monkeysaudio.com/files/MAC_$($env:MAC_VERSION -replace '\.','')_x64.exe\"; \
    (New-Object System.Net.WebClient).DownloadFile($url, 'mac.exe'); \
    if ((Get-FileHash mac.exe -Algorithm sha512).Hash -ne $Env:MAC_SHA) { \
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
        exit 1; \
    }; \
    c:\innounp.exe -x -dC:\mtemp mac.exe; \
    mkdir C:\mac > $null; \
    Move-Item 'C:\mtemp\{app}\Help' C:\mac\; \
    Move-Item 'C:\mtemp\{app}\MAC.exe' C:\mac\; \
    Remove-Item -Force mac.exe; \
    Remove-Item -Force -Recurse C:\mtemp

FROM microsoft/nanoserver:1709

COPY --from=eac ["C:\\\\eac", "C:\\\\eac"]
COPY --from=aac ["C:\\\\aac", "C:\\\\aac"]
COPY --from=mac ["C:\\\\mac", "C:\\\\mac"]
COPY --from=lame ["C:\\\\lame", "C:\\\\lame"]
COPY --from=ogg ["C:\\\\ogg", "C:\\\\ogg"]

CMD xcopy c:\eac c:\App\EAC\ /s /e & \
    xcopy c:\aac c:\App\AAC\ /s /e & \
    xcopy c:\mac c:\App\APE\ /s /e & \
    xcopy c:\lame c:\App\LAME\ /s /e & \
    xcopy c:\ogg c:\App\Ogg\ /s /e
