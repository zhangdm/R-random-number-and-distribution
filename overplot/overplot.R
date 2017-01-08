library(SWMPr)
# import data and do some initial clean up
data(apacpwq)
View(apacpwq)
dat <- qaqc(apacpwq)

# a truly heinous plot
overplot(dat, select = c('depth', 'do_mgl', 'ph', 'turb'),
         subset = c('2013-01-01 0:0', '2013-02-01 0:0'), lwd = 2)

# import data
data(apadbwq)
dat <- apadbwq

# retain only '0' and '-1' flags, as in the older version
newdat <- qaqc(dat, qaqc_keep = c('0', '-1'))

# retain observations with the 'CSM' error code
newdat <- qaqc(dat, qaqc_keep = 'CSM')

