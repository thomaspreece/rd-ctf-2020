# RD-CTFD-2020

This repo was used to run the R&D CTF 2020. It contains the following:
- CTFD fronted by [louketo-proxy](https://github.com/louketo/louketo-proxy) to allow authentication to be provided by a KeyCloak server.
- CTFD DockerCompose for local deployment
- CTFD Kubernetes deployment via scripts found in `/deploy` for production deployment.
- `ctfd-portable-challenges-plugin` plugin bundled by default
- Selection of challenges from BSidesSF and custom created challenges along with Kubernetes deployment

## Local Deploy (Docker)

### Setup KeyCloak
You will need a Realm in KeyCloak. Next you will need to update docker-compose.yml to point to that realm. Now you need to create a new client. Click Create on the Clients section.

Set `Enabled` and `Standard Flow Enabled` to ON. All other toggles can be OFF. Set `Valid Redirect URIs` to be the URL of where you are running this container. E.g. `https://127.0.0.1:8443/*`.

Click `Credentials` tab, and note down client_secret. Click `Mappers` tab. Click Create. Name it `AudienceMapper`. Select `Audience` under `Mapper Type`. In `Included Client Audience` select the name of this client you are editing. Click Save.

### Generate Keys
You'll need TLS keys for localhost/127.0.0.1. You may find https://github.com/FiloSottile/mkcert useful for this.

### Start DockerCompose
You'll need to copy `./start_example.sh` to `start.sh` and add in client_secret and client_id from the above setup. Now you can start CTFD by running:
```
./start.sh
```

## Production Deploy (Kubernetes)

### Setup KeyCloak
You will need a Realm in KeyCloak. Next you will need to update `deploy/ctfd-louketo-proxy-deployment.yaml` to point to that realm. Now you need to create a new client. Click Create on the Clients section.

Set `Enabled` and `Standard Flow Enabled` to ON. All other toggles can be OFF. Set `Valid Redirect URIs` to be the URL of where you are running this container. E.g. `https://127.0.0.1:8443/*`.

Click `Credentials` tab, and note down client_secret. Click `Mappers` tab. Click Create. Name it `AudienceMapper`. Select `Audience` under `Mapper Type`. In `Included Client Audience` select the name of this client you are editing. Click Save.

### Deploy to Kubernetes
You'll need to update the yaml for your environment/domain. Then you can run the following on the cluster:

```
kubectl create namespace ctfd
# Note: It is important that there is NOT any newlines in the below file
# otherwise proxy will fail to authenticate with KeyCloak
# See https://www.funkypenguin.co.nz/beware-the-hidden-newlines-in-kubernetes-secrets/
echo -n "MY_OAUTH_SECRET" > ./deploy-secrets/ctfd-oauth2-client-secret.txt
pwgen 16 1 > ./deploy-secrets/ctfd-oauth2-cookie-secret.txt

kubectl create secret generic ctfd-oauth2-client-secret --from-file=./deploy-secrets/ctfd-oauth2-client-secret.txt --namespace ctfd
kubectl create secret generic ctfd-oauth2-cookie-secret --from-file=./deploy-secrets/ctfd-oauth2-cookie-secret.txt --namespace ctfd

kubectl apply -f deploy/ctfd-mysql-db-deployment.yaml
kubectl apply -f deploy/ctfd-redis-cache-deployment.yaml
kubectl apply -f deploy/ctfd-deployment.yaml
kubectl apply -f deploy/ctfd-nginx-deployment.yaml
kubectl apply -f deploy/ctfd-oauth2-proxy-deployment.yaml
```

# ![](https://github.com/CTFd/CTFd/blob/master/CTFd/themes/core/static/img/logo.png?raw=true)

![CTFd MySQL CI](https://github.com/CTFd/CTFd/workflows/CTFd%20MySQL%20CI/badge.svg?branch=master)
![Linting](https://github.com/CTFd/CTFd/workflows/Linting/badge.svg?branch=master)
[![MajorLeagueCyber Discourse](https://img.shields.io/discourse/status?server=https%3A%2F%2Fcommunity.majorleaguecyber.org%2F)](https://community.majorleaguecyber.org/)
[![Documentation Status](https://api.netlify.com/api/v1/badges/6d10883a-77bb-45c1-a003-22ce1284190e/deploy-status)](https://docs.ctfd.io)

## What is CTFd?

CTFd is a Capture The Flag framework focusing on ease of use and customizability. It comes with everything you need to run a CTF and it's easy to customize with plugins and themes.

![CTFd is a CTF in a can.](https://github.com/CTFd/CTFd/blob/master/CTFd/themes/core/static/img/scoreboard.png?raw=true)

## Features

- Create your own challenges, categories, hints, and flags from the Admin Interface
  - Dynamic Scoring Challenges
  - Unlockable challenge support
  - Challenge plugin architecture to create your own custom challenges
  - Static & Regex based flags
    - Custom flag plugins
  - Unlockable hints
  - File uploads to the server or an Amazon S3-compatible backend
  - Limit challenge attempts & hide challenges
  - Automatic bruteforce protection
- Individual and Team based competitions
  - Have users play on their own or form teams to play together
- Scoreboard with automatic tie resolution
  - Hide Scores from the public
  - Freeze Scores at a specific time
- Scoregraphs comparing the top 10 teams and team progress graphs
- Markdown content management system
- SMTP + Mailgun email support
  - Email confirmation support
  - Forgot password support
- Automatic competition starting and ending
- Team management, hiding, and banning
- Customize everything using the [plugin](https://docs.ctfd.io/docs/plugins/) and [theme](https://docs.ctfd.io/docs/themes/) interfaces
- Importing and Exporting of CTF data for archival
- And a lot more...

## Install

1. Install dependencies: `pip install -r requirements.txt`
   1. You can also use the `prepare.sh` script to install system dependencies using apt.
2. Modify [CTFd/config.ini](https://github.com/CTFd/CTFd/blob/master/CTFd/config.ini) to your liking.
3. Use `python serve.py` or `flask run` in a terminal to drop into debug mode.

You can use the auto-generated Docker images with the following command:

`docker run -p 8000:8000 -it ctfd/ctfd`

Or you can use Docker Compose with the following command from the source repository:

`docker-compose up`

Check out the [CTFd docs](https://docs.ctfd.io/) for [deployment options](https://docs.ctfd.io/docs/deployment/) and the [Getting Started](https://docs.ctfd.io/tutorials/getting-started/) guide

## Live Demo

https://demo.ctfd.io/

## Support

To get basic support, you can join the [MajorLeagueCyber Community](https://community.majorleaguecyber.org/): [![MajorLeagueCyber Discourse](https://img.shields.io/discourse/status?server=https%3A%2F%2Fcommunity.majorleaguecyber.org%2F)](https://community.majorleaguecyber.org/)

If you prefer commercial support or have a special project, feel free to [contact us](https://ctfd.io/contact/).

## Managed Hosting

Looking to use CTFd but don't want to deal with managing infrastructure? Check out [the CTFd website](https://ctfd.io/) for managed CTFd deployments.

## MajorLeagueCyber

CTFd is heavily integrated with [MajorLeagueCyber](https://majorleaguecyber.org/). MajorLeagueCyber (MLC) is a CTF stats tracker that provides event scheduling, team tracking, and single sign on for events.

By registering your CTF event with MajorLeagueCyber users can automatically login, track their individual and team scores, submit writeups, and get notifications of important events.

To integrate with MajorLeagueCyber, simply register an account, create an event, and install the client ID and client secret in the relevant portion in `CTFd/config.py` or in the admin panel:

```python
OAUTH_CLIENT_ID = None
OAUTH_CLIENT_SECRET = None
```

## Credits

- Logo by [Laura Barbera](http://www.laurabb.com/)
- Theme by [Christopher Thompson](https://github.com/breadchris)
- Notification Sound by [Terrence Martin](https://soundcloud.com/tj-martin-composer)
