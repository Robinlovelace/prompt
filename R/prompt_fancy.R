
#' A fancy prompt, showing probably too much information
#'
#' It also uses color, on terminals that support it.
#' Is shows: \itemize{
#'   \item Status of last command.
#'   \item Memory usage of the R process.
#'   \item Package being developed using devtools, if any.
#'   \item Git branch and state of the working tree if within a git tree.
#' }
#'
#' @param expr Evaluated expression.
#' @param value Its value.
#' @param ok Whether the evaluation succeeded.
#' @param visible Whether the result is visible.
#'
#' @family example prompts
#' @importFrom crayon green red blue
#' @export

prompt_fancy <- function(expr, value, ok, visible) {

  status <- if (ok) green(symbol$tick) else red(symbol$cross)

  mem <- paste0(memory_usage(), " ")

  pkg <- if (using_devtools()) paste0(devtools_package(), " ") else ""

  git <- git_info()

  paste0(
    "\n",
    status, " ",
    grey(mem),
    blue(pkg),
    grey(git), "\n",
    symbol$pointer,
    " "
  )
}

memory_usage <- function() {
  current <- memuse::Sys.procmem()[[1]]
  size <- memuse::size(current)
  unit <- memuse::unit(current)

  paste0(round(size, 1), " ", unit)
}

git_info <- function() {
  if (!is_git_dir()) return("")

  paste0(
    git_branch(),
    git_dirty(),
    git_arrows()
  )
}

grey <- crayon::make_style("darkgrey")