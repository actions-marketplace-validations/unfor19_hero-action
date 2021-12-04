# hero-action

[![testing](https://github.com/unfor19/hero-action/workflows/testing/badge.svg)](https://github.com/unfor19/hero-action/actions?query=workflow%3Atesting)
[![test-action](https://github.com/unfor19/hero-action-test/workflows/test-action/badge.svg)](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)


All-in-one action to develop and maintain GitHub Actions.

Tested in [unfor19/hero-action-test](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)

## Usage

1. Generate a new [Personal Access Token](https://github.com/settings/tokens) with the scope: **repo + workflow**. Keep this token in a safe place we'll use it later on.
1. Add the following job to your **action**'s repository, e.g. `hero-action`
    ```yaml
    jobs:
      dispatch_test_action:
          name: Dispatch Test Action
            runs-on: ubuntu-20.04
          steps:
            - uses: actions/checkout@v2
            - name: Workflow Dispatch Status
            uses: unfor19/hero-action@v1
            with:
                action: "dispatch-status"
                src_repository: ${{ github.repository }}
                src_workflow_name: "testing.yml"
                src_sha: ${{ github.sha }}
                target_repository: ${{ github.repository }}-test
                target_workflow_name: "test-action.yml"
                gh_token: ${{ secrets.GH_TOKEN }} # scope: repo + workflow
    ```   
2. Create a new GitHub repository to test your action, e.g. `hero-action-test`, add the following file `.github/workflows/test-action.yml`.
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
        name: Add steps to test your action
        steps:
          - uses: actions/checkout@v2
          ############################## START MODIFY THIS PART
          # - name: Your Action
          #   continue-on-error: true # Allow failure, on failure, a status update will be sent to source repo
          #   uses: repo_owner/repo_name@repo_branch
          #   with:
          #     input1: some_input
          #     input2: another_input
          ############################## END MODIFY THIS PART
        outputs:
          target_job_status: ${{ job.status }}

      update-status-check:
        name: Update Status Check In Source Repository
        runs-on: ubuntu-20.04
        needs:
          - test # Change if necessary
        if: ${{ always() }}
        steps:
          - name: Status Update Action Repo
            uses: unfor19/hero-action@v1
            with:
              action: "status-update"
              gh_token: ${{ secrets.GH_TOKEN }} # scope: repo + workflow
              src_repository: ${{ github.event.inputs.src_repository }}
              src_workflow_name: ${{ github.event.inputs.src_workflow_name }}
              src_sha: ${{ github.event.inputs.src_sha }}
              target_repository: ${{ github.repository }}
              target_job_status: ${{ needs.test.outputs.target_job_status }}
              target_run_id: ${{ github.run_id }}
    ```
3. Add the secret `GH_TOKEN` to both repositories, `hero-action` and `hero-action-test`
4. Commit and push code to your **action**'s repository, or [dispatch a workflow](https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows#workflow_dispatch) manually.


## How It Works

1. The action repository, `hero-action`, triggers a workflow in the test repository, `hero-action-test`. Meanwhile, the `hero-action` is "stuck" with the status **pending**.
2. The repository `hero-action-test` tests the action by using it.
3. Upon success/failure, the test action `hero-action-test` [creates a commit status](https://docs.github.com/en/rest/reference/repos#create-a-commit-status) in the action's repository, this updates the status of the **pending** workflow with **success** or **failure**

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
