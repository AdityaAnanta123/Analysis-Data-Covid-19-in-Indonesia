#Import library httr (to request http)
#Import library dplyr (to manipulate data)
#Import library ggplot2 (to visualize data)
#Import library hrbrthemes (to change the theme and visual element data)
#Import library lubridate (to manipulate date and time data)
#Import library tidyr (to change data info structural format data)
library(httr)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(lubridate)
library(tidyr)

#Config to disable SSL Verification
set_config(config(ssl_verifypeer = 0L))

#Make new variable names resp_jabar to request get in "https://storage.googleapis.com/dqlab-dataset/prov_detail_JAWA_BARAT.json"
resp_jabar <- GET("https://storage.googleapis.com/dqlab-dataset/prov_detail_JAWA_BARAT.json")

##Make a variable names cov_jabar_raw to extract content using content() function.
cov_jabar_raw <- content(resp_jabar, as = "parsed", simplifyVector = TRUE)

#Check names of component in variable cov_jabar_raw
names(cov_jabar_raw)

#View total case covid-19 in component kasus_total of variable cov_jabar_raw
cov_jabar_raw$kasus_total

#View presentage of patient death covid-19 in component meninggal_persen of variable cov_jabar_raw
cov_jabar_raw$meninggal_persen

#View presentage of patient recover covid-19 in component meninggal_persen of variable cov_jabar_raw
cov_jabar_raw$sembuh_persen

#Make a new variable named cov_jabar with values component list_perkembangan of variable cov_jabar_raw
cov_jabar <- cov_jabar_raw$list_perkembangan

#View structure variable cov_jabar
str(cov_jabar)

#View top data from variable cov_jabar
head(cov_jabar)

#Make a new variable named new_cov_jabar
new_cov_jabar <-
  cov_jabar %>%  #Make a pipeline using operator %>% to connect more than 1 operation
  select(-contains("DIRAWAT_OR_ISOLASI")) %>% #Select data except contains "DIRAWAT_OR_ISOLASI" word
  select(-starts_with("AKUMULASI")) %>% #Select data except start with "AKUMULASI" word
  rename(
    kasus_baru = KASUS,
    meninggal = MENINGGAL,
    sembuh = SEMBUH
  ) %>% #Rename multiple column like kasus_baru, meninggal, and sembuh
  mutate(
    tanggal = as.POSIXct(tanggal / 1000, origin = "1970-01-01"),
    tanggal = as.Date(tanggal)
  ) #Convert date from milisecond to original date

#View structure of variable new_cov_jabar
str(new_cov_jabar)  

#Visualize Daily Positive Covid Cases in early Juli 2020-2022
ggplot(new_cov_jabar, aes(tanggal, kasus_baru)) +
  geom_col(fill = "salmon") + labs(
    x = NULL,
    y = "Jumlah Kasus",
    title = "Kasus Harian Positif Covid-19 di Indonesia",
    subtitle = "Terjadi pelonjakan kasus di awal bulan Juli akibat klaster Secapa AD Bandung",
    caption = "Sumber Data : covid19.go.id"
  ) + theme_ipsum(
    base_size = 13,
    plot_title_size = 21,
    grid = "y",
    ticks = TRUE
  ) + theme(plot.title.position = "plot")


#Visualize Daily Recovery Covid Cases in Jawa Barat
ggplot(new_cov_jabar, aes(tanggal, sembuh)) +
  geom_col(fill = "olivedrab2") +
  labs(
    x = NULL,
    y = "Jumlah kasus",
    title = "Kasus Harian Sembuh Dari COVID-19 di Jawa Barat",
    caption = "Sumber data: covid.19.go.id"
  ) +
  theme_ipsum(
    base_size = 13, 
    plot_title_size = 21,
    grid = "Y",
    ticks = TRUE
  ) +
  theme(plot.title.position = "plot")

#Visualize Daily Death Covid-19 Cases in Jawa Barat
ggplot(new_cov_jabar, aes(tanggal, meninggal)) +
  geom_col(fill = "darkslategray4") +
  labs(
    x = NULL,
    y = "Jumlah kasus",
    title = "Kasus Harian Meninggal Akibat COVID-19 di Jawa Barat",
    caption = "Sumber data: covid.19.go.id"
  ) +
  theme_ipsum(
    base_size = 13, 
    plot_title_size = 21,
    grid = "Y",
    ticks = TRUE
  ) +
  theme(plot.title.position = "plot")

#Make a new variable cov_jabar_pekanan
cov_jabar_pekanan <- new_cov_jabar %>% 
  count(
    tahun = year(tanggal), #Make a new variable tahun using year in column tanggal
    pekan_ke = week(tanggal), #Make a new variable pekan_ke using week in column tanggal
    wt = kasus_baru, #Count tahun and pekan_ke based on kasus_baru column
    name = "jumlah" #Named calculation for wt in column jumlah
  )

#Show the information statistic about the variable cov_jabar_pekanan
glimpse(cov_jabar_pekanan)

#Make a new variable named cov_jabar_pekanan 
cov_jabar_pekanan <-
  cov_jabar_pekanan %>% 
  mutate(
    jumlah_pekanlalu = dplyr::lag(jumlah, 1), #Take a values from the previous row
    jumlah_pekanlalu = ifelse(is.na(jumlah_pekanlalu), 0, jumlah_pekanlalu), #Fill data if column jumlah_pekanlalu have a missing values (na) to 0 
    lebih_baik = jumlah < jumlah_pekanlalu #Make new column lebih_baik with values based on values jumlah < jumlah_pekanlalu
  )

#Show the information statistic about the variable cov_jabar_pekanan
glimpse(cov_jabar_pekanan)

#Visualize Positive Weekly Cases of COVID-19 in Jawa Barat
ggplot(cov_jabar_pekanan[cov_jabar_pekanan$tahun == 2020,], aes(pekan_ke, jumlah, fill = lebih_baik)) + geom_col(show.legend = FALSE) + scale_x_continuous(breaks = 9:29, expand = c(0,0)) + scale_fill_manual(values = c("TRUE" = "seagreen3", "FALSE" = "salmon")) + labs(
  x = NULL,
  y = "Jumlah kasus",
  title = "Kasus Pekanan Positif COVID-19 di Jawa Barat",
  subtitle = "Kolom hijau menunjukan penambahan kasus baru lebih sedikit dibandingkan satu pekan sebelumnya",
  caption = "Sumber data: covid.19.go.id"
) + theme_ipsum(base_size = 13,
                plot_title_size = 21,
                grid = "Y",
                ticks = TRUE)
+ theme(plot.title.position = "plot")

#make a new variable named cov_jabar_akumulasi
cov_jabar_akumulasi <- 
  new_cov_jabar %>% 
  transmute(
    tanggal,
    akumulasi_aktif = cumsum(kasus_baru) - cumsum(sembuh) - cumsum(meninggal), #Make new column named akumulasi_aktif with cumsum(kasus_baru) - cumsum(sembuh) - cumsum(meninggal)
    akumulasi_sembuh = cumsum(sembuh), #Make a new column named akumulasi_sembuh with values cumsum(sembuh) 
    akumulasi_meninggal = cumsum(meninggal) #Make a new column named akumulasi_meninggal with values cumsum(meninggal)
  )

#Show bottom data of variable cov_jabar_akumulasi
tail(cov_jabar_akumulasi)

#Visualize Accumulate Active case covid-19 in Jawa Barat
ggplot(data = cov_jabar_akumulasi, aes(x = tanggal, y = akumulasi_aktif)) + geom_line()

#Show dimension of variable
dim(cov_jabar_akumulasi)

#Make a new variable named cov_jabar_akumulasi_pivot
cov_jabar_akumulasi_pivot <- 
  cov_jabar_akumulasi %>% 
  gather(
    key = "kategori", #Move the previous column into new column named kategori
    value = "jumlah", #Move the previous column into new column named jumlah
    -tanggal #Column tanggal will not gathered because using operator "-"
  ) %>% 
  mutate(
    kategori = sub(pattern = "akumulasi_", replacement = "", kategori) #replace akumulasi_ in column kategori
  )

#Show dimension of variable cov_jabar_akumulasi_pivot
dim(cov_jabar_akumulasi_pivot)

#Show the information statistic about the variable cov_jabar_akumulasi_pivot
glimpse(cov_jabar_akumulasi_pivot)

#Visualize Dynamics of COVID-19 Cases in Jawa Barat
ggplot(cov_jabar_akumulasi_pivot, aes(tanggal, jumlah, colour = (kategori))) +
  geom_line(size = 0.9) + scale_y_continuous(sec.axis = dup_axis(name = NULL)) + 
  scale_color_manual(
    values = c(
      "aktif" = "salmon",
      "meninggal" = "darkslategray4",
      "sembuh" = "olivedrab2"
    ),
    labels = c("Aktif", "Meninggal", "Sembuh")
  ) + labs(
    x = NULL,
    y = "Jumlah Kasus akumulasi",
    colour = NULL,
    title = "Dinamika Kasus COVID-19 di Jawa Barat",
    caption = "Sumber data: covid.19.go.id"
  ) + theme_ipsum(
    base_size = 13,
    plot_title_size = 21,
    grid = "Y",
    ticks = TRUE
  ) + theme(plot.title = element_text(hjust = 0.5),
            legend.position = "top")