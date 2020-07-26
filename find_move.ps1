$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib)

function find_artist {
  $_=$args[0]
  $media = [taglib.file]::create($_.FullName)
  $tags = $media.GetTag('Id3v2')
  $fileperformers = $tags.performers
  $filealbumartists = $tags.albumartists
  if (-not ( $fileperformers -eq $null) -and [string]::IsNullOrEmpty($fileperformers) -eq $False ) {
    return $fileperformers
  } elseif ( -not ( $filealbumartists -eq $null ) -and [string]::IsNullOrEmpty($filealbumartists) -eq $False ) {
    return $filealbumartists
  } else {
    return $False
  }
}

$basepath="D:\soulseek-downloads\complete"
$a = Get-ChildItem $basepath -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
  if ( $_.FullName -like '*mp3' -or $_.FullName -like '*flac' -or $_.FullName -like '*m4a' -or $_.FullName -like '*wav') {
    if (Test-Path -LiteralPath $_.FullName)  {
      $artist=find_artist $_
      if (-not ( $artist -eq $False) ) {
        if ( ( -not ( $artist -match "\&") ) -and ( -not ( $artist -match "\/" ) ) ) {
  	  $dir=Split-Path -Path $_.FullName -Parent
          if ( -not ( "$dir" -like "$basepath\$artist\*" ) -and -not ("$dir" -like "$basepath\$artist") ) {
            write-host "dir" $dir
            write-host "$basepath\$artist"
            write-host $artist
            if (-not(Test-Path -LiteralPath "$basepath\$artist") ) {
              New-Item -Path "$basepath" -Name "$artist" -ItemType "directory"
            }
            move-item -literalpath "$dir" -destination "$basepath\$artist" -Force
          }
        } else {
          write-host "$artist"
        }
      }
    }
  }
}

