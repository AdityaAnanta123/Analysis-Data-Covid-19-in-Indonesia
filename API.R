#Import library httr (to request http)
library(httr)

#Config to disable SSL Verification
set_config(config(ssl_verifypeer = 0L))

#Make new variable names resp to request get in "https://storage.googleapis.com/dqlab-dataset/update.json"
resp <- GET ("https://storage.googleapis.com/dqlab-dataset/update.json")

#Checking status code from resp variable (200 : success, 400 : couldn't find the request file, 403 : request denied, and 500 : An error occurred on the server)
status_code(resp)

#Checking status code from element resp using operator "$"
resp$status_code

#Comparating values in resp$status_code and status_code(resp). If same the output is TRUE and if not same the output is FALSE
identical(resp$status_code, status_code(resp))

#View metadata inside the headers of resp
headers(resp)

#Make a variable names cov_id_raw to extract content using content() function.
cov_id_raw <- content(resp, as = "parsed", simplifyVector = TRUE)

#Count total component of variable cov_id_raw
length(cov_id_raw)

#See names of the component in variable cov_id_raw
names(cov_id_raw)

#Make new variable named cov_id_update that contains component update from variable cov_id_raw
cov_id_update <- cov_id_raw$update

#View all sub component in component inside variable cov_id_update
lapply(cov_id_update,names)

#View date of component penambahan in variable cov_id_update
cov_id_update$penambahan$tanggal

#View number of recovered patients from covid-19 of component penambahan in variable cov_id_update
cov_id_update$penambahan$jumlah_sembuh

#View Number of deaths from covid-19 of component penambahan in variable cov_id_update
cov_id_update$penambahan$jumlah_meninggal

#View Number of positive patients from covid-19 of component total in variable cov_id_update
cov_id_update$total$jumlah_positif

#View Number of deaths from covid-19 of component total in variable cov_id_update
cov_id_update$total$jumlah_meninggal