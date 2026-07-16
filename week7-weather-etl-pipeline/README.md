# Week 7: Weather Data ETL Pipeline

## Project Overview
This project demonstrates a basic ETL (Extract, Transform, Load) pipeline built in Python. 
Real-time weather data for three Nigerian cities — Lagos, Abuja, and Port Harcourt — was 
extracted from the OpenWeather API, cleaned and structured using Pandas, and stored as a 
CSV file for analysis.

## Data Source
- **OpenWeather API** (https://openweathermap.org/api)
- Live weather data retrieved via API calls for Lagos, Abuja, and Port Harcourt.

## ETL Process

**Extract:**
- Connected to the OpenWeather API using an API key.
- Retrieved weather data (temperature, feels-like temperature, humidity, weather condition, 
description, wind speed) for each city.

**Transform:**
- Structured the raw API responses into a Pandas DataFrame.
- Verified and corrected data types (e.g., converted the retrieval timestamp to proper 
datetime format).
- Organized columns with clear, readable labels and units.

**Load:**
- Saved the cleaned dataset as `weather_data.csv` for future analysis.

## Tools Used
- Python
- Pandas
- Requests
- Google Colab
- OpenWeather API

## Steps Taken
1. Created an OpenWeather account and generated an API key.
2. Wrote a Python script to extract weather data for 3 cities.
3. Transformed the raw JSON responses into a structured Pandas DataFrame.
4. Cleaned and corrected data types.
5. Saved the processed data to CSV.
6. Performed basic comparative analysis across the three cities.

## Key Findings
- **Hottest city:** Lagos (25.18°C)
- **Most humid city:** Port Harcourt (96%)
- **Windiest city:** Lagos (4.32 m/s)
- **Weather conditions:** Lagos experienced light rain, Abuja was cloudy (overcast clouds), 
and Port Harcourt had moderate rain.

Despite being geographically close, all three cities showed noticeably different weather 
conditions and humidity levels on the day of data collection — a good reminder of how 
localized weather patterns can be even within the same country.

## Author
Nanahawah — AnalystLab Africa, Batch B Intern
