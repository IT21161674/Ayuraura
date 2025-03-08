from flask import Flask, request, jsonify
import joblib
import numpy as np

# Initialize Flask app
app = Flask(__name__)

# Load the pre-trained model
model = joblib.load("stress_level_model.joblib")

# Define mapping for categorical variables
mandala_design_mapping = {"1 (Complex)": 0, "2 (Medium)": 1, "3 (Simple)": 2}
gender_mapping = {"Male": 0, "Female": 1}

@app.route('/predict_stress', methods=['POST'])
def predict_stress():
    try:
        # Parse JSON input
        data = request.json
        age = data['Age']
        gender = gender_mapping[data['Gender']]
        mandala_design = mandala_design_mapping[data['Mandala Design Pattern']]
        mandala_colors_used = data['Mandala Colors Used']
        mandala_time_spent = data['Mandala Time Spent']
        music_type = data['Music Type']
        music_time_spent = data['Music Time Spent']
        total_time = data['Total_Time']

        # Prepare the input for the model
        input_features = np.array([[age, gender, mandala_design, mandala_colors_used,
                                    mandala_time_spent, music_type, music_time_spent, total_time]])

        # Make prediction
        predicted_stress_level = model.predict(input_features)

        # Return the result
        return jsonify({"Stress Level": int(predicted_stress_level[0])})

    except Exception as e:
        return jsonify({"error": str(e)}), 400

# Run the app
if __name__ == '__main__':
    app.run(debug=True)
