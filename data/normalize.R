cal_na <- function(sat_der) {
  res <- length(which(!is.na(sat_der) & sat_der != 0))
  return(res)
}

normalize <- function(sat_der, mark_val) {
  num_vec <- apply(sat_der,1,cal_na)
  cal_vec <- 1. / (num_vec * mark_val)
  sat_der[is.na(sat_der)] <- 0
  cal_vec[is.infinite(cal_vec)] <- 0
  res <- cal_vec * sat_der
  return(res)
}