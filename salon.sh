#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

### SERVICE MENU SECTION ###

SERVICE_MENU() {
    if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nWhat service are you looking for?"
 AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
 echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
 do 
  SID=$(echo $SERVICE_ID | sed 's/ //g')
    SNAME=$(echo $SERVICE | sed 's/ //g')
    echo "$SID) $SERVICE"
done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU ;;
    2) APPOINTMENT_MENU ;;
    3) APPOINTMENT_MENU ;;
    4) APPOINTMENT_MENU ;;
    5) APPOINTMENT_MENU ;;
    6) EXIT ;;
    *) SERVICE_MENU "I could not find that service. What would you like today?" ;;
  esac
}

### APPOINTMENT SECTION ###

APPOINTMENT_MENU() {
  echo -e "\nPlease enter your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone ='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWe don't have a record for your phone number, Please enter your name."
    read  CUSTOMER_NAME
   INSERT_CUSTOMERS=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  SERVICE_NAME=$(echo $SERVICE_NAME| sed 's/ //g')
 

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  if [[ $APPOINTMENT_INSERT == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

EXIT() {
  echo -E "\nWelcome to My Salon, how can I help you?"
}
SERVICE_MENU