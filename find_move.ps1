$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib)

function find_artist {
  $_=$args[0]
  $media = [taglib.file]::create($_.FullName)
  $fileperformers = $media.tag.performers
  $filealbumartists = $media.tag.albumartists
  if (-not ( $fileperformers -eq $null) ) {
    return $fileperformers
  } elseif ( -not ( $filealbumartists -eq $null ) ) {
    return $filealbumartists
  } else {
    return $False
  }
}

$find_artist="Cisfinitum"
$basepath="d:\soulseek-downloads\complete"
$a = Get-ChildItem $basepath -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
  if ( $_.FullName -like '*mp3' -or $_.FullName -like '*flac' -or $_.FullName -like '*m4a' -or $_.FullName -like '*wav') {
    if (Test-Path -LiteralPath $_.FullName)  {
      $dir=Split-Path -Path $_.FullName -Parent
      if ( -not ( "$dir" -like "$basepath\$find_artist\*" ) ) {
        write-host "dir" $dir
        $artist=find_artist $_
        if (-not ( $artist -eq $False) ) {
          write-host $artist
          if ($artist -like "*$find_artist*" ) {
            if (-not(Test-Path -LiteralPath "$basepath\$find_artist") ) {
              New-Item -Path "$basepath" -Name "$find_artist" -ItemType "directory"
            }
              move-item -path "$dir" -destination "$basepath\$find_artist" -Force
          }
        }
      }
    }
  }
}
