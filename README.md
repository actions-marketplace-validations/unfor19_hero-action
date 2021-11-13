# hero-action

[![testing](https://github.com/unfor19/hero-action/workflows/testing/badge.svg)](https://github.com/unfor19/hero-action/actions?query=workflow%3Atesting)
[![test-action](https://github.com/unfor19/hero-action-test/workflows/test-action/badge.svg)](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)


All-in-one action to develop and maintain GitHub Actions.

Tested in [unfor19/hero-action-test](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)

## How It Works

...

## Usage

In your **action** repository, add the following **job**

```yaml
name: Update README.md
on:
  push:

jobs:
   dispatch_test_action:
      name: Dispatch Test Action
         runs-on: ubuntu-20.04
      steps:
         - uses: actions/checkout@v2
         - name: Set Environment Variables
         run: |
            echo "HERO_SRC_SHA=${GITHUB_SHA}" >> $GITHUB_ENV
         - name: Workflow Dispatch Status
         uses: unfor19/hero-action@v1
         with:
            action: "dispatch-status"
            src_repository: "unfor19/hero-action"
            src_workflow_name: "testing"
            target_repository: "unfor19/hero-action-test"
            target_workflow_name: "test-action.yml"
            target_ref: "master"
            gh_token: ${{ secrets.GH_TOKEN }} # TODO: Add required scope
            src_sha: ${{ env.HERO_SRC_SHA }}  # Fetched from previous step            
```

In your **action-test** repository, add the following file `.github/workflows/test-action.yml`

```yaml
name: test-action

on:
  workflow_dispatch:
    inputs:
      src_repository:
        description: Source Repository - {owner}/{repo_name}
        required: true
      src_workflow_name:
        description: Source Workflow Name
        required: true
      src_sha:
        description: Source Repository SHA - GITHUB_SHA
        required: true

jobs:
  test:
    runs-on: ubuntu-20.04
    name: Dummy Test
    steps:
      - uses: actions/checkout@v2
      # Add steps to test your action ...
    outputs:
      target_job_status: ${{ job.status }}

  update-status-check:
    name: Update Status Check In Source Repository
    runs-on: ubuntu-20.04
    needs:
      - test # Change if necessary
    if: ${{ always() }}
    env:
      HERO_SRC_REPOSITORY: ${{ github.event.inputs.src_repository }}
      HERO_SRC_WORKFLOW_NAME: ${{ github.event.inputs.src_workflow_name }}
      HERO_SRC_SHA: ${{ github.event.inputs.src_sha }}
      HERO_TARGET_JOB_STATUS: ${{ needs.test.outputs.target_job_status }}
    steps:
      - name: Set Environment Variables
        run: |
          echo "HERO_TARGET_RUN_ID=${GITHUB_RUN_ID}" >> $GITHUB_ENV
          echo "HERO_TARGET_REPOSITORY=${GITHUB_REPOSITORY}" >> $GITHUB_ENV
      - name: Status Update
        uses: unfor19/hero-action@master
        with:
          action: "status-update"
          gh_token: ${{ secrets.GH_TOKEN }}
          src_repository: ${{ env.HERO_SRC_REPOSITORY }}
          src_workflow_name: ${{ env.HERO_SRC_WORKFLOW_NAME }}
          src_sha: ${{ env.HERO_SRC_SHA }}
          target_repository: ${{ env.HERO_TARGET_REPOSITORY }}
          target_job_status: ${{ env.HERO_TARGET_JOB_STATUS }}
          target_run_id: ${{ env.HERO_TARGET_RUN_ID }}
```

### Help Menu

```bash
./entrypoint.sh --help
```

<!-- help_menu_start -->

```bash
Help menu is injected here
```
<!-- help_menu_end -->

_NOTE_: the code block above :point_up: was automatically generated with replacer! See the raw version of this [README.md](https://raw.githubusercontent.com/unfor19/hero-action/master/README.md) file

## Contributing

Report issues/questions/feature requests on the [Issues](https://github.com/unfor19/hero-action/issues) section.

Pull requests are welcome! These are the steps:

1. Fork this repo
1. Create your feature branch from master
   ```bash
   git checkout -b my-new-feature
   ```
2. Build development image
   ```bash
   docker build -t "hero-action:dev" --target "dev" .
   ```
1. Create `.env` file
   ```bash
   cp "env" ".env"
   ```
2. Run development image
   ```bash
   docker run --rm -it -v "$PWD":"/code" --env-file ".env" --workdir "/code" "hero-action:dev"
   ```
3. Add the code of your new feature
4. Run tests on your code, feel free to add more tests
   ```bash
   # in container
   ./tests/test.sh
   ... # All good? Move on to the next step
   ```
5. Commit your remarkable changes
   ```bash
   git commit -am 'Added new feature'
   ```
6. Push to the branch
   ```bash
   git push --set-up-stream origin my-new-feature
   ```
7. Create a new Pull Request and provide details about your changes

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/hero-action/blob/master/LICENSE) file for details
