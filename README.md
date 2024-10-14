# LMODroid Auto-Adapt Workflow

This GitHub Actions workflow is designed to add a LineageOS device tree and adapt it using scripts from the LMODroid infrastructure. The workflow allows users to input the device tree URL, the source branch, and the final branch for output.

## Inputs

- **LineageOS Device Tree**: LineageOS device tree repository.
    - Expected format: username/name_of_repo
- **LineageOS Device Tree Branch**: The branch of the LineageOS device tree to be used.
- **Output Branch**: The branch where the adapted device tree will be pushed.

## Setup

The workflow requires a Personal Access Token (PAT) with the following access:

- **repository access**: Control of all repositories.
- **repository permissions**:
    - **write:webhooks**: For webhooks, and gh tool.
    - **write:administration**: Repository creation, deletion, settings, teams, and collaborators.
    - **write:contents**: Repository contents, commits, branches, downloads, releases, and merges.  

These scopes are necessary to allow the workflow to clone repositories, fork repositories if needed, push changes, and interact with GitHub Actions workflows.

Save the token as a github secret(for actions) called "PAT" without the quotes.

## How It Works

1. **Clone Scripts**: The workflow clones the necessary scripts from the LMODroid infrastructure(or my backup mirror).
2. **Set Up Git**: Git is configured with the user's name and email.
3. **Run `add-device.sh` Script**: The workflow runs a script that adapts the LineageOS device tree to LMODroid, commits the changes, and pushes them to the specified branch.

This workflow leverages scripts from the LMODroid infrastructure and adapts them to work within GitHub Actions, streamlining the process of adding and adapting LineageOS device trees.
