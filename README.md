---
title: "Shiny Application for geostatistical analysis"
output:
  html_document:
    toc: true
    toc_float:
      collapsed: false
      smooth_scroll: false
    toc_depth: 5
---

## ShinyApp

<a href = "https://sayfchagtmi.shinyapps.io/ProjetML/" target="_blank"><i class="far fa-chart-bar"></i> Application </a>

** NB : This project is in French ! **

## Data 

<a href = "https://github.com/sayfchagtmi/Qos_3G-2G_Tunisie/raw/master/2g3g-f.xlsx" target="_blank" > <i class="fas fa-download"></i> Download data</a>

```{r}
library(readxl)
dt = read_excel("data/shiny_application/2g3g-f.xlsx")
head(dt)
```

In order to represent the data on a leaflet map I used "geopy" (Python package) in order to extract longitude and latitude.


```{python, eval=F}
import pandas as pd 
df = pd.read_excel("2g3g-f.xlsx")
op = []
reg = []
for i in range(len(df)):
    s = df['gouvernorat'][i]
    l= s.split(": ")
    if(l[1] == "TT"):
        op.append("Tunisie Télécom")
    if(l[1] == "OT"):
        op.append("Orange Tunisie")
    if(l[1] == "OO"):
        op.append("Ooredoo")

    reg.append(l[0])
    
df.gouvernorat = reg
df['opérateur'] = op

from geopy.geocoders import Nominatim
geolocator = Nominatim(user_agent="https://maps.google.com/")

lat = []
long = []
for i in range(len(df)):
    try:
        location = geolocator.geocode(df.gouvernorat[i])
        lat.append(location.latitude)
        long.append(location.longitude)
    except:
        lat.append("NAN")
        long.append("NAN")
        
df['Longitude'] = long
df['Latitude'] = lat

pd.DataFrame.to_csv(df,"data.csv")

```

And this is how the data looks now 

```{r}
df = read.csv("data/shiny_application/data.csv")
head(df)
```

## GitHub repository

<a href= "https://github.com/sayfchagtmi/Qos_3G-2G_Tunisie" ><i class="fab fa-github"></i>  Qos_3G-2G_Tunisie </a>
