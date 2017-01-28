alias h='heroku'
alias hr='heroku run'

alias -g prod='legelisten-prod'
alias -g staging='legelisten-staging'

alias staging-logs='heroku logs -t -alegelisten-staging'
alias staging-console='heroku run rails c -alegelisten-staging'

alias legelisten_start='docker-compose -f docker-compose.yml -f docker-compose-linux.yml up'
alias legelisten_cli='docker exec -t -i legelisten_web_1 bash'
