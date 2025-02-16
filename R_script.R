Countries = c( "Australia","Austria", "Belgium", "Bulgaria", "Canada", "Denmark", 
              "Estonia", "Finland", "France","Germany","Hungary", "Iceland",  "Ireland", 
              "Italy", "Japan",  "Latvia","Lithuania" , "Netherlands", "Norway", "Poland", 
              "Portugal", "Spain", "Sweden","Switzerland","Ukraine", "United Kingdom", "United States" )

#The following without less reliable countries:"Russia","Bulgaria", "Latvia", "lithuania","Ukraine" (see )
Countries = c( "Australia","Austria", "Belgium", "Canada", "Denmark", "Finland", "France","Germany","Hungary", "Iceland",  "Ireland", 
               "Italy", "Japan" , "Netherlands", "Norway", "Poland", 
               "Portugal", "Spain", "Sweden","Switzerland", "United Kingdom", "United States" )
#Selected countries for the study
col = "#1d559f"

Years = 1958:2100
#Selected years for the study


######################################################################################################################################################
#Source UN World Population Prospects (2022) [medium variant fertility scenario] : https://population.un.org/wpp/Download/Standard/Population/
#actual data up to 1950 to 2021, future projection from 2022 to 2100

Population = `Total_Population_By_Country&Year`[`Total_Population_By_Country&Year`$Country %in% Countries, ]
#Selecting Population By each year by selected countries

Population = Population[order(Population$Year), ]
Population = Population[Population$Year%in%Years,]
#Selecting population by selected Years

P =aggregate(Population ~ Year, data = Population, sum)
#P is the total population of the selected countries by each Year

plot(Years, P$Population,
     type = "l",
     lwd=5,
     col = "Black", 
     xlab = "Years", 
     ylab = "Selected countries population",
     main = "Selected countries population by year")


#############################################################################
#Source UN World Population Prospects (2022) [medium variant fertility scenario] : https://population.un.org/wpp/Download/Standard/Population/
#actual data up to 1950 to 2021, future projection from 2022 to 2100

Life_Expectancy= Life_Expectancy_Yearly_By_Country[Life_Expectancy_Yearly_By_Country$Country %in% Countries, ]
#Selecting Life Expectancy by selected countries

Life_Expectancy = Life_Expectancy[order(Life_Expectancy$Year), ]
Life_Expectancy = Life_Expectancy[Life_Expectancy$Year%in%Years,]

#Selecting Life Expectancy by selected Years


LE = aggregate(Life_expectancy ~ Year, 
               data = Life_Expectancy, 
               FUN = mean)

#LE is the mean Life expectancy of the selected countries by each Year


plot(LE$Year, LE$Life_expectancy,
     type = "l", 
     lwd=5,
     col = "Black", 
     xlab = "Year", 
     ylab = "Mean life expectancy",
     main = "Life expectancy")


############################################################################
Years_110 = 1958:2019

#Source HMD human mortality database:  https://www.mortality.org
#Data filtered to consider only death happened at age 109 years
Living_110 = `Living110_Country_Year`

Living_110= Living_110[Living_110$Country %in% Countries, ]
#Selecting Living people at age of 110 for each year by selected countries

Living_110 =Living_110[order(Living_110$Year), ]
Living_110$Year = as.integer(Living_110$Year)

Living_110 = Living_110[Living_110$Year %in% Years_110, ]

#Selecting  Living people at age of 110  by selected Years

n  = aggregate(Total ~ Year, data = Living_110, sum)
#N is the total number of living people at age 110 of the selected countries by each Year


plot(Years_110, n$Total,
     type = "l",
     col = "blue", 
     xlab = "Year",
     ylab = "Total 110s", 
     main = "number of 110s")

########################################################################################
#Modeling 
P_past = P[P$Year %in% Years_110,]
LE_past = LE[LE$Year %in% Years_110,]
#truncating P and LE databases to have the same lenght of N

n.P = n$Total/P_past$Population
#Ratio Number of living people at age 110 and Total population in that year (selected countries only)

plot(LE_past$Life_expectancy, n.P,
     col = "Black",
     xlab = "Life Expectancy",
     ylab = "NUmber of people at age 110 over Population")


model_data = data.frame( n.P = n.P,
                         LE = LE_past$Life_expectancy)
#Data frame to train the model

model = glm(n.P ~ LE , family = binomial(link = "probit"), 
            data = model_data)
#Probit model, where NoP depends on LE

#plot(model)

Years_model = (max(Years_110)+1) : 2100

new_data = data.frame(LE = LE$Life_expectancy[LE$Year %in% Years_model])
N.P_future = predict(model , newdata = new_data, type = "response")
#Generated NoP for any value that LE assumes from 2016 up to 2100

