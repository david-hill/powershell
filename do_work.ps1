$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
  if ( $_.FullName -like '*mp3') {
  } elseif ( $_.FullName -like '*m4a' -or $_.FullName -like '*wma' -or $_.FullName -like '*mp2') {
  } elseif ($_.FullName -like '*wav' -or $_.FullName -like '*flac' -or $_.FullName -like '*cue' -or $_.FullName -like '*ape') {
  } elseif ($_.FullName -like '*rar' -or $_.FullName -like '*zip') {
  } ElseIf ($_.FullName -like '*avi' -or $_.FullName -like '*mov' -or $_.FullName -like '*mpeg' -or $_.FullName -like '*mpg' -or $_.FullName -like '*wmv' -or $_.FullName -like '*flv') {
  } else {
    if ($_.FullName -like '*psd' -or $_.FullName -like '*dsn' -or $_.FullName -like '*acl' -or $_.FullName -like '*css' -or $_.FullName -like '*cld' -or $_.FullName -like '*sfk' -or $_.FullName -like '*onetoc2' -or $_.FullName -like '*csv' -or $_.FullName -like '*conf' -or $_.FullName -like '*ini'  -or $_.FullName -like '*lrc' -or $_.FullName -like '*bmp' -or $_.FullName -like '*ico' -or $_.FullName -like '*jpeg' -or $_.FullName -like '*tif' -or $_.FullName -like '*m3u' -or $_.FullName -like '*doc'  -or $_.FullName -like '*png' -or $_.FullName -like '*gif' -or $_.FullName -like '*jpg' -or $_.FullName -like '*DS_Store' -or $_.FullName -like '*nzb' -or $_.FullName -like '*torrent' -or $_.FullName -like '*rtf' -or $_.FullName -like '*db' -or $_.FullName -like '*html' -or $_.FullName -like '*log' -or $_.FullName -like '*nfo' -or $_.FullName -like '*docx' -or $_.FullName -like '*pdf' -or $_.FullName -like '*tqd' -or $_.FullName -like '*txt' -or $_.FullName -like '*md5' -or $_.FullName -like '*dat' -or $_.FullName -like '*asd' -or $_.FullName -like '*htm' -or $_.FullName -like '*yaml' -or $_.FullName -like '*hash' -or $_.FullName -like '*sfv' -or $_.FullName -like '*sls' -or $_.FullName -like '*url' -or $_.FullName -like '*lnk' -or $_.FullName -like '*xml' -or $_.FullName -like '*mht' -or $_.FullName -like '*directory' -or $_.FullName -like '*micro' -or $_.FullName -like '*bak' -or $_.FullName -like '*fpl' -or $_.FullName -like '*nra' -or $_.FullName -like '*diz' -or $_.FullName -like '*m3u8' -or $_.FullName -like '*mxm' -or $_.FullName -like '*b52' -or $_.FullName -like '*jsp' -or $_.FullName -like '*lfml' -or $_.FullName -like '*thm' -or $_.FullName -like '*webloc' -or $_.FullName -like '*accurip' -or $_.FullName -like '*pamp' -or $_.FullName -like '*m3u8'-or $_.FullName -like '*par2'-or $_.FullName -like '*webp' -or $_.FullName -like '*bat' -or $_.FullName -like '*tmp' -or $_.FullName -like '*cfg') {
      write-host $_.FullName
      remove-item  -LiteralPath $_.FullName
    } else {
      if (-not ((GET-ITEM $_.FullName) -is [system.io.directoryinfo])) {
        write-host $_.FullName
      }
    }
  }
}

$a | Where-Object {$_.GetFiles().Count -eq 0 -and $_.GetDirectories().count -eq 0} | Remove-Item

$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles("*.flac").Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem  | ForEach-Object {
  if ($_.FullName -like '*flac') {
    $d=$_.FullName -replace "flac$", "wav"
    $e=$_.FullName -replace "flac$", "mp3"
    if (-not (Test-Path -LiteralPath "$e")) {
      & 'd:\tools\flac.exe' -d $_.FullName -F
      & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
      Remove-Item $d
    }
  }
}         

$a | Where-Object {$_.GetFiles("*.ape").Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem  | ForEach-Object {
  if ($_.FullName -like '*ape') {
    $d=$_.FullName -replace "ape$", "wav"
    $e=$_.FullName -replace "ape$", "mp3"
    if (-not (Test-Path -LiteralPath "$e")) {
      & "C:\Program Files (x86)\Monkey's Audio\MAC.exe" $_.FullName $d -d
      & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
      Remove-Item $d
    }
  }
}     

$a | Where-Object {$_.GetFiles("*.wav").Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem  | ForEach-Object {
  if ($_.FullName -like '*wav') {
    $d=$_.FullName -replace "wav$", "mp3"
    if (-Not (Test-Path -LiteralPath $d)) {
      & 'C:\Program Files (x86)\Lame\lame.exe' $_.FullName $d -b 320
    }
  }
}
