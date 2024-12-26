import os
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix
from sklearn.model_selection import GridSearchCV
import joblib
import warnings
import matplotlib.pyplot as plt
import seaborn as sns

warnings.filterwarnings("ignore")

def preprocess_data(filepath):
    """
    Preprocess the dataset by reading the file and handling encoding issues.
    Removes unnecessary columns and maps categorical values to numeric.
    """
    try:
        # Attempt to read the file with utf-8 encoding
        data = pd.read_csv(filepath, encoding='utf-8')
    except UnicodeDecodeError:
        # Fall back to latin1 encoding if utf-8 fails
        data = pd.read_csv(filepath, encoding='latin1')
    
    # Drop unnecessary columns
    data = data.drop(columns=["User ID", "Unnamed: 10", "Unnamed: 11", "Unnamed: 12"], errors='ignore')

    # Map categorical columns to numeric values
    mapping = {
        "Mandala Design Pattern": {"1 (Complex)": 1, "2 (Medium)": 2, "3 (Simple)": 3},
        "Gender": {"Male": 0, "Female": 1, "Other": 2}
    }
    data.replace(mapping, inplace=True)
    return data

class StressLevelModel:
    def __init__(self):
        self.model = RandomForestClassifier(random_state=42)

    def train(self, X_train, y_train):
        self.model.fit(X_train, y_train)

    def evaluate(self, X_test, y_test):
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        report = classification_report(y_test, y_pred, output_dict=True)
        cm = confusion_matrix(y_test, y_pred)
        return accuracy, report, cm

    def tune_hyperparameters(self, X_train, y_train):
        param_grid = {
            'n_estimators': [50, 100, 200],
            'max_depth': [None, 10, 20, 30],
            'min_samples_split': [2, 5, 10]
        }
        grid_search = GridSearchCV(self.model, param_grid, cv=3, scoring='accuracy')
        grid_search.fit(X_train, y_train)
        self.model = grid_search.best_estimator_
        return grid_search.best_params_

    def save_model(self, filepath):
        joblib.dump(self.model, filepath)

    def load_model(self, filepath):
        self.model = joblib.load(filepath)

    def predict(self, input_data):
        return self.model.predict(input_data)

def plot_metrics(report):
    # Extract metrics for each class
    classes = list(report.keys())[:-3]  # Exclude 'accuracy', 'macro avg', and 'weighted avg'
    precision = [report[cls]["precision"] for cls in classes]
    recall = [report[cls]["recall"] for cls in classes]
    f1 = [report[cls]["f1-score"] for cls in classes]
    classes = [str(cls) for cls in classes]

    # Plot precision, recall, and F1-score
    plt.figure(figsize=(10, 6))
    plt.plot(classes, precision, marker='o', label='Precision', color='blue')
    plt.plot(classes, recall, marker='o', label='Recall', color='green')
    plt.plot(classes, f1, marker='o', label='F1-Score', color='red')
    plt.xlabel('Class')
    plt.ylabel('Score')
    plt.title('Precision, Recall, and F1-Score for Each Class')
    plt.legend()
    plt.grid()
    plt.show()

# Path to your dataset on your local machine
file_path = 'dataset.csv'  
if not os.path.exists(file_path):
    print(f"Dataset not found at {file_path}. Please update the path.")
    exit()

# Preprocess data
data = preprocess_data(file_path)

# Split data into features and target
X = data.drop(columns=["Stress Level (1-4)"])
y = data["Stress Level (1-4)"]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Initialize and train the model
stress_model = StressLevelModel()
stress_model.train(X_train, y_train)

# Evaluate the model
accuracy, report, cm = stress_model.evaluate(X_test, y_test)
print(f"Initial Accuracy: {accuracy}\n")
print("Classification Report:\n", classification_report(y_test, stress_model.model.predict(X_test)))

# Plot confusion matrix
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=[1, 2, 3, 4], yticklabels=[1, 2, 3, 4])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix - Initial Model')
plt.show()

# Plot precision, recall, and F1-score curves
plot_metrics(report)

# Tune hyperparameters
best_params = stress_model.tune_hyperparameters(X_train, y_train)
print("Best Hyperparameters:\n", best_params)

# Evaluate tuned model
accuracy, report, cm = stress_model.evaluate(X_test, y_test)
print(f"Tuned Accuracy: {accuracy}\n")
print("Tuned Classification Report:\n", classification_report(y_test, stress_model.model.predict(X_test)))

# Plot confusion matrix for tuned model
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=[1, 2, 3, 4], yticklabels=[1, 2, 3, 4])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix - Tuned Model')
plt.show()

# Plot precision, recall, and F1-score curves for tuned model
plot_metrics(report)

# Save the model locally
model_path = 'stress_level_model.joblib'  # Update with your desired local save path
stress_model.save_model(model_path)
print(f"Model saved to {model_path}")