N_future = N.P_future*P$Population[P$Year %in% Years_model]
#Future amount of living people at age 110

plot(Years_model, N_future,
     type = "l",
     col = col,
     xlab = "Years",
     ylab = "Living people at 110")

###############################################################################
#Plotting expected record by year
N_cum=cumsum(N_future)  #Cumulative 110s in the future, starting from 2020
plot (Years_model, N_cum, type = "l") #graph of cumulative number of 110s over time
record = log(1/N_cum, 0.5)+110   #Inverse function to have expected record age

plot(cumsum(N_future), (log(1/cumsum(N_future), 0.5)+110), type ="l",
     xlab = "Cumulative number of 110s existed", ylab = "Expected maximum age", col = col, lwd = 2)
#Plotting the expected maximum age one of the 110s reaches

plot(2020:2100,record, type = "l") 
#Plotting the above graph with the years we expect to have such number of 100s






###############################################################################

#Modeling also past data. 

N.P_past =  predict(model , newdata =data.frame(LE =  LE$Life_expectancy[LE$Year %in% 1958:2019]), type = "response")
N_past = N.P_past*P$Population[P$Year %in% 1958:2019]

plot(Years_110, n$Total,
     type = "l",
     col = col, 
     xlab = "Year",
     ylab = "Total 110s", 
     main = "number of 110s") #plotting the past number of 110s in the past

lines(1958:2019, N_past, col = "#7ed957", type = "l") #plotting the prediced number of 110s in the past

#In blue a line connecting the actual data, in red a line connecting predicted past data

sum(n$Total)
sum(N_past)
sum(N_past)-sum(n$Total) # The model predicted only 2 less
(sum(N_past)-sum(n$Total))/sum(n$Total) #0.0003690553 is the error !
# Note that the margin of error is very low

N_total = c(N_past, N_future)
plot( 1958:2100,N_total , type = "l", col = col , lwd = 3, xlab = "Years", ylab= "Estimated number of 110s per year")
lines(1958:2019, n$Total, col = "#ff5757", type = "l" , lwd = 4)




##########################################################################################################
#Findings 
sum ( N_past)*(0.5^12) #Given the projected past data, we actually expected a people reacihng 122 years
sum(n$Total)*(0.5^12) #Given the past data up to 2015, we actually expected a people reaching 122 years
sum(n$Total)*(0.5^13) #Very likely, one (uncertified) person lived 123 years

sum(N_future)*(0.5^16) # in the next 80 years we espect at least one persone reaching 126 years or more


dpois(0,sum(N_future)*(0.5^13))
prod(1-(N_future*0.5^13))
#Either by considering all future living people at 110, or by considering them year by year,
#the probability that none of them will beat the record is roughly 0.14%





##################################################################################################ù

#TESTS unreliable countries: "Russia","Bulgaria", "Latvia", "lithuania","Ukraine"
country = "Bulgaria"

plot(Living110_Country_Year$Year[Living110_Country_Year$Country==country] ,Living110_Country_Year$Total[Living110_Country_Year$Country==country & Living110_Country_Year$Year %in% Years_110])

lenght((Living110_Country_Year$Total[Living110_Country_Year$Country==country & Living110_Country_Year$Year %in% Years_110]))

sum(n$Total[n$Year %in% 2014:2019])

#Adjust the lenght of the Years for the years avaiable in the countries




###############################################################################################ù
#SIMULATION

#-NO NEED TO RUN THE SIMULATION, IT TAKES ABOUT 5 HOURS 

