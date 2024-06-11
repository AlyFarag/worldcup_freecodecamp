#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate the tables
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")
# Read and insert data from games.csv
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do 
  for team in "$winner" "$opponent"
  do
  if [[ $team = "winner" || $team = "opponent" ]]
  then
  continue
  else
    # Get team_id
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$team'")    
    # check if the team exixts it will be empty
    if [[ -z $team_id ]]
      then
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$team')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into teams: $team"
        fi
      fi
  fi
  
  done
done
  
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
    if [[ $year != "year" ]]
    then
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

      #if [[ -z $winner_id && -z $opponent_id ]]
      #then
        INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
        if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into Games: $round"
        fi
      #fi
  fi
done