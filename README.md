[![Maintainability](https://api.codeclimate.com/v1/badges/37b5a384d1577b23c532/maintainability)](https://codeclimate.com/github/barsoom/pipeline/maintainability)

## About

This is a tool for viewing CI build status from multiple CI servers and projects. It's a second iteration of our internal tools at [auctionet](http://dev.auctionet.com) and is in daily use.

The instructions are not complete, but it should not be hard to figure out what's needed to set up your own (this is basically just a simple rails app).

## How it looks

![how it looks](http://cl.ly/image/0r0D1C2P1I2v/Screen%20Shot%202014-02-17%20at%2013.01.15.png)

Each commit shows up as its own line, the newest at the top. Within each line boxes are shown for the different builds run on that revision.

The build names are links to the `status_url` passed in when reporting builds. At barsoom we pass in a link to the jenkins build result console. This way we can easily get to any build result of any recent revision.

## Web UI

Visit <https://pipeline.auctionet.dev/?pw=PASSWORD>, finding the actual `PASSWORD` in application config: `k config:get pipeline WEB_PASSWORD`

## API

The api token is set with the `API_TOKEN` environment variable.

### Alternative 1) Github Actions Webhooks API

Add a webhook to the project on github, set Payload URL to `https://example.com/api/github_actions_webhook` and content type to `application/json` and select the "Workflow jobs" event. The secret should be kept in sync with the `GITHUB_WEBHOOK_SECRET` environment variable.

### Alternative 2) Use the build status API

[Example client for CircleCI](examples/build_reporting_client_for_circleci.sh) (just a wrapper around curl, can easily be adapted for other CI tools as well).

Build status is reported to `/api/build_status` as a POST with the following attributes:

* *token*: The api token.
* *name*: The name of the build (e.g. `foo_tests` or `foo_deploy`). The app assumes that each build has a unique name. You use mappings configured for each project to display short names as in the screenshot.
* *repository*: The repository path (e.g. git@github...).
* *revision*: The git revision.
* *status_url*: The url to link to for showing build results.
* *status*: Current build status, can be `building`, `successful` or `failed`.

Normally the client would first post with the status of `building` and then either `successful` or `failed` after the build is done.

### Project status webhook

A webhook to receive the current project build status. Useful for displaying the current build status on dashboards.

Set the `WEBHOOK_URLS` config variable to the URLs (space-separated) where you want the project build status posted (as the JSON encoded parameter "payload").

The payload looks like this:

```json
{
  "project_name": "pipeline",
  "project_removed": false,
  "latest_revisions": [
    {
      "hash": "ea75a9c817757f1ebe09be035c807b7fe23499a0",
      "short_name": "ea75a9",
      "builds": [
        {
          "name": "tests",
          "status": "building"
        },
        {
          "name": "deploy",
          "status": "pending"
        }
      ]
    }
  ]
}
```

The webhook will only be called once and it will wait no longer than 10 seconds. It does not delay the `/api/build_status` call since it runs in a thread.

The `status_url` (link to your CI server) is intentionally excluded for now for security reasons (and because we haven't needed it yet). If you want this feature, open an issue or send a pull request.

The build `status:` can be one of: "pending", "building", "successful", "failed" and "fixed".

### Project API

Removing a project

    DELETE /api/projects/:name?token=...

### Build locking API

**NOTE**: Experimental feature

Builds can be locked so that only one build with a specific name can run at a time. This can be useful if you
have a CI server that isn't capable of doing this by itself (like CircleCI) and you for example don't
want it to try and deploy to different versions of the same app at the same time.

A build is locked by posting to `/api/build/lock` with the following attributes:

* *name*: The name of the build.
* *repository*: The repository path (e.g. git@github...).
* *revision*: The revision that you wish to lock.

The response contains the revision currently holding the lock, and looks like `{ "locked_by_revision": "foo" }`. Locks will remove themselves after 30 minutes just in case something went wrong, but you should try and ensure that unlocking happens as nobody wants to wait that long.

A build is unlocked by posting to `/api/build/unlock` with the following attributes:

* *name*: The name of the build.
* *repository*: The repository path (e.g. git@github...).
* *revision*: The revision that you wish to unlock.

## Cloud-init support

The app can be used to provision new servers using cloud-init. You can create a new script in the WEB UI which is then served by the API.

In addition to this there is a rake task `rake app:cloud_init_password[template_name, remote_ip]` for accessing password for the servers provisioned by the cloud-init script (given you have used {{password}} in the template).

This is useful for servers that are not accessible by SSH (for security reasons) where you still have console access via the server provider by other means.

When provisioning a server on Hetzner, take the IPv6 and replace /64 with 1 when running `rake app:cloud_init_password` to get the correct password.

For more information see the [cloud-init docs](https://cloudinit.readthedocs.io/en/latest/).

## ENVs

To run the app in production you need to set a few envs.

    WEB_PASSWORD=your-password-here
    SECRET_KEY_BASE=$(rake secret)

Optionally you can use SSO instead of WEB_PASSWORD via the use of [jwt_authentication](https://github.com/barsoom/jwt_authentication), see that gem for docs.

By default builds will go from "building" to "pending" after 60 minutes
as some builds may have been killed in a bad way where the final status
was never reported. You can change this time with an env:

    # BUILD_TIMEOUT_IN_MINUTES=120

You can limit the amount of revisions, to keep the database size manageable with an env:

    # REVISIONS_TO_KEEP=1000

`REVISIONS_TO_KEEP` defaults to 500.

## Running the tests

You need postgres installed.

    script/bootstrap

    rake              # all tests
    rake spec:unit    # unit tests
    rake spec         # integrated tests

## Download production data

    rake app:reset

## Development notes

The project controller has a `before_action` for projects

    before_action :get_projects

This is needed for the navigation.

## TODO

Various things we could do later.

* Add CircleCI support if they [improve their webhooks](https://discuss.circleci.com/t/build-webhook-notifications-for-starting-a-build-and-for-each-step-as-it-goes/5500)
* Add build reporting script
  - possibly built in go so that it is simple to install, no deps on ruby or similar
* Make a new screenshot
* Be able to manually trigger builds in CI. Probably some kind of plugin-API.
* Possibly make it possible to view one project at a time, or the latest results from all projects in a compact view.
* Custom urls configurable for projects, possibly driven by custom data in build status?
* Show fixed status for builds when a later revision fixes a build [see `fixed_status` branch]
* Keep updates around instead of changing builds existing? Would be nice for statistics.
* Support for custom badges, etc. Like codeclimate.
* Explore using it do manage continuous deployment pipelines better and simpler than can be done with jenkins plugins.
* Stats: averge build times, estimated time left, time from commit to deploy, average number of commits per deploy, ...
* Integrate with the commit status API https://github.com/blog/1227-commit-status-api
  * Report a commit status as an aggregate of several builds. Ex: Green if units, integration and staging is green.
  * Seems like it only supports showing status on pull requests though.
