# Push Notification to MQTT

Convert push notifications to MQTT messages. Trigger automations from 3rd party apps that may not have native integration into your smart home. Not only detect push notifications from 3rd party apps, but you can inspect the contents and trigger automations off those details as well.

Supported platforms:

| Platform | Supported          |
| -------- | ------------------ |
| Android  | :white_check_mark: |
| iOS      | :x:                |

## Usage examples

### Bus alert

Let's say you have an app that lets you know when the bus is nearby. Even if the bus app doesn't integrate with your smart home, you can now pick up on those push notifications and trigger your home to flash the lights or announce on a speaker that the bus is almost here.

### Package delivery

Got a package delivered by Amazon? You can pick up on their notification and trigger your home to alert you of your awaiting package.

### Sport updates

Want your home to celebrate with you when your team scores? You can pick up on the same push notifications that you already get from your favorite sports app and trigger automations for your home.

> Keep in mind that any throttling done by the 3rd party app will apply here as well. For instance, basketball scores aren't updated every time a team scores, but are sent out periodically. Other sports are near real-time, so also be aware of spoilers if there's a broadcast delay.

## Rules

Rules contain the information needed to determine a match and where to publish the MQTT message.

```
{
    "packageName": "io.homeassistant.companion.android",
    "titleRegex": "(.*)",
    "messageRegex": ".*",
    "publishTopic": "push-notification-to-mqtt"
}
```

| Property       | Comment                                                                                                                                                                        |
| -------------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `packageName`  | The 3rd party app's package name. If you don't know the package name, you can determine this by waiting for a push notification to be received and viewing the console output. |
| `titleRegex`   | Regex pattern to match on the push notification title. If you want to capture a value within the title, add a capture group with `()`.                                         |
| `messageRegex` | Regex pattern to match on the push notification message. If you want to capture a value within the message, add a capture group with `()`.                                     |
| `publishTopic` | Topic to publish to your broker. If you captured a value from the title or message, the MQTT message will return a JSON payload with any matches.                              |

## MQTT Payload

The payload of the MQTT message is a JSON object that contains the original push notification data, as well as any matches from the title and/or message.

```
{
    "title": "26' Giorgian De Arrascaeta scores!",
    "message": "Ghana 0 - [1] Uruguay",
    "titleMatch": "Giorgian De Arrascaeta",
    "messageMatch": "Uruguay"
}
```

## Configuration

### MQTT

You need to have an MQTT broker available to send messages. Username and password are optional, but advisable.

> In my case, I'm running Mosquito on my Home Assistant, so I used the IP address of my Home Assistant and created a user specifically for my Android device.

### Android Settings

In order for the app to intercept 3rd party push notifications, you need to enable this capability in the system settings.

> Apps > Special access > Notification access

Make sure that 'Push Notification to MQTT' is enabled

### Rules hosting

Currently the only way to add rules into the app is to load them from an external source. Once you have this set up, you can update those rules remotely and the app can reload the rules.

> In my case I made a JSON file in my Dropbox and used a download link to get the raw data
> https://dl.dropbox.com/s/xxxxxxxxxxxxxxxx/rules.json?dl=0

### Reloading Rules

If you want to instantly and remotely update the rules in the app, you can send a push notification from Home Assistant to your device with a specific payload:

```
service: notify.android_device
data:
  message: reload
  title: Notification MQTT
```

Obviously update the service to point to the desired device, but it will look for that specific title and message and then kick off reloading the rules.

Additionally, after each reload the app will send an MQTT message to the topic `notification-mqtt-rules-loaded` which you can verify that everything was reloaded.

## Use Case - World Cup

I wanted to create an automation that would trigger a few things in my house when a goal was scored in the World Cup. Those things include:

- trigger a minature wacky wavy inflatable tubeman to start dancing
- change my lights to the team's color
- send a push notification to my phone of who scored

### Rules

I'm using the Fotmob app to capture push notifications, and I determined that the message had the best data to work with. I basically see 2 types of messages when a team scores:

- Spain [1] - 0 Germany
- Spain 1 - [1] Germany

I basically need 2 rules to cover both of these cases, and that looks like this:

