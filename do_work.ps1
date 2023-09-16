$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib)

$basepath = "d:\mp3"
$basepath = "h:\mp3"
$basepath = "d:\soulseek-downloads\complete"

#$a = Get-ChildItem d:\mp3 -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem d:\soulseek-downloads\ -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem D:\soulseek-downloads\Known -recurse | Where-Object {$_.PSIsContainer -eq $True}

#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "H:\MP3\Pre-Sorted\Pietro Antonio Locatelli" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem n:\mp3 -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted\Audiomachine" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted\Elephant Gym" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem d:\soulseek-downloads\ -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted\Fred Frith" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted\Audiomachine" -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem d:\mp3 -recurse | Where-Object {$_.PSIsContainer -eq $True}
#$a = Get-ChildItem "D:\soulseek-downloads\Pre-Sorted\Elephant Gym" -recurse | Where-Object {$_.PSIsContainer -eq $True}

function cleanup {
	$a = Get-ChildItem $basepath -recurse | Where-Object {$_.PSIsContainer -eq $True}
	$a | Where-Object {$_.GetFiles().Count -eq 0 -and $_.GetDirectories().count -eq 0} | Remove-Item
	return $a
}

function copy_tag {
  $oformat=$args[0]
  $fullname=$args[1]
  if ($fullname -like "*$oformat") {
    $e=$fullname -replace "$oformat$", "mp3"
    $f=$fullname -replace "$oformat$", "wav"
    if (Test-Path -LiteralPath "$e") {
      $mediad = [taglib.file]::create($e)
      if (Test-Path -LiteralPath "$f" ) {
        if (-not($fullname -like '*.wav')) {
          write-host "Deleting $f"
          Remove-item -LiteralPath "$f"
        }
      }
      if ($mediad.tag.album -eq $null) {
        write-host "Sync tags for $e"
        $media = [taglib.file]::create($_.FullName)
        $filetitle = $media.tag.title
        $fileperformers = $media.tag.performers
        $filealbumartists = $media.tag.albumartists
        $filealbum = $media.tag.album
        $filegenres = $media.tag.genres
        $fileyear = $media.tag.year
        $filetrack = $media.tag.track
        $filetrackcount = $media.tag.trackcount
        $fileaudiobitrate = $media.properties.audiobitrate
        $fileconductor = $media.tag.conductor
        $filecomposers = $media.tag.Composers
        $fileBPM = $media.tag.BeatsPerMinute
        $pic = $media.tag.pictures
        $mediad.tag.title = [string]$filetitle
        $mediad.tag.performers = [string]$fileperformers
        $mediad.tag.albumartists = [string]$filealbumartists
        $mediad.tag.album = [string]$filealbum
        $mediad.tag.genres = [string]$filegenres
        $mediad.tag.year = $fileyear
        $mediad.tag.track = [string]$filetrack
        $mediad.tag.trackcount = [string]$filetrackcount
        $mediad.tag.conductor = [string]$fileconductor
        $mediad.tag.composers = [string]$filecomposers
        $mediad.tag.BeatsPerMinute = [string]$filebpm
        $mediad.tag.pictures = $pic
        $mediad.save()
      }
    }
  }
}

