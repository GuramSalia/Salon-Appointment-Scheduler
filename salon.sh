#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Salon ~~~"

# display a numbered list of the services
MAIN_MENU() {
# prompt users to enter a service_id, 
  echo -e "\nPlease select from following services:"
  DISPLAY_SERVICES=$($PSQL "SELECT * FROM services") 
  echo "$DISPLAY_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

# read as SERVICE_ID_SELECTED
read SERVICE_ID_SELECTED

  #if wrong service_id display the list of services again
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo $SERVICE_NAME
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU
  else
# prompt users to enter a phone
    echo -e "\nWhat is your phone number?"
# read as CUSTOMER_PHONE
    read CUSTOMER_PHONE
# check user in db 
# get CUSTOMER_ID
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if user not found 
    if [[ -z $CUSTOMER_ID ]]
    then
    # prompt users to enter name, 
      echo -e "\nPlease enter your name:"
    # read as CUSTOMER_NAME
      read CUSTOMER_NAME
    # add new user to customers table
      RESULT_ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    # get CUSTOMER_ID
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi
    # get CUSTOMER_NAME 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
# prompt user to enter service time
    echo -e "\nPlease enter your desired time:"
# read as SERVICE_TIME
    read SERVICE_TIME

# create a new row in appointment table
  RESULT_CREATE_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
# After an appointment is successfully added output message:
  # format variables
    SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
    SERVICE_TIME_FORMATTED=$(echo $SERVICE_TIME | sed -r 's/^ *| *$//g')
    CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
  # use formated variables in message
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
    ## "I have put you down for a <service> at <time>, <name>."
    ## "I have put you down for a cut at 10:30, Fabio."

  fi

}

MAIN_MENU

## You can create a row in the appointments table by running your script 
  ## and entering 1, 555-555-5555, Fabio, 10:30
  ## and entering 2, 555-555-5555, 11am

### Make sure your script finishes running after completing any of the tasks above, 
### or else the tests won't pass
