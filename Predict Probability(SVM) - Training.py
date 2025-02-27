import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.svm import SVC
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
    precision_recall_curve,
    f1_score,
)
from sklearn.preprocessing import StandardScaler
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import joblib
import warnings

warnings.filterwarnings("ignore")

# Load the dataset
file_path = 'stress probability dataset.csv'  # Local path to the dataset
data = pd.read_csv(file_path)

# Renaming columns for better readability
data.columns = [
    'avg_sleep_hours_per_night',
    'avg_exercise_days_per_week',
    'avg_work_or_study_hours_per_week',
    'avg_screen_hours_per_day',
    'social_interaction_quality_rating',
    'diet_healthiness_rating',
    'smoking_drinking_habits_rating',
    'avg_recreational_hours_per_week',
    'stress_probability'
]

# Splitting the dataset into features (X) and target (y)
X = data.drop('stress_probability', axis=1)
y = data['stress_probability']

# Standardizing the feature values
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Splitting the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# Initial SVM Model
svm_model = SVC(probability=True, random_state=42)
svm_model.fit(X_train, y_train)

# Initial Model Evaluation
y_pred = svm_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"SVM Model Accuracy: {accuracy * 100:.2f}%")
print("Classification Report:\n", classification_report(y_test, y_pred))

# Defining the parameter grid for GridSearchCV
param_grid = {
    'C': [0.1, 1, 10, 100],
    'kernel': ['linear', 'rbf', 'poly'],
    'gamma': ['scale', 'auto']
}

# Hyperparameter Tuning with GridSearchCV
grid_search = GridSearchCV(
    estimator=SVC(probability=True, random_state=42),
    param_grid=param_grid,
    cv=3,
    scoring='accuracy',
    verbose=1,
    n_jobs=-1
)

grid_search.fit(X_train, y_train)

# Displaying the best parameters and score
best_params = grid_search.best_params_
print(f"Best Parameters: {best_params}")
best_svm_model = grid_search.best_estimator_

# Optimized Model Evaluation
y_pred_best = best_svm_model.predict(X_test)
accuracy_best = accuracy_score(y_test, y_pred_best)
print(f"Optimized SVM Model Accuracy: {accuracy_best * 100:.2f}%")
print("Optimized Classification Report:\n", classification_report(y_test, y_pred_best))

# Confusion Matrix for Initial Model
cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=['No Stress', 'Stress'], yticklabels=['No Stress', 'Stress'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix for Initial SVM Model')
plt.show()

# Confusion Matrix for Optimized Model
cm_optimized = confusion_matrix(y_test, y_pred_best)
plt.figure(figsize=(8, 6))
sns.heatmap(cm_optimized, annot=True, fmt='d', cmap='Greens', xticklabels=['No Stress', 'Stress'], yticklabels=['No Stress', 'Stress'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix for Optimized SVM Model')
plt.show()

# Predict probabilities for the test set
y_prob_best = best_svm_model.predict_proba(X_test)[:, 1]

# Calculate Precision, Recall, and Thresholds
precision, recall, thresholds = precision_recall_curve(y_test, y_prob_best)

# Calculate F1-scores for all thresholds
f1_scores = 2 * (precision * recall) / (precision + recall + 1e-10)

# Visualize Precision, Recall, and F1-Score Curves
plt.figure(figsize=(10, 6))
plt.plot(thresholds, precision[:-1], label="Precision", color="blue")
plt.plot(thresholds, recall[:-1], label="Recall", color="green")
plt.plot(thresholds, f1_scores[:-1], label="F1-Score", color="red")
plt.axvline(0.5, linestyle='--', color='gray', label='Threshold = 0.5')
plt.title("Precision, Recall, and F1-Score vs Thresholds")
plt.xlabel("Threshold")
plt.ylabel("Score")
plt.legend()
plt.grid()
plt.show()

# Saving the trained SVM model and scaler
joblib.dump(best_svm_model, 'svm_model.pkl')  # Save the trained SVM model
joblib.dump(scaler, 'svm_scaler.pkl')  # Save the scaler for the SVM model
