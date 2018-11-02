# Ledger
A simple web application to keep track daily expense. 

## Dependecies
* Ruby 2.5
* System dependencies
    Ruby on rails 5.2
    Devise 4.1
    Pundit
    Bootstrap 4.1


## Basic feature

1. Authentication
    - Database Login
    ~~Google Plus 0Auth~~
2. Authorization
    - Access control
3. Expense item CRUD operation.
4. Visual report generation.

## Future backlog
5.  OCR data input support.


## Compilation

### Prerequisite
1. postgres 12 is installed and database is setup.
2. bundler is installed.

```bash
$ git clone git@github.com:khenfei/ledger.git
$ cd ledger
##Before continue further, please remember to update config/database.yml to point to your database URL.
$ rails db:setup        #to create databases
$ rails db:migrate      #to apply all the SQL script
$ rails server          #start server locally

## Run spec
$ rails spec
```
