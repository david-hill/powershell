$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib)

$a = Get-ChildItem d:\soulseek-downloads\complete -recurse | Where-Object {$_.PSIsContainer -eq $True}

$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
  if ($_.FullName -like '*flac') {
    $e=$_.FullName -replace "flac$", "mp3"
    $f=$_.FullName -replace "flac$", "wav"
    if (Test-Path -LiteralPath "$e") {
      $mediad = [taglib.file]::create($e)
      if ($media.tag.album -eq $null) {
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
        $media.tag.title = [string]$filetitle
        $media.tag.performers = [string]$fileperformers
        $media.tag.albumartists = [string]$filealbumartists
        $media.tag.album = [string]$filealbum
        $media.tag.genres = [string]$filegenres
        $media.tag.year = $fileyear
        $media.tag.track = [string]$filetrack
        $media.tag.trackcount = [string]$filetrackcount
        $media.tag.conductor = [string]$fileconductor
        $media.tag.composers = [string]$filecomposers
        $media.tag.BeatsPerMinute = [string]$filebpm
        $media.tag.pictures = $pic
        $media.save()
        Remove-Item "$f"
      } else {
        write-host $media.tag.album
      }
    }
  }
}
