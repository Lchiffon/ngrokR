
authCheck = function(){
  file.exists('~/.ngrok2/ngrok.yml')
}

is_windows = function() .Platform$OS.type == 'windows'
is_osx = function() Sys.info()[['sysname']] == 'Darwin'
is_linux = function() Sys.info()[['sysname']] == 'Linux'



download2 = function(url, ...) {
  download = function(method = 'auto', extra = getOption('download.file.extra')) {
    download.file(url, ..., method = method, extra = extra)
  }
  if (is_windows())
    return(tryCatch(download(method = 'wininet'), error = function(e) {
      download()  # try default method if wininet fails
    }))

  R340 = getRversion() >= '3.4.0'
  if (R340 && download() == 0) return(0L)
  # if non-Windows, check for libcurl/curl/wget/lynx, call download.file with
  # appropriate method
  res = NA
  if (Sys.which('curl') != '') {
    # curl needs to add a -L option to follow redirects
    if ((res <- download(method = 'curl', extra = '-L')) == 0) return(res)
  }
  if (Sys.which('wget') != '') {
    if ((res <- download(method = 'wget')) == 0) return(res)
  }
  if (Sys.which('lynx') != '') {
    if ((res <- download(method = 'lynx')) == 0) return(res)
  }
  if (is.na(res)) stop('no download method found (wget/curl/lynx)')

  res
}


pkg_file = function(..., mustWork = TRUE) {
  system.file(..., package = 'ngrokR', mustWork = mustWork)
}