simulate_ <- function(vectorN_future, num_simulations = 1000, frequency_threshold = 0) {
  all_data <- list()
  
  # Run the simulation multiple times
  for (sim in 1:num_simulations) {
    vector_lived <- c()
    years_end <- c()
    age_of_death <- c()
    current_year <- 2020
    
    for (year in 1:length(vectorN_future)) {
      num_people <- vectorN_future[year]
      for (i in 1:num_people) {
        years_lived <- 0
        while (sample(c(0, 1), 1, replace = TRUE) != 0) {
          years_lived <- years_lived + 1
        }
        vector_lived <- c(vector_lived, years_lived)
        years_end <- c(years_end, current_year + year - 1 + years_lived)
        age_of_death <- c(age_of_death, 110 + years_lived)
      }
    }
    
    # Append each simulation data to the list
    all_data[[sim]] <- data.frame(
      Years_Lived = vector_lived,
      Year_of_Death = years_end,
      Age_of_Death = age_of_death
    )
  }
  
  # Combine all simulations into one data frame
  combined_data <- do.call(rbind, all_data)
  
  # Analyze the data for ages 123 to 200+
  results <- data.frame(Age_of_Death = integer(), Year_of_Death = integer(), Frequency = integer())
  for (age in 123:200) {
    age_data <- subset(combined_data, Age_of_Death == age)
    year_counts <- table(age_data$Year_of_Death)
    frequent_years <- year_counts[year_counts > frequency_threshold]
    if (length(frequent_years) > 0) {
      for (year in names(frequent_years)) {
        results <- rbind(results, data.frame(Age_of_Death = age, Year_of_Death = year, Frequency = as.integer(frequent_years[year])))
      }
    }
  }
  
  # Special case for 200+
  age_data <- subset(combined_data, Age_of_Death > 200)
  year_counts <- table(age_data$Year_of_Death)
  frequent_years <- year_counts[year_counts > frequency_threshold]
  if (length(frequent_years) > 0) {
    for (year in names(frequent_years)) {
      results <- rbind(results, data.frame(Age_of_Death = "200+", Year_of_Death = year, Frequency = as.integer(frequent_years[year])))
    }
  }
  
  return(results)
}
Results = simulate_(N_future) #DO NOT RUN

Results = Simulation_1000
Results$Year_of_Death = as.numeric(Results$Year_of_Death) 

#Since some people will die after the age of 113, but we are interested in counting all people that have
#died or reached the age of 113 some point in their life, we normalize all ages to the year a person reached age 113
Results$Normalized_Age_123 <- ifelse(Results$Age_of_Death == 123,
                                     Results$Year_of_Death,
                                     ifelse(Results$Age_of_Death>123,
                                            Results$Year_of_Death - (Results$Age_of_Death - 123),
                                            NA))
#We repeat this for ages up to 126
Results_123_year = rep(Results$Normalized_Age_123[Results$Age_of_Death>=123],Results$Frequency[Results$Age_of_Death>=123])
Results$Normalized_Age_124 <- ifelse(Results$Age_of_Death == 124,
                                     Results$Year_of_Death,
                                     ifelse(Results$Age_of_Death>124,
                                            Results$Year_of_Death - (Results$Age_of_Death - 124),
                                            NA))
Results_124_year = rep(Results$Normalized_Age_124[Results$Age_of_Death>=124],Results$Frequency[Results$Age_of_Death>=124])
Results$Normalized_Age_125 <- ifelse(Results$Age_of_Death == 125,
                                     Results$Year_of_Death,
                                     ifelse(Results$Age_of_Death>125,
                                            Results$Year_of_Death - (Results$Age_of_Death - 125),
                                            NA))
Results_125_year = rep(Results$Normalized_Age_125[Results$Age_of_Death>=125],Results$Frequency[Results$Age_of_Death>=125])
Results$Normalized_Age_126 <- ifelse(Results$Age_of_Death == 126,
                                     Results$Year_of_Death,
                                     ifelse(Results$Age_of_Death>126,
                                            Results$Year_of_Death - (Results$Age_of_Death - 126),
                                            NA))
Results_126_year = rep(Results$Normalized_Age_126[Results$Age_of_Death>=126],Results$Frequency[Results$Age_of_Death>=126])



t123=table(Results_123_year)
t124=table(Results_124_year)
t125=table(Results_125_year)
t126=table(Results_126_year)

cumsum(t123)
sum(t123)
cumsum(t124)
sum(t124)
cumsum(t125)
sum(t125)
cumsum(t126)
sum(t126)



df123=data.frame( year = as.numeric(names(t123)),
                  value = cumsum(as.vector(t123)/1000))
df124=data.frame( year = as.numeric(names(t124)),
                  value = cumsum(as.vector(t124)/1000))
df125=data.frame( year = as.numeric(names(t125)),
                  value = cumsum(as.vector(t125)/1000))
df126=data.frame( year = as.numeric(names(t126)),
                  value = cumsum(as.vector(t126)/1000))

df123 = merge(data.frame(year = 2030:2120), df123, by = "year", all.x = TRUE)               
df124= merge(data.frame(year = 2030:2120), df124, by = "year", all.x = TRUE)
df125 = merge(data.frame(year = 2030:2120), df125, by = "year", all.x = TRUE)
df126 = merge(data.frame(year = 2030:2120), df126, by = "year", all.x = TRUE)
plot(df123, type = "l", ylim = c(0,3.5), col = "#004aad", xlab = "Years", ylab = "Normalized observed value", lwd = 3)
lines(2030:2120, df124$value, col="#7ed957", type= "l", lwd = 3)
lines(2030:2120, df125$value, col="#ff914d", type= "l", lwd = 3)
lines(2030:2120, df126$value, col="red", type="l",lwd=3)

