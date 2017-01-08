# simple pop model
proc_mod <- function(N_0 = 50, b = 20, s = 0.8, t = 50){
  
  N_out <- numeric(length = t)
  N_out[1] <- N_0
  
  for(step in 1:t) 
    N_out[step + 1] <- s*N_out[step] + b
  
  out <- data.frame(steps = 1:t, Pop = N_out[-1])
  
  return(out)
  
}

est <- proc_mod()


library(ggplot2)
ggplot(est, aes(steps, Pop)) + 
  geom_point() + 
  theme_bw() + 
  ggtitle('N_0 = 50, s = 0.8, b = 20\n')




# simple pop model with process uncertainty 
proc_mod2 <- function(N_0 = 50, b = 20, s = 0.8, t = 50, 
                      sig_w = 5){
  
  N_out <- numeric(length = t + 1)
  N_out[1] <- N_0
  
  sig_w <- rnorm(t, 0, sig_w)
  
  for(step in 1:t) 
    N_out[step + 1] <- s*N_out[step] + b + sig_w[step]
  
  out <- data.frame(steps = 1:t, Pop = N_out[-1])
  
  return(out)
  
}

set.seed(2)
est2 <- proc_mod2()

# plot the estimates
ggt <- paste0('N_0 = 50, s = 0.8, b = 20, sig_w = ',formals(proc_mod)$sig_w,'\n')
ggplot(est2, aes(steps, Pop)) + 
  geom_point() + 
  theme_bw() + 
  ggtitle(ggt)














# model with observation uncertainty
proc_mod3 <- function(N_0 = 50, b = 20, s = 0.8, t = 50, sig_v = 5){
  
  N_out <- numeric(length = t)
  N_out[1] <- N_0
  
  sig_v <- rnorm(t, 0, sig_v)
  
  for(step in 1:t) 
    N_out[step + 1] <- s*N_out[step] + b
  
  N_out <- N_out + c(NA,sig_v)
  
  out <- data.frame(steps = 1:t, Pop = N_out[-1])
  
  return(out)
  
}

# get estimates
set.seed(3)
est3 <- proc_mod3()

# plot
ggt <- paste0('N_0 = 50, s = 0.8, b = 20, sig_v = ',
              formals(proc_mod3)$sig_v,'\n')
ggplot(est3, aes(steps, Pop)) + 
  geom_point() + 
  theme_bw() + 
  ggtitle(ggt)




















# combined function
proc_mod_all <- function(N_0 = 50, b = 20, s = 0.8, t = 50, 
                         sig_w = 5, sig_v = 5){
  
  N_out <- matrix(NA, ncol = 4, nrow = t + 1)
  N_out[1,] <- N_0
  
  sig_w <- rnorm(t, 0, sig_w)
  sig_v <- rnorm(t, 0, sig_v)
  
  for(step in 1:t){
    N_out[step + 1, 1] <- s*N_out[step] + b
    N_out[step + 1, 2] <- N_out[step, 1] + sig_w[step]
  }
  
  N_out[1:t + 1, 3]  <- N_out[1:t + 1, 1] + sig_v
  
  N_out[1:t + 1, 4]  <- N_out[1:t + 1, 2] + sig_v
  
  out <- data.frame(1:t,N_out[-1,])
  names(out) <- c('steps', 'mod_act', 'mod_proc', 'mod_obs', 'mod_all')
  
  return(out)
  
}

# create data
set.seed(2)
est_all <- proc_mod_all()

# plot the data
library(reshape2)
to_plo <- melt(est_all, id.var = 'steps')

# re-assign factor labels for plotting
to_plo$variable <- factor(to_plo$variable, levels = levels(to_plo$variable),
                          labels = c('Actual','Pro','Obs','Pro + Obs'))

ggplot(to_plo, aes(steps, value)) + 
  geom_point() + 
  facet_wrap(~variable) + 
  ylab('Pop. estimate') + 
  theme_bw()









# comparison of mods
# create vectors for pop estimates at time t (t_1) and t - 1 (t_0)
t_1 <- est_all[2:nrow(est_all),-1]
t_1 <- melt(t_1, value.name = 'val_1')
t_0 <- est_all[1:(nrow(est_all)-1),-1]
t_0 <- melt(t_0, value.name = 'val_0')

#combine for plotting
to_plo2 <- cbind(t_0,t_1[,!names(t_1) %in% 'variable',drop = F])
head(to_plo2)
##   variable   val_0    val_1
## 1  mod_act 60.0000 68.00000
## 2  mod_act 68.0000 74.40000
## 3  mod_act 74.4000 79.52000
## 4  mod_act 79.5200 83.61600
## 5  mod_act 83.6160 86.89280
## 6  mod_act 86.8928 89.51424

# re-assign factor labels for plotting
to_plo2$variable <- factor(to_plo2$variable, levels = levels(to_plo2$variable),
                           labels = c('Actual','Pro','Obs','Pro + Obs'))

# we don't want to plot the first process model
sub_dat <- to_plo2$variable == 'Actual'
ggplot(to_plo2[!sub_dat,], aes(val_0, val_1)) + 
  geom_point() + 
  facet_wrap(~variable) + 
  theme_bw() + 
  scale_y_continuous('Population size at time t') + 
  scale_x_continuous('Population size at time t - 1') +
  geom_abline(slope = 0.8, intercept = 20)








