## OTT Content Scheduling for Maximizing Engagement

This project analyzes OTT (Over-the-Top) platform data to explore patterns in viewer engagement and build intelligent content scheduling strategies. It includes exploratory data analysis (EDA), SQL-based insights, a Power BI dashboard, a predictive model for estimating average watch time, and an interactive Streamlit application.

---

## 📌 Project Highlights

### ✅ 1. Exploratory Data Analysis (EDA)
- Performed data cleaning and exploration to understand content types, viewership patterns, and audience preferences.
- Identified peak viewership times, seasonal trends, and demographic impacts on engagement.

### ✅ 2. SQL Analysis
- Executed SQL queries to extract insights like:
  - Top-performing content by genre and day
  - Viewer trends by age group and gender
  - Impact of promotions and competitor content

### ✅ 3. Power BI Dashboard
- Designed and published an interactive dashboard for:
  - Genre-based performance
  - Daily/weekly viewer engagement
  - Demographic distribution and trends
- [🔗 Dashboard Link]
  https://app.powerbi.com/view?r=eyJrIjoiZDM3ZjE2ZTctMGE5Yy00YWMyLWJiMzEtZjk4Y2IyMzM2YTJhIiwidCI6ImUyNTFiNjU0LWE2MWQtNDJjZS04MGFjLThkMzcxZWI4NmM2YSJ9

### ✅ 4. Predictive Modeling
- Built a regression model to predict **Average Watch Time** using features like:
  - Content Type, Duration_mins,Subscription Data, Viewership, Genre, Release Time, Likes, Comments
- Evaluated using RMSE, R², and visualized results.
  
### 📈 Model Performance Summary

| Model                          | Train R² | Test R² | Test RMSE | Remarks                          |
|-------------------------------|----------|---------|-----------|-----------------------------------|
| Linear Regression             | 0.21     | 0.19    | 27.11     | Poor fit, high error               |
| XGBoost Regressor (All Features) | 0.99     | 0.19    | 27.11  | Overfitted on training data        |
| Random Forest (All Features)  | 0.88     | 0.29    | 25.28     | Improved generalization            |
| Random Forest (Top 5 Features)| 0.89     | 0.34    | 25.28     | Best test performance with reduced features |

### Why This Model Was Selected

- **Balanced Train-Test Performance**  
- **Lowest Test MSE & Highest Test R²**  
- **Avoided Overfitting**  
- **Effective Feature Selection**

### ✅ 5. Streamlit Application
- Developed and deployed an interactive Streamlit app that:
  - Predicts average watch time
  - Visualizes key performance metrics
  - Provides user-friendly filters and recommendations





