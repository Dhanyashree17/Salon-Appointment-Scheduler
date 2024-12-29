#!/bin/bash

# Display available services
echo "Welcome to the Salon!"
echo "We offer the following services:"
echo "1) Hair Cut"
echo "2) Shampoo"
echo "3) Manicure"

# Prompt for service selection with validation
while true; do
    echo "Please select a service by entering the service number (1-3):"
    read SERVICE_ID_SELECTED

    # Check if the selected service exists (1, 2, or 3)
    if [[ "$SERVICE_ID_SELECTED" -ge 1 && "$SERVICE_ID_SELECTED" -le 3 ]]; then
        break  # Exit the loop if a valid service is selected
    else
        # If invalid, show the list of services again
        echo "Invalid choice. Please select a valid service from the list:"
        echo "1) Hair Cut"
        echo "2) Shampoo"
        echo "3) Manicure"
    fi
done

# Prompt for phone number
echo "Please enter your phone number:"
read CUSTOMER_PHONE

# Check if the phone number exists in the database
CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [ -z "$CUSTOMER_NAME" ]; then
    # If the phone number doesn't exist, prompt for name
    echo "We don't have your details in our system. Please enter your name:"
    read CUSTOMER_NAME

    # Add customer to the database
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
fi

# Prompt for appointment time
echo "Please enter the time for your appointment (e.g., 10:30):"
read SERVICE_TIME

# Insert the appointment into the database
psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ((SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'), $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# Output confirmation message
SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
