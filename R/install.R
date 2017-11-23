#' Install ngrok
#'
#' \code{downloadNgrok()} provide the function to download and install ngrok.
#'
#' @export
downloadNgrok = function(){
  message("Download URL from https://ngrok.com/download")
  if(is_linux()){
   url = 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
  }else if(is_windows()){
   url = 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip'
  }else if(is_osx()){
   url = 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip'
  }else{
    stop("Sorry, ngrokR only support Windows/Mac/Linux...")
  }

  message(url)

  owd = setwd(tempdir())
  on.exit(setwd(owd), add = TRUE)

  download_zip = function(type = 'zip') {
    type = 'zip'
    zipfile = 'ngrok.zip'
    download2(url, zipfile, mode = 'wb')
    switch(type, zip = utils::unzip(zipfile), tar.gz = {
      files = utils::untar(zipfile, list = TRUE)
      utils::untar(zipfile)
      files
    })
  }

  files = download_zip(type = 'zip')

  if (is_windows()) {
    file.rename(basename(files), 'ngrok.exe')
    exec = 'ngrok.exe'
  } else {
    file.rename(basename(files), 'ngrok')
    exec = 'ngrok'
    Sys.chmod(exec, '0755')  # chmod +x
  }

  success = FALSE
  dirs = pkg_file()
  for (destdir in dirs) {
    dir.create(destdir, showWarnings = FALSE)
    success = file.copy(exec, destdir, overwrite = TRUE)
    if (success) break
  }
  file.remove(exec)

  if (!success) stop(
    'Unable to install ngrok to any of these dirs: ',
    paste(dirs, collapse = ', ')
  )
  message('ngrok has been installed to ', normalizePath(destdir))
}


checkNgrok = function(){
  filePath = ngrokPath()
  status = file.exists(filePath)
  if(!status){
    message("ngrok not Found! run ngrokR::installNgrok() to install ngrok tools...")
  }
  return(status)
}