```
{
    "packageName": "com.mobilefootie.wc2010",
    "titleRegex": "\\d+' (.*) scores!",
    "messageRegex": "(.*) \\[\\d+\\] - .*",
    "publishTopic": "soccer/worldcup/goal"
},
{
    "packageName": "com.mobilefootie.wc2010",
    "titleRegex": "\\d+' (.*) scores!",
    "messageRegex": ".* - \\[\\d+\\] (.*)",
    "publishTopic": "soccer/worldcup/goal"
}
```

This should send out a message on the topic `soccer/worldcup/goal` with a json payload that contains the original title and message, as well as any matched values. In this case we're using the `messageMatch` to pull the team name.

### Automation

There's basically 3 things that need to happen for this to run successfully.

1. team name comes from `trigger.payload_json.messageMatch`
2. team needs to match one of the teams listed in the `teams` variable. This basically verifies this goal has to do with the World Cup.
3. team color needs to be defined in the `team_colors` variable. Need RGB values for the lights.

```
alias: World Cup Goal
description: ""
trigger:
  - platform: mqtt
    topic: soccer/worldcup/goal
    variables:
      team: "{{ trigger.payload_json.messageMatch }}"
      teams: >-
        ('Netherlands', 'Ecuador', 'Senegal', 'Qatar', 'England', 'Iran', 'USA',
        'Wales', 'Poland', 'Argentina', 'Saudi Arabia', 'Mexico', 'France',
        'Australia', 'Denmark', 'Tunisia', 'Spain', 'Japan', 'Costa Rica',
        'Germany', 'Croatia', 'Morocco', 'Belgium', 'Canada', 'Brazil',
        'Switzerland', 'Cameroon', 'Serbia', 'Portugal', 'South Korea',
        'Uruguay', 'Ghana')
      team_colors: |-
        {{
          {
          "Netherlands": [243, 108, 33], 
          "Ecuador": [255, 209, 0], 
          "Senegal": [0, 133, 63], 
          "Qatar": [127, 20, 49], 
          "England": [0, 0, 64],
          "Iran": [35, 159, 64], 
          "USA": [10, 49, 97], 
          "Wales": [200, 16, 46], 
          "Poland": [220, 20, 60], 
          "Argentina": [67, 161, 213], 
          "Saudi Arabia": [22, 93, 49], 
          "Mexico": [0, 99, 65],
          "France": [33, 48, 77], 
          "Australia": [1, 33, 105], 
          "Denmark": [205, 24, 30], 
          "Tunisia": [200, 16, 46], 
          "Spain": [139, 13, 17], 
          "Japan": [188, 0, 45], 
          "Costa Rica": [0, 32, 91],
          "Germany": [176, 165, 95], 
          "Croatia": [237, 28, 36], 
          "Morocco": [193, 39, 45], 
          "Belgium": [227, 6, 19], 
          "Canada": [216, 6, 33], 
          "Brazil": [25, 174, 71], 
          "Switzerland": [255, 0, 0],
          "Cameroon": [0, 122, 94], 
          "Serbia": [183, 46, 62], 
          "Portugal": [4, 106, 56], 
          "South Korea": [205, 46, 58], 
          "Uruguay": [0, 20, 137], 
          "Ghana": [239, 51, 64]
          }
        }}
condition:
  - condition: template
    value_template: "{{ team in teams }}"
    alias: Validate team name
action:
  - service: notify.personal_phone
    data:
      title: World Cup Goal
      message: "{{ team }} scored!"
  - service: scene.create
    data:
      scene_id: world_cup_goal_lights_before
      snapshot_entities:
        - light.office_lights
        - light.theater_accent_lights
    enabled: true
    alias: Capture current light state
  - service: light.turn_on
    data:
      rgb_color: "{{ team_colors[team] }}"
      transition: 0.1
      brightness: 255
    target:
      entity_id:
        - light.office_lights
        - light.theater_accent_lights
    alias: Set team color
  - service: script.wacky_wavy_inflatable_tubeman_alert
    data: {}
    enabled: true
  - delay:
      hours: 0
      minutes: 0
      seconds: 1
      milliseconds: 0
  - service: light.turn_on
    data:
      flash: long
    target:
      entity_id:
        - light.office_lights
        - light.theater_accent_lights
    alias: Flash lights
    enabled: true
  - delay:
      hours: 0
      minutes: 0
      seconds: 15
      milliseconds: 0
  - service: scene.turn_on
    target:
      entity_id: scene.world_cup_goal_lights_before
    metadata: {}
    enabled: true
    alias: Reset lights back to original state
mode: single
```
