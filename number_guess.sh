#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((RANDOM % 1000 + 1))

GUESS_NUMBER(){
echo "Guess the secret number between 1 and 1000:"
NUMBER=""
echo $SECRET_NUMBER
read NUMBER

while [[ $NUMBER != $SECRET_NUMBER ]]
  do
    if [[ ! $NUMBER =~ ^[0-9]+$ ]] 
    then
      echo "That is not an integer, guess again:"
      read NUMBER
    else
      NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES + 1))
      if [[ $NUMBER > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read NUMBER
      else
        echo "It's higher than that, guess again:"
        read NUMBER
      fi
    fi
  done
  echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
  #if not exist argument its the first time
}

echo "Enter your username:"
read USERNAME
while [[ $USERNAME -gt 22 ]]
do
  echo "Error: Username must be 22 characters or less."
  read USERNAME
done

USER=$($PSQL "SELECT games_played, best_game FROM users WHERE name = '$USERNAME';")

#set global variable to use after

NUMBER_OF_GUESSES=1

if [[ -z $USER ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(name, games_played, best_game) VALUES('$USERNAME',0,0);")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GUESS_NUMBER 
else
  
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name = '$USERNAME'")  

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GUESS_NUMBER

fi

BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name = '$USERNAME'") 

if [[ $NUMBER_OF_GUESSES -le $BEST_GAME ]]
then
  INSERT_TO_DATABASE3=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES, games_played = games_played + 1 WHERE name = '$USERNAME'")
else
  if [[ $BEST_GAME -eq 0 ]]
  then
    INSERT_TO_DATABASE4=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES, games_played = games_played + 1 WHERE name = '$USERNAME'")
  fi
fi

