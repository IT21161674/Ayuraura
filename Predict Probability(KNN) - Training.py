import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, precision_recall_curve, auc
from sklearn.preprocessing import StandardScaler
import seaborn as sns
import matplotlib.pyplot as plt
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

# Initial KNN Model
knn_model = KNeighborsClassifier()
knn_model.fit(X_train, y_train)

# Initial Model Evaluation
y_pred = knn_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"KNN Model Accuracy: {accuracy * 100:.2f}%")
print("Classification Report:\n", classification_report(y_test, y_pred))

# Defining the parameter grid for GridSearchCV
param_grid = {
    'n_neighbors': [3, 5, 7, 9],
    'weights': ['uniform', 'distance'],
    'metric': ['euclidean', 'manhattan', 'minkowski']
}

# Hyperparameter Tuning with GridSearchCV
grid_search = GridSearchCV(
    estimator=KNeighborsClassifier(),
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
best_knn_model = grid_search.best_estimator_

# Optimized Model Evaluation
y_pred_best = best_knn_model.predict(X_test)
accuracy_best = accuracy_score(y_test, y_pred_best)
print(f"Optimized KNN Model Accuracy: {accuracy_best * 100:.2f}%")
print("Optimized Classification Report:\n", classification_report(y_test, y_pred_best))

# Confusion Matrix for Initial Model
cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=['No Stress', 'Stress'], yticklabels=['No Stress', 'Stress'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix for Initial KNN Model')
plt.show()

# Confusion Matrix for Optimized Model
cm_optimized = confusion_matrix(y_test, y_pred_best)
plt.figure(figsize=(8, 6))
sns.heatmap(cm_optimized, annot=True, fmt='d', cmap='Greens', xticklabels=['No Stress', 'Stress'], yticklabels=['No Stress', 'Stress'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix for Optimized KNN Model')
plt.show()

# Precision-Recall Curve for Initial Model
y_probs = knn_model.predict_proba(X_test)[:, 1]  # Probability estimates for positive class
precision, recall, thresholds = precision_recall_curve(y_test, y_probs)
f1_scores = 2 * (precision * recall) / (precision + recall)

plt.figure(figsize=(8, 6))
plt.plot(thresholds, precision[:-1], label='Precision', color='blue')
plt.plot(thresholds, recall[:-1], label='Recall', color='green')
plt.plot(thresholds, f1_scores[:-1], label='F1 Score', color='red')
plt.xlabel('Threshold')
plt.ylabel('Score')
plt.title('Precision, Recall, and F1 Score vs. Threshold for Initial KNN Model')
plt.legend()
plt.show()

# Precision-Recall Curve for Optimized Model
y_probs_best = best_knn_model.predict_proba(X_test)[:, 1]  # Probability estimates for positive class
precision_best, recall_best, thresholds_best = precision_recall_curve(y_test, y_probs_best)
f1_scores_best = 2 * (precision_best * recall_best) / (precision_best + recall_best)

plt.figure(figsize=(8, 6))
plt.plot(thresholds_best, precision_best[:-1], label='Precision', color='blue')
plt.plot(thresholds_best, recall_best[:-1], label='Recall', color='green')
plt.plot(thresholds_best, f1_scores_best[:-1], label='F1 Score', color='red')
plt.xlabel('Threshold')
plt.ylabel('Score')
plt.title('Precision, Recall, and F1 Score vs. Threshold for Optimized KNN Model')
plt.legend()
plt.show()

# Saving the trained KNN model and scaler
joblib.dump(best_knn_model, 'knn_model.pkl')  # Save the trained KNN model
joblib.dump(scaler, 'knn_scaler.pkl')  # Save the scaler for the KNN model
