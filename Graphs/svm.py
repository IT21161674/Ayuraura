import os
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import matplotlib.pyplot as plt
import seaborn as sns
import warnings

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

# Path to your dataset
file_path = 'dataset.csv'
if not os.path.exists(file_path):
    print(f"Dataset not found at {file_path}. Please update the path.")
    exit()

# Preprocess data
data = preprocess_data(file_path)

# Split data into features and target
X = data.drop(columns=["Stress Level (1-4)"])
y = data["Stress Level (1-4)"]

# Standardize features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Encode target labels
label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(y)

# Split data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y_encoded, test_size=0.2, random_state=42, stratify=y)

# Initialize the SVM classifier
svm_model = SVC(kernel='rbf', C=1.0, gamma='scale', random_state=42)

# Train the model
svm_model.fit(X_train, y_train)

# Evaluate the model
y_pred = svm_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy: {accuracy}\n")
print("Classification Report:\n", classification_report(y_test, y_pred))

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=label_encoder.classes_, yticklabels=label_encoder.classes_)
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix - SVM Model')
plt.show()
