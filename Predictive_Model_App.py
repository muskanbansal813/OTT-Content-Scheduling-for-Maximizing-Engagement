# app.py

import streamlit as st
import joblib
import numpy as np

# Set up the page
st.set_page_config(page_title="OTT Watch Time Predictor", layout="centered")

# Hardcoded credentials (for example purposes only)
USERNAME = "muskan"
PASSWORD = "Muskan@2025"

# Function to display login page
def login():
    st.title("🔐 Login to OTT Watch Time Predictor")

    with st.form("login_form"):
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        login_button = st.form_submit_button("Login")

    if login_button:
        if username == USERNAME and password == PASSWORD:
            st.session_state.logged_in = True
            st.rerun()
        else:
            st.error("❌ Invalid username or password")

# Function to display the prediction interface
def main_app():
    st.title("🎬 Predict Average Watch Time for OTT Scheduling")

    st.markdown("Enter values for each feature used in the model:")

    # Load the trained model and feature names
    model = joblib.load('model_top.pkl')
    feature_names = joblib.load('feature_names_top.pkl')  # Must be a list of 26 names

    # Collect user input for all features
    user_inputs = []
    for feature in feature_names:
        val = st.number_input(f"{feature}", step=0.1, format="%.2f")
        user_inputs.append(val)

    # Predict when button is clicked
    if st.button("Predict"):
        if len(user_inputs) == model.n_features_in_:
            input_array = np.array([user_inputs])
            prediction = model.predict(input_array)
            st.success(f"🎯 Predicted Average Watch Time: **{prediction[0]:.2f} minutes**")
        else:
            st.error("❌ Incorrect number of inputs.")

# Set default session state
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False

# Display login or main app based on login state
if st.session_state.logged_in:
    main_app()
else:
    login()
