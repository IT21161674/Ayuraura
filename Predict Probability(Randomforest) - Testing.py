import joblib
import warnings
warnings.filterwarnings("ignore")
import os

# Specify the paths to the model and scaler files
model_path = "stress_probability_model.pkl"
scaler_path = "scaler.pkl"

# Verify if the files exist
if not os.path.exists(model_path):
    raise FileNotFoundError(f"Model file not found at {model_path}")
if not os.path.exists(scaler_path):
    raise FileNotFoundError(f"Scaler file not found at {scaler_path}")

# Load the trained model and scaler
loaded_model = joblib.load(model_path)
loaded_scaler = joblib.load(scaler_path)

# Example input for prediction
avg_sleep_hours_per_night = 6
avg_exercise_days_per_week = 3
avg_work_or_study_hours_per_week = 35
avg_screen_hours_per_day = 7
social_interaction_quality_rating = 7
diet_healthiness_rating = 6
smoking_drinking_habits_rating = 3
avg_recreational_hours_per_week = 10

# Prepare the input for prediction
sample_input = [[
    avg_sleep_hours_per_night,
    avg_exercise_days_per_week,
    avg_work_or_study_hours_per_week,
    avg_screen_hours_per_day,
    social_interaction_quality_rating,
    diet_healthiness_rating,
    smoking_drinking_habits_rating,
    avg_recreational_hours_per_week
]]

# Scale the input data
scaled_input = loaded_scaler.transform(sample_input)

# Predicting the class and probabilities
predicted_class = loaded_model.predict(scaled_input)[0]
predicted_probabilities = loaded_model.predict_proba(scaled_input)[0]  # Probabilities for both classes

# Print the results
print(f"Predicted Class: {'Stress' if predicted_class == 1 else 'No Stress'}")
print(f"Probability of No Stress (0): {predicted_probabilities[0] * 100:.2f}%")
print(f"Probability of Stress (1): {predicted_probabilities[1] * 100:.2f}%")
print()

# Additional Example
# Input for another prediction
avg_sleep_hours_per_night = 6
avg_exercise_days_per_week = 0
avg_work_or_study_hours_per_week = 40
avg_screen_hours_per_day = 2
social_interaction_quality_rating = 4
diet_healthiness_rating = 6
smoking_drinking_habits_rating = 2
avg_recreational_hours_per_week = 3

sample_input = [[
    avg_sleep_hours_per_night,
    avg_exercise_days_per_week,
    avg_work_or_study_hours_per_week,
    avg_screen_hours_per_day,
    social_interaction_quality_rating,
    diet_healthiness_rating,
    smoking_drinking_habits_rating,
    avg_recreational_hours_per_week
]]

scaled_input = loaded_scaler.transform(sample_input)
predicted_class = loaded_model.predict(scaled_input)[0]
predicted_probabilities = loaded_model.predict_proba(scaled_input)[0]

# Print the results
print(f"Predicted Class: {'Stress' if predicted_class == 1 else 'No Stress'}")
print(f"Probability of No Stress (0): {predicted_probabilities[0] * 100:.2f}%")
print(f"Probability of Stress (1): {predicted_probabilities[1] * 100:.2f}%")
