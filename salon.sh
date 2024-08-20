#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi     
  # get services and corresponding ids
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")

  echo -e "\nWelcome to My Salon, how can I help you?\n"

  # display services
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  # input service selection
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) BOOK_APPOINTMENT ;;
    2) BOOK_APPOINTMENT ;;
    3) BOOK_APPOINTMENT ;;
    4) BOOK_APPOINTMENT ;;
    5) BOOK_APPOINTMENT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

BOOK_APPOINTMENT() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # get name of service selected
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # format service_name and customer_name
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME_SELECTED | sed -E 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')

  # get appointment time
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  # insert new appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # format service_time
  SERVICE_TIME_FORMATTED=$(echo $SERVICE_TIME | sed -E 's/^ *| *$//g')

  # Exit program
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
}

MAIN_MENU
