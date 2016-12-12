#' @importFrom stats pchisq qchisq
#' @title One sample variance comparison test
#' @description  \code{os_vartest} performs tests on the equality of standard
#' deviations (variances).It tests that the standard deviation of \code{x} is
#' \code{sd}.
#' @param x a numeric vector
#' @param sd hypothesised standard deviation
#' @param conf.int confidence level
#' @param alternative a character string specifying the alternative hypothesis,
#' must be one of "both" (default), "greater", "less" or "all". You can specify
#' just the initial letter.
#' @return \code{os_vartest} returns an object of class \code{"os_vartest"}.
#' An object of class \code{"os_vartest"} is a list containing the
#' following components:
#'
#' \item{n}{number of observations}
#' \item{sd}{hypothesised standard deviation of \code{x}}
#' \item{sigma}{observed standard deviation}
#' \item{se}{estimated standard error}
#' \item{chi}{chi-square statistic}
#' \item{df}{degrees of freedom}
#' \item{p_lower}{lower one-sided p-value}
#' \item{p_upper}{upper one-sided p-value}
#' \item{p_two}{two-sided p-value}
#' \item{xbar}{mean of \code{x}}
#' \item{c_lwr}{lower confidence limit of standard deviation}
#' \item{c_upr}{upper confidence limit of standard deviation}
#' \item{var_name}{name of \code{x}}
#' \item{conf}{confidence level}
#' \item{type}{alternative hypothesis}
#'
#' @examples
#' os_vartest(mtcars$mpg, 0.3, alternative = 'less')
#' os_vartest(mtcars$mpg, 0.3, alternative = 'greater')
#' os_vartest(mtcars$mpg, 0.3, alternative = 'both')
#' os_vartest(mtcars$mpg, 0.3, alternative = 'all')
#'
#' @export
#'
os_vartest <- function(x, sd, conf.int = 0.95,
	alternative = c('both', 'less', 'greater', 'all')) UseMethod('os_vartest')

# default
os_vartest.default <- function(x, sd, alpha = 0.05,
	alternative = c('both', 'less', 'greater', 'all')) {

	type    <- match.arg(alternative)
	varname <- l(deparse(substitute(x)))
	n       <- length(x)
	df      <- n - 1
	xbar    <- round(mean(x), 4)
	sigma   <- round(sd(x), 4)
	se      <- round(sigma / sqrt(n), 4)
	chi     <- round((df * (sigma / sd) ^ 2), 4)

	p_lower <- pchisq(chi, df)
	p_upper <- pchisq(chi, df, lower.tail = F)
	p_two   <- pchisq(chi, df, lower.tail = F) * 2

	conf    <- conf.int
	a       <- (1 - conf) / 2
	al      <- 1 - a
	tv      <- df * sigma
	c_lwr   <- round(tv / qchisq(al, df), 4)
	c_upr   <- round(tv / qchisq(a, df), 4)

	result <- list(n        = n,
                 sd       = sd,
                 sigma    = sigma,
                 se       = se,
                 chi      = chi,
		             df       = df,
                 p_lower  = p_lower,
                 p_upper  = p_upper,
                 p_two    = p_two,
                 xbar     = xbar,
		             c_lwr    = c_lwr,
                 c_upr    = c_upr,
                 var_name = varname,
                 conf     = conf,
                 type     = type)

	class(result) <- 'os_vartest'
	return(result)

}

#' @export
#'
print.os_vartest <- function(x, ...) {
  print_os_vartest(x)
}