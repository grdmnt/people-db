# People DB

## Notes
__Note: I wasn't able to ask for these clarifications due to me doing the challenge during the weekend. Therefore I just went ahead with assumptions__

1. Based on the spec given, there is a contradiction where it says that:

```
A Person should have both a `first_name` and `last_name`. All fields
need to be validated except for `last_name`, `weapon` and `vehicle` which are optional.
```

Given that a Person should have both name attributes, while `last_name` being optional, I just went ahead and made `last_name` required as well. Also due to the sample csv to be imported only have one field called `name`, another assumption has been made found in #2.

2. The name field to be imported should have at least two parts as the importer always assume that the last 'word' of the name will be considered as their `last_name`. eg. Jar Jar Binks will have 'Jar Jar' as `first_name` and 'Binks' as `last_name` or Jabba the Hutt will have 'Jabba the' as `first_name` and 'Hutt' as `last_name`. This assumption can have weird combinations such as 'Jabba the / Hutt'.

3. Importer tranforms the following:
  1. Splitting of Name into `first_name` and `last_name`
  2. Automatic titlecase for all fields (for uniformity) upon import.

4. Did not do server side pagination and sorting for this but would definitely be recommended for any production level application.

5. Table implementation is heavily referenced from react-table examples.

## How to run the application
1. Make sure to have the latest docker installed. Went with a docker setup to avoid setup issues on anyone's end.
2. Run `docker compose up`, and it should run three services `db` - Postgresql, `api` - Rails API (port 3000), and `web` - ReactJS (port 3001)
3. Open your browser to http://localhost:3001.
4. Saved the sample CSV in the root folder for your convenience.