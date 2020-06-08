$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib)

$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
  if ($_.FullName -like '*flac') {
    $e=$_.FullName -replace "flac$", "mp3"
    $f=$_.FullName -replace "flac$", "wav"
    if (Test-Path -LiteralPath "$e") {
      write-host "$e"
      $mediad = [taglib.file]::create($e)
      if (Test-Path -LiteralPath "$f") {
        Remove-Item "$f"
      }
      if ($mediad.tag.album -eq $null) {
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
      } else {
        write-host $media.tag.album
      }
    }
  }
}
