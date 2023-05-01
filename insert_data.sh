#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Script to insert data in games.csv into teams & games tables in worldcup postgreSQL DB

function GET_TEAM_ID(){
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
    if [[ -z $TEAM_ID ]]; then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1')")
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
    fi
  echo $TEAM_ID
}

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPONENT_GOALS
do
  if [[ $YEAR != year ]]; then
    WINNER_ID=$(GET_TEAM_ID "$WINNER")
    OPPONENT_ID=$(GET_TEAM_ID "$OPPONENT")
    INSERT_GAME_RESULT=$($PSQL "
      INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPONENT_GOALS)
    ")
  fi
done
