<div align="center">
<img src="https://gdurl.com/n2JJ" alt="Alcancia Logo" width="150"/>
<h1>Alcancia Flutter Application </h1>
</div>
<p align="center">
<img src="https://img.shields.io/badge/author-Alcancia-blue" alt="Alcancia Author Badge" />
<img src="https://api.codemagic.io/apps/646661ebaffcba620387e6f4/646661ebaffcba620387e6f3/status_badge.svg" alt="Build status" />
</p>


## About Alcancia

With the goal to disrupt Traditional Finance (TradFi) and the mobile banking industry, Alcancía uses the power of blockchain and stablecoins, to create the best savings accounts in Latin America.

## Requirements

- Flutter installed in your system
- .env file (from Alcancia Front End Developer)


## Developer Quickstart

Clone the repo:

```sh
$ git clone https://github.com/Alcancia-io/Alcancia-FrontEnd.git
```

Obtain a `.env.dev` and/or a `.env.prod` file from an Alcancia Front End Developer and place it in the root directory of the project. Development will not work otherwise.

### Option 1: Using your IDE of choice
#### Setup Flutter flavors:
In your IDE of choice setup two configurations, `stage` and `prod`
Your `stage` configuration should run `pre-build-stage.sh` before launching the app and your `prod` configuration should run `pre-build-stage.sh`
This files will set up the correct environment variables for each flavor.
Here are some screenshots of how to do this in IntelliJ IDEs (IntelliJ IDEA or Android Studio):
<img width="1321" alt="IntelliJ IDEA Run/Debug Configurations" src="https://gdurl.com/Soe4">
<img width="1321" alt="IntelliJ IDEA Run/Debug Configurations Shell Scripts" src="https://gdurl.com/xqA4">




And sample `launch.json` and `tasks.json` files for VSCode:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "stage",
      "request": "launch",
      "type": "dart",
      "args": [
        "--flavor",
        "stage"
      ],
      "program": "lib/main.dart",
      "preLaunchTask": "preLaunchStage"
    },
    {
      "name": "prod",
      "request": "launch",
      "type": "dart",
      "args": [
        "--flavor",
        "prod"
      ],
      "program": "lib/main.dart",
      "preLaunchTask": "preLaunchProd"
    }
  ]
}
```

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "preLaunchStage",
      "type": "shell",
      "command": "${workspaceFolder}/pre-build-stage.sh",
      "problemMatcher": []
    },
    {
      "label": "preLaunchProd",
      "type": "shell",
      "command": "${workspaceFolder}/pre-build-prod.sh",
      "problemMatcher": []
    }
  ]
}
```

#### Run the app:
Now you can the app using the `stage` or `prod` configurations in your IDE of choice.
<img width="1321" alt="IntelliJ IDEA Configurations" src="https://gdurl.com/yXbBM">

<img width="1321" alt="VSCode Configurations" src="https://gdurl.com/1J-d">

### Option 2: Using the command line
Run the following commands in the root directory of the project:

```sh
$ flutter pub get
$ ./pre-build-stage.sh
$ flutter run --flavor stage
```
or
```sh
$ flutter pub get
$ ./pre-build-prod.sh
$ flutter run --flavor prod
```

## CI/CD
Release builds are automatically triggered on tag creation following the format `vMAJOR.MINOR.PATCH+BUILD` (e.g. `v0.0.1+1`) in the `develop` branch.
Staging builds are automatically triggered on tag creation following the format `vMAJOR.MINOR.PATCH+BUILD-stage` (e.g. `v0.0.1+1-stage`) in the `stage` branch.