function do_work {
	$a = $args[0]

	$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
	  if ( $_.FullName -like '*mp3') {
	  } elseif ( $_.FullName -like '*m4a' -or $_.FullName -like '*wma' -or $_.FullName -like '*mp2') {
	  } elseif ( $_.FullName -like '*cue' ) {
		 write-host "Split => " $_.FullName
	  } elseif ( $_.FullName -like '*wav' ) {
		$d=$_.FullName -replace "wav$", "mp3"
		write-host $_.FullName $d
		if (-Not (Test-Path -LiteralPath $d)) {
		  & 'C:\Program Files (x86)\Lame\lame.exe' $_.FullName $d -b 320
		}
		copy_tag wav $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*aif') {
		$d=$_.FullName -replace "aif$", "wav"
		$e=$_.FullName -replace "aif$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & "d:\tools\ffmpeg.exe" -i $_.FullName $d 
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag ape $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*aiff') {
		$d=$_.FullName -replace "aiff$", "wav"
		$e=$_.FullName -replace "aiff$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & "d:\tools\ffmpeg.exe" -i $_.FullName $d
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag ape $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*aac') {
		$d=$_.FullName -replace "aac$", "wav"
		$e=$_.FullName -replace "aac$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & "d:\tools\ffmpeg.exe" -i $_.FullName $d 
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag ape $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*ape') {
		$d=$_.FullName -replace "ape$", "wav"
		$e=$_.FullName -replace "ape$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & "C:\Program Files (x86)\Monkey's Audio\MAC.exe" $_.FullName $d -d
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag ape $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*flac' ) {
		$d=$_.FullName -replace "flac$", "wav"
		$e=$_.FullName -replace "flac$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & 'd:\tools\flac.exe' -d $_.FullName -F
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag flac $_.FullName
		Remove-Item -LiteralPath $_.FullName
		
	  } elseif ( $_.FullName -like '*wv' ) {
		$d=$_.FullName -replace "wv$", "wav"
		$e=$_.FullName -replace "wv$", "mp3"
		if (-not (Test-Path -LiteralPath "$e")) {
		  & 'd:\tools\wvunpack.exe'  --wav $_.FullName $d
		  & 'C:\Program Files (x86)\Lame\lame.exe' $d $e -b 320
		  Remove-Item -LiteralPath $d
		}
		copy_tag wv $_.FullName
		Remove-Item -LiteralPath $_.FullName
	  } elseif ( $_.FullName -like '*rar' ) {
		  $7zoutput = Split-Path $_.FullName -Parent
		  #write-host $7zoutput
		  & 'C:\Program Files\7-Zip\7z.exe' e -yo"$7zoutput" $_.FullName 
	  } elseif ($_.FullName -like '*rar' -or $_.FullName -like '*zip') {
	  } ElseIf ($_.FullName -like '*avi' -or $_.FullName -like '*mov' -or $_.FullName -like '*mpeg' -or $_.FullName -like '*mpg' -or $_.FullName -like '*wmv' -or $_.FullName -like '*flv') {
	  } else {
		if ($_.FullName -like '*.original_epub' -or $_.FullName -like '*.prc' -or $_.FullName -like '*.azw3' -or $_.FullName -like '*.lit' -or $_.FullName -like '*.mobi' -or $_.FullName -like '*.opf' -or $_.FullName -like '*psd' -or $_.FullName -like '*dsn' -or $_.FullName -like '*acl' -or $_.FullName -like '*css' -or $_.FullName -like '*cld' -or $_.FullName -like '*sfk' -or $_.FullName -like '*onetoc2' -or $_.FullName -like '*csv' -or $_.FullName -like '*conf' -or $_.FullName -like '*ini'  -or $_.FullName -like '*lrc' -or $_.FullName -like '*bmp' -or $_.FullName -like '*ico' -or $_.FullName -like '*jpeg' -or $_.FullName -like '*tif' -or $_.FullName -like '*m3u' -or $_.FullName -like '*doc'  -or $_.FullName -like '*png' -or $_.FullName -like '*gif' -or $_.FullName -like '*jpg' -or $_.FullName -like '*DS_Store' -or $_.FullName -like '*nzb' -or $_.FullName -like '*torrent' -or $_.FullName -like '*rtf' -or $_.FullName -like '*db' -or $_.FullName -like '*html' -or $_.FullName -like '*log' -or $_.FullName -like '*nfo' -or $_.FullName -like '*docx' -or $_.FullName -like '*pdf' -or $_.FullName -like '*tqd' -or $_.FullName -like '*txt' -or $_.FullName -like '*md5' -or $_.FullName -like '*dat' -or $_.FullName -like '*asd' -or $_.FullName -like '*htm' -or $_.FullName -like '*yaml' -or $_.FullName -like '*hash' -or $_.FullName -like '*sfv' -or $_.FullName -like '*sls' -or $_.FullName -like '*url' -or $_.FullName -like '*lnk' -or $_.FullName -like '*xml' -or $_.FullName -like '*mht' -or $_.FullName -like '*directory' -or $_.FullName -like '*micro' -or $_.FullName -like '*bak' -or $_.FullName -like '*fpl' -or $_.FullName -like '*nra' -or $_.FullName -like '*diz' -or $_.FullName -like '*m3u8' -or $_.FullName -like '*mxm' -or $_.FullName -like '*b52' -or $_.FullName -like '*jsp' -or $_.FullName -like '*lfml' -or $_.FullName -like '*thm' -or $_.FullName -like '*webloc' -or $_.FullName -like '*accurip' -or $_.FullName -like '*pamp' -or $_.FullName -like '*m3u8'-or $_.FullName -like '*par2'-or $_.FullName -like '*webp' -or $_.FullName -like '*bat' -or $_.FullName -like '*tmp' -or $_.FullName -like '*cfg') {
		  write-host "*$_.FullName"
		  remove-item  -LiteralPath $_.FullName
		} else {
		  if (-not ((GET-ITEM $_.FullName) -is [system.io.directoryinfo])) {
			write-host $_.FullName
		  }
		}
	  }
	}
}

$a = cleanup
do_work $a
$a = cleanup

$basepath = "d:\soulseek-downloads\Known"
$a = cleanup
