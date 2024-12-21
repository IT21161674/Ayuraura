from flask import Flask, request, jsonify, render_template
import joblib
import numpy as np
from flask_cors import CORS
import logging

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (CORS)

# Set up logging
logging.basicConfig(level=logging.INFO)

# Load the trained model
try:
    model = joblib.load('./models/stress_recovery_model_logistic_reg.joblib')  # Ensure model is in the 'models/' folder
    logging.info("Model loaded successfully.")
except FileNotFoundError as e:
    raise FileNotFoundError(f"Error loading model: {e}")

@app.route('/')
def home():
    return render_template('index.html')

# Endpoint for predicting recovery time
@app.route('/predict_recovery_time', methods=['POST'])
def predict_recovery_time():
    try:
        # Get input data from the request (JSON format)
        data = request.json
        logging.info(f"Input data received: {data}")

        # Define all required fields, including 'Days'
        required_features = [
            'Age',
            'Gender',
            'InitialStressLevel',
            'Days',  # New field added here
            'DailyStressLevel',
            'DailyEnergyLevel',
            'DailyHappinessLevel',
            'DailyCalmnessLevel',
            'MandalaCompletion',
            'MusicCompletion',
            'OverallActivityCompletionRate',
            'DurationofParticipation',
            'BaseRecoveryDays',
            'ActivityMultiplier'
        ]

        # Validate input fields
        if not all(feature in data for feature in required_features):
            missing_fields = [feature for feature in required_features if feature not in data]
            return jsonify({"error": f"Missing required fields: {missing_fields}"}), 400

        # Extract the feature values in the correct order
        input_features = np.array([[data[feature] for feature in required_features]])
        logging.info(f"Extracted input features: {input_features}")

        # Get prediction from the model
        prediction = model.predict(input_features)

        # Convert prediction to a standard Python data type
        predicted_recovery_time = float(prediction[0])  # Ensure it's a standard Python float
        logging.info(f"Model prediction (converted): {predicted_recovery_time}")

        # Return the result as JSON
        return jsonify({"predicted_recovery_Days": round(predicted_recovery_time, 2)})

    except Exception as e:
        # Log unexpected errors
        logging.error(f"Error occurred: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
