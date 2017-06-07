chatty <- function(f) {
  function(x, ...) {
    res <- f(x, ...)
    cat("Processing ", x, "\n", sep = "")
    res
  }
}
f = function(x) x ^ 2
chatty(f)(1)

s = c(1,2,3)
sapply(s, chatty(f))


