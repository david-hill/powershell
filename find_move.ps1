$taglib = "d:\tools\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($taglib) | out-null

$a = $null
$basepath="D:\soulseek-downloads\complete"

function cleanup {
	$a = $args[0]
	if ($a -ne $null) {
		write-host "Cleaning up emtpy folders... " -nonewline
		$a | Where-Object {$_.GetFiles().Count -eq 0 -and $_.GetDirectories().count -eq 0} | Remove-Item
		write-host "done.`n" -nonewline
	}
}
function get_list {
	write-host "`nGetting file list... " -nonewline
	$a = Get-ChildItem $basepath -recurse | Where-Object {$_.PSIsContainer -eq $True}
	write-host "done.`n" -nonewline
	return $a
}

function find_artist {
  $_=$args[0]
  $artist=$_
  try {
	$media = [taglib.file]::create($_.FullName)
    $tags = $media.GetTag('Id3v2')
  }
  catch {
    "Error: $artist"
	return $False
  }
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

function findAndMove {
	$a=$args[0]
	$total = 0
	$inc = 0
	$last = -1
	if ($a -ne $null) {
		write-host "`nCounting objects... " -nonewline
		$total = ($a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | Measure-Object).Count
		write-host "done.`n" -nonewline
		write-host "`nProcessing $total items`n"
		$a | Where-Object {$_.GetFiles().Count -ne 0 -and $_.GetDirectories().count -eq 0} | get-childitem | ForEach-Object {
			if ( $_.FullName -like '*mp3' -or $_.FullName -like '*flac' -or $_.FullName -like '*m4a' -or $_.FullName -like '*wav') {
				$inc = $inc + 1;
				$progress = [math]::floor($inc / $total * 100)
				if ($progress -ne $last) {
					#write-host "`rProgress: $progress %" -nonewline
					Write-Progress -Activity "Search in Progress" -Status "$progress% Complete:" -PercentComplete $progress
					$last = $progress
				}
				if (Test-Path -LiteralPath $_.FullName)  {
					$artist=find_artist $_
					$filename=$_.FullName
					if (-not ( $artist -eq $False) ) {
						if ( ( -not ( $artist -match "\&") ) -and ( -not ( $artist -match "\/" ) ) ) {
							$dir=Split-Path -Path $_.FullName -Parent
							try {
								if ( -not ( "$dir" -like "$basepath\$artist\*" ) -and -not ("$dir" -like "$basepath\$artist") ) {
									write-host "dir" $dir
									write-host "$basepath\$artist"
									write-host $artist
									if (-not(Test-Path -LiteralPath "$basepath\$artist") ) {
										try {
											New-Item -Path "$basepath" -Name "$artist" -ItemType "directory"
										}
										catch {
											"ERROR: $basepath $artist"
										}
									}
									try {
										$media = [taglib.file]::create($_.FullName)
										$filealbum = $media.tag.album
										$fileyear = $media.tag.year
										if ( (-not [string]::IsNullOrEmpty($filealbum)) -and (-not [string]::IsNullOrEmpty($fileyear))) {
											move-item -literalpath "$dir" -destination "$basepath\$artist\$fileyear - $filealbum" -Force
										} else {
											move-item -literalpath "$dir" -destination "$basepath\$artist" -Force
										}			  
									}
									catch {
									  "ERROR: $filename"
									}
								}
							} catch {
								"ERROR: $filename"						
							}
						} else {
						  $dir=Split-Path -Path $_.FullName -Parent
						  write-host "$dir = $artist"
						}
					}
				}
			} else {
				$inc = $inc + 1;
			}
		}
	} else {
		write-host "Nothing to process."
	}
}

$a = get_list
findAndMove $a
$a = get_list
cleanup $a
