#' Install ngrok
#'
#' \code{ngrok()} provide the function to start ngrok job.
#' \code{proc_kill()} used to kill the ngrok.
#'
#' @export
ngrok = function(port=8080, user = NULL,password = NULL) {
  statusInstall = checkNgrok()
  if(!statusInstall){
    stop("ngrok not found!")
  }
  statusAuth = authCheck()
  if(!statusAuth){
    stop("ngrok not authrised, try www.ngrok.com to get token.\n
         Using: ngrokAuth(\"***YourToken***\") to set token")
  }

  port = as.integer(port)
  if(is.null(user) | is.null(password)){
    p1 = proc_new(ngrokPath(),c("http", port,'--log','\'stdout\''))
  }else{
    p1 = proc_new(ngrokPath(), c('http','--auth',
                           sprintf("\"%s:%s\"",user,password),
                           '--log','\'stdout\'',
                           port))
  }
  pid = p1$get_pid()
  # p1_print = function() {
  #   if (proc_print(p1, c(TRUE, TRUE))) later::later(p1_print, 100)
  # }
  # p1_print()
  message(sprintf('ngrok running in pid: %s ,using `proc_kill(%s)` to kill ngrok~',pid,pid))
  browseURL("localhost:4040")
  invisible(NULL)
}

#' @export
ngrokAuth = function(token){
  statusInstall = checkNgrok()
  if(!statusInstall){
    stop("ngrok not found!")
  }

  system2(ngrokPath(),c("authtoken", token))

  invisible(NULL)
}



proc_new = function(..., stderr = '|') {
  processx::process$new(..., stderr = stderr)
}

# control = c(show_out, show_error)
# proc_print = function(p, control = c(TRUE, TRUE)) {
#   if (!p$is_alive()) return(FALSE)
#   if (control[1]) {
#     out = p$read_output_lines()
#     if (length(out)) cat(out, file = stdout(), sep = '\n')
#   }
#   if (control[2]) {
#     err = p$read_error_lines()
#     if (length(err)) cat(err, file = stderr(), sep = '\n')
#   }
#   TRUE
# }

#'export
proc_kill = function(pid) {
  if (is_windows()) {
    system2('taskkill', c('/f', '/pid', pid))
  } else {
    system2('kill', pid)
  }
}
