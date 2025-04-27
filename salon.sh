#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICES() {
if [[ $1 ]]
then
echo -e '\n'$1''
fi

echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
read SERVICE_ID_SELECTED

 SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
 #if not exist
 if [[ -z $SELECTED_SERVICE ]]
 then
 SERVICES "I could not find that service. What would you like today?"
 else 
 echo -e "\nWhat's your phone number:"
 read CUSTOMER_PHONE
 SELECTED_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 SELECTED_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

 #if phone number not exist
 if [[ -z $SELECTED_PHONE_NUMBER ]]
 then
 echo -e "\nI don't have a record for that phone number, what's your name?"
 read CUSTOMER_NAME
 INSERTED_PHONE_NUMBER=$($PSQL "INSERT INTO customers (phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
 SELECTED_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
 echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
 read SERVICE_TIME
 echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
INSERTED_APPOINTMENTS=$($PSQL "INSERT INTO appointments (customer_id, time, service_id) VALUES($SELECTED_CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED)")
 else 
 echo -e "\nWhat time would you like your cut, $SELECTED_NAME?" | sed -E 's/  / /g'
 read SERVICE_TIME
 SELECTED_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$SELECTED_PHONE'")
 INSERTED_APPOINTMENTS=$($PSQL "INSERT INTO appointments (customer_id, time, service_id) VALUES($SELECTED_CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED)")
 echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $SELECTED_NAME." | sed -E 's/  / /g'
 fi

fi
 }

SERVICES