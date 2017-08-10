library(dplyr)
library(tidyverse)
read.csv(file.choose(),header = TRUE)
refine <- read.csv(file.choose(),header = TRUE)

# Clean up the 'company' column, so all of the misspellings of the brand names are standardized. 
refine$company <- sub(".*ps","philips",refine$company,ignore.case = TRUE)
refine$company <-  sub(".*zo","akzo",refine$company,ignore.case = TRUE)
refine[10,1] = "akzo"
refine$company <- sub(".*ten","van houten",refine$company,ignore.case = TRUE)
refine$company <- sub(".*ver","unilever",refine$company,ignore.case = TRUE)

# Separate the product code and product number into separate columns i.e. add two new columns called product_code and product_number, containing the product code and number respectively

refine <- refine %>% separate("Product code / number",c("product_code","product_number"),sep = "-")

#You learn that the product codes actually represent the following product categories:
#p = Smartphone
#v = TV
#x = Laptop
#q = Tablet
#In order to make the data more readable, add a column with the product category for each record.

refine <- refine %>% mutate(product_category = recode(product_code,
                                                      p = "Smartphone",
                                                      v = "TV",
                                                      x = "Laptop",
                                                      q = "Tablet"
))
# Want to view data to see how if output consistent with intent
View(refine)

#You'd like to view the customer information on a map. In order to do that, the addresses need to be in a form that can be easily geocoded. 
#Create a new column full_address that concatenates the three address fields (address, city, country), separated by commas.
refine <- refine %>% unite(full_address,address,city,country,sep = ", ")
#Both the company name and product category are categorical variables i.e. they take only a fixed set of values. In order to use them in further analysis you need to create dummy variables. Create dummy binary variables for each of them with the prefix company_ and product_ i.e.,
#Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever.
#Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet.

refine$company_philips <- as.numeric(refine$company %in% "philips")
refine$company_akzo <- as.numeric(refine$company %in% "akzo")
refine$company_vanhouten <- as.numeric(refine$company %in% "van houten")
refine$company_unilever <- as.numeric(refine$company %in% "unilever")

#Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet
refine$product_smartphone <- as.numeric(refine$product_category %in% "Smartphone")
refine$product_tv <- as.numeric(refine$product_category %in% "TV")
refine$product_laptop <- as.numeric(refine$product_category %in% "Laptop")
refine$product_tablet <- as.numeric(refine$product_category %in% "Tablet")


