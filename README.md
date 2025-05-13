# peacock-builder

Build script for a custom build of [The Peacock Project][1].

## What's different?

This build supports HITMAN World of Assassination Steam demo, requires
authentication from Steam for access to content.

## Installation

This repository includes a workflow for [GitHub Actions][4] which needs to be
run manually once set up. The action requires the following parameters:

* The commit/tag to build Peacock at: Any tag or commit in
[thepeacockproject/Peacock][5].
* Don't bundle NodeJS: Enable to not include [NodeJS][6] in the build(aka the
  linux version).

Once the build finishes, get the artifact from the **Artifacts** section of the
run and proceed for installation as listed in the [official website][7].

## Maintenance

Maintenance of this custom build involves managing patches rather than entire
codebase. Below are some naming conventions for these patches:

* Patches intended to be applied _as is_ are named `*.patch`.
* Patches intended to be applied _reversed_ are named `*.revpatch`.
  * These patches should be [commits done in thepeacockproject/Peacock][8], and
  must be in `git am` format obtained by [following this method][9].
  * In the instance the commit does not appear as an ancestor from which Peacock
  is being built, it will be ignored.
* Any other patches are ignored. For better clarity, append "`.ignore`" to the
file name.

### The following patches are included in this repository:

* `steam-demo.patch`: Enables support for HITMAN World of Assassination Steam
  demo.
* `packaging.patch`: Modifies the packaging process for proper artifact upload
  in GitHub actions.
* `default-flags.patch`: Changes some default configuration flags out of the
  box.
* `dashboard-go-to-evergreen-planning.patch`: Makes the Freelancer tile in the
  main menu take to the planning screen instead of [taking in-game][11].

[1]: https://thepeacockproject.org
[4]: https://docs.github.com/en/actions
[5]: https://github.com/thepeacockproject/Peacock
[6]: https://nodejs.org
[7]: https://thepeacockproject.org/wiki/intel/installation
[8]: https://github.com/thepeacockproject/Peacock/commits
[9]: https://webapps.stackexchange.com/a/159720
[11]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment
